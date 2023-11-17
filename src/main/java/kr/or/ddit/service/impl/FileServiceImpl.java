package kr.or.ddit.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.inject.Inject;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.compress.utils.IOUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;

import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.mapper.FileMapper;
import kr.or.ddit.service.IFileService;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FolderFileVO;
import kr.or.ddit.vo.FolderVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FileServiceImpl implements IFileService {

	@Inject
	private FileMapper mapper;

	@Inject
	private EmpMapper empMapper;

	// 알집안에 파일을 넣기위한 재귀메소드.
	private static void zipFolder(String sourceFolder, String currentFolder, ZipOutputStream zos) throws IOException {
		System.out.println("알집재귀호출 : ");
		System.out.println(currentFolder);
		File folder = new File(currentFolder);
		System.out.println("알집재귀폴더");
		System.out.println(folder);
		if (folder == null || !folder.exists() || !folder.isDirectory()) {
			// 에러 처리: 폴더가 존재하지 않거나 폴더가 아닌 경우
			return;
		}

		File[] files = folder.listFiles();
		System.out.println("폴더리스트파일즈 : ");
		System.out.println(folder.listFiles());
		if (files == null) {
			// 에러 처리: 폴더가 비어있거나 읽을 수 없는 경우
			return;
		}

		for (File file : files) {
			if (file.isDirectory()) {
				// 하위 폴더의 경우 재귀적으로 폴더를 압축
				zipFolder(sourceFolder, file.getPath(), zos);
			} else {
				// 파일의 경우 압축
				String entryName = file.getPath().substring(sourceFolder.length() + 1);
				ZipEntry ze = new ZipEntry(entryName);
				zos.putNextEntry(ze);

				FileInputStream fis = new FileInputStream(file);
				byte[] buffer = new byte[1024];
				int len;
				while ((len = fis.read(buffer)) > 0) {
					zos.write(buffer, 0, len);
				}

				fis.close();
				zos.closeEntry();
			}
		}
	}

	// 유저넘버를 메소드로 꺼낼 수 있게 해주는 메소드.
	private String UserNoFind() {
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		UserDetails userDetails = (UserDetails) principal;
		String empNo = userDetails.getUsername();
		return empNo;
	}

	private String UserDepFind() {
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		UserDetails userDetails = (UserDetails) principal;
		String empNo = userDetails.getUsername();

		EmpVO userDep = empMapper.readByUserId(empNo);
		String dep = userDep.getDeptCd();

		return dep;
	}

	private String company = "IWORKS";

	// 재귀호출을 사용해서 폴더를 생성해주는 재귀메소드.
	private List<String> FolderCreate(FolderVO folderVO, List<String> folderPathArray) {
		System.out.println("재귀호출 들어옴");
		if (folderVO.getFolderParent() == null) {
			System.out.println("재귀호출 널");
			return folderPathArray;
		} else {
			System.out.println(folderVO.getFolderParent());
			String motherFolder = folderVO.getFolderParent();
			FolderVO parentFolder = mapper.selectParentFolder(motherFolder);
			// 코드가아닌 이름값을 집어넣어서 패스로 활용해야함.
			folderPathArray.add(parentFolder.getFolderName());
			FolderCreate(parentFolder, folderPathArray);
			System.out.println("재귀호출 낫널");
		}
		return folderPathArray;
	}

	// 재귀호출로 폴더안쪽에 있는 모든 폴더에 속한 파일의 데이터를 꺼내줄 재귀메소드.
	private List<String> folderFileList(String folderCd, List<String> fileCdList) {

		FolderVO sourceFolder = new FolderVO();
		sourceFolder.setFolderCd(folderCd);
		List<FolderVO> childFolder = mapper.selectChildFolder(sourceFolder);
		List<FolderFileVO> childFile = mapper.selectChildFile(sourceFolder);
		if (childFolder.size() != 0) {
			for (int i = 0; i < childFolder.size(); i++) {
				// 재귀로 계속 진행
				List<FolderFileVO> fileList = mapper.selectChildFile(childFolder.get(i));
				if (fileList.size() != 0) {
					for (int j = 0; j < fileList.size(); j++) {
						System.out.print("재귀안에있는 파일 cd값 : ");
						System.out.println(fileList.get(j).getFileCd());
						fileCdList.add(fileList.get(j).getFileCd());
					}
				}
				folderFileList(childFolder.get(i).getFolderCd(), fileCdList);
			}
		}
		if (childFile.size() > 0) {
			for (int i = 0; i < childFile.size(); i++) {
				log.info("파일 cd값 : {}", childFile.get(i));
				fileCdList.add(childFile.get(i).getFileCd());

			}
		}
		return fileCdList;
	}
	
	private void updateParentSizeAll(FolderVO folderVO) {
		log.info("재귀호출 돌고있는 폴더VO : {} " + folderVO);
		if(folderVO.getFolderParent() != null) {
			mapper.updateFolderSize(folderVO.getFolderParent());
			folderVO = mapper.selectParentFolder(folderVO.getFolderParent());
			updateParentSizeAll(folderVO);
		}
	}
	

	private List<String> folderFolderList(String folderCd, List<String> folderCdList) {

		FolderVO sourceFolder = new FolderVO();
		sourceFolder.setFolderCd(folderCd);
		List<FolderVO> childFolder = mapper.selectChildFolder(sourceFolder);
		if (childFolder.size() != 0) {
			for (int i = 0; i < childFolder.size(); i++) {
				folderCdList.add(childFolder.get(i).getFolderCd());
				folderFolderList(childFolder.get(i).getFolderCd(), folderCdList);
			}
		}
		return folderCdList;
	}

	// 재귀로 안에있는 폴더cd값을 전부 가져오는 메소드
	// 빈리스트만들어서 넣어줄곳을 같이 파라미터로 보내줘야함.
	private List<String> shareList(FolderVO folderList, List<String> shareList, List<String> shareFileList) {

		shareList.add(folderList.getFolderCd());
		List<FolderVO> childFolderList = mapper.selectChildFolder(folderList);
		List<FolderFileVO> childFileList = mapper.selectChildFile(folderList);
		if (childFolderList != null) {
			for (int i = 0; i < childFolderList.size(); i++) {
				System.out.println("폴더리스트");
				shareList(childFolderList.get(i), shareList, shareFileList);
			}
		}
		if (childFileList != null) {
			for (int i = 0; i < childFileList.size(); i++) {
				if (childFileList.get(i).getFileSavename() != null) {
					shareFileList.add(childFileList.get(i).getFileCd());
					System.out.println("파일리스트");
					System.out.println((childFileList.get(i).getFileSavename()));
				}
			}
		}
		return shareList;
	}

	// 개인 //

	@Override
	public String insertIndFolder(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) {
		folderVO.setEmpNo(UserNoFind());

		// 중요!!.
		// 현재 파라미터로 받은 값은 인서트가 안된 값이기 때문에 폴더코드가 없으므로
		// 부모코드가 있을 경우, 부모코드에 대한 내용을 꼭 받아와서 로직이 처리될 수 있게해야한다.
		List<String> folderPathArray = new ArrayList<String>();
		folderPathArray.add(folderVO.getFolderName());

		if (folderVO.getFolderParent() == null) {
			System.out.println("널");
		} else {
			System.out.println("낫널");
			// 폴더부모의 이름값들의 array를 리턴받기 위한 재귀호출.
			folderPathArray = FolderCreate(folderVO, folderPathArray);
		}

		String addPath = "";
		// for문 마이너스로 가야함.
		// 재귀호출 메소드에서 자식 >> 부모형태로 array가 쌓이므로 추가시킬땐 역순으로.
		for (int i = folderPathArray.size() - 1; i >= 0; i--) {
			addPath += "/" + folderPathArray.get(i);
			System.out.println("i = " + i);
		}
		System.out.println(addPath);

		String path = req.getServletContext().getRealPath("/resources/file") + addPath;
		System.out.println(path);

		// 알집저장에 필요한 파라미터 folderPath를 위한 폴더패스 세팅
		folderVO.setFolderPath(path);

		File file = new File(path);

		if (!file.exists()) {
			file.mkdirs();
		}

		HttpSession session = req.getSession();
		System.out.println("세선에 넣은 값 : " + folderVO.getFolderParent());
		session.setAttribute("folderCd", folderVO.getFolderParent());

		FolderVO checkDupVO = new FolderVO();
		checkDupVO.setFolderCd(folderVO.getFolderParent());
		List<FolderVO> folderList = selectChildFolder(checkDupVO);
		for (FolderVO check : folderList) {
			if (check.getFolderName().equals(folderVO.getFolderName())) {
				session.setAttribute("dup", folderVO.getFolderName() + "은(는) 현재 사용중인 폴더명입니다.");
				return "redirect:/indfiles.do";
			}
		}

		mapper.insertIndFolder(folderVO);

		return null;
	}

	@Override
	public FolderVO selectIndFolder(FolderVO folderVO) {
		folderVO.setEmpNo(UserNoFind());
		folderVO.setFolderCd(UserNoFind());
		System.out.println("서비스 폴더보 사원명 : " + folderVO.getEmpNo());
		System.out.println("서비스 폴더코드 명 : " + folderVO.getFolderCd());
		return mapper.selectIndFolder(folderVO);
	}

	@Override
	public List<FolderVO> selectChildFolder(FolderVO folderVO) {
		return mapper.selectChildFolder(folderVO);
	}

	@Override
	public FolderVO selectParentFolder(String motherFolder) {
		return mapper.selectParentFolder(motherFolder);
	}

	@Override
	public FolderVO selectMyselfFolder(FolderVO folderVO) {
		return mapper.selectMyselfFolder(folderVO);
	}

	@Override
	public String insertIndFile(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		System.out.println("인서트 서비스 시작");
		FolderVO folderFile = new FolderVO();
		FolderFileVO fileVO = new FolderFileVO();
		fileVO.setEmpNo(UserNoFind());

		FolderVO checkDupVO = new FolderVO();
		checkDupVO.setFolderCd(folderVO.getFolderParent());
		List<FolderFileVO> fileList = selectChildFile(checkDupVO);

		// 세션 미리 생성해주기.
		HttpSession session = req.getSession();
		System.out.println("세선에 넣은 값 : " + folderVO.getFolderParent());
		session.setAttribute("folderCd", folderVO.getFolderParent());

		// 파일명 중복검사.
		for (FolderFileVO check : fileList) {
			for (int i = 0; i < folderVO.getFoFile().length; i++) {

				String[] fileOrgNameArr = folderVO.getFoFile()[i].getOriginalFilename().split("\\.");
				String fileOrgName = "";
				for (int j = 0; j < fileOrgNameArr.length - 1; j++) {
					System.out.println("대환장 네임들 : " + fileOrgNameArr[j]);
					fileOrgName += fileOrgNameArr[j];
				}
				if (check.getFileOrgname().equals(fileOrgName)) {
					session.setAttribute("fileDup", fileOrgName + "은(는) 현재 사용중인 파일명입니다.");
					return "redirect:/indfiles.do";
				}
			}
		}

		for (int i = 0; i < folderVO.getFoFile().length; i++) {

			String fileName = folderVO.getFoFile()[i].getOriginalFilename();
			System.out.println(fileName);
			String fileType = fileName.substring((fileName.lastIndexOf(".") + 1));
			System.out.println(fileType);
			UUID randomName = UUID.randomUUID();
			System.out.println(randomName);
			String fileSavename = randomName + fileName;
			System.out.println(fileSavename);

			List<String> folderPathArray = new ArrayList<String>();

			if (folderVO.getFolderParent() == null) {
				System.out.println("널");
			} else {
				System.out.println("낫널");
				// 폴더부모의 이름값들의 array를 리턴받기 위한 재귀호출.
				folderPathArray = FolderCreate(folderVO, folderPathArray);
			}

			String addPath = "";
			// for문 마이너스로 가야함.
			// 재귀호출 메소드에서 자식 >> 부모형태로 array가 쌓이므로 추가시킬땐 역순으로.
			for (int j = folderPathArray.size() - 1; j >= 0; j--) {
				addPath += "/" + folderPathArray.get(j);
				System.out.println("j = " + j);
			}
			System.out.println(addPath);

			// 일단 CRUD하듯이 멀티파트에 배열형태로 담겨져온 데이터를 SET해놓고.
			// target에 경로값, UUID+이름값을 담은후에
			// FileCopyUtils에 추가로 데이터값을 담아서 파일의 카피를 진행한다.
			// 만약 타겟에서 이름값을 보내주지 않으면 카피를 진행할때 이름이 설정되지않고 FOFILE(변수이름)로 저장되는것 같다.
			String fileSavepath = req.getServletContext().getRealPath("/" + "resources" + "/" + "file") + addPath;
			System.out.println(fileSavepath);

			String fileDataSavePath = "resources/file" + addPath + "/";
			File filePath = new File(fileSavepath);

			if (!filePath.exists()) {
				filePath.mkdirs();
			}

			byte[] fileData = folderVO.getFoFile()[i].getBytes();

			File target = new File(fileSavepath, fileSavename); // 파일 업로드 준비
			FileCopyUtils.copy(fileData, target); // 파일 복사 진행

			fileVO.setFileSec(i + 1);
			// 다운로드 횟수
			fileVO.setFileDowncnt(0);
			// 즐겨찾기 여부
			fileVO.setFileLikese(1);
			// 파일 마임타입
			fileVO.setFileMime(folderVO.getFoFile()[i].getContentType());
			// 확장자명 제거한 순수이름 가져오기.
			String[] fileOrgNameArr = folderVO.getFoFile()[i].getOriginalFilename().split("\\.");
			String fileOrgName = "";
			for (int j = 0; j < fileOrgNameArr.length - 1; j++) {
				System.out.println("대환장 네임들 : " + fileOrgNameArr[j]);
				fileOrgName += fileOrgNameArr[j];
			}
			// 파일이름
			fileVO.setFileOrgname(fileOrgName);
			// 파일 저장이름 (UUID포함)
			fileVO.setFileSavename(fileSavename);
			// 파일 저장경로
			fileVO.setFileSavepath(fileDataSavePath);
			// 파일 구분
			fileVO.setFileSe("개인");
			// 파일크기
			fileVO.setFileSize(folderVO.getFoFile()[i].getSize());
			// 파일 확장자
			fileVO.setFileType(fileType);
			System.out.println("폴더파일 폴더코드 : ");
			System.out.println(folderVO.getFolderParent());
			folderFile.setFolderCd(folderVO.getFolderParent());
			folderFile.setFileSec(i + 1);
			System.out.println("파일인서트");
			mapper.insertIndFile(fileVO);
			System.out.println("폴더파일인서트");
			mapper.insertFolderFile(folderFile);
			// currval에 문제있는거 물어볼것.
			// 물어보고 해결되면 insertFolderFile작업 마무리하고
			// 교수님 시간되면 > 업로드 다운로드
			// 안되시면 리스트 띄워서 확장자별로 아이콘 따로주기 작업해놓을것.
		}
		// 파일 용량업데이트
		updateParentSizeAll(folderVO);
		log.info("파일용량 업데이트에 필요한 부모CD값  : {}" , folderVO.getFolderParent());
		return null;
	}

	@Override
	public List<FolderFileVO> selectChildFile(FolderVO folderVO) {
		return mapper.selectChildFile(folderVO);
	}

	@Override
	public void insertDefaultIndFolder(FolderVO folderVO) {
		folderVO.setEmpNo(UserNoFind());
		mapper.insertDefaultIndFolder(folderVO);
	}

	@Override
	public int selectDefaultIndFolder(FolderVO folderVO) {
		return mapper.selectDefaultIndFolder(folderVO);
	}

	@Override
	public FolderFileVO selectMyselfFile(FolderFileVO folderFileVO) {
		return mapper.selectMyselfFile(folderFileVO);
	}

	@Override
	public ResponseEntity<byte[]> fileDownload(String submitFileCd, HttpServletRequest request,
			HttpServletResponse response) throws UnsupportedEncodingException {
		System.out.println("다운로드 서비스까지왔음.");
		FolderFileVO folderFileVO = new FolderFileVO();
		folderFileVO.setFileCd(submitFileCd);
		folderFileVO = mapper.selectMyselfFile(folderFileVO);

		String fileName = "";
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;

		String headerKind = request.getHeader("User-Agent");

		if ((headerKind.contains("MSIE")) || (headerKind.contains("Trident")) || (headerKind.contains("Edge"))) {
			fileName = URLEncoder.encode(folderFileVO.getFileOrgname(), "UTF-8");
		} else {
			fileName = new String(folderFileVO.getFileOrgname().getBytes("UTF-8"), "iso-8859-1");
		}

		File file = new File(request.getServletContext().getRealPath("") + folderFileVO.getFileSavepath(),
				folderFileVO.getFileSavename());

		fileName += "." + folderFileVO.getFileType();

		try {
			HttpHeaders header = new HttpHeaders();
			in = new FileInputStream(file);
			header.setContentType(MediaType.APPLICATION_OCTET_STREAM);
			header.add("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
			entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), header, HttpStatus.CREATED);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		}

		return entity;
	}

	@Override
	public ResponseEntity<byte[]> alzipDownload(List<String> folderArray, List<String> fileArray,
			HttpServletRequest request, HttpServletResponse response) throws IOException {
		String zipFileName = "";
		System.out.println(folderArray);
		
		if (folderArray.size() != 0) {
			FolderVO alzipName = new FolderVO();
			alzipName.setFolderCd(folderArray.get(0));
			alzipName = selectMyselfFolder(alzipName);
			if(folderArray.size() > 1) {
				zipFileName = alzipName.getFolderName()+" 외 "+(folderArray.size()+fileArray.size()-1)+"개 공유자료";
			} else {
				zipFileName = alzipName.getFolderName();
			}
			System.out.println(zipFileName);
		} else {
			FolderFileVO alzipName = new FolderFileVO();
			alzipName.setFileCd(fileArray.get(0));
			alzipName = selectMyselfFile(alzipName);
			if(fileArray.size() > 1) {
				zipFileName = alzipName.getFileOrgname()+" 외 "+(fileArray.size()-1)+"개 공유파일";
			} else {
				zipFileName = alzipName.getFileOrgname();
			}
			System.out.println(zipFileName);
		}

		FileOutputStream fos = new FileOutputStream(zipFileName);
		ZipOutputStream zos = new ZipOutputStream(fos);

		if (folderArray != null) {
			for (int i = 0; i < folderArray.size(); i++) {
				System.out.println(folderArray.get(i));
				FolderVO folderVO = new FolderVO();
				folderVO.setFolderCd(folderArray.get(i));
				folderVO = selectMyselfFolder(folderVO);
				String folderPath = folderVO.getFolderPath();

				// 폴더패스의 상위폴더를 가져와 zipFolder의 소스폴더로 넣을 경로
				String sourcePath = "";
				String[] sourcePathArray = folderPath.split("/");
				for (int j = 0; j < sourcePathArray.length - 1; j++) {
					if (j == 0) {
						sourcePath += sourcePathArray[j];
					} else {
						sourcePath += "/" + sourcePathArray[j];
					}
				}

				System.out.println("커런트패스 : " + folderPath);
				// 전체경로와 현재경로가 같을시 문제점
				// 1. 경로를 자신을 포함했을때 : 첫폴더는 폴더간 경계가 없어진다.
				// 2. 경로를 자신을 포함하지 않을때 : 선택하지 않은 상위폴더의 하위폴더들까지 압축됨.
				// > 따라서 전체경로는 상위로, 현재경로는 자신을 포함한 경로로 해볼예정.
				zipFolder(sourcePath, folderPath, zos);
			}
		}

		if (fileArray != null) {
			for (int i = 0; i < fileArray.size(); i++) {
				FolderFileVO folderFileVO = new FolderFileVO();
				folderFileVO.setFileCd(fileArray.get(i));
				folderFileVO = selectMyselfFile(folderFileVO);
				String entryName = folderFileVO.getFileOrgname() + "." + folderFileVO.getFileType();
				ZipEntry ze = new ZipEntry(entryName);
				zos.putNextEntry(ze);

				FileInputStream fis = new FileInputStream(request.getServletContext().getRealPath("")
						+ folderFileVO.getFileSavepath() + folderFileVO.getFileSavename());
				byte[] buffer = new byte[1024];
				int len;
				while ((len = fis.read(buffer)) > 0) {
					zos.write(buffer, 0, len);
				}

				fis.close();
			}
		}

		zos.close();

		byte[] zipFileContent = Files.readAllBytes(Paths.get(zipFileName));

		String zipSaveFilName = URLEncoder.encode(zipFileName, "UTF-8");
		zipSaveFilName = zipSaveFilName.replace("+", "%20");
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
		headers.setContentDispositionFormData("attachment", zipSaveFilName+".zip");
		headers.setContentLength(zipFileContent.length);

		return new ResponseEntity<>(zipFileContent, headers, HttpStatus.OK);

	}

	// 파일 좋아요 기능을 처리해주는 서비스로직.
	@Override
	public Map<String, FolderFileVO> updateLikeSe(Map<String, Object> param) {

		// 파라미터값을 가져와서 넘어온 fileCd를 확인
		String fileCd = (String) param.get("fileCd");
		System.out.print("좋아요업데이트로 넘어온 파람 값 : ");
		System.out.println(fileCd);

		// 받은 fileCd값을 VO에 넣어준후, 해당 코드의 파일값을 구해옴.
		FolderFileVO folderFileVO = new FolderFileVO();
		folderFileVO.setFileCd(fileCd);

		folderFileVO = selectMyselfFile(folderFileVO);

		// 좋아요상태를 설정한다.
		// 좋아요상태가 아니었다면(1) set값을 '2'로 해주고,
		// 이미 좋아요 상태였다면(2) set값을 '1'로 해준다.
		if (folderFileVO.getFileLikese() == 1) {
			folderFileVO.setFileLikese(2);
		} else if (folderFileVO.getFileLikese() == 2) {
			folderFileVO.setFileLikese(1);
		}

		// 이제 업데이트 하는 로직으로 쏴준다.
		mapper.updateLikeSe(folderFileVO);

		// ajax리턴으로 보내줄 변경된 값을 다시 셀렉트로 가져온다.
		folderFileVO = selectMyselfFile(folderFileVO);

		// 마지막으로 Map에 해당내용을 담아주고 리턴시켜준다.
		Map<String, FolderFileVO> likeMap = new HashMap<String, FolderFileVO>();
		likeMap.put("fileLike", folderFileVO);

		System.out.println(folderFileVO.getFileLikese());

		mapper.updateLikeSe(folderFileVO);

		return likeMap;
	}

	@Override
	public Map<String, FolderFileVO> imageFileInfoAjax(Map<String, Object> param) {

		// ajax로 보낸 json형식의 파라미터를 받아낸다.
		String fileCd = (String) param.get("submitFileCd");
		// fileCd값을 담아 전체내용을 받아올 객체선언.
		FolderFileVO fileVO = new FolderFileVO();
		// fileVO에 json으로 받아온 fileCd값을 넣어준다.
		fileVO.setFileCd(fileCd);
		// fileCd를 가지고 자신의 파일 정보를 불러오는 서비스를 통해 전체 정보를 담아낸다.
		fileVO = selectMyselfFile(fileVO);

		// 맵 = 뉴해쉬맵을 선언해서 맵객체를 하나만들어준다.
		Map<String, FolderFileVO> imageMap = new HashMap<String, FolderFileVO>();
		// imageMap안에 fileVO데이터를 담아준다.
		imageMap.put("imageVO", fileVO);

		return imageMap;
	}

	@Override
	public void deletefile(List<String> folderArray, List<String> fileArray, String folderParent,
			HttpServletRequest req, HttpServletResponse resp) {

		HttpSession session = req.getSession();
		session.setAttribute("folderCd", folderParent);
		String deleteMessage = "삭제가 완료되었습니다";
		session.setAttribute("deleteMessage", deleteMessage);

		if (folderArray.size() != 0) {
			for (String folderCd : folderArray) {
				List<String> fileCdList = new ArrayList<String>();
				List<String> folderCdList = new ArrayList<String>();
				FolderVO spareFolder = new FolderVO();
				spareFolder = selectParentFolder(folderCd);
				List<String> fileCds = folderFileList(spareFolder.getFolderCd(), fileCdList);
				List<String> folderCds = folderFolderList(folderCd, folderCdList);

				for (int i = 0; i < fileCds.size(); i++) {
					FolderFileVO deleteFile = new FolderFileVO();
					deleteFile.setFileCd(fileCds.get(i));

					log.info("파일 목록에서 가져온 파일 CD값 : {} : ", fileCds.get(i));

					// 파일 자체를 삭제시키려면 여기서 진행해야함.
					FolderFileVO delete = new FolderFileVO();
					delete.setFileCd(fileCds.get(i));
					delete = selectMyselfFile(delete);

					if (delete != null) {
						File file = new File(req.getServletContext().getRealPath("") + delete.getFileSavepath()
								+ delete.getFileSavename());

						if (file.exists()) {
							file.delete();
						} else {
							log.info("파일이 존재하지 않습니다 파일경로  : {}", delete.getFileSavepath() + delete.getFileSavename());
						}
					}
					
					mapper.deleteFolderFile(deleteFile);
					mapper.deleteFile(deleteFile);
				}
				

				for (int i = folderCds.size() - 1; i >= 0; i--) {
					FolderVO deleteFolder = new FolderVO();
					deleteFolder.setFolderCd(folderCds.get(i));
					mapper.deleteFolder(deleteFolder);
				}

				FolderVO folderVO = new FolderVO();
				folderVO.setFolderCd(folderCd);
				folderVO = selectMyselfFolder(folderVO);
				String updateSize = folderVO.getFolderParent();
				mapper.deleteFolder(folderVO);
				FolderVO updateSizeVO = new FolderVO();
				updateSizeVO.setFolderParent(updateSize);
				updateParentSizeAll(updateSizeVO);

			}
		}

		if (fileArray.size() != 0) {
			for (String fileCd : fileArray) {
				FolderFileVO fileVO = new FolderFileVO();
				fileVO.setFileCd(fileCd);

				// 파일 자체를 삭제시키려면 여기서 진행해야함.
				// 파일 자체를 삭제시키려면 여기서 진행해야함.
				FolderFileVO delete = new FolderFileVO();
				delete.setFileCd(fileCd);
				delete = selectMyselfFile(delete);
				
				String folderCd = mapper.selectMyselfFolderFile(fileCd);

				if (delete != null) {
					File file = new File(req.getServletContext().getRealPath("") + delete.getFileSavepath()
							+ delete.getFileSavename());

					if (file.exists()) {
						file.delete();
					} else {
						log.info("파일이 존재하지 않습니다 파일경로  : {}", delete.getFileSavepath() + delete.getFileSavename());
					}
				}

				mapper.deleteFolderFile(fileVO);
				mapper.deleteFile(fileVO);
				FolderVO updateSizeVO = new FolderVO();
				updateSizeVO.setFolderParent(folderCd);
				updateParentSizeAll(updateSizeVO);
			}
		}
	}

	@Override
	public Map<String, Object> searchText(Map<String, String> param) {
		String searchText = param.get("searchText");
		String folderCd = param.get("folderParent");

		System.out.println("에이잭스 컨트롤러 시작");

		FolderVO folderVO = new FolderVO();
		folderVO.setFolderCd(folderCd);
		folderVO.setSearchText(searchText);

		List<FolderVO> folderList = mapper.searchFolderText(folderVO);
		List<FolderFileVO> fileList = mapper.searchFileText(folderVO);

		Map<String, Object> searchMap = new HashMap<String, Object>();

		searchMap.put("folderList", folderList);
		searchMap.put("fileList", fileList);

		return searchMap;
	}

	@Override
	public List<FolderFileVO> selectChildFileDate(FolderVO folderVO) {
		return mapper.selectChildFileDate(folderVO);
	}

	@Override
	public List<FolderVO> selectChildFolderDate(FolderVO folderVO) {
		return mapper.selectChildFolderDate(folderVO);
	}

	// 부서 //
	// 부서 //
	// 부서 //
	// 부서 //
	// 부서 //
	// 부서 //
	@Override
	public int selectDefaultDepFolder(FolderVO folderVO) {
		return mapper.selectDefaultDepFolder(folderVO);
	}

	@Override
	public void insertDefaultDepFolder(FolderVO folderVO) {
		folderVO.setEmpNo(UserNoFind());
		mapper.insertDefaultDepFolder(folderVO);
	}

	@Override
	public FolderVO selectDepFolder(FolderVO folderVO) {

		folderVO.setFolderCd(UserDepFind());
		System.out.println("서비스 폴더보 사원명 : " + folderVO.getEmpNo());
		System.out.println("서비스 폴더코드 명 : " + folderVO.getFolderCd());
		return mapper.selectDepFolder(folderVO);
	}

	@Override
	public String insertDepFolder(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) {
		// 중요!!.
		// 현재 파라미터로 받은 값은 인서트가 안된 값이기 때문에 폴더코드가 없으므로
		// 부모코드가 있을 경우, 부모코드에 대한 내용을 꼭 받아와서 로직이 처리될 수 있게해야한다.
		List<String> folderPathArray = new ArrayList<String>();
		folderPathArray.add(folderVO.getFolderName());

		if (folderVO.getFolderParent() == null) {
			System.out.println("널");
		} else {
			System.out.println("낫널");
			// 폴더부모의 이름값들의 array를 리턴받기 위한 재귀호출.
			folderPathArray = FolderCreate(folderVO, folderPathArray);
		}

		String addPath = "";
		// for문 마이너스로 가야함.
		// 재귀호출 메소드에서 자식 >> 부모형태로 array가 쌓이므로 추가시킬땐 역순으로.
		for (int i = folderPathArray.size() - 1; i >= 0; i--) {
			addPath += "/" + folderPathArray.get(i);
			System.out.println("i = " + i);
		}
		System.out.println(addPath);

		String path = req.getServletContext().getRealPath("/resources/file") + addPath;
		System.out.println(path);

		// 알집저장에 필요한 파라미터 folderPath를 위한 폴더패스 세팅
		folderVO.setFolderPath(path);
		folderVO.setEmpNo(UserNoFind());
		folderVO.setFolderSe(UserDepFind());

		File file = new File(path);

		if (!file.exists()) {
			file.mkdirs();
		}

		HttpSession session = req.getSession();
		System.out.println("세선에 넣은 값 : " + folderVO.getFolderParent());
		session.setAttribute("folderCd", folderVO.getFolderParent());

		FolderVO checkDupVO = new FolderVO();
		checkDupVO.setFolderCd(folderVO.getFolderParent());
		List<FolderVO> folderList = selectChildFolder(checkDupVO);
		for (FolderVO check : folderList) {
			if (check.getFolderName().equals(folderVO.getFolderName())) {
				session.setAttribute("dup", folderVO.getFolderName() + "은(는) 현재 사용중인 폴더명입니다.");
				return "redirect:/depfiles.do";
			}
		}

		mapper.insertDepFolder(folderVO);

		return null;
	}

	public String insertDepFile(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		System.out.println("인서트 서비스 시작");
		FolderVO folderFile = new FolderVO();
		FolderFileVO fileVO = new FolderFileVO();
		fileVO.setEmpNo(UserNoFind());

		FolderVO checkDupVO = new FolderVO();
		checkDupVO.setFolderCd(folderVO.getFolderParent());
		List<FolderFileVO> fileList = selectChildFile(checkDupVO);

		// 세션 미리 생성해주기.
		HttpSession session = req.getSession();
		System.out.println("세선에 넣은 값 : " + folderVO.getFolderParent());
		session.setAttribute("folderCd", folderVO.getFolderParent());

		// 파일명 중복검사.
		for (FolderFileVO check : fileList) {
			for (int i = 0; i < folderVO.getFoFile().length; i++) {

				String[] fileOrgNameArr = folderVO.getFoFile()[i].getOriginalFilename().split("\\.");
				String fileOrgName = "";
				for (int j = 0; j < fileOrgNameArr.length - 1; j++) {
					System.out.println("대환장 네임들 : " + fileOrgNameArr[j]);
					fileOrgName += fileOrgNameArr[j];
				}
				if (check.getFileOrgname().equals(fileOrgName)) {
					session.setAttribute("fileDup", fileOrgName + "은(는) 현재 사용중인 파일명입니다.");
					return "redirect:/depfiles.do";
				}
			}
		}

		for (int i = 0; i < folderVO.getFoFile().length; i++) {

			String fileName = folderVO.getFoFile()[i].getOriginalFilename();
			System.out.println(fileName);
			String fileType = fileName.substring((fileName.lastIndexOf(".") + 1));
			System.out.println(fileType);
			UUID randomName = UUID.randomUUID();
			System.out.println(randomName);
			String fileSavename = randomName + fileName;
			System.out.println(fileSavename);

			List<String> folderPathArray = new ArrayList<String>();

			if (folderVO.getFolderParent() == null) {
				System.out.println("널");
			} else {
				System.out.println("낫널");
				// 폴더부모의 이름값들의 array를 리턴받기 위한 재귀호출.
				folderPathArray = FolderCreate(folderVO, folderPathArray);
			}

			String addPath = "";
			// for문 마이너스로 가야함.
			// 재귀호출 메소드에서 자식 >> 부모형태로 array가 쌓이므로 추가시킬땐 역순으로.
			for (int j = folderPathArray.size() - 1; j >= 0; j--) {
				addPath += "/" + folderPathArray.get(j);
				System.out.println("j = " + j);
			}
			System.out.println(addPath);

			// 일단 CRUD하듯이 멀티파트에 배열형태로 담겨져온 데이터를 SET해놓고.
			// target에 경로값, UUID+이름값을 담은후에
			// FileCopyUtils에 추가로 데이터값을 담아서 파일의 카피를 진행한다.
			// 만약 타겟에서 이름값을 보내주지 않으면 카피를 진행할때 이름이 설정되지않고 FOFILE(변수이름)로 저장되는것 같다.
			String fileSavepath = req.getServletContext().getRealPath("/" + "resources" + "/" + "file") + addPath;
			System.out.println(fileSavepath);

			String fileDataSavePath = "resources/file" + addPath + "/";
			File filePath = new File(fileSavepath);

			if (!filePath.exists()) {
				filePath.mkdirs();
			}

			byte[] fileData = folderVO.getFoFile()[i].getBytes();

			File target = new File(fileSavepath, fileSavename); // 파일 업로드 준비
			FileCopyUtils.copy(fileData, target); // 파일 복사 진행

			fileVO.setFileSec(i + 1);
			// 다운로드 횟수
			fileVO.setFileDowncnt(0);
			// 즐겨찾기 여부
			fileVO.setFileLikese(1);
			// 파일 마임타입
			fileVO.setFileMime(folderVO.getFoFile()[i].getContentType());
			// 확장자명 제거한 순수이름 가져오기.
			String[] fileOrgNameArr = folderVO.getFoFile()[i].getOriginalFilename().split("\\.");
			String fileOrgName = "";
			for (int j = 0; j < fileOrgNameArr.length - 1; j++) {
				System.out.println("대환장 네임들 : " + fileOrgNameArr[j]);
				fileOrgName += fileOrgNameArr[j];
			}
			// 파일이름
			fileVO.setFileOrgname(fileOrgName);
			// 파일 저장이름 (UUID포함)
			fileVO.setFileSavename(fileSavename);
			// 파일 저장경로
			fileVO.setFileSavepath(fileDataSavePath);
			// 파일 구분
			fileVO.setFileSe(UserDepFind());
			// 파일크기
			fileVO.setFileSize(folderVO.getFoFile()[i].getSize());
			// 파일 확장자
			fileVO.setFileType(fileType);
			System.out.println("폴더파일 폴더코드 : ");
			System.out.println(folderVO.getFolderParent());
			folderFile.setFolderCd(folderVO.getFolderParent());
			folderFile.setFileSec(i + 1);
			System.out.println("파일인서트");
			mapper.insertDepFile(fileVO);
			System.out.println("폴더파일인서트");
			mapper.depInsertFolderFile(folderFile);
			// currval에 문제있는거 물어볼것.
			// 물어보고 해결되면 insertFolderFile작업 마무리하고
			// 교수님 시간되면 > 업로드 다운로드
			// 안되시면 리스트 띄워서 확장자별로 아이콘 따로주기 작업해놓을것.
		}
		// 파일 용량업데이트
		updateParentSizeAll(folderVO);
		log.info("파일용량 업데이트에 필요한 부모CD값  : {}", folderVO.getFolderParent());
		return null;
	}

	// 전사 //
	@Override
	public int selectDefaultComFolder(FolderVO folderVO) {
		return mapper.selectDefaultComFolder(folderVO);
	}

	@Override
	public void insertDefaultComFolder(FolderVO folderVO) {
		folderVO.setEmpNo(UserNoFind());
		mapper.insertDefaultComFolder(folderVO);
	}

	@Override
	public FolderVO selectComFolder(FolderVO folderVO) {
		folderVO.setFolderSe(company);
		folderVO.setFolderCd(UserNoFind());
		System.out.println("서비스 폴더보 사원명 : " + folderVO.getEmpNo());
		System.out.println("서비스 폴더코드 명 : " + folderVO.getFolderCd());
		return mapper.selectComFolder(folderVO);
	}

	@Override
	public String insertComFolder(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) {
		// 중요!!.
		// 현재 파라미터로 받은 값은 인서트가 안된 값이기 때문에 폴더코드가 없으므로
		// 부모코드가 있을 경우, 부모코드에 대한 내용을 꼭 받아와서 로직이 처리될 수 있게해야한다.
		List<String> folderPathArray = new ArrayList<String>();
		folderPathArray.add(folderVO.getFolderName());

		if (folderVO.getFolderParent() == null) {
			System.out.println("널");
		} else {
			System.out.println("낫널");
			// 폴더부모의 이름값들의 array를 리턴받기 위한 재귀호출.
			folderPathArray = FolderCreate(folderVO, folderPathArray);
		}

		String addPath = "";
		// for문 마이너스로 가야함.
		// 재귀호출 메소드에서 자식 >> 부모형태로 array가 쌓이므로 추가시킬땐 역순으로.
		for (int i = folderPathArray.size() - 1; i >= 0; i--) {
			addPath += "/" + folderPathArray.get(i);
			System.out.println("i = " + i);
		}
		System.out.println(addPath);

		String path = req.getServletContext().getRealPath("/resources/file") + addPath;
		System.out.println(path);

		// 알집저장에 필요한 파라미터 folderPath를 위한 폴더패스 세팅
		folderVO.setFolderPath(path);
		folderVO.setEmpNo(UserNoFind());
		folderVO.setFolderSe(company);

		File file = new File(path);

		if (!file.exists()) {
			file.mkdirs();
		}

		HttpSession session = req.getSession();
		System.out.println("세선에 넣은 값 : " + folderVO.getFolderParent());
		session.setAttribute("folderCd", folderVO.getFolderParent());

		FolderVO checkDupVO = new FolderVO();
		checkDupVO.setFolderCd(folderVO.getFolderParent());
		List<FolderVO> folderList = selectChildFolder(checkDupVO);
		for (FolderVO check : folderList) {
			if (check.getFolderName().equals(folderVO.getFolderName())) {
				session.setAttribute("dup", folderVO.getFolderName() + "은(는) 현재 사용중인 폴더명입니다.");
				return "redirect:/comfiles.do";
			}
		}

		mapper.insertComFolder(folderVO);

		return null;
	}

	public String insertComFile(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		System.out.println("인서트 서비스 시작");
		FolderVO folderFile = new FolderVO();
		FolderFileVO fileVO = new FolderFileVO();
		fileVO.setEmpNo(UserNoFind());

		FolderVO checkDupVO = new FolderVO();
		checkDupVO.setFolderCd(folderVO.getFolderParent());
		List<FolderFileVO> fileList = selectChildFile(checkDupVO);

		// 세션 미리 생성해주기.
		HttpSession session = req.getSession();
		System.out.println("세선에 넣은 값 : " + folderVO.getFolderParent());
		session.setAttribute("folderCd", folderVO.getFolderParent());

		// 파일명 중복검사.
		for (FolderFileVO check : fileList) {
			for (int i = 0; i < folderVO.getFoFile().length; i++) {

				String[] fileOrgNameArr = folderVO.getFoFile()[i].getOriginalFilename().split("\\.");
				String fileOrgName = "";
				for (int j = 0; j < fileOrgNameArr.length - 1; j++) {
					System.out.println("대환장 네임들 : " + fileOrgNameArr[j]);
					fileOrgName += fileOrgNameArr[j];
				}
				if (check.getFileOrgname().equals(fileOrgName)) {
					session.setAttribute("fileDup", fileOrgName + "은(는) 현재 사용중인 파일명입니다.");
					return "redirect:/comfiles.do";
				}
			}
		}

		for (int i = 0; i < folderVO.getFoFile().length; i++) {

			String fileName = folderVO.getFoFile()[i].getOriginalFilename();
			System.out.println(fileName);
			String fileType = fileName.substring((fileName.lastIndexOf(".") + 1));
			System.out.println(fileType);
			UUID randomName = UUID.randomUUID();
			System.out.println(randomName);
			String fileSavename = randomName + fileName;
			System.out.println(fileSavename);

			List<String> folderPathArray = new ArrayList<String>();

			if (folderVO.getFolderParent() == null) {
				System.out.println("널");
			} else {
				System.out.println("낫널");
				// 폴더부모의 이름값들의 array를 리턴받기 위한 재귀호출.
				folderPathArray = FolderCreate(folderVO, folderPathArray);
			}

			String addPath = "";
			// for문 마이너스로 가야함.
			// 재귀호출 메소드에서 자식 >> 부모형태로 array가 쌓이므로 추가시킬땐 역순으로.
			for (int j = folderPathArray.size() - 1; j >= 0; j--) {
				addPath += "/" + folderPathArray.get(j);
				System.out.println("j = " + j);
			}
			System.out.println(addPath);

			// 일단 CRUD하듯이 멀티파트에 배열형태로 담겨져온 데이터를 SET해놓고.
			// target에 경로값, UUID+이름값을 담은후에
			// FileCopyUtils에 추가로 데이터값을 담아서 파일의 카피를 진행한다.
			// 만약 타겟에서 이름값을 보내주지 않으면 카피를 진행할때 이름이 설정되지않고 FOFILE(변수이름)로 저장되는것 같다.
			String fileSavepath = req.getServletContext().getRealPath("/" + "resources" + "/" + "file") + addPath;
			System.out.println(fileSavepath);

			String fileDataSavePath = "resources/file" + addPath + "/";
			File filePath = new File(fileSavepath);

			if (!filePath.exists()) {
				filePath.mkdirs();
			}

			byte[] fileData = folderVO.getFoFile()[i].getBytes();

			File target = new File(fileSavepath, fileSavename); // 파일 업로드 준비
			FileCopyUtils.copy(fileData, target); // 파일 복사 진행

			fileVO.setFileSec(i + 1);
			// 다운로드 횟수
			fileVO.setFileDowncnt(0);
			// 즐겨찾기 여부
			fileVO.setFileLikese(1);
			// 파일 마임타입
			fileVO.setFileMime(folderVO.getFoFile()[i].getContentType());
			// 확장자명 제거한 순수이름 가져오기.
			String[] fileOrgNameArr = folderVO.getFoFile()[i].getOriginalFilename().split("\\.");
			String fileOrgName = "";
			for (int j = 0; j < fileOrgNameArr.length - 1; j++) {
				System.out.println("대환장 네임들 : " + fileOrgNameArr[j]);
				fileOrgName += fileOrgNameArr[j];
			}
			// 파일이름
			fileVO.setFileOrgname(fileOrgName);
			// 파일 저장이름 (UUID포함)
			fileVO.setFileSavename(fileSavename);
			// 파일 저장경로
			fileVO.setFileSavepath(fileDataSavePath);
			// 파일 구분
			fileVO.setFileSe(company);
			// 파일크기
			fileVO.setFileSize(folderVO.getFoFile()[i].getSize());
			// 파일 확장자
			fileVO.setFileType(fileType);
			System.out.println("폴더파일 폴더코드 : ");
			System.out.println(folderVO.getFolderParent());
			folderFile.setFolderCd(folderVO.getFolderParent());
			folderFile.setFileSec(i + 1);
			System.out.println("파일인서트");
				mapper.insertComFile(fileVO);
			System.out.println("폴더파일인서트");
			mapper.comInsertFolderFile(folderFile);
			
			
			// 파일 용량업데이트
			mapper.updateFolderSize(folderVO.getFolderParent());
			log.info("파일용량 업데이트에 필요한 부모CD값  : {}" , folderVO.getFolderParent());
			
			// currval에 문제있는거 물어볼것.
			// 물어보고 해결되면 insertFolderFile작업 마무리하고
			// 교수님 시간되면 > 업로드 다운로드
			// 안되시면 리스트 띄워서 확장자별로 아이콘 따로주기 작업해놓을것.
		}
		// 파일 용량업데이트
		updateParentSizeAll(folderVO);
		log.info("파일용량 업데이트에 필요한 부모CD값  : {}" , folderVO.getFolderParent());
		return null;
	}

	// 중요
	@Override
	public int selectDefaultImpFolder(FolderVO folderVO) {
		return mapper.selectDefaultImpFolder(folderVO);
	}

	@Override
	public void insertDefaultImpFolder(FolderVO folderVO) {
		mapper.insertDefaultImpFolder(folderVO);
	}

	@Override
	public FolderVO selectImpFolder(FolderVO folderVO) {
		folderVO.setFolderSe(UserNoFind() + "Imp");
		folderVO.setFolderCd(UserNoFind() + "Imp");
		System.out.println("서비스 폴더보 사원명 : " + folderVO.getEmpNo());
		System.out.println("서비스 폴더코드 명 : " + folderVO.getFolderCd());
		return mapper.selectImpFolder(folderVO);
	}

	@Override
	public List<FolderFileVO> showImpFiles(FolderVO folderVO) {
		folderVO.setEmpNo(UserNoFind());
		return mapper.showImpFiles(folderVO);
	}

	// 파일 좋아요 기능을 처리해주는 서비스로직.
	@Override
	public Map<String, Object> impUpdateLikeSe(Map<String, Object> param) {

		// 파라미터값을 가져와서 넘어온 fileCd를 확인
		String fileCd = (String) param.get("fileCd");
		System.out.print("좋아요업데이트로 넘어온 파람 값 : ");
		System.out.println(fileCd);

		// 받은 fileCd값을 VO에 넣어준후, 해당 코드의 파일값을 구해옴.
		FolderFileVO folderFileVO = new FolderFileVO();
		folderFileVO.setFileCd(fileCd);

		// 리턴타입으로 라이크상태의 파일들을 보내줄 설정파일
		List<FolderFileVO> folderFileLike = new ArrayList<FolderFileVO>();

		// 파라미터값으로 필요한 폴더VO
		FolderVO folderVO = new FolderVO();
		folderVO.setEmpNo(UserNoFind());

		folderFileVO = selectMyselfFile(folderFileVO);

		// 좋아요상태를 설정한다.
		// 좋아요상태가 아니었다면(1) set값을 '2'로 해주고,
		// 이미 좋아요 상태였다면(2) set값을 '1'로 해준다.
		if (folderFileVO.getFileLikese() == 1) {
			folderFileVO.setFileLikese(2);
		} else if (folderFileVO.getFileLikese() == 2) {
			folderFileVO.setFileLikese(1);
		}

		// 이제 업데이트 하는 로직으로 쏴준다.
		mapper.updateLikeSe(folderFileVO);

		// 라이크된애들만 모아주는 showImpFiles를 리스트에 담아준다.
		folderFileLike = mapper.showImpFiles(folderVO);

		// ajax리턴으로 보내줄 변경된 값을 다시 셀렉트로 가져온다.
		folderFileVO = selectMyselfFile(folderFileVO);

		// 마지막으로 Map에 해당내용을 담아주고 리턴시켜준다.
		Map<String, Object> likeMap = new HashMap<String, Object>();
		likeMap.put("fileLike", folderFileVO);
		likeMap.put("folderFileLike", folderFileLike);

		System.out.println(folderFileVO.getFileLikese());
		for (int i = 0; i < folderFileLike.size(); i++) {
			System.out.println(folderFileLike.get(i));
		}

		return likeMap;
	}

	@Override
	public Map<String, Object> impSearchText(Map<String, String> param) {
		String searchText = param.get("searchText");

		System.out.println("에이잭스 컨트롤러 시작");

		FolderVO folderVO = new FolderVO();

		folderVO.setSearchText(searchText);
		folderVO.setEmpNo(UserNoFind());

		List<FolderFileVO> fileList = mapper.impSearchText(folderVO);

		for (int i = 0; i < fileList.size(); i++) {
			System.out.println(fileList.get(i));
		}

		Map<String, Object> searchMap = new HashMap<String, Object>();

		searchMap.put("fileList", fileList);

		return searchMap;
	}

	@Override
	public String impSelectUnlike(List<String> fileArray) {

		if (fileArray != null) {
			for (int i = 0; i < fileArray.size(); i++) {
				FolderFileVO fileVO = new FolderFileVO();
				String fileCd = fileArray.get(i);
				fileVO.setFileCd(fileCd);

				fileVO = selectMyselfFile(fileVO);

				if (fileVO.getFileLikese() == 1) {
					fileVO.setFileLikese(2);
				} else if (fileVO.getFileLikese() == 2) {
					fileVO.setFileLikese(1);
				}
				mapper.updateLikeSe(fileVO);
			}
		}
		return "redirect:/impfiles.do";
	}

	@Override
	public List<FolderFileVO> showImpFilesDate(FolderVO folderVO) {
		folderVO.setEmpNo(UserNoFind());
		return mapper.showImpFilesDate(folderVO);
	}

	// 공통 //
	@Override
	public String fileShare(List<String> folderArray, List<String> fileArray, HttpServletRequest req,
			HttpServletResponse resp) throws IOException {

		String sourcePath = "";

		// 폴더중복체크
		for (int i = 0; i < folderArray.size(); i++) {
			List<FolderVO> allIndFoders = new ArrayList<FolderVO>();
			allIndFoders = mapper.selectAllIndFolders(UserNoFind());
			for (int f = 0; f < allIndFoders.size(); f++) {
				log.info("s추가된 폴더어레이 값 : {}", ("s" + folderArray.get(i)));
				log.info("전체폴더에서 꺼내온 값 : {}", allIndFoders.get(f).getFolderCd());
				if (("s" + folderArray.get(i)).equals(allIndFoders.get(f).getFolderCd())) {
					HttpSession session = req.getSession();
					String shareDup = "이미 공유완료된 자료입니다";
					session.setAttribute("shareDup", shareDup);
					return null;
				}
			}
		}

		for (int i = 0; i < folderArray.size(); i++) {
			// folderSe, empNo, folderParent, folderPath 바꿔야함.
			List<String> shareList = new ArrayList<String>();
			List<String> shareFileList = new ArrayList<String>();
			FolderVO folderList = new FolderVO();
			folderList.setFolderCd(folderArray.get(i));
			folderList = selectMyselfFolder(folderList);
			shareList = shareList(folderList, shareList, shareFileList);

			// 폴더중복체크
			for (int ff = 0; ff < shareList.size(); ff++) {
				List<FolderVO> allIndFoders = new ArrayList<FolderVO>();
				allIndFoders = mapper.selectAllIndFolders(UserNoFind());
				for (int f = 0; f < allIndFoders.size(); f++) {
					log.info("s추가된 폴더어레이 값 : {}", ("s" + shareList.get(ff)));
					log.info("전체폴더에서 꺼내온 값 : {}", allIndFoders.get(f).getFolderCd());
					if (("s" + shareList.get(ff)).equals(allIndFoders.get(f).getFolderCd())) {
						HttpSession session
						= req.getSession();
						String shareDup = "이미 공유완료된 자료입니다";
						session.setAttribute("shareDup", shareDup);
						return null;
					}
				}
			}

			FolderVO parent = selectParentFolder(folderList.getFolderParent());
			System.out.println("페어런트 값 : ");
			System.out.println(parent);
			sourcePath = parent.getFolderPath();
			sourcePath = sourcePath.replace("\\", "/");
			System.out.print("바깥쪽 소스패스 : ");
			System.out.println(sourcePath);

			for (int j = 0; j < shareList.size(); j++) {
				System.out.println(shareList.get(j));

				FolderVO shareFolder = new FolderVO();
				shareFolder.setFolderCd(shareList.get(j));
				shareFolder = selectMyselfFolder(shareFolder);

				System.out.println("셰어에 올라간 리스트 :");
				System.out.println(shareFolder);

				// folderCd
				shareFolder.setFolderCd("s" + shareFolder.getFolderCd());
				System.out.println("셰어 이후 cd : ");
				System.out.println(shareFolder.getFolderCd());
				// folderSe
				shareFolder.setFolderSe("개인");
				System.out.println("셰어 이후 se : ");
				System.out.println(shareFolder.getFolderSe());
				// empNo (완료)
				shareFolder.setEmpNo(UserNoFind());
				System.out.println("셰어 이후 empNo : ");
				System.out.println(shareFolder.getEmpNo());
				// folderName
				shareFolder.setFolderName(shareFolder.getFolderName());
				// folderParent
				System.out.print("셰어폴더의 페어런트값 : ");
				System.out.println(shareFolder.getFolderParent());
				System.out.print("부서값 : ");
				System.out.println(UserDepFind());
				if (shareFolder.getFolderParent().equals(UserDepFind())
						|| shareFolder.getFolderParent().equals(company)) {
					System.out.println("페어런트가 같다.");
					shareFolder.setFolderParent(UserNoFind());
				} else {
					System.out.println("페어런트가 같지 않다.");
					shareFolder.setFolderParent("s" + shareFolder.getFolderParent());
				}
				System.out.println("셰어 이후 parent : ");
				System.out.println(shareFolder.getFolderParent());

				// folderDelse (기존꺼로대체)
				// folderPath
//					String originalString = shareFolder.getFolderPath();
//					String dynamicValue = "";
//					if (shareFolder.getFolderSe().equals(company)) {
//						System.out.println("컴퍼니다");
//						dynamicValue = req.getServletContext().getRealPath("\\resources\\file\\") + company;
//					} else {
//						System.out.println("컴퍼니가아니다.");
//						dynamicValue = req.getServletContext().getRealPath("\\resources\\file\\") + "/" + UserDepFind();
//					}
//					String ownPath = originalString.replace(dynamicValue, "");
//					System.out.print("오리지널 : ");
//					System.out.println(originalString);
//					System.out.print("잘라낸 부분 : ");
//					System.out.println(dynamicValue);
				System.out.print("원본 폴더패스 : ");
				shareFolder.setFolderPath(shareFolder.getFolderPath().replace("\\", "/"));
				System.out.println(shareFolder.getFolderPath());
				System.out.print("부모 소스패스 : ");
				System.out.println(sourcePath);

				String ownPath = shareFolder.getFolderPath().replace(sourcePath, "");

				String folderPath = req.getServletContext().getRealPath("\\resources\\file") + "/" + UserNoFind()
						+ ownPath;
				shareFolder.setFolderPath(folderPath);
				System.out.println("셰어 이후 path : ");
				System.out.println(shareFolder.getFolderPath());
				// folderUploaddt (시스데이트)

				File file = new File(shareFolder.getFolderPath());
				if (!file.exists()) {
					file.mkdirs();
				}

				mapper.folderShare(shareFolder);
			}

			for (int j = 0; j < shareFileList.size(); j++) {
				FolderFileVO fileList = new FolderFileVO();
				FolderFileVO copyFileVO = new FolderFileVO();
				if (shareFileList != null) {
					fileList.setFileCd(shareFileList.get(j));
					fileList = mapper.selectMyselfFile(fileList);
					copyFileVO = mapper.selectMyselfFile(fileList);

					String basicPath = req.getServletContext().getRealPath("");
					String sourceFilePath = fileList.getFileSavepath();
					String sourceFileName = fileList.getFileSavename();

					String copyFileName = fileList.getFileSavename();
					File souceFile = new File(basicPath + sourceFilePath + sourceFileName);

//					String[] pahtArray = SourceFilePath.split("/");
//					String copysavePath = "";
//					for (int k = 0; k < pahtArray.length; k++) {
//						if (k <= 1) {
//							copysavePath += pahtArray[k] + "/";
//						} else if (k == 2) {
//							copysavePath += UserNoFind() + "/";
//						} else {
//							copysavePath += pahtArray[k] + "/";
//						}
//					}

//					String copyFilePath = basicPath + copysavePath;
//					System.out.println("불러올 경로 : " + basicPath + SourceFilePath + SourceFileName);
//					System.out.println("저장될 경로 : " + copyFilePath + copyFileName);

					String userNo = UserNoFind();

					String contextPath = req.getServletContext().getRealPath("");
					contextPath = contextPath.replace("\\", "/");
					System.out.print("컨텍스트 패스 값 : ");
					System.out.println(contextPath);
					sourcePath = sourcePath.replace("\\", "/");
					String sourcePartPath = sourcePath.replace(contextPath, "");
					System.out.print("부모 폴더에서 컨텍스트 패스를 뺀값");
					System.out.println(sourcePartPath);
					sourceFilePath = sourceFilePath.replace("\\", "/");
					String copySparePath = sourceFilePath.replace(sourcePartPath, "");
					System.out.print("파일 패스에서 부모요소를 뺀 값");
					System.out.println(copySparePath);
					String copyPath = contextPath + "/resources/file/" + userNo + copySparePath;
					System.out.print("최종 파일패스에 들어갈 값");
					System.out.println(copyPath);

					// 파일 cd
					fileList.setFileCd("s" + fileList.getFileCd());
					System.out.println("파일cd : " + fileList.getFileCd());
					// 파일 올린사람
					fileList.setEmpNo(userNo);
					// 파일 자료실유형
					fileList.setFileSe("개인");
					// 파일경로의 전사 혹은 부서에대한 내용을 개인으로 바꿔줌
					log.info("넘어온 파일값들의 패쓰 : {}", sourceFilePath);
					if (sourceFilePath.contains(company)) {
						fileList.setFileSavepath(sourceFilePath.replace(company, userNo));
					}
					if (sourceFilePath.contains(UserDepFind())) {
						fileList.setFileSavepath(sourceFilePath.replace(UserDepFind(), userNo));
					}
					log.info("넘어온 파일값의 패쓰를 변환한 값 : {}", fileList.getFileSavepath());

					FolderVO folderVO = new FolderVO();
					folderVO.setFileCd(fileList.getFileCd());
					folderVO = mapper.selectMyFolderFile(copyFileVO);
					folderVO.setFileCd("s" + folderVO.getFileCd());
					folderVO.setFolderCd("s" + folderVO.getFolderCd());
					folderVO.setFileCd(folderVO.getFileCd());

					mapper.insertShareFile(fileList);
					mapper.insertShareFolderFile(folderVO);

					File copyFile = new File(copyPath + sourceFileName);
					// 복사 대상 파일을 생성

					Files.copy(souceFile.toPath(), copyFile.toPath());
				}

			}
			FolderVO folderSave = new FolderVO();
			folderSave.setFolderCd("s" + folderArray.get(i));
			folderSave = selectMyselfFolder(folderSave);
			folderSave.setFolderParent(UserNoFind());
			mapper.folderShareUpdate(folderSave);
		}

		// 파일중복체크
		for (int i = 0; i < fileArray.size(); i++) {
			List<FolderVO> allIndFoders = new ArrayList<FolderVO>();
			allIndFoders = mapper.selectAllIndFiles(UserNoFind());
			for (int f = 0; f < allIndFoders.size(); f++) {
				log.info("s추가된 폴더어레이 값 : {}", ("s" + fileArray.get(i)));
				log.info("전체폴더에서 꺼내온 값 : {}", allIndFoders.get(f).getFileCd());
				if (("s" + fileArray.get(i)).equals(allIndFoders.get(f).getFileCd())) {
					HttpSession session = req.getSession();
					String shareDup = "이미 공유완료된 파일입니다";
					session.setAttribute("shareDup", shareDup);
					return null;
				}
			}
		}

		for (int i = 0; i < fileArray.size(); i++) {

			FolderFileVO fileList = new FolderFileVO();
			FolderFileVO copyFileVO = new FolderFileVO();
			if (fileArray != null) {
				fileList.setFileCd(fileArray.get(i));
				fileList = mapper.selectMyselfFile(fileList);
				copyFileVO = mapper.selectMyselfFile(fileList);

				String basicPath = req.getServletContext().getRealPath("");
				String sourceFilePath = fileList.getFileSavepath();
				String sourceFileName = fileList.getFileSavename();

				String copyFileName = fileList.getFileSavename();

				File souceFile = new File(basicPath + sourceFilePath + sourceFileName);

//				String[] pahtArray = SourceFilePath.split("/");
//				String copysavePath = "";
//				for (int k = 0; k < pahtArray.length; k++) {
//					if (k <= 1) {
//						copysavePath += pahtArray[k] + "/";
//					} else if (k == 2) {
//						copysavePath += UserNoFind() + "/";
//					} else {
//						copysavePath += pahtArray[k] + "/";
//					}
//				}

//				String copyFilePath = basicPath + copysavePath;
//				System.out.println("불러올 경로 : " + basicPath + SourceFilePath + SourceFileName);
//				System.out.println("저장될 경로 : " + copyFilePath + copyFileName);

				String copyPath = req.getServletContext().getRealPath("/resources/file") + "/" + UserNoFind() + "/";

				// 파일 cd
				fileList.setFileCd("s" + fileList.getFileCd());
				System.out.println("파일cd : " + fileList.getFileCd());
				// 파일 올린사람
				fileList.setEmpNo(UserNoFind());
				// 파일 자료실유형
				fileList.setFileSe("개인");
//				fileList.setFileSavepath(copysavePath);

				FolderVO folderVO = new FolderVO();
				folderVO.setFileCd(fileList.getFileCd());
				folderVO.setFolderCd(UserNoFind());
				folderVO.setFileCd(folderVO.getFileCd());

				// 파일중복체크

				mapper.insertShareFile(fileList);
				mapper.insertShareFolderFile(folderVO);

				File copyFile = new File(copyPath + sourceFileName);
				// 복사 대상 파일을 생성

				Files.copy(souceFile.toPath(), copyFile.toPath());
			}
		}
		String shareDup = "개인자료실로 공유가 완료되었습니다";
		HttpSession session = req.getSession();
		session.setAttribute("shareDup", shareDup);
		return null;
	}

	@Override
	public List<DeptVO> selectAllDeptList() {
		return mapper.selectAllDeptList();
	}

	@Override
	public FolderVO selectAdminDepFolder(FolderVO selectedDep) {
		return mapper.selectDepFolder(selectedDep);
	}

	@Override
	public String insertDepFolderAdmin(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) {
		// 중요!!.
		// 현재 파라미터로 받은 값은 인서트가 안된 값이기 때문에 폴더코드가 없으므로
		// 부모코드가 있을 경우, 부모코드에 대한 내용을 꼭 받아와서 로직이 처리될 수 있게해야한다.
		List<String> folderPathArray = new ArrayList<String>();
		folderPathArray.add(folderVO.getFolderName());

		if (folderVO.getFolderParent() == null) {
			System.out.println("널");
		} else {
			System.out.println("낫널");
			// 폴더부모의 이름값들의 array를 리턴받기 위한 재귀호출.
			folderPathArray = FolderCreate(folderVO, folderPathArray);
		}

		String addPath = "";
		// for문 마이너스로 가야함.
		// 재귀호출 메소드에서 자식 >> 부모형태로 array가 쌓이므로 추가시킬땐 역순으로.
		for (int i = folderPathArray.size() - 1; i >= 0; i--) {
			addPath += "/" + folderPathArray.get(i);
			System.out.println("i = " + i);
		}
		System.out.println(addPath);

		String path = req.getServletContext().getRealPath("/resources/file") + addPath;
		System.out.println(path);

		// 알집저장에 필요한 파라미터 folderPath를 위한 폴더패스 세팅
		folderVO.setFolderPath(path);
		folderVO.setEmpNo(UserNoFind());
		folderVO.setFolderSe(UserDepFind());

		File file = new File(path);

		if (!file.exists()) {
			file.mkdirs();
		}

		HttpSession session = req.getSession();
		System.out.println("세선에 넣은 값 : " + folderVO.getFolderParent());
		session.setAttribute("folderCd", folderVO.getFolderParent());

		FolderVO checkDupVO = new FolderVO();
		checkDupVO.setFolderCd(folderVO.getFolderParent());
		List<FolderVO> folderList = selectChildFolder(checkDupVO);
		for (FolderVO check : folderList) {
			if (check.getFolderName().equals(folderVO.getFolderName())) {
				session.setAttribute("dup", folderVO.getFolderName() + "은(는) 현재 사용중인 폴더명입니다.");
				return "redirect:/adminDepfiles.do";
			}
		}

		mapper.insertDepFolder(folderVO);

		return null;
	}

	@Override
	public String insertDepFileAdmin(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		FolderVO folderFile = new FolderVO();
		FolderFileVO fileVO = new FolderFileVO();
		fileVO.setEmpNo(UserNoFind());

		FolderVO checkDupVO = new FolderVO();
		checkDupVO.setFolderCd(folderVO.getFolderParent());
		List<FolderFileVO> fileList = selectChildFile(checkDupVO);

		// 세션 미리 생성해주기.
		HttpSession session = req.getSession();
		System.out.println("세선에 넣은 값 : " + folderVO.getFolderParent());
		session.setAttribute("folderCd", folderVO.getFolderParent());

		// 파일명 중복검사.
		for (FolderFileVO check : fileList) {
			for (int i = 0; i < folderVO.getFoFile().length; i++) {

				String[] fileOrgNameArr = folderVO.getFoFile()[i].getOriginalFilename().split("\\.");
				String fileOrgName = "";
				for (int j = 0; j < fileOrgNameArr.length - 1; j++) {
					System.out.println("대환장 네임들 : " + fileOrgNameArr[j]);
					fileOrgName += fileOrgNameArr[j];
				}
				if (check.getFileOrgname().equals(fileOrgName)) {
					session.setAttribute("fileDup", fileOrgName + "은(는) 현재 사용중인 파일명입니다.");
					return "redirect:/adminDepfiles.do";
				}
			}
		}

		for (int i = 0; i < folderVO.getFoFile().length; i++) {

			String fileName = folderVO.getFoFile()[i].getOriginalFilename();
			System.out.println(fileName);
			String fileType = fileName.substring((fileName.lastIndexOf(".") + 1));
			System.out.println(fileType);
			UUID randomName = UUID.randomUUID();
			System.out.println(randomName);
			String fileSavename = randomName + fileName;
			System.out.println(fileSavename);

			List<String> folderPathArray = new ArrayList<String>();

			if (folderVO.getFolderParent() == null) {
				System.out.println("널");
			} else {
				System.out.println("낫널");
				// 폴더부모의 이름값들의 array를 리턴받기 위한 재귀호출.
				folderPathArray = FolderCreate(folderVO, folderPathArray);
			}

			String addPath = "";
			// for문 마이너스로 가야함.
			// 재귀호출 메소드에서 자식 >> 부모형태로 array가 쌓이므로 추가시킬땐 역순으로.
			for (int j = folderPathArray.size() - 1; j >= 0; j--) {
				addPath += "/" + folderPathArray.get(j);
				System.out.println("j = " + j);
			}
			System.out.println(addPath);

			// 일단 CRUD하듯이 멀티파트에 배열형태로 담겨져온 데이터를 SET해놓고.
			// target에 경로값, UUID+이름값을 담은후에
			// FileCopyUtils에 추가로 데이터값을 담아서 파일의 카피를 진행한다.
			// 만약 타겟에서 이름값을 보내주지 않으면 카피를 진행할때 이름이 설정되지않고 FOFILE(변수이름)로 저장되는것 같다.
			String fileSavepath = req.getServletContext().getRealPath("/" + "resources" + "/" + "file") + addPath;
			System.out.println(fileSavepath);

			String fileDataSavePath = "resources/file" + addPath + "/";
			File filePath = new File(fileSavepath);

			if (!filePath.exists()) {
				filePath.mkdirs();
			}

			byte[] fileData = folderVO.getFoFile()[i].getBytes();

			File target = new File(fileSavepath, fileSavename); // 파일 업로드 준비
			FileCopyUtils.copy(fileData, target); // 파일 복사 진행

			fileVO.setFileSec(i + 1);
			// 다운로드 횟수
			fileVO.setFileDowncnt(0);
			// 즐겨찾기 여부
			fileVO.setFileLikese(1);
			// 파일 마임타입
			fileVO.setFileMime(folderVO.getFoFile()[i].getContentType());
			// 확장자명 제거한 순수이름 가져오기.
			String[] fileOrgNameArr = folderVO.getFoFile()[i].getOriginalFilename().split("\\.");
			String fileOrgName = "";
			for (int j = 0; j < fileOrgNameArr.length - 1; j++) {
				System.out.println("대환장 네임들 : " + fileOrgNameArr[j]);
				fileOrgName += fileOrgNameArr[j];
			}
			// 파일이름
			fileVO.setFileOrgname(fileOrgName);
			// 파일 저장이름 (UUID포함)
			fileVO.setFileSavename(fileSavename);
			// 파일 저장경로
			fileVO.setFileSavepath(fileDataSavePath);
			// 파일 구분
			fileVO.setFileSe(UserDepFind());
			// 파일크기
			fileVO.setFileSize(folderVO.getFoFile()[i].getSize());
			// 파일 확장자
			fileVO.setFileType(fileType);
			System.out.println("폴더파일 폴더코드 : ");
			System.out.println(folderVO.getFolderParent());
			folderFile.setFolderCd(folderVO.getFolderParent());
			folderFile.setFileSec(i + 1);
			System.out.println("파일인서트");
			mapper.insertDepFile(fileVO);
			System.out.println("폴더파일인서트");
			mapper.depInsertFolderFile(folderFile);
			// currval에 문제있는거 물어볼것.
			// 물어보고 해결되면 insertFolderFile작업 마무리하고
			// 교수님 시간되면 > 업로드 다운로드
			// 안되시면 리스트 띄워서 확장자별로 아이콘 따로주기 작업해놓을것.
		}
		// 파일 용량업데이트
		updateParentSizeAll(folderVO);
		log.info("파일용량 업데이트에 필요한 부모CD값  : {}" , folderVO.getFolderParent());
		return null;
	}

	@Override
	public String insertComFolderAdmin(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) {
		// 중요!!.
		// 현재 파라미터로 받은 값은 인서트가 안된 값이기 때문에 폴더코드가 없으므로
		// 부모코드가 있을 경우, 부모코드에 대한 내용을 꼭 받아와서 로직이 처리될 수 있게해야한다.
		List<String> folderPathArray = new ArrayList<String>();
		folderPathArray.add(folderVO.getFolderName());

		if (folderVO.getFolderParent() == null) {
			System.out.println("널");
		} else {
			System.out.println("낫널");
			// 폴더부모의 이름값들의 array를 리턴받기 위한 재귀호출.
			folderPathArray = FolderCreate(folderVO, folderPathArray);
		}

		String addPath = "";
		// for문 마이너스로 가야함.
		// 재귀호출 메소드에서 자식 >> 부모형태로 array가 쌓이므로 추가시킬땐 역순으로.
		for (int i = folderPathArray.size() - 1; i >= 0; i--) {
			addPath += "/" + folderPathArray.get(i);
			System.out.println("i = " + i);
		}
		System.out.println(addPath);

		String path = req.getServletContext().getRealPath("/resources/file") + addPath;
		System.out.println(path);

		// 알집저장에 필요한 파라미터 folderPath를 위한 폴더패스 세팅
		folderVO.setFolderPath(path);
		folderVO.setEmpNo(UserNoFind());
		folderVO.setFolderSe(company);

		File file = new File(path);

		if (!file.exists()) {
			file.mkdirs();
		}

		HttpSession session = req.getSession();
		System.out.println("세선에 넣은 값 : " + folderVO.getFolderParent());
		session.setAttribute("folderCd", folderVO.getFolderParent());

		FolderVO checkDupVO = new FolderVO();
		checkDupVO.setFolderCd(folderVO.getFolderParent());
		List<FolderVO> folderList = selectChildFolder(checkDupVO);
		for (FolderVO check : folderList) {
			if (check.getFolderName().equals(folderVO.getFolderName())) {
				session.setAttribute("dup", folderVO.getFolderName() + "은(는) 현재 사용중인 폴더명입니다.");
				return "redirect:/adminComfiles.do";
			}
		}

		mapper.insertComFolder(folderVO);
		
		return null;
	}

	public String insertComFileAdmin(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		System.out.println("인서트 서비스 시작");
		FolderVO folderFile = new FolderVO();
		FolderFileVO fileVO = new FolderFileVO();
		fileVO.setEmpNo(UserNoFind());

		FolderVO checkDupVO = new FolderVO();
		checkDupVO.setFolderCd(folderVO.getFolderParent());
		List<FolderFileVO> fileList = selectChildFile(checkDupVO);

		// 세션 미리 생성해주기.
		HttpSession session = req.getSession();
		System.out.println("세선에 넣은 값 : " + folderVO.getFolderParent());
		session.setAttribute("folderCd", folderVO.getFolderParent());

		// 파일명 중복검사.
		for (FolderFileVO check : fileList) {
			for (int i = 0; i < folderVO.getFoFile().length; i++) {

				String[] fileOrgNameArr = folderVO.getFoFile()[i].getOriginalFilename().split("\\.");
				String fileOrgName = "";
				for (int j = 0; j < fileOrgNameArr.length - 1; j++) {
					System.out.println("대환장 네임들 : " + fileOrgNameArr[j]);
					fileOrgName += fileOrgNameArr[j];
				}
				if (check.getFileOrgname().equals(fileOrgName)) {
					session.setAttribute("fileDup", fileOrgName + "은(는) 현재 사용중인 파일명입니다.");
					return "redirect:/insertComFileAdmin.do";
				}
			}
		}

		for (int i = 0; i < folderVO.getFoFile().length; i++) {

			String fileName = folderVO.getFoFile()[i].getOriginalFilename();
			System.out.println(fileName);
			String fileType = fileName.substring((fileName.lastIndexOf(".") + 1));
			System.out.println(fileType);
			UUID randomName = UUID.randomUUID();
			System.out.println(randomName);
			String fileSavename = randomName + fileName;
			System.out.println(fileSavename);

			List<String> folderPathArray = new ArrayList<String>();

			if (folderVO.getFolderParent() == null) {
				System.out.println("널");
			} else {
				System.out.println("낫널");
				// 폴더부모의 이름값들의 array를 리턴받기 위한 재귀호출.
				folderPathArray = FolderCreate(folderVO, folderPathArray);
			}

			String addPath = "";
			// for문 마이너스로 가야함.
			// 재귀호출 메소드에서 자식 >> 부모형태로 array가 쌓이므로 추가시킬땐 역순으로.
			for (int j = folderPathArray.size() - 1; j >= 0; j--) {
				addPath += "/" + folderPathArray.get(j);
				System.out.println("j = " + j);
			}
			System.out.println(addPath);

			// 일단 CRUD하듯이 멀티파트에 배열형태로 담겨져온 데이터를 SET해놓고.
			// target에 경로값, UUID+이름값을 담은후에
			// FileCopyUtils에 추가로 데이터값을 담아서 파일의 카피를 진행한다.
			// 만약 타겟에서 이름값을 보내주지 않으면 카피를 진행할때 이름이 설정되지않고 FOFILE(변수이름)로 저장되는것 같다.
			String fileSavepath = req.getServletContext().getRealPath("/" + "resources" + "/" + "file") + addPath;
			System.out.println(fileSavepath);

			String fileDataSavePath = "resources/file" + addPath + "/";
			File filePath = new File(fileSavepath);

			if (!filePath.exists()) {
				filePath.mkdirs();
			}

			byte[] fileData = folderVO.getFoFile()[i].getBytes();

			File target = new File(fileSavepath, fileSavename); // 파일 업로드 준비
			FileCopyUtils.copy(fileData, target); // 파일 복사 진행

			fileVO.setFileSec(i + 1);
			// 다운로드 횟수
			fileVO.setFileDowncnt(0);
			// 즐겨찾기 여부
			fileVO.setFileLikese(1);
			// 파일 마임타입
			fileVO.setFileMime(folderVO.getFoFile()[i].getContentType());
			// 확장자명 제거한 순수이름 가져오기.
			String[] fileOrgNameArr = folderVO.getFoFile()[i].getOriginalFilename().split("\\.");
			String fileOrgName = "";
			for (int j = 0; j < fileOrgNameArr.length - 1; j++) {
				System.out.println("대환장 네임들 : " + fileOrgNameArr[j]);
				fileOrgName += fileOrgNameArr[j];
			}
			// 파일이름
			fileVO.setFileOrgname(fileOrgName);
			// 파일 저장이름 (UUID포함)
			fileVO.setFileSavename(fileSavename);
			// 파일 저장경로
			fileVO.setFileSavepath(fileDataSavePath);
			// 파일 구분
			fileVO.setFileSe(company);
			// 파일크기
			fileVO.setFileSize(folderVO.getFoFile()[i].getSize());
			// 파일 확장자
			fileVO.setFileType(fileType);
			System.out.println("폴더파일 폴더코드 : ");
			System.out.println(folderVO.getFolderParent());
			folderFile.setFolderCd(folderVO.getFolderParent());
			folderFile.setFileSec(i + 1);
			System.out.println("파일인서트");
			mapper.insertComFile(fileVO);
			System.out.println("폴더파일인서트");
			mapper.comInsertFolderFile(folderFile);
			// currval에 문제있는거 물어볼것.
			// 물어보고 해결되면 insertFolderFile작업 마무리하고
			// 교수님 시간되면 > 업로드 다운로드
			// 안되시면 리스트 띄워서 확장자별로 아이콘 따로주기 작업해놓을것.
		}
		// 파일 용량업데이트
		updateParentSizeAll(folderVO);
		log.info("파일용량 업데이트에 필요한 부모CD값  : {}" , folderVO.getFolderParent());
		return null;
	}

	@Override
	public void comFileResYes(FolderFileVO folderFileVO) {
		mapper.comFileResYes(folderFileVO);
	}

	@Override
	public void deleteRefuse(String fileCd) {
		FolderFileVO folderFile = new FolderFileVO();
		folderFile.setFileCd(fileCd);
		mapper.deleteFolderFile(folderFile);
		mapper.deleteFile(folderFile);
	}

	@Override
	public List<FolderFileVO> selectApprList() {
		return mapper.selectApprList();
	}

	@Override
	public List<FolderFileVO> selectAppr() {
		String empNo = UserNoFind();
		return mapper.selectAppr(empNo);
	}
}

package kr.or.ddit.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.inject.Inject;
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
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.mapper.BoardFileMapper;
import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.mapper.MailMapper;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.service.IMailService;
import kr.or.ddit.service.INotifyService;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FileVO;
import kr.or.ddit.vo.MailFormVO;
import kr.or.ddit.vo.MailRecVO;
import kr.or.ddit.vo.RMailVO;
import kr.or.ddit.vo.SMailVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MailServiceImpl implements IMailService{

	@Inject
	private MailMapper mapper;
	
	@Inject
	private EmpMapper empMapper;
	
	@Inject 
	private BoardFileMapper fileMapper;

	
	@Inject
	private INotifyService notiService;
	// 시큐리티에서 유저정보 꺼내오기
	private String UserNoFind() {
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		UserDetails userDetails = (UserDetails)principal;
		String empNo = userDetails.getUsername();
		return empNo;
	}
	
	
	// 받은 메일함 전체목록 가져오기
	@Override
	public List<RMailVO> selectAllRmail() {
		List<RMailVO> receiveMail = mapper.selectAllRmail(UserNoFind());
		for(int i = 0; i < receiveMail.size(); i++) {
			EmpVO empVO = new EmpVO();
			empVO = empMapper.readByUserId(receiveMail.get(i).getMailrEmpno());
			receiveMail.get(i).setMailrEmpname(empVO.getEmpName());
			empVO = empMapper.readByUserId(receiveMail.get(i).getMailsEmpno());
			receiveMail.get(i).setMailsEmpname(empVO.getEmpName());
		}
		return receiveMail;
	}

	// 받은 메일한 상세보기
	@Override
	public RMailVO selectRmailOne(RMailVO rmailVO) {
		EmpVO empVO = new EmpVO();
		rmailVO.setMailrEmpno(UserNoFind());
		rmailVO = mapper.selectRmailOne(rmailVO);
		// 메일 디테일 클릭하면 메일 확인 상태값 업데이트 추가
		mapper.updateMailChkse(rmailVO.getMailNo());
		log.debug("rmailVO.getMailNo():{}",rmailVO.getMailNo());
		
		empVO = empMapper.readByUserId(rmailVO.getMailrEmpno());
		rmailVO.setMailrEmpname(empVO.getEmpName());
		empVO = empMapper.readByUserId(rmailVO.getMailsEmpno());
		//관리자가 보낸사람일때 fullName설정 (관리자는 직책과 부서가 없음)
		if(empVO.getDeptCd() == null) {
			rmailVO.setMailsEmpname("관리자");
		} else {
			rmailVO.setMailsEmpname(empVO.getEmpName()+" "+empVO.getCodeVO().getCdName()+"/"+empVO.getDeptVO().getDeptName());
		}
		
		MailRecVO spareVO = new MailRecVO();
		spareVO.setMailNo(rmailVO.getMailNo());
		List<MailRecVO> recList = mapper.selectAllRecEmp(spareVO);
		List<MailRecVO> refList = mapper.selectAllRefEmp(spareVO);
		
		if (recList != null) {
			for (int i = 0; i < recList.size(); i++) {
				EmpVO emp = new EmpVO();
				emp = empMapper.readByUserId(recList.get(i).getMailrecEmpno());
				String fullName = "";
				if(recList.get(i).getMailrecEmpno().equals("admin")) {
					fullName = "관리자";
				} else {
					String name = emp.getEmpName();
					String code = emp.getCodeVO().getCdName();
					String dep = emp.getDeptVO().getDeptName();
					fullName = name + " " + code + "/" + dep;
				}
				System.out.println(fullName);
				recList.get(i).setMailrecEmpname(fullName);
			}
		}
		
		if (refList != null) {
			for (int i = 0; i < refList.size(); i++) {
				EmpVO emp = new EmpVO();
				emp = empMapper.readByUserId(refList.get(i).getMailrefEmpno());
				String fullName = "";
				if (refList.get(i).getMailrefEmpno().equals("admin")) {
					fullName = "관리자";
				} else {
					String name = emp.getEmpName();
					String code = emp.getCodeVO().getCdName();
					String dep = emp.getDeptVO().getDeptName();
					fullName = name + " " + code + "/" + dep;
				}
				refList.get(i).setMailrefEmpname(fullName);
			}
		}
		
		List<FileVO> fileVO = new ArrayList<FileVO>();
		fileVO = fileMapper.selectNoticefile(rmailVO.getMailNo());
		rmailVO.setMailRec(recList);
		rmailVO.setMailRef(refList);
		rmailVO.setFileList(fileVO);
		
		return rmailVO;
	}

	
	// 파일을 받아서 파일명을 보내는 ajax
	@Override
	public Map<String, Object> SendMailAjax(List<MultipartFile> selectFileList, HttpServletRequest req,
			HttpServletResponse resp) throws IOException {
		List<FileVO> fileList = new ArrayList<FileVO>();
		for(int i = 0; i < selectFileList.size(); i++) {
			FileVO fileVO = new FileVO();
			// 랜덤네임 생성해주는 ㅠㅠ아이디.
			UUID randomName = UUID.randomUUID();
			// 파일 카피에 사용할 file(경로, 파일이름), byte[](데이터 세팅).
			String preFile = selectFileList.get(i).getOriginalFilename();
			System.out.println(preFile);
			// 저장할 랜덤이름 세팅
			fileVO.setFileSavename(randomName+preFile);
			fileVO.setFileOrgname(preFile);
			fileList.add(fileVO);
		}
		for(int i = 0; i < fileList.size(); i++) {
			System.out.println(fileList.get(i));
		}
		Map<String, Object> ajaxMap = new HashMap<String, Object>();
		ajaxMap.put("preFile", fileList);
		return ajaxMap;
	}


	@Override
	public ServiceResult sendMailForm(MailFormVO mailFormVO,
								HttpServletRequest req, 
								HttpServletResponse resp) throws IOException {
		ServiceResult result = ServiceResult.FAILED;
		
		List<String> empList = mailFormVO.getMailEmpno();
		log.info("메일 수신자 목록 {} : ", empList);
		List<String> refList = mailFormVO.getMailRef();
		log.info("메일 참조자 목록 {} : ", refList);
		String title = mailFormVO.getMailTitle();
		String refTitle = "(ref) "+title;
		String content = mailFormVO.getMailContent();
		List<MultipartFile> fileList = mailFormVO.getFileList();
		String shareId = "";
		String shareFileId = "";
		String shareSmailEmpno = "";
		
		
		// 메일 발신자로직
		if(1==1) {
			SMailVO mail = new SMailVO();
			SMailVO spareVO = new SMailVO();
			mail.setMailsEmpno(UserNoFind());
			mail.setMailTitle(title);
			mail.setMailContent(content);
			
			// 기본 인서트
			mapper.insertSmail(mail);
			// 인서트된것 중에 가장 최신을 불러옴
			spareVO = mapper.selectFastestOne(mail);
			mail.setMailNo(spareVO.getMailNo());
			// 위에서 가져온걸 바탕으로 하나의 인서트된 값을 불러옴.
			mail = mapper.selectSmailOne(mail);
			// "메일"+메일번호로 첨부파일번호 생성.
			String fileName = mail.getMailNo();
			mail.setMailFileno(fileName);
			// 첨부파일 번호 세팅
			mapper.updateSmailFile(mail);
			
			// 공용으로 쓸 만들어진 메일넘버.
			shareId = mail.getMailNo();
			// 공용으로 쓸 만들어진 파일넘버.
			shareFileId = fileName;
			// 공용으로 쓸 받은사람.
			shareSmailEmpno = mail.getMailsEmpno();
		}
		
		
		// 메일 수신자로직
		if(empList != null) {
			// 널 아닐때 리스트를 돌림.
			for(int i = 0; i < empList.size(); i++) {
				System.out.println("rmail수신자 : "+empList.get(i));
				// 받은메일보 초기화.
				RMailVO mail = new RMailVO();
				// 메일수신참조보 초기화.
				MailRecVO recVO = new MailRecVO();
				// 메일 번호
				mail.setMailNo(shareId);
				// 메일 제목
				mail.setMailTitle(title);
				// 메일 내용
				mail.setMailContent(content);
				// 메일 보낸사람
				mail.setMailsEmpno(shareSmailEmpno);
				// 메일 받는사람
				mail.setMailrEmpno(empList.get(i));
				// 메일 체크여부
				mail.setMailChkse("1");
				// 메일 삭제여부
				mail.setMailDelse("1");
				// 메일 중요메일여부
				mail.setMailImpse("1");
				// 메일 첨부파일 번호
				mail.setMailFileno(shareFileId);
				// 받은메일 인서트.
				mapper.insertRmail(mail);
				
				// 메일 수신테이블에 추가.
				recVO.setMailNo(shareId);
				recVO.setMailrecEmpno(empList.get(i));
				// 받은이 인서트.
				int status = mapper.insertRecEmp(recVO);
				// 받은이 인서트 성공 시 알람 테이블에 추가 
				if(status > 0) {
					result = ServiceResult.OK;
				}
			}
		}
		
		
		// 메일 참조자 로직
		if(refList != null) {
			for(int i = 0; i < refList.size(); i++) {
				System.out.println("rmail참조자 : "+refList.get(i));
				// 받은메일보 초기화.
				RMailVO mail = new RMailVO();
				// 메일수신참조보 초기화.
				MailRecVO recVO = new MailRecVO();
				// 메일 번호
				mail.setMailNo(shareId);
				// 메일 제목
				mail.setMailTitle(refTitle);
				// 메일 내용
				mail.setMailContent(content);
				// 메일 보낸사람
				mail.setMailsEmpno(shareSmailEmpno);
				// 메일 받는사람
				mail.setMailrEmpno(refList.get(i));
				// 메일 체크여부
				mail.setMailChkse("1");
				// 메일 삭제여부
				mail.setMailDelse("1");
				// 메일 중요메일여부
				mail.setMailImpse("1");
				// 메일 첨부파일 번호
				mail.setMailFileno(shareFileId);
				// 받은메일 인서트.
				mapper.insertRmail(mail);
				
				//메일 참조테이블에 추가.
				recVO.setMailNo(shareId);
				recVO.setMailrefEmpno(refList.get(i));
				// 참조자 인서트.
				int status = mapper.insertRefEmp(recVO);
				if(status > 0) {
					result = ServiceResult.OK;
				}
			}
		}
		
		
		// 파일 로직
		if(fileList!=null) {
			for(int i = 0; i < fileList.size(); i++) {
				FileVO fileVO = new FileVO();
				// 오리지날 네임 세팅
				String orgName = fileList.get(i).getOriginalFilename();
				// 세이브 네임에 사용할 ㅠㅠ아이디 세팅
				UUID uuid = UUID.randomUUID();
				// 세이브 네임 세팅
				String saveName = uuid+orgName;
				// 기본 경로 비포
				String fileBeforePath = req.getServletContext().getRealPath("");
				// 이후 설정 경로 애프터
				String fileAfterPath = "resources/file/mail/";
				// 합쳐놓는게 짧으니 일단 하나 만들자.
				String allPath = fileBeforePath+fileAfterPath;
				// 사이즈는 롱.
				long fileSize = fileList.get(i).getSize();
				// 컨텐트타입 = 마임타입 = 미디어타입.
				String fileMime = fileList.get(i).getContentType();
				// 확장자 나누기
				String[] nameArray = orgName.split("\\.");
				String fileType = nameArray[nameArray.length-1];
				// 데이터업로드할 데이터
				byte[] fileData = fileList.get(i).getBytes();
				
				
				
				// 기본경로 + 설정경로로 파일생성
				File file = new File(fileBeforePath+"/"+fileAfterPath);
				
				//없으면
				if(!file.exists()) {
					//만들어 '줘'
					file.mkdirs();
				}
				
				// 어디서 무슨이름으로 파일 만들지 정하기.
				// 이름이 겹치면 터지니까 ㅠㅠ아이디붙은 세이브네임으로 만들자.
				File targetFile = new File(allPath+saveName);
				
				// 복사
				FileCopyUtils.copy(fileData, targetFile); // 파일 복사 진행
				
				// 보세팅.
				fileVO.setFileNo(shareFileId);
				fileVO.setFileOrgname(orgName);
				fileVO.setFileSavename(saveName);
				fileVO.setFileSavepath(fileAfterPath);
				fileVO.setFileSize(fileSize);
				fileVO.setFileMime(fileMime);
				fileVO.setFileType(fileType);
				
				fileMapper.insertFile(fileVO);
			}
			HttpSession session = req.getSession();
			String sendMail = "메일 발송이 완료되었습니다";
			session.setAttribute("sendMail", sendMail);
		}
		return result;
	}


	@Override
	public void sendMailToMeForm(MailFormVO mailFormVO, HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		String title = mailFormVO.getMailTitle();
		String content = mailFormVO.getMailContent();
		List<MultipartFile> fileList = mailFormVO.getFileList();
		log.info("타이틀 {} : ",title);
		log.info("내용 : {}", content);
		String shareId = "";
		String shareFileId = "";
		String shareSmailEmpno = "";

		// 메일 발신자로직
		if (1 == 1) {
			SMailVO mail = new SMailVO();
			SMailVO spareVO = new SMailVO();
			mail.setMailsEmpno(UserNoFind());
			mail.setMailTitle(title);
			mail.setMailContent(content);
			// 기본 인서트
			mapper.insertSmail(mail);
			// 인서트된것 중에 가장 최신을 불러옴
			spareVO = mapper.selectFastestOne(mail);
			mail.setMailNo(spareVO.getMailNo());
			// 위에서 가져온걸 바탕으로 하나의 인서트된 값을 불러옴.
			mail = mapper.selectSmailOne(mail);
			// "메일"+메일번호로 첨부파일번호 생성.
			String fileName = mail.getMailNo();
			mail.setMailFileno(fileName);
			// 첨부파일 번호 세팅
			mapper.updateSmailFile(mail);

			// 공용으로 쓸 만들어진 메일넘버.
			shareId = mail.getMailNo();
			// 공용으로 쓸 만들어진 파일넘버.
			shareFileId = fileName;
			// 공용으로 쓸 받은사람.
			shareSmailEmpno = mail.getMailsEmpno();
			
			// 받은메일보 초기화.
			RMailVO rmail = new RMailVO();
			// 메일수신참조보 초기화.
			MailRecVO recVO = new MailRecVO();
			// 메일 번호
			rmail.setMailNo(shareId);
			// 메일 제목
			rmail.setMailTitle(title);
			// 메일 내용
			rmail.setMailContent(content);
			// 메일 보낸사람
			rmail.setMailsEmpno(shareSmailEmpno);
			// 메일 받는사람
			rmail.setMailrEmpno(UserNoFind());
			// 메일 체크여부
			rmail.setMailChkse("1");
			// 메일 삭제여부
			rmail.setMailDelse("1");
			// 메일 중요메일여부
			rmail.setMailImpse("1");
			// 메일 첨부파일 번호
			rmail.setMailFileno(shareFileId);
			// 받은메일 인서트.
			mapper.insertRmail(rmail);

			// 메일 수신테이블에 추가.
			recVO.setMailNo(shareId);
			recVO.setMailrecEmpno(UserNoFind());
			// 받은이 인서트.
			mapper.insertRecEmp(recVO);
		}

		// 파일 로직
		if (fileList != null) {
			for (int i = 0; i < fileList.size(); i++) {
				FileVO fileVO = new FileVO();
				// 오리지날 네임 세팅
				String orgName = fileList.get(i).getOriginalFilename();
				// 세이브 네임에 사용할 ㅠㅠ아이디 세팅
				UUID uuid = UUID.randomUUID();
				// 세이브 네임 세팅
				String saveName = uuid + orgName;
				// 기본 경로 비포
				String fileBeforePath = req.getServletContext().getRealPath("");
				// 이후 설정 경로 애프터
				String fileAfterPath = "resources/file/mail/";
				// 합쳐놓는게 짧으니 일단 하나 만들자.
				String allPath = fileBeforePath + fileAfterPath;
				// 사이즈는 롱.
				long fileSize = fileList.get(i).getSize();
				// 컨텐트타입 = 마임타입 = 미디어타입.
				String fileMime = fileList.get(i).getContentType();
				// 확장자 나누기
				String[] nameArray = orgName.split("\\.");
				String fileType = nameArray[nameArray.length - 1];
				// 데이터업로드할 데이터
				byte[] fileData = fileList.get(i).getBytes();

				// 기본경로 + 설정경로로 파일생성
				File file = new File(fileBeforePath + "/" + fileAfterPath);

				// 없으면
				if (!file.exists()) {
					// 만들어 '줘'
					file.mkdirs();
				}

				// 어디서 무슨이름으로 파일 만들지 정하기.
				// 이름이 겹치면 터지니까 ㅠㅠ아이디붙은 세이브네임으로 만들자.
				File targetFile = new File(allPath + saveName);

				// 복사
				FileCopyUtils.copy(fileData, targetFile); // 파일 복사 진행

				// 보세팅.
				fileVO.setFileNo(shareFileId);
				fileVO.setFileOrgname(orgName);
				fileVO.setFileSavename(saveName);
				fileVO.setFileSavepath(fileAfterPath);
				fileVO.setFileSize(fileSize);
				fileVO.setFileMime(fileMime);
				fileVO.setFileType(fileType);

				fileMapper.insertFile(fileVO);
			}
			HttpSession session = req.getSession();
			String sendMail = "메일 발송이 완료되었습니다";
			session.setAttribute("sendMail", sendMail);
		}
	}


	@Override
	public List<SMailVO> selectAllSmail() {
		List<SMailVO> sendedMail = mapper.selectAllSmail(UserNoFind());
		int index = 0;
		for(int i = 0; i < sendedMail.size(); i++) {
			EmpVO empVO = new EmpVO();
			MailRecVO recVO = new MailRecVO();
			empVO = empMapper.readByUserId(sendedMail.get(i).getMailsEmpno());
			sendedMail.get(i).setMailsEmpname(empVO.getEmpName());
			// 받은사람 얻어내기
			recVO.setMailNo(sendedMail.get(i).getMailNo());
			List<MailRecVO> recList = mapper.selectAllRecEmp(recVO);
			List<MailRecVO> refList = mapper.selectAllRefEmp(recVO);
			for(int j = 0; j < recList.size(); j++) {
				String empName = recList.get(j).getMailrecEmpno();
				EmpVO emp = new EmpVO();
				emp = empMapper.readByUserId(empName);
				recList.get(j).setMailrecEmpname(emp.getEmpName());
			}
			// 참조자 얻어내기
			for(int j = 0; j < refList.size(); j++) {
				String empName = refList.get(j).getMailrefEmpno();
				EmpVO emp = new EmpVO();
				emp = empMapper.readByUserId(empName);
				refList.get(j).setMailrefEmpname(emp.getEmpName());
			}
			sendedMail.get(i).setRecCnt(recList.size());
			sendedMail.get(i).setMailRec(recList);
			sendedMail.get(i).setMailRef(refList);
		}
		return sendedMail;
	}


	@Override
	public List<RMailVO> selectAllMyselfMail() {
		List<RMailVO> mailList = mapper.selectAllMyselfMail(UserNoFind());
		for(int i = 0; i < mailList.size(); i++) {
			EmpVO empVO = new EmpVO();
			empVO = empMapper.readByUserId(UserNoFind());
			String empName = empVO.getEmpName();
			mailList.get(i).setMailsEmpname(empName);
			mailList.get(i).setMailrEmpname(empName);
		}
		return mailList;
	}


	@Override
	public Map<String, Object> mailLikeAjax(RMailVO rmailVO) {
		rmailVO = selectRmailOne(rmailVO);
		if(rmailVO.getMailImpse().equals("1")) {
			rmailVO.setMailImpse("2");
		} else if (rmailVO.getMailImpse().equals("2")) {
			rmailVO.setMailImpse("1");
		}
		mapper.mailLikeAjax(rmailVO);
		rmailVO = selectRmailOne(rmailVO);
		Map<String, Object> ajaxMap = new HashMap<String, Object>();
		ajaxMap.put("mailLike", rmailVO);
		return ajaxMap;
	}


	@Override
	public List<RMailVO> selectAllImpRmail() {
		String mailrEmpno = UserNoFind();
		List<RMailVO> mailList = mapper.selectAllImpRmail(mailrEmpno);
		for(int i = 0; i < mailList.size(); i++) {
			EmpVO empVO = new EmpVO();
			empVO = empMapper.readByUserId(mailList.get(i).getMailsEmpno());
			mailList.get(i).setMailsEmpname(empVO.getEmpName());
		}
		return mailList;
	}


	@Override
	public Map<String, Object> mailFileViewAjax(FileVO fileVO) {
		fileVO = fileMapper.selectFileInfo(fileVO.getFileSec());
		System.out.print("파일형태 : ");
		System.out.println(fileVO);
		System.out.println(fileVO.getFileSec());
		// 맵으로 주려고했음.
		Map<String, Object> fileInfo = new HashMap<String, Object>();
		fileInfo.put("fileInfo", fileVO);
		return fileInfo;
	}


	@Override
	public ResponseEntity<byte[]> fileDownload(int isFile, HttpServletRequest request,
			HttpServletResponse response) throws UnsupportedEncodingException {
		System.out.println("다운로드 서비스까지왔음.");
		FileVO fileVO = new FileVO();
		fileVO = fileMapper.selectFileInfo(isFile);

		String fileName = "";
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;
		
		String headerKind = request.getHeader("User-Agent");
		
		if ((headerKind.contains("MSIE")) || (headerKind.contains("Trident")) || (headerKind.contains("Edge"))) {
		  fileName = URLEncoder.encode(fileVO.getFileOrgname(), "UTF-8");
		} else {
		  fileName = new String(fileVO.getFileOrgname().getBytes("UTF-8"), "iso-8859-1");
		}
		
		File file = new File(request.getServletContext().getRealPath("")
				+fileVO.getFileSavepath() ,fileVO.getFileSavename());
		
		fileName += "."+fileVO.getFileType();
		
		try {
			HttpHeaders header = new HttpHeaders();
			in = new FileInputStream(file);
			header.setContentType(MediaType.APPLICATION_OCTET_STREAM);
			header.add("Content-Disposition", "attachment; filename=\"" + fileName +"\"");
			entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), header, HttpStatus.CREATED);
		}catch(Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}


	@Override
	public SMailVO selectSmailOne(SMailVO smailVO) {
		smailVO.setMailsEmpno(UserNoFind());
		smailVO = mapper.selectSmailOne(smailVO);
		MailRecVO recVO = new MailRecVO();
		// 받는사람 불러오기
		recVO.setMailNo(smailVO.getMailNo());
		List<MailRecVO> recEmp = mapper.selectAllRecEmp(recVO);
		if(recEmp != null) {
			for(int i = 0; i < recEmp.size(); i++) {
				EmpVO empVO = new EmpVO();
				empVO = empMapper.readByUserId(recEmp.get(i).getMailrecEmpno());
				String fullName = "";
				if(recEmp.get(i).getMailrecEmpno().equals("admin")) {
					fullName = "관리자";
				} else {
					fullName = empVO.getEmpName()+" "+empVO.getCodeVO().getCdName()+"/"+empVO.getDeptVO().getDeptName();
				}
				recEmp.get(i).setMailrecEmpname(fullName);
			}
		}
		// 참조자 불러오기
		List<MailRecVO> refEmp = mapper.selectAllRefEmp(recVO);
		if(refEmp != null) {
			for(int i = 0; i < refEmp.size(); i++) {
				EmpVO empVO = new EmpVO();
				empVO = empMapper.readByUserId(refEmp.get(i).getMailrefEmpno());
				String fullName = empVO.getEmpName()+" "+empVO.getCodeVO().getCdName()+"/"+empVO.getDeptVO().getDeptName();
				refEmp.get(i).setMailrefEmpname(fullName);
			}
		}
		List<FileVO> fileList = new ArrayList<FileVO>();
		fileList = fileMapper.selectNoticefile(smailVO.getMailNo());
		smailVO.setFileList(fileList);
		smailVO.setMailRec(recEmp);
		smailVO.setMailRef(refEmp);
		return smailVO;
	}

	
	// 메일삭제
	@Override
	public void rmailDelete(List<String> mailArray) {
		for(int i = 0; i < mailArray.size(); i++) {
			RMailVO mailVO = new RMailVO();
			mailVO.setMailNo(mailArray.get(i));
			mailVO.setMailrEmpno(UserNoFind());
			mapper.rmailDelete(mailVO);
		}
	}

	// 삭제한 메일함으로 이동하는 로직.
	@Override
	public List<RMailVO> selectDeletedMail() {
		List<RMailVO> mailList = new ArrayList<RMailVO>();
		RMailVO rmailVO = new RMailVO();
		rmailVO.setMailrEmpno(UserNoFind());
		
		mailList = mapper.selectDeletedMail(rmailVO);
		
		for(int i = 0; i < mailList.size(); i ++) {
			EmpVO empVO = new EmpVO();
			empVO = empMapper.readByUserId(mailList.get(i).getMailsEmpno());
			mailList.get(i).setMailsEmpname(empVO.getEmpName());
		}
		return mailList;
	}


	@Override
	public void smailDelete(List<String> mailArray) {
		for(int i = 0; i < mailArray.size(); i++) {
			SMailVO smailVO = new SMailVO();
			smailVO.setMailNo(mailArray.get(i));
			smailVO.setMailsEmpno(UserNoFind());
			mapper.smailDelete(smailVO);
		}
	}


	@Override
	public void deleteMailAll(List<String> mailArray) {
		for(int i = 0; i < mailArray.size(); i++) {
			RMailVO rmailVO = new RMailVO();
			rmailVO.setMailNo(mailArray.get(i));
			rmailVO.setMailrEmpno(UserNoFind());
			mapper.deleteMailAll(rmailVO);
		}
	}
	
	/**
	 * 관리자 이름으로 메일 발송(동호회 개설, 승인 등 필요시 자동)
	 */
	@Override
	public void adminSendMail(String empNo, String title, String content) {
		MailFormVO mailFormVO = new MailFormVO();
		
		List<String> empList = new ArrayList<String>();
		empList.add(empNo);
		mailFormVO.setMailEmpno(empList);
		
		mailFormVO.setMailTitle(title);
		mailFormVO.setMailContent(content);
		
		String shareId = "";
		String shareFileId = "";
		String shareSmailEmpno = "";
		
		// 메일 발신자로직
		if(1==1) {
			SMailVO mail = new SMailVO();
			SMailVO spareVO = new SMailVO();
			mail.setMailsEmpno("admin");
			mail.setMailTitle(title);
			mail.setMailContent(content);
			
			// 기본 인서트
			mapper.insertSmail(mail);
			// 인서트된것 중에 가장 최신을 불러옴
			spareVO = mapper.selectFastestOne(mail);
			mail.setMailNo(spareVO.getMailNo());
			// "메일"+메일번호로 첨부파일번호 생성.
			String fileName = mail.getMailNo();
			mail.setMailFileno(fileName);
			// 첨부파일 번호 세팅
			mapper.updateSmailFile(mail);
			
			// 공용으로 쓸 만들어진 메일넘버.
			shareId = mail.getMailNo();
			// 공용으로 쓸 만들어진 파일넘버.
			shareFileId = fileName;
			// 공용으로 쓸 받은사람.
			shareSmailEmpno = mail.getMailsEmpno();
		}
		
		// 메일 수신자로직
		if(empList != null) {
			// 널 아닐때 리스트를 돌림.
			for(int i = 0; i < empList.size(); i++) {
				RMailVO mail = new RMailVO();
				MailRecVO recVO = new MailRecVO();
				// 메일 번호
				mail.setMailNo(shareId);
				// 메일 제목
				mail.setMailTitle(title);
				// 메일 내용
				mail.setMailContent(content);
				// 메일 보낸사람
				mail.setMailsEmpno(shareSmailEmpno);
				// 메일 받는사람
				mail.setMailrEmpno(empList.get(i));
				// 메일 체크여부
				mail.setMailChkse("1");
				// 메일 삭제여부
				mail.setMailDelse("1");
				// 메일 중요메일여부
				mail.setMailImpse("1");
				// 메일 첨부파일 번호
				mail.setMailFileno(shareFileId);
				// 받은메일 인서트.
				mapper.insertRmail(mail);
				
				// 메일 수신테이블에 추가.
				recVO.setMailNo(shareId);
				recVO.setMailrecEmpno(empList.get(i));
				// 받은이 인서트.
				mapper.insertRecEmp(recVO);
			}
		}
	}
	@Override
	public void resMail(List<String> mailArray) {
		for(int i = 0; i < mailArray.size(); i++) {
			RMailVO mailVO = new RMailVO();
			mailVO.setMailNo(mailArray.get(i));
			mailVO.setMailrEmpno(UserNoFind());
			mapper.resMail(mailVO);
		}
	}



	@Override
	public Map<String, Object> updateMailChkse(RMailVO rMailVO) {
		
		log.info("updateMailChkse 실행여부 확인");
		CustomUser user = (CustomUser)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		rMailVO.setMailrEmpno(user.getUsername());
		
		rMailVO = mapper.selectRmailOne(rMailVO);
		
		if(rMailVO.getMailChkse().equals("1")) {
			rMailVO.setMailChkse("2");
		}else if(rMailVO.getMailChkse().equals("2")) {
			rMailVO.setMailChkse("1");
		}
		
		mapper.updateMailChkse2(rMailVO);
		rMailVO = mapper.selectRmailOne(rMailVO);
		log.info("rMailVO:{}",rMailVO);
		Map<String, Object> ajaxMap = new HashMap<String, Object>();
		ajaxMap.put("mailLike", rMailVO);
		return ajaxMap;
	}


	@Override
	public int showUnreadMailCnt(String empNo) {
		return mapper.selectUnreadRmailCnt(empNo);
	}
	
}



















package kr.or.ddit.service.impl;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.mapper.BoardFileMapper;
import kr.or.ddit.mapper.NoticeMapper;
import kr.or.ddit.multipart.FileVOtoMultipartFileAdapter;
import kr.or.ddit.service.IBoardNoticeService;
import kr.or.ddit.vo.BoardNoticeVO;
import kr.or.ddit.vo.FileVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class BoardNoticeServiceImpl implements IBoardNoticeService{

	@Inject
	private NoticeMapper mapper;
	
	@Inject
	private BoardFileMapper filemapper;
	// 게시글 전체 조회
	@Override
	public List<BoardNoticeVO> noticeList() {
		log.info("[noticeList] list");
		List<BoardNoticeVO> noticeList = mapper.noticeList();
		
		for(int i=0; i<noticeList.size(); i++) {
			String empNo = noticeList.get(i).getNoWriterEmpNo();
			String empName = mapper.selectUserName(empNo);
			noticeList.get(i).setEmpName(empName);
		}
		
		return noticeList;
	}
	// 게시글 등록
	@Override
	public void insertNotice(BoardNoticeVO notice, HttpServletRequest req, HttpServletResponse res) {
		mapper.insertNotice(notice);
		log.info("notice.getNoNo() : {}" ,notice.getNoNo());
		
		
		List<MultipartFile> boardfile = notice.getNoFile();
		String fileNo = ("NO" + notice.getNoNo());
		// 한 게시글의 여러 첨부파일
		if (boardfile != null && !boardfile.isEmpty()) {
			for(int i = 0; i < boardfile.size(); i++) {
				MultipartFile multipartFile = boardfile.get(i);
	            if (!multipartFile.isEmpty()) {
					FileVO file = new FileVO();
					file.setFileNo(fileNo);
					log.info("fileNo : {}",fileNo);
					String orgName = notice.getNoFile().get(i).getOriginalFilename();
					file.setFileOrgname(orgName);
					log.info("orgName : {}",orgName);
					String savePath = req.getServletContext().getRealPath("/resources/board/notice/");
					file.setFileSavepath(savePath);
					log.info("savePath : {}",savePath);
					long size = notice.getNoFile().get(i).getSize();
					file.setFileSize(size);
					log.info("size : {}",size);
					String mime = notice.getNoFile().get(i).getContentType();
					file.setFileMime(mime);
					log.info("mime : {}",mime);
					String saveName = UUID.randomUUID().toString()+"_"+orgName;	// UUID의 랜덤 파일명 생성
					file.setFileSavename(saveName);
					log.info("saveName : {}",saveName);
					int lastIndex = orgName.lastIndexOf(".");
					if (lastIndex > 0) {
						String fileType = orgName.substring(lastIndex + 1);
						System.out.println("확장자: " + fileType);
						file.setFileType(fileType);
						log.info("fileType : {}",fileType);
					} else {
						System.out.println("확장자를 찾을 수 없습니다.");
					}
					// 등록한 게시글 첨부파일
					filemapper.insertFile(file);
					noticeFileUpload(multipartFile, fileNo, req ,saveName);
					log.info("insertFile()...!실행");
					// 게시글 등록
	            }
			}
		}
	}
	// 게시글 상세보기
	@Override
	public BoardNoticeVO selectNotice(String noNo) {
		log.info("selectNotice() 실행...!");
//		String fileNo = ("NO" + noNo);
//		List<FileVO> fileVO = filemapper.selectNoticefile(fileNo);
//		List<MultipartFile> fileList = new ArrayList<MultipartFile>();
//		
//		if (fileVO != null) {
//	        List<MultipartFile> file = new FileVOtoMultipartFileAdapter(fileVO); // FileVO를 MultipartFile로 변환하는 부분을 구현해야 합니다.
//	        fileList.addAll(file);
//	    }
//		notice.setNoFile(fileList);
		BoardNoticeVO notice = mapper.selectNotice(noNo);
		String empNo = notice.getNoWriterEmpNo();
		String empName = mapper.selectUserName(empNo);
		notice.setEmpName(empName);
		mapper.incrementHit(noNo);
		return notice;
	}
	// 게시글 첨부파일 조회
	@Override
	public List<FileVO> selectNoticefile(String fileNo) {
		log.info("selectNoticefile() 실행...!");
		return filemapper.selectNoticefile(fileNo);
	}
	@Override
	public List<FileVO> selectNoticefilenoNO(String noNo) {
		log.info("selectNoticefile() 실행...!");
	 	String fileNo = "NO" + noNo; 
		return filemapper.selectNoticefile(fileNo);
	}

	private void noticeFileUpload(MultipartFile noticeFile, String fileNo, HttpServletRequest req, String saveName) {
		String savePath = "/resources/board/notice/";
		
		if(noticeFile != null && !noticeFile.getOriginalFilename().equals("")) {
			// 파일 업로드 처리 시작
//			String saveName = UUID.randomUUID().toString();	// UUID의 랜덤 파일명 생성
//			saveName = saveName + "_" + noticeFile.getName().replaceAll(" ", "_") +"."+ noticeFile.getContentType();
//			saveName = saveName.replaceAll(" ", "_");
			
			// .../resources/board/notice/[] 경로
			String saveLocate = req.getServletContext().getRealPath(savePath + fileNo);
			File file = new File(saveLocate);
			if(!file.exists()) { 	// 업로드시 폴더가 존재하지 않을때
				file.mkdirs();		// 폴더 생성
			}
			
			// /resources/board/notice[]/UUID_원본파일명
			saveLocate += "/" + saveName;
			
			File savefile = new File(saveLocate);
			try {
				noticeFile.transferTo(savefile);
			} catch (IllegalStateException | IOException e) {
				e.printStackTrace();
			}
		}
	}
	// 공지사항 수정
	@Override
	public ServiceResult NoticeModify(HttpServletRequest req, BoardNoticeVO noticeVO) {
		ServiceResult result = null;
		// 공지사항 글 수정
		int status = mapper.updateNotice(noticeVO);
		if(status > 0) {
			try {
				String[] fileSec = noticeVO.getFileSec();
				log.info("fileSec : {}" , fileSec);
				if(fileSec != null) {	 
					for(int i = 0; i < fileSec.length; i++) {
						String fileSeci = fileSec[i];
						List<FileVO> fileVO = filemapper.selectNoticefileSec(fileSeci);
						log.info("fileVO : {}",fileVO);
						if (fileVO != null) {
			                // 기존 파일 삭제
			                String fileSavePath = fileVO.get(0).getFileSavepath() + 
			                		fileVO.get(0).getFileNo() + "/" + fileVO.get(0).getFileSavename();
			                File fileToDelete = new File(fileSavePath);
			                if (fileToDelete.exists()) {
			                    fileToDelete.delete();
			                }
			                // 기존 파일 DB에서 삭제
			                filemapper.deleteFile(fileSec[i]);
			                log.info("deleteFile()실행...!");
			            }
			        }
			    }
			}catch (Exception e) {
				e.printStackTrace();
			}
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		List<MultipartFile> boardfile = noticeVO.getNoFile();
		String fileNo = ("NO" + noticeVO.getNoNo());
		// 한 게시글의 여러 첨부파일
		if (boardfile != null && !boardfile.isEmpty()) {
			for(int i = 0; i < boardfile.size(); i++) {
				MultipartFile multipartFile = boardfile.get(i);
	            if (!multipartFile.isEmpty()) {
					FileVO file = new FileVO();
					file.setFileNo(fileNo);
					log.info("fileNo : {}",fileNo);
					String orgName = noticeVO.getNoFile().get(i).getOriginalFilename();
					file.setFileOrgname(orgName);
					log.info("orgName : {}",orgName);
					String saveName = UUID.randomUUID().toString()+"_"+orgName;
					file.setFileSavename(saveName);
					log.info("saveName : {}",saveName);
					String savePath = req.getServletContext().getRealPath("/resources/board/notice/");
					file.setFileSavepath(savePath);
					log.info("savePath : {}",savePath);
					long size = noticeVO.getNoFile().get(i).getSize();
					file.setFileSize(size);
					log.info("size : {}",size);
					String mime = noticeVO.getNoFile().get(i).getContentType();
					file.setFileMime(mime);
					log.info("mime : {}",mime);
					int lastIndex = orgName.lastIndexOf(".");
					if (lastIndex > 0) {
						String fileType = orgName.substring(lastIndex + 1);
						System.out.println("확장자: " + fileType);
						file.setFileType(fileType);
						log.info("fileType : {}",fileType);
					} else {
						System.out.println("확장자를 찾을 수 없습니다.");
					}
					// 등록한 게시글 첨부파일
					filemapper.insertFile(file);
					noticeFileUpload(multipartFile, fileNo, req,saveName);
					log.info("insertFile()...!실행");
					// 게시글 등록
	            }
			}
		}
		return result;
	}
	// 공지사항 글 삭제
	@Override
	public ServiceResult deleteNotice(HttpServletRequest req, String noNo) {
		ServiceResult result = null;
		BoardNoticeVO notice = mapper.selectNotice(noNo);
		String fileNo = ("NO" + notice.getNoNo());
		int status = mapper.deleteNotice(noNo);
		if(status > 0) {
			List<FileVO> noticeFileList = new ArrayList<FileVO>();
			noticeFileList.addAll(filemapper.selectNoticefile(fileNo));
			log.info("noticeFileList : {}" ,noticeFileList);
			try {
				if(noticeFileList != null && noticeFileList.size() > 0) {
					for(int i = 0; i < noticeFileList.size(); i ++) {
						String filePath = noticeFileList.get(i).getFileSavepath() + "\\" + 
									noticeFileList.get(i).getFileNo();
						log.info("filePath[] : {}", filePath);
						String path = filePath;
						deleteFolder(req, path);
					}
				}
			}catch (Exception e) {
				e.printStackTrace();
			}
			result = ServiceResult.OK;
			filemapper.deleteFolder(fileNo);
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}
	private void deleteFolder(HttpServletRequest req, String path) {
		File folder = new File(path);
		
		try {
			if(folder.exists()) {	// 경로가 존재
				File[] folderList = folder.listFiles();	// 폴더안에 있는 파일들
				
				for(int i = 0; i < folderList.length; i++) {
					if(folderList[i].isFile()) {	// 폴더안의 있는 것이 파일일때
						folderList[i].delete(); // 폴더안의 파일 차례대로 삭제
					}else {
						// 폴더안의 있는 파일이 폴더 일때 재귀함수 호출(폴더 안으로 들어가서 다시 이행)
						deleteFolder(req, folderList[i].getPath());
					}
				}
				folder.delete();	// 폴더삭제
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	@Override
	public FileVO noticeDownload(String fileNo,int fileSec) {
		log.info("noticeDownload()실행...!");
		log.info("fileNo, fileSec : {}, {}",fileNo,fileSec);
		FileVO fileVO = filemapper.noticeDownload(fileNo,fileSec);
		if(fileVO == null) {
			throw new RuntimeException();
		}
		
		return fileVO;
	}
//	@Override
//	public FileVO selectFileInfo(int fileSec) {
//		return filemapper.selectFileInfo(fileSec);
//	}
}

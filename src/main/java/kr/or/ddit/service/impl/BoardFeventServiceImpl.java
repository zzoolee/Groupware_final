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
import kr.or.ddit.mapper.CommentMapper;
import kr.or.ddit.mapper.FeventMapper;
import kr.or.ddit.service.IBoardfeventService;
import kr.or.ddit.vo.BoardFeventVO;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.FileVO;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Service
public class BoardFeventServiceImpl implements IBoardfeventService {

	@Inject
	private FeventMapper mapper;
	
	@Inject
	private BoardFileMapper filemapper;
	
	@Inject
	private CommentMapper commentMapper;
	
	
	
	@Override
	public List<BoardFeventVO> feventList() {
		log.info("[feventList] list");
		List<BoardFeventVO> feventList = mapper.feventList();
		
		for(int i = 0; i<feventList.size(); i++) {
			String empNo = feventList.get(i).getFeWriterEmpNo();
			String empName = mapper.selectUserName(empNo);
			feventList.get(i).setEmpName(empName);
		}
		return feventList;	
		}

	@Override
	public void insertFevent(BoardFeventVO fevent, HttpServletRequest req, HttpServletResponse res) {
		log.info("insertFevent() 실행...!");
		mapper.insertFevent(fevent);
		
		List<MultipartFile> boardfile = fevent.getFeFile();
		String fileNo = ("FE" + fevent.getFeNo());
		
		if(boardfile != null && !boardfile.isEmpty()) {
			for(int i = 0; i < boardfile.size(); i++) {
				MultipartFile multipartFile = boardfile.get(i);
				if(!multipartFile.isEmpty()) {
					FileVO file = new FileVO();
					file.setFileNo(fileNo);
					log.info("fileNo : {}", fileNo);
					String orgname = fevent.getFeFile().get(i).getOriginalFilename();
					file.setFileOrgname(orgname);
					log.info("orgName : {}",orgname);
					String savePath = req.getServletContext().getRealPath("/resources/board/fevent/");
					file.setFileSavepath(savePath);
					log.info("savePath : {}",savePath);
					long size = fevent.getFeFile().get(i).getSize();
					file.setFileSize(size);
					log.info("size : {}",size);
					String mime = fevent.getFeFile().get(i).getContentType();
					file.setFileMime(mime);
					log.info("mime : {}",mime);
					String saveName = UUID.randomUUID().toString()+"_"+orgname;	// UUID의 랜덤 파일명 생성
					file.setFileSavename(saveName);
					log.info("saveName : {}",saveName);
					int lastIndex = orgname.lastIndexOf(".");
					if (lastIndex > 0) {
						String fileType = orgname.substring(lastIndex + 1);
						System.out.println("확장자: " + fileType);
						file.setFileType(fileType);
						log.info("fileType : {}",fileType);
					} else {
						System.out.println("확장자를 찾을 수 없습니다.");
					}
					// 등록한 게시글 첨부파일
					filemapper.insertFile(file);
					feventFileUpload(multipartFile, fileNo, req ,saveName);
					log.info("insertFile()...!실행");
					// 게시글 등록
				}
			}
		}

	}

	private void feventFileUpload(MultipartFile feventFile, String fileNo, HttpServletRequest req, String saveName) {
		String savePath = "/resources/board/fevent/";
		
		if(feventFile != null && !feventFile.getOriginalFilename().equals("")) {
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
				feventFile.transferTo(savefile);
			} catch (IllegalStateException | IOException e) {
				e.printStackTrace();
			}
		}
		
	}

	@Override
	public BoardFeventVO selectfevent(String feNo) {
		log.info("selectfevent() 실행...!");
		BoardFeventVO fevent = mapper.selectFevent(feNo);
		String empNo = fevent.getFeWriterEmpNo();
		String empName = mapper.selectUserName(empNo);
		fevent.setEmpName(empName);
		mapper.incrementHit(feNo);
		return fevent;
	}

	@Override
	public List<FileVO> selectfeventfilefeNo(String feNo) {
		log.info("selectfeventfilefeNo() 실행...!");
		String fileNo = "FE" + feNo;
		return filemapper.selectFreefile(fileNo);
	}

	@Override
	public List<CommentVO> selectfeventComment(String feNo) {
		String cmBoardse = "FE";
		return commentMapper.selectCommentFree(feNo, cmBoardse);
	}

	@Override
	public String selectUserName(String empNo) {
		return mapper.selectUserName(empNo);
	}

	@Override
	public String selectUserPhoto(String empNo) {
		return mapper.selectUserPhoto(empNo);
	}

	@Override
	public List<FileVO> selectfeventfile(String fileNo) {
		log.info("selectfeventfile() 실행...!");
		return filemapper.selectNoticefile(fileNo);
	}

	@Override
	public ServiceResult feventModify(HttpServletRequest req, BoardFeventVO feventVO) {
		ServiceResult result = null;
		// 공지사항 글 수정
		int status = mapper.updateFevent(feventVO);
		if(status > 0) {
			try {
				String[] fileSec = feventVO.getFileSec();
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
		List<MultipartFile> boardfile = feventVO.getFeFile();
		String fileNo = ("FE" + feventVO.getFeNo());
		// 한 게시글의 여러 첨부파일
		if (boardfile != null && !boardfile.isEmpty()) {
			for(int i = 0; i < boardfile.size(); i++) {
				MultipartFile multipartFile = boardfile.get(i);
	            if (!multipartFile.isEmpty()) {
					FileVO file = new FileVO();
					file.setFileNo(fileNo);
					log.info("fileNo : {}",fileNo);
					String orgName = feventVO.getFeFile().get(i).getOriginalFilename();
					file.setFileOrgname(orgName);
					log.info("orgName : {}",orgName);
					String saveName = UUID.randomUUID().toString()+"_"+orgName;
					file.setFileSavename(saveName);
					log.info("saveName : {}",saveName);
					String savePath = req.getServletContext().getRealPath("/resources/board/fevent/");
					file.setFileSavepath(savePath);
					log.info("savePath : {}",savePath);
					long size = feventVO.getFeFile().get(i).getSize();
					file.setFileSize(size);
					log.info("size : {}",size);
					String mime = feventVO.getFeFile().get(i).getContentType();
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
					feventFileUpload(multipartFile, fileNo, req,saveName);
					log.info("insertFile()...!실행");
					// 게시글 등록
	            }
			}
		}
		return result;
	}

	@Override
	public ServiceResult deletefevent(HttpServletRequest req, String feNo) {
		ServiceResult result = null;
		BoardFeventVO fevent = mapper.selectFevent(feNo);
		String fileNo = ("FE" + fevent.getFeNo());
		String CmBoardse = "FE";
		mapper.deleteFeventComment(CmBoardse,feNo);
		int status = mapper.deleteFevent(feNo);
		if(status > 0) {
			List<FileVO> feventFileList = new ArrayList<FileVO>();
			feventFileList.addAll(filemapper.selectNoticefile(fileNo));
			log.info("noticeFileList : {}" ,feventFileList);
			try {
				if(feventFileList != null && feventFileList.size() > 0) {
					for(int i = 0; i < feventFileList.size(); i ++) {
						String filePath = feventFileList.get(i).getFileSavepath() + "\\" + 
								feventFileList.get(i).getFileNo();
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
	public CommentVO insertComment(CommentVO commentVO) {
		CommentVO result = null;
		int cnt = commentMapper.insertComment(commentVO);
		// 알람을 날리기 위해 게시글 번호를 가지고 작성자 정보를 가져온다
		BoardFeventVO boardFeventVO = mapper.selectFevent(commentVO.getCmBno());
		
		if(cnt > 0) {
			result = commentMapper.selectComment(commentVO.getCmNo());
		}
		String empName = mapper.selectUserName(commentVO.getCmwriterEmpno());
		result.setEmpName(empName);
		return result;
	}

	@Override
	public void removeComment(String cmNo) {
		commentMapper.deleteComment(cmNo);
	}

	@Override
	public void modifyComment(CommentVO commentVO) {
		commentMapper.updateComment(commentVO);
	}

	@Override
	public FileVO feventDownload(String fileNo, int fileSec) {
		log.info("feventDownload()실행...!");
		log.info("fileNo, fileSec : {}, {}",fileNo,fileSec);
		FileVO fileVO = filemapper.noticeDownload(fileNo,fileSec);
		if(fileVO == null) {
			throw new RuntimeException();
		}
		
		return fileVO;
	}

}

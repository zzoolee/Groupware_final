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
import kr.or.ddit.mapper.FreeMapper;
import kr.or.ddit.service.IBoardFreeService;
import kr.or.ddit.vo.BoardFreeVO;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.FileVO;
import kr.or.ddit.vo.LikeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class BoardFreeServiceImpl implements IBoardFreeService {

	@Inject
	private FreeMapper mapper;

	@Inject
	private BoardFileMapper filemapper;

	@Inject
	private CommentMapper commentMapper;


	// 게시글 전체 조회
	@Override
	public List<BoardFreeVO> freeList() {
		log.info("[freeList] list");
		List<BoardFreeVO> freeList = mapper.freeList();

		for (int i = 0; i < freeList.size(); i++) {
			String empNo = freeList.get(i).getFrWriterEmpNo();
			String empName = mapper.selectUserName(empNo);
			freeList.get(i).setEmpName(empName);
		}
		return freeList;
	}

	// 게시판 글 등록
	@Override
	public void insertFree(BoardFreeVO free, HttpServletRequest req, HttpServletResponse res) {
		log.info("insertFree() 실행...!");
		mapper.insertFree(free);

		List<MultipartFile> boardfile = free.getFrFile();
		String fileNo = ("FR" + free.getFrNo());

		if (boardfile != null && !boardfile.isEmpty()) {
			for (int i = 0; i < boardfile.size(); i++) {
				MultipartFile multipartFile = boardfile.get(i);
				if (!multipartFile.isEmpty()) {
					FileVO file = new FileVO();
					file.setFileNo(fileNo);
					log.info("fileNo : {}", fileNo);
					String orgname = free.getFrFile().get(i).getOriginalFilename();
					file.setFileOrgname(orgname);
					log.info("orgName : {}", orgname);
					String savePath = req.getServletContext().getRealPath("/resources/board/free/");
					file.setFileSavepath(savePath);
					log.info("savePath : {}", savePath);
					long size = free.getFrFile().get(i).getSize();
					file.setFileSize(size);
					log.info("size : {}", size);
					String mime = free.getFrFile().get(i).getContentType();
					file.setFileMime(mime);
					log.info("mime : {}", mime);
					String saveName = UUID.randomUUID().toString() + "_" + orgname; // UUID의 랜덤 파일명 생성
					file.setFileSavename(saveName);
					log.info("saveName : {}", saveName);
					int lastIndex = orgname.lastIndexOf(".");
					if (lastIndex > 0) {
						String fileType = orgname.substring(lastIndex + 1);
						System.out.println("확장자: " + fileType);
						file.setFileType(fileType);
						log.info("fileType : {}", fileType);
					} else {
						System.out.println("확장자를 찾을 수 없습니다.");
					}
					// 등록한 게시글 첨부파일
					filemapper.insertFile(file);
					freeFileUpload(multipartFile, fileNo, req, saveName);
					log.info("insertFile()...!실행");
					// 게시글 등록
				}
			}
		}
	}

	// 파일 업로드
	private void freeFileUpload(MultipartFile freeFile, String fileNo, HttpServletRequest req, String saveName) {
		String savePath = "/resources/board/free/";

		if (freeFile != null && !freeFile.getOriginalFilename().equals("")) {
			// 파일 업로드 처리 시작
//			String saveName = UUID.randomUUID().toString();	// UUID의 랜덤 파일명 생성
//			saveName = saveName + "_" + noticeFile.getName().replaceAll(" ", "_") +"."+ noticeFile.getContentType();
//			saveName = saveName.replaceAll(" ", "_");

			// .../resources/board/notice/[] 경로
			String saveLocate = req.getServletContext().getRealPath(savePath + fileNo);
			File file = new File(saveLocate);
			if (!file.exists()) { // 업로드시 폴더가 존재하지 않을때
				file.mkdirs(); // 폴더 생성
			}

			// /resources/board/notice[]/UUID_원본파일명
			saveLocate += "/" + saveName;

			File savefile = new File(saveLocate);
			try {
				freeFile.transferTo(savefile);
			} catch (IllegalStateException | IOException e) {
				e.printStackTrace();
			}
		}
	}

	@Override
	public BoardFreeVO selectFree(String frNo) {
		log.info("selectFree");
		BoardFreeVO free = mapper.selectFree(frNo);
		String empNo = free.getFrWriterEmpNo();
		String empName = mapper.selectUserName(empNo);
		free.setEmpName(empName);
		mapper.incrementHit(frNo);
		return free;
	}

	@Override
	public List<FileVO> selectFreefilefrNo(String frNo) {
		log.info("selectFreefilenoNo() 실행...!");
		String fileNo = "FR" + frNo;
		return filemapper.selectFreefile(fileNo);
	}

	@Override
	public List<FileVO> selectFreefile(String fileNo) {
		log.info("selectFreefile() 실행...!");
		return filemapper.selectNoticefile(fileNo);
	}

	@Override
	public ServiceResult freeModify(HttpServletRequest req, BoardFreeVO freeVO) {
		ServiceResult result = null;
		// 공지사항 글 수정
		int status = mapper.updateFree(freeVO);
		if (status > 0) {
			try {
				String[] fileSec = freeVO.getFileSec();
				log.info("fileSec : {}", fileSec);
				if (fileSec != null) {
					for (int i = 0; i < fileSec.length; i++) {
						String fileSeci = fileSec[i];
						List<FileVO> fileVO = filemapper.selectNoticefileSec(fileSeci);
						log.info("fileVO : {}", fileVO);
						if (fileVO != null) {
							// 기존 파일 삭제
							String fileSavePath = fileVO.get(0).getFileSavepath() + fileVO.get(0).getFileNo() + "/"
									+ fileVO.get(0).getFileSavename();
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
			} catch (Exception e) {
				e.printStackTrace();
			}
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		List<MultipartFile> boardfile = freeVO.getFrFile();
		String fileNo = ("FR" + freeVO.getFrNo());
		// 한 게시글의 여러 첨부파일
		if (boardfile != null && !boardfile.isEmpty()) {
			for (int i = 0; i < boardfile.size(); i++) {
				MultipartFile multipartFile = boardfile.get(i);
				if (!multipartFile.isEmpty()) {
					FileVO file = new FileVO();
					file.setFileNo(fileNo);
					log.info("fileNo : {}", fileNo);
					String orgName = freeVO.getFrFile().get(i).getOriginalFilename();
					file.setFileOrgname(orgName);
					log.info("orgName : {}", orgName);
					String saveName = UUID.randomUUID().toString() + "_" + orgName;
					file.setFileSavename(saveName);
					log.info("saveName : {}", saveName);
					String savePath = req.getServletContext().getRealPath("/resources/board/free/");
					file.setFileSavepath(savePath);
					log.info("savePath : {}", savePath);
					long size = freeVO.getFrFile().get(i).getSize();
					file.setFileSize(size);
					log.info("size : {}", size);
					String mime = freeVO.getFrFile().get(i).getContentType();
					file.setFileMime(mime);
					log.info("mime : {}", mime);
					int lastIndex = orgName.lastIndexOf(".");
					if (lastIndex > 0) {
						String fileType = orgName.substring(lastIndex + 1);
						System.out.println("확장자: " + fileType);
						file.setFileType(fileType);
						log.info("fileType : {}", fileType);
					} else {
						System.out.println("확장자를 찾을 수 없습니다.");
					}
					// 등록한 게시글 첨부파일
					filemapper.insertFile(file);
					freeFileUpload(multipartFile, fileNo, req, saveName);
					log.info("insertFile()...!실행");
					// 게시글 등록
				}
			}
		}
		return result;
	}

	@Override
	public ServiceResult deleteFree(HttpServletRequest req, String frNo) {
		ServiceResult result = null;
		BoardFreeVO free = mapper.selectFree(frNo);
		String fileNo = ("FR" + free.getFrNo());
		mapper.deleteFreeLike(frNo);
		String CmBoardse = "FR";
		mapper.deleteFreeComment(CmBoardse, frNo);
		int status = mapper.deleteFree(frNo);
		if (status > 0) {
			List<FileVO> freeFileList = new ArrayList<FileVO>();
			freeFileList.addAll(filemapper.selectNoticefile(fileNo));
			log.info("noticeFileList : {}", freeFileList);
			try {
				if (freeFileList != null && freeFileList.size() > 0) {
					for (int i = 0; i < freeFileList.size(); i++) {
						String filePath = freeFileList.get(i).getFileSavepath() + "\\"
								+ freeFileList.get(i).getFileNo();
						log.info("filePath[] : {}", filePath);
						String path = filePath;
						deleteFolder(req, path);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			result = ServiceResult.OK;
			filemapper.deleteFolder(fileNo);
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	private void deleteFolder(HttpServletRequest req, String path) {
		File folder = new File(path);
		try {
			if (folder.exists()) { // 경로가 존재
				File[] folderList = folder.listFiles(); // 폴더안에 있는 파일들

				for (int i = 0; i < folderList.length; i++) {
					if (folderList[i].isFile()) { // 폴더안의 있는 것이 파일일때
						folderList[i].delete(); // 폴더안의 파일 차례대로 삭제
					} else {
						// 폴더안의 있는 파일이 폴더 일때 재귀함수 호출(폴더 안으로 들어가서 다시 이행)
						deleteFolder(req, folderList[i].getPath());
					}
				}
				folder.delete(); // 폴더삭제
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public CommentVO insertComment(CommentVO commentVO) {
		CommentVO result = null;
		int cnt = commentMapper.insertComment(commentVO);
		// 알람을 날리기 위해 게시글 번호를 가지고 작성자 정보를 가져온다
		BoardFreeVO boardFreeVO = mapper.selectFree(commentVO.getCmBno());
		log.debug("boardFreeVO:{}", boardFreeVO);
		if (cnt > 0) {
			CommentVO comment = commentMapper.selectComment(commentVO.getCmNo());
			String empName = mapper.selectUserName(commentVO.getCmwriterEmpno());
			log.info("commentVO.getCmwriterEmpno() : {}", commentVO.getCmwriterEmpno());
			log.info("empName : {}", empName);
			comment.setEmpName(empName);
			result = comment;
		}
		return result;
	}

	@Override
	public List<CommentVO> selectFreeComment(String frNo) {
		String cmBoardse = "FR";
		return commentMapper.selectCommentFree(frNo, cmBoardse);
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
	public void removeComment(String cmNo) {
		commentMapper.deleteComment(cmNo);
	}

	@Override
	public void modifyComment(CommentVO commentVO) {
		commentMapper.updateComment(commentVO);
	}

	@Override
	public void likeInsert(LikeVO likeVO) {
		mapper.likeInsert(likeVO);
	}

	@Override
	public void likeUpCount(String frNo) {
		mapper.likeUpCount(frNo);
	}

	@Override
	public void removeLike(LikeVO likeVO) {
		mapper.removeLike(likeVO);
	}

	@Override
	public void likeDownCount(String frNo) {
		mapper.likeDownCount(frNo);
	}

	@Override
	public int selectFreeLike(String chatuser, String frNo) {
		int result = mapper.selectFreeLike(frNo, chatuser);
		return result;
	}

	@Override
	public FileVO freeDownload(String fileNo, int fileSec) {
		log.info("noticeDownload()실행...!");
		log.info("fileNo, fileSec : {}, {}", fileNo, fileSec);
		FileVO fileVO = filemapper.noticeDownload(fileNo, fileSec);
		if (fileVO == null) {
			throw new RuntimeException();
		}

		return fileVO;
	}
}

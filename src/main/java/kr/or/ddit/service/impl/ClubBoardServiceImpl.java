package kr.or.ddit.service.impl;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

import javax.annotation.Resource;
import javax.inject.Inject;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.mapper.BoardFileMapper;
import kr.or.ddit.mapper.ClubBoardMapper;
import kr.or.ddit.mapper.CommentMapper;
import kr.or.ddit.service.IClubBoardService;
import kr.or.ddit.vo.ClubMemberVO;
import kr.or.ddit.vo.ClubNotMemVO;
import kr.or.ddit.vo.ClubPostVO;
import kr.or.ddit.vo.ClubVO;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.FileVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ClubBoardServiceImpl implements IClubBoardService{

	@Resource(name="uploadPath")
	private String resourcePath; // /resources/upload
	
	@Inject
	private ClubBoardMapper mapper;
	
	@Inject
	private BoardFileMapper fileMapper;

	@Inject
	private CommentMapper commentMapper;
	
	
	
	@Override
	public void createClub(ClubVO clubVO, MultipartFile file) throws IllegalStateException, IOException {
		
		// 동호회 테이블에 (파일 제외)정보 인서트
		mapper.insertClub(clubVO);
		
		if(file != null) {
			// 파일 업로드
			String saveLocate = resourcePath.replace(File.separatorChar, '/')+"/club/cover";
	//		String saveLocate = req.getServletContext().getRealPath("/resources/club/cover");
			String fileSavename = clubFileUpload(saveLocate, file);
			
			// 첨부파일 테이블에 정보 인서트
			String fileNo = clubVO.getClubCd();
			String fileOrgname = file.getOriginalFilename();
			String fileSavepath = "/resources/upload/club/cover/"+fileSavename;
			long fileSize = file.getSize();
			String fileMime = file.getContentType();
			String fileType = fileOrgname.substring(fileOrgname.lastIndexOf(".")+1);
			FileVO fileVO = new FileVO(fileNo, fileOrgname, fileSavename, fileSavepath, fileSize, fileMime, fileType);
			fileMapper.insertFile(fileVO);
			
			// 동호회 테이블에 정보 업데이트(첨부파일)
			clubVO.setClubPhoto(fileSavepath);
			mapper.updateClub(clubVO);
		}
		
	}
	
	public String clubFileUpload(String saveLocate, MultipartFile file) throws IllegalStateException, IOException {
		String fileSaveName = UUID.randomUUID().toString()+"_"+file.getOriginalFilename().replaceAll(" ", "_");
		
		File folder = new File(saveLocate);
		if(!folder.exists()) {
			folder.mkdirs();
		}
		
		// 첫번째 방법
		File target = new File(saveLocate+"/"+fileSaveName);
		file.transferTo(target); // 파일 복사
		
		// 두번째 방법
//		File target2 = new File(saveLocate, fileSaveName);
//		FileCopyUtils.copy(file.getBytes(), target2); // 파일 복사
		
		return fileSaveName;
	}

	@Override
	public List<ClubVO> showMyClub(String empNo) {
		return mapper.selectMyClub(empNo);
	}

	@Override
	public List<ClubVO> showAllClub() {
		return mapper.selectAllClub();
	}
	
	@Override
	public List<ClubVO> showPopularClub() {
		return mapper.selectPopularClub();
	}

	@Override
	public ClubVO showOneClub(String clubCd) {
		// 동호회 기본 정보
		ClubVO clubVO = mapper.selectOneclub(clubCd);
		
		ClubPostVO clubPostVO = new ClubPostVO();
		clubPostVO.setClubCd(clubCd);
		// 동호회 게시판 정보
		clubPostVO.setCbCd("NO");
		clubVO.setClubNOPostList(mapper.selectClubPost(clubPostVO));
		clubPostVO.setCbCd("FR");
		clubVO.setClubFRPostList(mapper.selectClubPost(clubPostVO));
		clubPostVO.setCbCd("AC");
		clubVO.setClubACPostList(mapper.selectClubActivity(clubPostVO));
		
		// 동호회 회원/승인대기 정보
		clubVO.setMemberList(mapper.selectClubMember(clubCd)); // 회원판단 용도
		clubVO.setAllMemberList(mapper.selectClubAllMember(clubCd)); // 회원목록 용도
		
		return clubVO;
	}

	@Override
	public void insertClubPost(ClubPostVO clubPostVO) throws IllegalStateException, IOException {
		mapper.insertClubPost(clubPostVO); // 게시글 등록
		
		if(clubPostVO.getFileList() != null && clubPostVO.getFileList().size() > 0) {
			// 파일 업로드
			String saveLocate = resourcePath.replace(File.separatorChar, '/')+"/club/board";
	//		String saveLocate = req.getServletContext().getRealPath("/resources/club/cover");
			
			for(int i=0; i<clubPostVO.getFileList().size(); i++) {
				// 파일 업로드
				FileVO file = clubPostVO.getFileList().get(i);
				String fileSavename = clubFileUpload(saveLocate, file.getItem());
				
				// 첨부파일 테이블에 정보 인서트
				String fileNo = clubPostVO.getClubCd() + "_" + clubPostVO.getCbCd() + clubPostVO.getCpNo();
				String fileSavepath = "/resources/upload/club/board/"+fileSavename;
				file.setFileNo(fileNo);
				file.setFileSavename(fileSavename);
				file.setFileSavepath(fileSavepath);
				
				fileMapper.insertFile(file);
			}
		}
	}

	@Override
	public ClubPostVO showClubBoardDetail(String cpNo) {
		mapper.incrementHit(cpNo);
		ClubPostVO clubPostVO = mapper.selectClubBoardDetail(cpNo);
		List<FileVO> fileList = mapper.selectClubBoardFileDetail(clubPostVO.getClubCd()+"_"+clubPostVO.getCbCd()+clubPostVO.getCpNo());
		clubPostVO.setFileList(fileList);
		List<CommentVO> commentList = mapper.selectClubBoardComment(cpNo);
		clubPostVO.setCommentList(commentList);
		
		return clubPostVO;
	}

	@Override
	public void modifyClubPost(ClubPostVO clubPostVO) throws IllegalStateException, IOException {
		mapper.updateClubPost(clubPostVO); // 게시글 수정
		
		log.debug(clubPostVO.toString());
		
		String[] delFileSec = clubPostVO.getDelFileSec();
		if(delFileSec != null) {
			fileMapper.deleteFileList(delFileSec); // 파일 삭제(해당하는 파일)
		}
		
		if(clubPostVO.getFileList() != null && clubPostVO.getFileList().size() > 0) {
			// 파일 추가 업로드
			String saveLocate = resourcePath.replace(File.separatorChar, '/')+"/club/board";
	//		String saveLocate = req.getServletContext().getRealPath("/resources/club/cover");
			
			for(int i=0; i<clubPostVO.getFileList().size(); i++) {
				// 파일 추가 업로드
				FileVO file = clubPostVO.getFileList().get(i);
				String fileSavename = clubFileUpload(saveLocate, file.getItem());
				
				// 첨부파일 테이블에 정보 인서트
				String fileNo = clubPostVO.getClubCd() + "_" + clubPostVO.getCbCd() + clubPostVO.getCpNo();
				String fileSavepath = "/resources/upload/club/board/"+fileSavename;
				file.setFileNo(fileNo);
				file.setFileSavename(fileSavename);
				file.setFileSavepath(fileSavepath);
				
				fileMapper.insertFile(file);
			}
		}
		
	}

	@Override
	public void removeClubPost(ClubPostVO clubPostVO) {
		mapper.deleteClubPost(clubPostVO.getCpNo());
		fileMapper.deleteFolder(clubPostVO.getClubCd() + "_" + clubPostVO.getCbCd() + clubPostVO.getCpNo());
	}
	
	@Override
	public void insertClubActivity(ClubPostVO clubPostVO, MultipartFile picture) throws IllegalStateException, IOException {
		mapper.insertClubPost(clubPostVO); // 게시글 등록
		
		if(picture != null && picture.getSize() > 0 && StringUtils.isNotBlank(picture.getName())) {
			// 파일 업로드
			String saveLocate = resourcePath.replace(File.separatorChar, '/')+"/club/board";
			String fileSavename = clubFileUpload(saveLocate, picture);
			
			// 첨부파일 테이블에 정보 인서트
			String fileNo = clubPostVO.getClubCd() + "_" + clubPostVO.getCbCd() + clubPostVO.getCpNo();
			String fileOrgname = picture.getOriginalFilename();
			String fileSavepath = "/resources/upload/club/board/"+fileSavename;
			long fileSize = picture.getSize();
			String fileMime = picture.getContentType();
			String fileType = fileOrgname.substring(fileOrgname.lastIndexOf(".")+1);
			FileVO fileVO = new FileVO(fileNo, fileOrgname, fileSavename, fileSavepath, fileSize, fileMime, fileType);
			fileMapper.insertFile(fileVO);
		}
	}
	
	@Override
	public void modifyClubActivity(ClubPostVO clubPostVO, MultipartFile picture) throws IllegalStateException, IOException {
		mapper.updateClubPost(clubPostVO); // 게시글 수정
		
		if(picture != null && picture.getSize() > 0 && StringUtils.isNotBlank(picture.getName())) {
			// 파일 업로드
			String saveLocate = resourcePath.replace(File.separatorChar, '/')+"/club/board";
			String fileSavename = clubFileUpload(saveLocate, picture);
			
			// 첨부파일 테이블에 정보 인서트
			String fileNo = clubPostVO.getClubCd() + "_" + clubPostVO.getCbCd() + clubPostVO.getCpNo();
			// (첨부파일 테이블에서 삭제)
			fileMapper.deleteFolder(fileNo);
			String fileOrgname = picture.getOriginalFilename();
			String fileSavepath = "/resources/upload/club/board/"+fileSavename;
			long fileSize = picture.getSize();
			String fileMime = picture.getContentType();
			String fileType = fileOrgname.substring(fileOrgname.lastIndexOf(".")+1);
			FileVO fileVO = new FileVO(fileNo, fileOrgname, fileSavename, fileSavepath, fileSize, fileMime, fileType);
			fileMapper.insertFile(fileVO);
		}
	}

	@Override
	public FileVO selectFileInfo(int fileSec) {
		return fileMapper.selectFileInfo(fileSec);
	}

	@Override
	public CommentVO insertComment(CommentVO commentVO) {
		CommentVO result = null;
		// 알람을 날리기 위해 게시글 번호를 가지고 작성자 정보를 가져온다
		ClubPostVO clubPostVO = mapper.selectClubBoardDetail(commentVO.getCmBno());
		int cnt = commentMapper.insertComment(commentVO);
		if(cnt > 0) {
			result = commentMapper.selectComment(commentVO.getCmNo());
		}
		
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
	public void clubJoinConfirm(ClubNotMemVO clubNotMemVO) {
		mapper.deleteFromNotmem(clubNotMemVO);
		ClubMemberVO clubMemberVO = new ClubMemberVO();
		clubMemberVO.setClubCd(clubNotMemVO.getClubCd());
		clubMemberVO.setCmEmpno(clubNotMemVO.getCnmEmpno());
		mapper.insertIntoMem(clubMemberVO);
	}

	@Override
	public void clubJoinReject(ClubNotMemVO clubNotMemVO) {
		mapper.updateNotmem(clubNotMemVO);
	}

	@Override
	public ServiceResult joinClub(ClubNotMemVO clubNotMemVO) {
		ServiceResult result = null;
		if(mapper.chkJoinClub(clubNotMemVO) == null) { // 가입 요청한 내역 없으면(거절 제외)
			mapper.joinClub(clubNotMemVO);
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}
	
	@Override
	public void leaveClub(ClubMemberVO clubMemberVO) {
		mapper.leaveClub(clubMemberVO);
	}

	@Override
	public List<ClubVO> showAllClubAdmin() {
		return mapper.selectAllClubAdmin();
	}

	@Override
	public void shutdownClub(String clubCd) {
		mapper.updateClubStatusShutdown(clubCd);
	}

	@Override
	public void approveClub(String clubCd) {
		mapper.updateClubStatusApprove(clubCd);
	}

	@Override
	public void rejectClub(String clubCd) {
		mapper.deleteClub(clubCd);
	}

	@Override
	public void modifyClubInfo(ClubVO clubVO, MultipartFile clubPhoto) throws IllegalStateException, IOException {
		if(clubPhoto != null && clubPhoto.getSize() > 0 && StringUtils.isNotBlank(clubPhoto.getName())) {
			// 파일 업로드
			String saveLocate = resourcePath.replace(File.separatorChar, '/')+"/club/cover";
			String fileSavename = clubFileUpload(saveLocate, clubPhoto);
			
			// 첨부파일 테이블에 정보 인서트
			String fileNo = clubVO.getClubCd();
			// (첨부파일 테이블에서 삭제)
			fileMapper.deleteFolder(fileNo);
			String fileOrgname = clubPhoto.getOriginalFilename();
			String fileSavepath = "/resources/upload/club/cover/"+fileSavename;
			long fileSize = clubPhoto.getSize();
			String fileMime = clubPhoto.getContentType();
			String fileType = fileOrgname.substring(fileOrgname.lastIndexOf(".")+1);
			FileVO fileVO = new FileVO(fileNo, fileOrgname, fileSavename, fileSavepath, fileSize, fileMime, fileType);
			fileMapper.insertFile(fileVO);
			
			// 동호회 테이블에 정보 업데이트(첨부파일)
			clubVO.setClubPhoto(fileSavepath);
			mapper.updateClub(clubVO);
		}
		if(StringUtils.isNotBlank(clubVO.getClubInfo())){
			mapper.updateClubInfo(clubVO);
		}
	}

	@Override
	public ClubVO showClubInfo(String clubCd) {
		return mapper.selectClubInfo(clubCd);
	}

}

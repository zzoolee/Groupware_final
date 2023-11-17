package kr.or.ddit.service;

import java.io.IOException;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.ClubMemberVO;
import kr.or.ddit.vo.ClubNotMemVO;
import kr.or.ddit.vo.ClubPostVO;
import kr.or.ddit.vo.ClubVO;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.FileVO;

public interface IClubBoardService {

	public void createClub(ClubVO clubVO, MultipartFile file) throws IllegalStateException, IOException;
	public List<ClubVO> showMyClub(String name);
	public List<ClubVO> showAllClub();
	public List<ClubVO> showPopularClub();
	public ClubVO showOneClub(String clubCd);
	public void insertClubPost(ClubPostVO clubPostVO) throws IllegalStateException, IOException;
	public ClubPostVO showClubBoardDetail(String cpNo);
	public void modifyClubPost(ClubPostVO clubPostVO) throws IllegalStateException, IOException;
	public void removeClubPost(ClubPostVO clubPostVO);
	public void insertClubActivity(ClubPostVO clubPostVO, MultipartFile picture) throws IllegalStateException, IOException;
	public void modifyClubActivity(ClubPostVO clubPostVO, MultipartFile picture) throws IllegalStateException, IOException;
	
	public FileVO selectFileInfo(int fileSec);
	public CommentVO insertComment(CommentVO commentVO);
	public void removeComment(String cmNo);
	public void modifyComment(CommentVO commentVO);
	
	public void clubJoinConfirm(ClubNotMemVO clubNotMemVO);
	public void clubJoinReject(ClubNotMemVO clubNotMemVO);
	public ServiceResult joinClub(ClubNotMemVO clubNotMemVO);
	public void leaveClub(ClubMemberVO clubMemberVO);
	
	public List<ClubVO> showAllClubAdmin();
	public void shutdownClub(String clubCd);
	public void approveClub(String clubcd);
	public void rejectClub(String clubcd);
	
	public void modifyClubInfo(ClubVO clubVO, MultipartFile clubPhoto) throws IllegalStateException, IOException;
	
	public ClubVO showClubInfo(String clubCd);
	
}

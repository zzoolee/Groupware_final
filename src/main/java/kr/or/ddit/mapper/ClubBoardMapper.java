package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.ClubAllMemberVO;
import kr.or.ddit.vo.ClubMemberVO;
import kr.or.ddit.vo.ClubNotMemVO;
import kr.or.ddit.vo.ClubPostVO;
import kr.or.ddit.vo.ClubVO;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.FileVO;

public interface ClubBoardMapper {

	public void insertClub(ClubVO clubVO);
	public void updateClub(ClubVO clubVO);
	public void updateClubInfo(ClubVO clubVO);
	public List<ClubVO> selectMyClub(String empNo);
	public List<ClubVO> selectAllClub();
	public List<ClubVO> selectPopularClub();
	public ClubVO selectOneclub(String clubCd);
	public void insertClubPost(ClubPostVO clubPostVO);
	public List<ClubPostVO> selectClubPost(ClubPostVO clubPostVO);
	public List<ClubPostVO> selectClubActivity(ClubPostVO clubPostVO);
	public void incrementHit(String cpNo);
	public ClubPostVO selectClubBoardDetail(String cpNo);
	public List<FileVO> selectClubBoardFileDetail(String string);
	public List<CommentVO> selectClubBoardComment(String cpNo);
	
	public void updateClubPost(ClubPostVO clubPostVO);
	public void deleteClubPost(String cpNo);
	
	public List<ClubMemberVO> selectClubMember(String clubCd);
	public List<ClubAllMemberVO> selectClubAllMember(String clubCd);
	
	public void deleteFromNotmem(ClubNotMemVO clubNotMemVO);
	public void insertIntoMem(ClubMemberVO clubMemberVO);
	public void updateNotmem(ClubNotMemVO clubNotMemVO);
	
	public ClubNotMemVO chkJoinClub(ClubNotMemVO clubNotMemVO);
	public void joinClub(ClubNotMemVO clubNotMemVO);
	public void leaveClub(ClubMemberVO clubMemberVO);
	
	public List<ClubVO> selectAllClubAdmin();
	public void updateClubStatusShutdown(String clubCd);
	public void updateClubStatusApprove(String clubCd);
	public void deleteClub(String clubCd);
	
	public ClubVO selectClubInfo(String clubCd);
}

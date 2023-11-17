package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.chatSelectResultVO;

public interface IChatTilesService {
	// 본인이 들어간 채팅방 조회
	public List<chatSelectResultVO> selectChatRoom(String chatuser);
	// 본인이 들어간 채팅방중 최근 채팅이 온 채팅방 조회
	public String selectRecentChat(String chatuser);
	// 나를 제외한 유저 No와 Name 조회
	public List<EmpVO> selectChatUser(String chatuser);
	// 나와 상대방의 채팅방 조회
	public String selectChatCrNo(String empNo, String chatuser);
	public void createChatMyRoom(String empNo, String chatuser);
	public void createchatMyMember();
	public void createChatMember(String empNo, String chatuser);
	public void insertCcFirst(String empNo, String chatuser);
	// <a>태그 리스트 검색기능
	public List<EmpVO> searchUsers(String keyword);
}

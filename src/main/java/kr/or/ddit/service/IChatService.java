package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.ChatMemberVO;
import kr.or.ddit.vo.ChatRoomDTLVO;
import kr.or.ddit.vo.ChatRoomVO;
import kr.or.ddit.vo.ChatVO;
import kr.or.ddit.vo.chatSelectResultVO;

public interface IChatService {
	// 채팅 데이터 저장
	public void insertChatting(String msg, String crNo, String empNo);
	// 채팅방 조회
	public List<chatSelectResultVO> selectChatRoom(String chatuser);
	// 유저 리스트 조회
	public List<chatSelectResultVO> selectChatUser(String chatuser);
	// 채팅방 상세보기 조회
	public List<ChatRoomDTLVO> selectRoomDetail(ChatVO chat);
	// 채팅방 생성 및 내 정보 입력
	public void createChatMyRoom(String empNo);
	// 단체 채팅방 생성
	public void createChatGroupRoom(String[] empNoList);
	// 채팅방 멤버 입력 (로그인 유저, 채팅 상대방, 단체채팅)
	public void createchatMyMember();
	public void createChatMember(String empNo);
	public void createChatGroupMember(String[] empNoList);
	// 채팅방 유무 확인
	public boolean checkChatRoomExists(String empNo);
	public String selectcrNo(String empNo);
	// 방번호로 방제목 검색
	public String selectChatRoomTitle(String roomCrNo, String userEmpNo);
	// 방번호로 방 검색
	public List<ChatRoomVO> selectCrNoRoom(String crNo);
	// 미확인 알람 갯수 가져오기
	public int selectUnreadChat(String empNo);
	public void insertCcFirst(String empNo);
	// 방번호로 방에 인원 사번 가져오기
	public List<ChatMemberVO> selectCrNoUser(String crNo);
	// 보낸사람 사진 찾기
	public String selectSenderEmpPhoto(String sender);
	// 채팅방 제목 변경
	public void crcmModify(String crcmTitle, String crNo);
	// 바뀐 채팅방 제목 조회
	public String newTitleselect(String crNo);
	// 검색어로 채팅방 조회
	public List<chatSelectResultVO> selectChatSearch(String keyword, String tab);
	// 방번호로 채팅방 멤버 이름 조회
	public List<chatSelectResultVO> selectUserNameList(String crNo);
}

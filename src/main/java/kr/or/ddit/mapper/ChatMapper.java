package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.ChatMemRoomVO;
import kr.or.ddit.vo.ChatMemberVO;
import kr.or.ddit.vo.ChatRoomDTLVO;
import kr.or.ddit.vo.ChatRoomVO;
import kr.or.ddit.vo.ChatVO;
import kr.or.ddit.vo.chatSelectResultVO;

public interface ChatMapper {
	// 채팅 메세지 데이터 등록
	public void insert(ChatVO chat);
	// 채팅방 멤버수 조회
	public int selectCRMemNum(ChatVO chat);
	// 채팅방 조회
	public List<chatSelectResultVO> selectChatRoom(String chatuser);
	// 채팅 유저 조회
	public List<chatSelectResultVO> selectChatUser(String chatuser);
	// 조회된 유저 crNo 조회
	public List<String> selectCrNoList(String chatuser, List<String> userList);
	// 채팅방 상세보기
	public List<ChatRoomDTLVO> selectRoomDetail(ChatVO chat);
	// 그룹채팅 생성
	public ChatRoomVO createGroupChat(List<String> empNo);
	// 1대 1 채팅방 생성
	public void createChatRoom(ChatRoomVO chatRoom);
	// 채팅방 내 채팅 생성하기
	public ChatRoomVO createChatMyRoom(String empNo);
	// 채팅방 입장시 입력되어있는 chat_no
	public int selectMemberChatNo(String crNo);
	// 방번호로 방 제목 검색
	public String selectRoomTitle(String crNo);
	// 채팅방 멤버 등록
	public void createChatMember(ChatMemberVO member);
	// 내가 가진 채팅방 확인
	public List<String> selectRoomList(String chatuser);
	// 채팅방 유무 확인
	public int checkChatRoomExists();
	// 채팅방에 유저 유무 확인
	public List<String> selectUserList(String chatRoom);
	// 최근 생성된 crNo조회
	public String selectCrNoMaxCount();
	// 채팅방 번호 empNo와 로그인 유저로 검색
	public String selectcrNo(@Param("myNo") String chatuser, @Param("empNo")String empNo);
	public String selectcrNo2(ChatMemRoomVO memRoom);
	// 방번호로 방 제목 검색
	public String selectChatRoomTitle(@Param("crNo") String roomCrNo,@Param("empNo") String userEmpNo);
	public List<String> selectChatUser2(String chatRoom);
	// 나와 상대방의 사번으로 1대1 채팅방 존재 확인
	public String selectcrUser(@Param("chatuser") String chatuser,@Param("empNo") String empNo);
	// 방 번호로 채팅방 검색
	public List<ChatRoomVO> selectCrNoRoom(String crNo);
	// 미확인 채팅 숫자 가져오기
	public List<ChatMemberVO> selectUnreadChat(String empNo);
	// 채팅룸의 마지막 채팅 번호 가져오기 
	public List<ChatVO> selectLastChatNo(String crNo);
	// 채팅룸의 안읽은 채팅 목록을 가져온다. 
	public List<ChatVO> selectCnt(ChatMemberVO chatMemberVO);
	// cc_end 수정
	public void updateCcEnd(@Param("crNo")String crNo,@Param("empNo")String empNo);
	// 처음 입장 시 환영 채팅 쓰기
	public void insertCcFirst(String crNo);
	public void insertGroupCcFirst(String crNo);
	// 채팅방의 채팅번호 조회
	public int selectChatNo(String crNo);
	// 채팅방 번호로 유저리스트 조회
	public List<ChatMemberVO> selectCrNoUser(String crNo);
	// 채팅방 이름 바꾸기
	public String nickNameModify(@Param("empNo")String chatuser,@Param("crNo")String crNo);
	// 채팅방 유저 상태 조회
	public String selectAtStatus(String empNo);
	// 채팅방 제목 변경
	public void crcmModify(@Param("crcmTitle")String crcmTitle, @Param("crNo")String crNo, @Param("empNo")String chatuser);
	// 채팅방 타입 조회
	public String selectCrSe(String crNo);
	// 채팅방 검색 기능
	public List<chatSelectResultVO> selectChatSearch(@Param("keyword")String keyword,@Param("empNo")String chatuser);
	// 방번호로 채팅방 멤버 조회
	public List<String> selectCRMemNo(String crNo);
	// 방번호로 채팅방 이름 조회
	public List<chatSelectResultVO> selectUserNameList(String crNo);
}

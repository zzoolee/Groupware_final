package kr.or.ddit.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.ChatMapper;
import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.service.IChatService;
import kr.or.ddit.vo.ChatMemRoomVO;
import kr.or.ddit.vo.ChatMemberVO;
import kr.or.ddit.vo.ChatRoomDTLVO;
import kr.or.ddit.vo.ChatRoomVO;
import kr.or.ddit.vo.ChatVO;
import kr.or.ddit.vo.chatSelectResultVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ChatServiceImpl implements IChatService {

	@Inject
	private ChatMapper mapper;
	@Inject
	private EmpMapper empMapper;
	
	@Override
	public void insertChatting(String msg, String crNo, String empNo) {
		ChatVO chat = new ChatVO();
		chat.setCrNo(crNo);
		chat.setChasenderEmpno(empNo);
		int memNum = mapper.selectCRMemNum(chat);
		int memNNN = memNum -1;
		chat.setChatUncheck(memNNN);
		chat.setChatMsg(msg);
		System.out.println("chat Impl : " + chat);
		// 채팅방 멤버 n조회
		mapper.insert(chat);
		mapper.updateCcEnd(crNo, empNo);
	}
	@Override
	public List<chatSelectResultVO> selectChatRoom(String chatuser) {
		List<chatSelectResultVO> resultList = mapper.selectChatRoom(chatuser);
		log.info("resultList111 :{}", resultList);
		if(resultList != null) {
			for(int i = 0; i < resultList.size(); i++) {
				chatSelectResultVO result = resultList.get(i);
//				String empNo = result.getEmpNo();
//				log.info("empNo12312312 : {}", empNo);
//				String atStatus = mapper.selectAtStatus(empNo);
//				log.info("atStatus12312312 : {}", atStatus);
				String crNo = result.getCrNo();
				String crSe = mapper.selectCrSe(crNo);
				result.setCrSe(crSe);
				String crcmTitle = result.getCrcmTitle();
				String[] titleParts = crcmTitle.split(", ");
				String userName = titleParts[0];
				result.setCrcmTitle(userName);
//				result.setAtStatus(atStatus);
			}
		}
		return resultList;
	}
	@Override
	public List<chatSelectResultVO> selectChatUser(String chatuser) {
	    List<chatSelectResultVO> userList = mapper.selectChatUser(chatuser);
	    for (int i = 0; i < userList.size(); i++) {
	    	chatSelectResultVO emp = userList.get(i);
	    	String empNo = emp.getEmpNo();
	    	String crNo = mapper.selectcrNo(chatuser,empNo);
	    	String atStatus = mapper.selectAtStatus(empNo);
	    	emp.setAtStatus(atStatus);
	    	log.info("crNo 확인하자 : {}", crNo);
//	        for(int i = 0; i < )
	    	userList.get(i).setCrNo(crNo);
	    }
	    
	    return userList;
	}
	@Override
	public List<ChatRoomDTLVO> selectRoomDetail(ChatVO chat) {
		String crNo = chat.getCrNo();
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String empNo = user.getEmp().getEmpNo();
		Integer chatNo = mapper.selectChatNo(crNo);
		if(chatNo == 0) { 
			log.info("null 값 들어옴");
			mapper.insertCcFirst(crNo);
			
		}else {
			mapper.updateCcEnd(crNo, empNo);
		}
		return mapper.selectRoomDetail(chat);
	}
	// chatList에 crNo 넣어주기
//	@Override
//	public void setCrNo(List<chatSelectResultVO> chatList) {
//	    CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();	
//	    String chatUser = user.getEmp().getEmpNo();
//
//	    // empNo 값을 담을 List 생성
//	    List<String> userEmp = new ArrayList<>();
//
//	    for (chatSelectResultVO chat : chatList) {
//	        userEmp.add(chatUser);
//	        userEmp.add(chat.getEmpNo());
//	        String crNo = mapper.setCrNo(userEmp);
//	        chat.setCrNo(crNo);
//	    }
	    
	// 채팅방 생성 및 내 정보 입력(1대 1)
	@Override
	public void createChatMyRoom(String empNo) {
		ChatRoomVO chatRoom = new ChatRoomVO();
		System.out.println("empNo : " +empNo);
		// 내 아이디
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		// 내 아이디도 제목에 추가
		String myName = user.getEmp().getEmpName();
		log.info("myName : {} " ,myName);
		String userName = empMapper.findName(empNo);
		String[] names = {myName, userName};
		String crTitle = String.join("," , names);
		log.info("crTitle : {}", crTitle);
		String crSe = "일반";
		chatRoom.setCrSe(crSe);
		chatRoom.setCrTitle(crTitle);
		// 채팅방 생성
		mapper.createChatRoom(chatRoom);
	}
	// 단체 채팅방 생성
	@Override
	public void createChatGroupRoom(String[] empNoList) {
		ChatMemRoomVO memRoom = new ChatMemRoomVO();
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		memRoom.setRoomEmp(new String[empNoList.length]);
		ChatRoomVO chatRoom = new ChatRoomVO();
		
		String username = user.getEmp().getEmpName();
		int countEmpNo = empNoList.length;
		log.info("empList.leghth : {}", countEmpNo);
		String roomTitle = (username+" 외 " +countEmpNo+"명");
		chatRoom.setCrTitle(roomTitle); 
		String crSe = "그룹";
		chatRoom.setCrSe(crSe);
		mapper.createChatRoom(chatRoom);
		for(int i=0; i < empNoList.length; i++) {
			memRoom.getRoomEmp()[i] = empNoList[i];
			String empNo = empNoList[i];
			log.info("empNo : {}", empNo);
		}
		String crNo = mapper.selectCrNoMaxCount();
		log.info("crNo : {}", crNo);
		mapper.insertGroupCcFirst(crNo);
		
	}
	
	// 로그인 사용자 입력
	@Override
	public void createchatMyMember() {
		ChatMemberVO member = new ChatMemberVO();
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String chatuser = user.getEmp().getEmpNo();
		String myName = user.getEmp().getEmpName();
		
		System.out.println("chatUser : " + chatuser);
		member.setEmpNo(chatuser);
		String crNo = mapper.selectCrNoMaxCount();
		member.setCrNo(crNo);
		System.out.println("CrNo : " + crNo);
		String crTitle = mapper.selectRoomTitle(crNo);
		String[] titleParts = crTitle.split(",");
		StringBuilder result = new StringBuilder();
		
		for(String title : titleParts) {
			if(!title.equals(myName)) {
				result.append(title);
			}
		}
		log.info("result.toString() : {}", result.toString());
		member.setCrcmTitle(result.toString());
		mapper.createChatMember(member);
	}
	// 채팅방 멤버 입력
	@Override
	public void createChatMember(String empNo) {
		ChatMemberVO member = new ChatMemberVO();
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String myName = user.getEmp().getEmpName();
		member.setEmpNo(empNo);
	    String crNo = mapper.selectCrNoMaxCount();
	    member.setCrNo(crNo);
//	    String crcmTitle = mapper.selectRoomTitle(crNo);
//	    String[] titleParts = crcmTitle.split(", ");
//		String userName = titleParts[1];
	    member.setCrcmTitle(myName);
	    log.info("myName : {}", myName);
	    mapper.createChatMember(member);
	}
	// 단체 채팅방 멤버 입력
	@Override
	public void createChatGroupMember(String[] empNoList) {
		ChatMemRoomVO memRoom = new ChatMemRoomVO();
		memRoom.setRoomEmp(new String[empNoList.length]);	
		
		
		// 최근 생성된 채팅방
		String crNo = mapper.selectCrNoMaxCount();
		String crcmTitle = mapper.selectRoomTitle(crNo);
		// empNoList안의 각각의 empNo
		for(int i=0; i < empNoList.length; i++) {
			ChatMemberVO member = new ChatMemberVO();
			memRoom.getRoomEmp()[i] = empNoList[i];
			String empNo = empNoList[i];
			log.info("empNo : {}", empNo);
			member.setEmpNo(empNo);
			member.setCrNo(crNo);
			member.setCrcmTitle(crcmTitle);
			mapper.createChatMember(member);
		}
	}
	// 채팅방 유무 확인
	@Override
	public boolean checkChatRoomExists(String empNo) {
		log.info("checkChatRoomExists() 실행...!");
		// 로그인 사용자
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String chatuser = user.getEmp().getEmpNo();
		boolean result = false;
		log.info("empNo : {}",empNo);
		// 
		String crNo = mapper.selectcrUser(chatuser,empNo);
		log.info("방검색 : {}",crNo);
		if(crNo != null && !crNo.equals("")) {
			result = true;
			return result;
		}
		log.info("result : {}",result);
		return result;
	}
	// 채팅방 번호 empNo와 로그인 유저로 검색
	@Override
	public String selectcrNo(String empNo) {
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String chatuser = user.getEmp().getEmpNo();
		
		return mapper.selectcrNo(chatuser, empNo);
	}
	@Override
	public String selectChatRoomTitle(String roomCrNo, String userEmpNo) {
		return mapper.selectChatRoomTitle(roomCrNo,userEmpNo);
	}
	@Override
	public List<ChatRoomVO> selectCrNoRoom(String crNo) {
		return mapper.selectCrNoRoom(crNo);
	}
	/**
	 * 미확인 채팅 숫자 가져오기
	 */
	@Override
	public int selectUnreadChat(String empNo) {
		
		int cnt=0;
		
		// 사번을 가지고 내가 속한 채팅방 조회
		List<ChatMemberVO> roomList = mapper.selectUnreadChat(empNo);
		
		// 내가 속한 채팅방 번호를 가지고 해당 채팅방의 마지막 채팅 넘버를 가져온다
		List<ChatVO> chatList = new ArrayList<ChatVO>(); 
		
		List<ChatVO> unReadChatCntList = new ArrayList<ChatVO>();
		
		for(int i=0; i< roomList.size(); i++) {
			String crNo = roomList.get(i).getCrNo();
			List<ChatVO> chatMaxList = mapper.selectLastChatNo(crNo);
			chatList.add(chatMaxList.get(0));
		}
		
		for(int i=0; i<roomList.size(); i++) {
			
			for(int j=0; j<chatList.size(); j++) {
				
				if(roomList.get(i).getCrNo().equals(chatList.get(j).getCrNo()) && !chatList.get(j).getChasenderEmpno().equals(empNo)) {
					int ccEndNo = roomList.get(i).getCcEnd();
					int chatNo = chatList.get(j).getChatNo();
					if(ccEndNo <  chatNo) {
						roomList.get(i).setEmpNo(empNo);
						roomList.get(i).setChatNo(chatNo);
						unReadChatCntList = mapper.selectCnt(roomList.get(i));
						
						if(unReadChatCntList.size() > 0) {
							cnt++;
						}
					}
				}
			}
		}
		
		return cnt;
	}
	@Override
	public void insertCcFirst(String empNo) {
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String chatuser = user.getEmp().getEmpNo();
		
		String crNo = mapper.selectcrUser(chatuser, empNo);
		if(crNo != null) {
			mapper.insertCcFirst(crNo);
		}
	}
	@Override
	public List<ChatMemberVO> selectCrNoUser(String crNo) {
		return mapper.selectCrNoUser(crNo);
	}
	@Override
	public String selectSenderEmpPhoto(String sender) {
		return empMapper.findSenderEmpPhto(sender);
	}
	@Override
	public void crcmModify(String crcmTitle, String crNo) {
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String chatuser = user.getEmp().getEmpNo();
		mapper.crcmModify(crcmTitle,crNo,chatuser);
	}
	@Override
	public String newTitleselect(String crNo) {
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String chatuser = user.getEmp().getEmpNo();
		return mapper.selectChatRoomTitle(crNo,chatuser);
	}
	@Override
	public List<chatSelectResultVO> selectChatSearch(String keyword, String tab) {
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String chatuser = user.getEmp().getEmpNo();
		List<chatSelectResultVO> chatSearchList = new ArrayList<>();

		List<chatSelectResultVO> resultList = mapper.selectChatRoom(chatuser);
		List<chatSelectResultVO> userList = mapper.selectChatUser(chatuser);
		
		if("user".equals(tab)) {
			log.info("selectChatSearch->if문");
			log.info("selectChatSearch->userList : " + userList);
			if(userList != null) {
				for(chatSelectResultVO userResult : userList) {
					if (userResult.getEmpNo() != null && userResult.getEmpName().startsWith(keyword)) {
	                    chatSearchList.add(userResult);
	                }
				}
			}
		}else {
			log.info("selectChatSearch->else문");
			if(resultList != null) {
				for (chatSelectResultVO result : resultList) {
	                if (result.getCrNo() != null && result.getCrcmTitle().startsWith(keyword)) {
	                    chatSearchList.add(result);
	                }
	            }
			}
		}
		
		log.info("selectChatSearch->chatSearchList : " + chatSearchList);
		return chatSearchList;
	}
	@Override
	public List<chatSelectResultVO> selectUserNameList(String crNo) {
		return mapper.selectUserNameList(crNo);
	}
	
}

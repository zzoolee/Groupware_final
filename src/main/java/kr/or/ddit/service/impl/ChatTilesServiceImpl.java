package kr.or.ddit.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.ChatMapper;
import kr.or.ddit.mapper.ChatTilesMapper;
import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.service.IChatTilesService;
import kr.or.ddit.vo.ChatMemberVO;
import kr.or.ddit.vo.ChatRoomVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.chatSelectResultVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ChatTilesServiceImpl implements IChatTilesService {

	@Inject
	private ChatMapper chatMapper;
	
	@Inject
	private ChatTilesMapper mapper;
	
	@Inject
	private EmpMapper empMapper;
	
	// 처음 방 들어갔을때
	@Override
	public List<chatSelectResultVO> selectChatRoom(String chatuser) {
		List<chatSelectResultVO> chatList = mapper.selectRoomList(chatuser);
		log.info("chatList : {}" , chatList);
		if(chatList != null) {
			for(int i=0; i<chatList.size(); i++) {
				
			}
		}
		
		return chatList;
	}

	@Override
	public String selectRecentChat(String chatuser) {
		return mapper.selectRecentChat(chatuser);
	}

	@Override
	public List<EmpVO> selectChatUser(String chatuser) {
		return mapper.selectChatUserTiles(chatuser);
	}

	@Override
	public String selectChatCrNo(String empNo, String chatuser) {
		return chatMapper.selectcrNo(empNo, chatuser);
	}

	@Override
	public void createChatMyRoom(String empNo, String chatuser) {
		ChatRoomVO chatRoom = new ChatRoomVO();
		String userName = empMapper.findName(empNo);
		String myName = empMapper.findName(chatuser);
		String crSe = "일반";
		chatRoom.setCrSe(crSe);
		String[] names = {myName, userName};
		String crTitle = String.join("," , names);
		chatRoom.setCrTitle(crTitle);
		chatMapper.createChatRoom(chatRoom);
	}

	@Override
	public void createchatMyMember() {
		ChatMemberVO member = new ChatMemberVO();
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String chatuser = user.getEmp().getEmpNo();
		String myName = user.getEmp().getEmpName();
		
		System.out.println("chatUser : " + chatuser);
		member.setEmpNo(chatuser);
		String crNo = chatMapper.selectCrNoMaxCount();
		member.setCrNo(crNo);
		System.out.println("CrNo : " + crNo);
		String crTitle = chatMapper.selectRoomTitle(crNo);
		String[] titleParts = crTitle.split(",");
		StringBuilder result = new StringBuilder();
		for(String title : titleParts) {
			if(!title.equals(myName)) {
				result.append(title);
			}
		}
		log.info("result.toString() : {}", result.toString());
		member.setCrcmTitle(result.toString());
		chatMapper.createChatMember(member);
	}

	@Override
	public void createChatMember(String empNo, String chatuser) {
		ChatMemberVO member = new ChatMemberVO();
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String myName = user.getEmp().getEmpName();
		member.setEmpNo(empNo);
	    String crNo = chatMapper.selectCrNoMaxCount();
	    member.setCrNo(crNo);
	    member.setCrcmTitle(myName);
	    chatMapper.createChatMember(member);
	}

	@Override
	public void insertCcFirst(String empNo, String chatuser) {
		String crNo = chatMapper.selectcrUser(chatuser, empNo);
		chatMapper.insertCcFirst(crNo);
	}

	@Override
	public List<EmpVO> searchUsers(String keyword) {
		return mapper.searchUsers(keyword);
	}
}

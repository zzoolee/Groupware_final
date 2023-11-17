package kr.or.ddit.controller.chat;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.bouncycastle.asn1.ocsp.ResponseData;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.security.CustomUser;
import kr.or.ddit.service.IChatService;
import kr.or.ddit.service.IChatTilesService;
import kr.or.ddit.vo.ChatRoomDTLVO;
import kr.or.ddit.vo.ChatRoomVO;
import kr.or.ddit.vo.ChatVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.chatSelectResultVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class chatTilesController {
	
	@Inject
	private IChatTilesService service;
	
	@Inject
	private IChatService chatService;
	
	@ResponseBody
	@RequestMapping(value = "/chatTiles.do")
	public ResponseEntity<Map<String, Object>> chatTiles(Model model) {
		log.info("chatTiles() 실행");
		
	    CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    String chatuser = user.getEmp().getEmpNo();
	    ChatVO chat = new ChatVO();
	    
	    String crNo = service.selectRecentChat(chatuser);
	    if(crNo != null) {
	    	chat.setCrNo(crNo);
	    	List<ChatRoomDTLVO> chatRoomDtlList = chatService.selectRoomDetail(chat);
	    	log.info("chatRoomDtlList : {}", chatRoomDtlList);
	    	if (chatRoomDtlList != null) {
	    		for (int i = 0; i < chatRoomDtlList.size(); i++) {
	    			String roomCrNo = chatRoomDtlList.get(i).getCrNo();
	    			String userEmpNo = chatuser;
	    			String roomTitle = chatService.selectChatRoomTitle(roomCrNo, userEmpNo);
	    			log.info("roomTitle : {}", roomTitle);
	    			chatRoomDtlList.get(i).setCrcmTitle(roomTitle);
	    			log.info("chatRoomDtlList() 실행..! : {}", chatRoomDtlList);
	    		}
	    	}
	    	Map<String, Object> responseData = new HashMap<>();
	    	responseData.put("chatuser", chatuser);
	    	responseData.put("chatRoomDtlList", chatRoomDtlList);
	    	
	    	return new ResponseEntity<>(responseData, HttpStatus.OK);
	    }else {
	    	return new ResponseEntity<>(HttpStatus.NOT_FOUND);
	    }
	}
	
	// 유저 목록 가져올때
	@GetMapping(value = "/chatTilesUserList.do")
	@ResponseBody
	public List<EmpVO> chatTilesList() {
		log.info("chatTilesList() 실행");
	    CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    String chatuser = user.getEmp().getEmpName();
	    List<EmpVO> userList = service.selectChatUser(chatuser);
	    log.info("userList : {}",userList);
	    return userList;
	}
//	// 채팅방 목록 가져올때
//	@GetMapping(value = "/chatTilesList.do")
//	@ResponseBody
//	public List<chatSelectResultVO> chatTilesList() {
//		log.info("chatTilesList() 실행");
//		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
//		String chatuser = user.getEmp().getEmpName();
//		List<chatSelectResultVO> chatRoomList = service.selectChatRoom(chatuser);
//		return chatRoomList;
//	}
	
	@ResponseBody
	@PostMapping(value = "/chatIconDetail")
	public ResponseEntity<?> chatIconDetail(@RequestBody Map<String, String> requestMap){
		log.info("chatIconDetail() 실행...!");
		String empNo = requestMap.get("empNo");
		log.info("empNo : {}" , empNo);
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    String chatuser = user.getEmp().getEmpNo();
		ChatVO chat = new ChatVO();
		boolean chatRoomExists = chatService.checkChatRoomExists(empNo);
    	log.info("채팅방 존재 유무 확인 : {}",chatRoomExists);
    	if (chatRoomExists == false) {
    		// 채팅방이 존재하지 않는 경우 생성
    		log.info("createChatMyRoom() 실행...!");
    		service.createChatMyRoom(empNo, chatuser);
    		log.info("createchatMyMember() 실행...!");
    		service.createchatMyMember();
    		log.info("createChatMember() 실행...!");
    		service.createChatMember(empNo, chatuser);
    	}
    	String crNo = service.selectChatCrNo(empNo, chatuser);
		chat.setCrNo(crNo);
		List<ChatRoomDTLVO> chatRoomDtlList = chatService.selectRoomDetail(chat);
		log.info("chatRoomDtlList : {}" , chatRoomDtlList);
		if (chatRoomDtlList != null && !chatRoomDtlList.isEmpty()) {
		    for (int i = 0; i < chatRoomDtlList.size(); i++) {
		        String roomCrNo = chatRoomDtlList.get(i).getCrNo();
		        String userEmpNo = chatuser;
		        String roomTitle = chatService.selectChatRoomTitle(roomCrNo, userEmpNo);
		        log.info("roomTitle : {}", roomTitle);
		        chatRoomDtlList.get(i).setChatuser(chatuser);
		        chatRoomDtlList.get(i).setCrcmTitle(roomTitle);
		        log.info("chatRoomDtlList() 실행..! : {}", chatRoomDtlList);
		    }
		} else {
		    List<ChatRoomVO> chatRoomList = chatService.selectCrNoRoom(crNo);
		    log.info("chatRoomList() 실행..! : {}", chatRoomList);
		    if (chatRoomList != null) {
		        ChatRoomDTLVO chatRoomDtl = new ChatRoomDTLVO();
		        chatRoomDtl.setCrNo(crNo);
		        chatRoomDtl.setCrcmTitle(chatRoomList.get(0).getCrTitle());
		        chatRoomDtlList.add(chatRoomDtl); // 빈 리스트에 아이템 추가
		    }
		}
		log.info("chatRoomDtlList()22222222 실행..! : {}",chatRoomDtlList);
		return new ResponseEntity<>(chatRoomDtlList,HttpStatus.OK);
		}
	
	
	@ResponseBody
	@PostMapping(value = "/searchChatAjax.do")
	public List<EmpVO> searchChatUsers(@RequestBody Map<String, String> requestData) {
	    String keyword = requestData.get("keyword");
		log.info("searchChatUsers() 실행...! : {}",keyword);
        return service.searchUsers(keyword);
    }
	
}


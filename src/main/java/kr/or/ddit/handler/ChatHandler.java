package kr.or.ddit.handler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.ddit.service.IChatService;
import kr.or.ddit.vo.ChatMemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ChatHandler extends TextWebSocketHandler{
	// 웹 소켓 세션을 저장할 리스트 생성
	private List<WebSocketSession> sessionList = new ArrayList<WebSocketSession>();
	
	@Inject
	private IChatService chatservice;
	
	// 클라이언트와 연결된 경우
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		sessionList.add(session);
		log.info("{} 연결됨", session.getId());
		log.info("채팅방 입장자 : " + session.getPrincipal().getName());
	}
	// 웹 소켓 서버로 데이터를 전송했을 경우
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
	    String payload = message.getPayload();
	    
	    // JSON 문자열을 파싱하여 JSON 객체로 변환
	    ObjectMapper objectMapper = new ObjectMapper();
	    JsonNode jsonNode = objectMapper.readTree(payload);
	    
	    String msg = jsonNode.get("message").asText();
	    String crNo = jsonNode.get("crNo").asText();
	    
	    
	    log.info("WebSocket 메시지 수신 - 메시지: {}, crNo: {}", msg, crNo);

	    chatservice.insertChatting(msg, crNo, session.getPrincipal().getName());
	    
	    log.info("msg : " + msg + "crNo : " + crNo + "session.getPrincipal().getName()" + session.getPrincipal().getName());
	    // 브로드캐스트할 메시지를 JSON 객체로 만들기
	    Map<String, String> broadcastMessage = new HashMap<>();
	    broadcastMessage.put("message", msg);
	    broadcastMessage.put("crNo", crNo);
	    String sender = session.getPrincipal().getName();
	    broadcastMessage.put("sender", sender);
	    String senderPhoto = chatservice.selectSenderEmpPhoto(sender);
	    broadcastMessage.put("photo", senderPhoto);
	    log.info("broadcastMessage : {}" , broadcastMessage);
	    
	    // JSON 객체를 문자열로 변환
	    String broadcastPayload = objectMapper.writeValueAsString(broadcastMessage);
	    log.info("broadcastPayload : {}" , broadcastPayload);
	    // 모든 WebSocket 세션에 브로드캐스트 메시지를 보내기
	    // 모든이 아닌 같은 방에 있는사람에게만 뿌려주자
	    for (WebSocketSession sess : sessionList) {
	        if (sess.isOpen()) {
	        	String chatUser = sess.getPrincipal().getName();
	        	log.info("chatUser : {} ", chatUser);
	        	List<ChatMemberVO> chatmemberList = chatservice.selectCrNoUser(crNo);
	        	for (int i = 0; i < chatmemberList.size(); i++) {
	        		ChatMemberVO chatMember = chatmemberList.get(i);
	        		log.info("chatMember : {}", chatMember);
	        		if(chatMember.getEmpNo().equals(chatUser)) {
	        			log.info("broadcastPayload22222 : {}" , broadcastPayload);
	        			sess.sendMessage(new TextMessage(broadcastPayload));
	        		}
	        	}
	        }
	    }
	}
	// 연결이 끊어진 경우
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		// List 삭제
		sessionList.remove(session);
		log.info("{} 연결 끊김." , session.getId());
		log.info("채팅방 퇴장 : {}" , session.getPrincipal().getName());
	}
	
}

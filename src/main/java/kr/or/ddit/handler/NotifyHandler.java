package kr.or.ddit.handler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import kr.or.ddit.mapper.AdminEmpMapper;
import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.mapper.NotifyMapper;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.NotifyVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class NotifyHandler extends TextWebSocketHandler {

	@Inject
	private EmpMapper empMapper;
	@Inject
	private AdminEmpMapper adminEmpMapper;
	@Inject
	private NotifyMapper notiMapper;

	// 세션에 접속한 인원들의 아이디를 키값으로 세션 정보 담기위한 맵
	Map<String, WebSocketSession> userSessionMap = new HashMap<String, WebSocketSession>();

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception { // 소켓 연결
		log.info("afterConnectionEstablished 실행...! 웹소켓 연결 성공 session 확인" + session.getId());
		// 세션 접속 인원 리스트에 담기
		String senderId = session.getPrincipal().getName();
		log.info("senderId : " + senderId);
		// 로그인한 사람의 정보 맵에 아이디를 키로 세션 정보 담기
		userSessionMap.put(senderId, session);
		log.info("현재 접속자 수 {}", userSessionMap.size());
		log.info("userSessionMap : " + userSessionMap.get(senderId));

		super.afterConnectionEstablished(session);
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception { // 소켓에 들어오는 메세지를
																										// 처리
		log.info("메세지 들어오는 지 확인 : " + "소켓" + session + "  , 메세지 : " + message);

		log.info("message.getPayload().toString() : " + message.getPayload().toString());
		// 메세지를 스트링으로 변환
		String receiveMessage = message.getPayload().toString();
		String subTitle="";
		String[] typeSave = receiveMessage.split(",");
		// 알림 타입을 추출 
		String notiType = typeSave[0];
		
		// 메세지가 일정일 경우
		if (notiType.equals("일정")) {
			String[] ArrMessage = receiveMessage.split(",");
			String msg = ArrMessage[1];
			TextMessage tmpMsg = new TextMessage("회사일정(" + msg + ")이 추가되었습니다.");
			
			
			if(msg.length()>18) {
				subTitle = msg.substring(0,14);
				subTitle +="...";
				tmpMsg = new TextMessage("회사일정(" + subTitle + ")이 추가되었습니다.");
			}
			
			// 회사일정은 전체 사원을 조회하여 확인한다.
			List<EmpVO> empList = adminEmpMapper.selectWorkEmp();
			
			for (int i = 0; i < empList.size(); i++) {
				
				
				log.info("여기가 돌아가는지 확인 " + empList);
				if (empList.get(i).getNotiList() != null && empList.get(i).getNotiList().contains("일정")) {
					
					String empNo = empList.get(i).getEmpNo();

					System.out.println("empList.get(i).getEmpNo()) 확인 : " + empNo);
					
					// 알림을 받기로 설정되어있다면 알림 리스트 insert
					insertNotiList(empNo,tmpMsg.getPayload(),"일정");
					if (userSessionMap.containsKey(empNo)) {
						// 메세지 전송
						userSessionMap.get(empNo).sendMessage(tmpMsg);
					}
				} else {
					continue;
				}
			}

		} else if (notiType.equals("결재")) {
			TextMessage tmpMsg = new TextMessage("결재 문서가 도착하였습니다.");
			// 결재,A0110123131,A0101321.. 이런형태를 잘라서 배열에 담는다
			String[] receiver = receiveMessage.split(",");

			for (int i = 1; i < receiver.length; i++) {
				// 어떤 알림을 받을지 설정 여부 확인
				String empNo = receiver[i];
				EmpVO empVO = empMapper.readByUserId(empNo);
				System.out.println("empVO : " + empVO);
				// empVO 안에 결재 알림을 받을 설정이 되어있다면
				if (empVO.getNotiList() != null && empVO.getNotiList().contains("결재")) {
					
					// 알림을 받기로 설정되어있다면 알림 리스트 insert
					insertNotiList(empNo,tmpMsg.getPayload(),"결재");
					// 로그인한 세션갑에서 아이디를 찾아 메세지를 보내준다.
					if (userSessionMap.containsKey(receiver[i])) {
						userSessionMap.get(receiver[i]).sendMessage(tmpMsg);
					} else {
						continue;
					}
				}
			}

		} else if (notiType.equals("참조")) {
			TextMessage tmpMsg = new TextMessage("결재 참조문서가 도착하였습니다.");
			// 참조,A0110123131,A0101321.. 이런형태를 잘라서 배열에 담는다
			String[] receiver = receiveMessage.split(",");
			for (int i = 1; i < receiver.length; i++) {
				// 어떤 알림을 받을지 설정 여부 확인
				String empNo = receiver[i];
				EmpVO empVO = empMapper.readByUserId(empNo);
				log.debug("참조에서 empVO  : {}", empVO);
				// empVO 안에 결재 알림을 받을 설정이 되어있다면
				if (empVO.getNotiList() != null && empVO.getNotiList().contains("참조")) {
					
					// 알림을 받기로 설정되어있다면 알림 리스트 insert
					insertNotiList(empNo,tmpMsg.getPayload(),"참조");
					
					// 로그인한 세션갑에서 아이디를 찾아 메세지를 보내준다.
					if (userSessionMap.containsKey(receiver[i])) {
						userSessionMap.get(receiver[i]).sendMessage(tmpMsg);
					} else {
						continue;
					}
				}
			}

		} else if (notiType.equals("업무")) {
			String[] receiver = receiveMessage.split(",");
			String taskTitle = receiver[1];

			TextMessage tmpMsg = new TextMessage("업무 요청(" + taskTitle + ")이 도착하였습니다.");
			
			if(taskTitle.length()>18) {
				subTitle = taskTitle.substring(0,14);
				subTitle +="...";
				tmpMsg = new TextMessage("업무 요청(" + subTitle + ")이 도착하였습니다.");
			}
			
			for (int i = 2; i < receiver.length; i++) {
				
				// 어떤 알림을 받을지 설정 여부 확인
				String empNo = receiver[i];
				EmpVO empVO = empMapper.readByUserId(empNo);
				System.out.println("업무에서 empVO  : " + empVO);
				
				// empVO 안에 결재 알림을 받을 설정이 되어있다면
				if (empVO.getNotiList() != null && empVO.getNotiList().contains("업무")) {
					
					// 알림을 받기로 설정되어있다면 알림 리스트 insert
					insertNotiList(empNo,tmpMsg.getPayload(),"업무");
					
					// 로그인한 세션갑에서 아이디를 찾아 메세지를 보내준다.
					if (userSessionMap.containsKey(receiver[i])) {
						userSessionMap.get(receiver[i]).sendMessage(tmpMsg);
					} else {
						continue;
					}
				}
			}

		} else if (receiveMessage.contains("메일") && !receiveMessage.contains("ref")) {

			String[] receiver = receiveMessage.split(",");
			String mailTitle = receiver[1];

			TextMessage tmpMsg = new TextMessage("메일(" + mailTitle + ")이 도착하였습니다.");
			
			if(mailTitle.length()>18) {
				subTitle = mailTitle.substring(0,14);
				subTitle +="...";
				tmpMsg = new TextMessage("메일(" + subTitle + ")이 도착하였습니다.");
			}
			
			for (int i = 2; i < receiver.length; i++) {
				// 어떤 알림을 받을지 설정 여부 확인
				String empNo = receiver[i];
				EmpVO empVO = empMapper.readByUserId(empNo);
				System.out.println("메일에서 empVO  : " + empVO);
				// empVO 안에 결재 알림을 받을 설정이 되어있다면
				if (empVO.getNotiList() != null && empVO.getNotiList().contains("메일")) {
					
					// 알림을 받기로 설정되어있다면 알림 리스트 insert
					insertNotiList(empNo,tmpMsg.getPayload(),"메일");
					
					// 로그인한 세션갑에서 아이디를 찾아 메세지를 보내준다.
					if (userSessionMap.containsKey(receiver[i])) {
						userSessionMap.get(receiver[i]).sendMessage(tmpMsg);
					} else {
						continue;
					}
				}
			}

		} else if (receiveMessage.contains("메일") && receiveMessage.contains("ref")) {
			String[] receiver = receiveMessage.split(",");
			String mailTitle = receiver[1];

			int idx = receiveMessage.indexOf("ref");
			String mailList = receiveMessage.substring(0, idx);
			String refList = receiveMessage.substring(idx);
			log.info("mailList:{}", mailList);
			log.info("refList:{}", refList);
			String[] mailNotiReceiver = mailList.split(",");
			String[] refNotirReceiver = refList.split(",");

			TextMessage tmpMsg = new TextMessage("메일(" + mailTitle + ")이 도착하였습니다.");
			TextMessage tmpMsgRef = new TextMessage("참조 메일(" + mailTitle + ")이 도착하였습니다.");
			if(mailTitle.length()>18) {
				subTitle = mailTitle.substring(0,14);
				subTitle +="...";
				tmpMsg = new TextMessage("메일((" + subTitle + ")이 도착하였습니다.");
				tmpMsgRef = new TextMessage("참조 메일(" + subTitle + ")이 도착하였습니다.");
			}
			
			
			
			for (int i = 2; i < mailNotiReceiver.length; i++) {
				// 어떤 알림을 받을지 설정 여부 확인
				String empNo = mailNotiReceiver[i];
				EmpVO empVO = empMapper.readByUserId(empNo);
				System.out.println("메일에서 empVO  : " + empVO);
				// empVO 안에 결재 알림을 받을 설정이 되어있다면
				if (empVO.getNotiList() != null && empVO.getNotiList().contains("메일")) {
					
					// 알림을 받기로 설정되어있다면 알림 리스트 insert
					insertNotiList(empNo,tmpMsg.getPayload(),"메일");
					
					// 로그인한 세션갑에서 아이디를 찾아 메세지를 보내준다.
					if (userSessionMap.containsKey(empNo)) {
						userSessionMap.get(empNo).sendMessage(tmpMsg);
					} else {
						continue;
					}
				}
			}

			for (int i = 1; i < refNotirReceiver.length; i++) {
				
				String empNo = refNotirReceiver[i];
				EmpVO empVO = empMapper.readByUserId(empNo);
				System.out.println("메일에서 empVO  : " + empVO);
				// empVO 안에 결재 알림을 받을 설정이 되어있다면
				if (empVO.getNotiList() != null && empVO.getNotiList().contains("메일")) {
					
					// 알림을 받기로 설정되어있다면 알림 리스트 insert
					insertNotiList(empNo,tmpMsgRef.getPayload(),"메일");
					
					// 로그인한 세션갑에서 아이디를 찾아 메세지를 보내준다.
					if (userSessionMap.containsKey(empNo)) {
						userSessionMap.get(empNo).sendMessage(tmpMsgRef);
					} else {
						continue;
					}
				}
			}

		}else if(notiType.equals("freeBoard")) {
			
			String[] receiver = receiveMessage.split(",");
			String freetitle = receiver[1];

			TextMessage tmpMsg = new TextMessage("자유게시판(" + freetitle + ")에 댓글이 작성되었습니다.");
			
			if(freetitle.length()>18) {
				subTitle = freetitle.substring(0,14);
				subTitle +="...";
				tmpMsg = new TextMessage("자유게시판(" + subTitle + ")에 댓글이 작성되었습니다.");
			}
			
			for (int i = 2; i < receiver.length; i++) {
				// 어떤 알림을 받을지 설정 여부 확인
				String empNo = receiver[i];
				EmpVO empVO = empMapper.readByUserId(empNo);
				System.out.println("자유게시판에서  empVO  : " + empVO);
				// empVO 안에 결재 알림을 받을 설정이 되어있다면
				if (empVO.getNotiList() != null && empVO.getNotiList().contains("댓글")) {
					
					// 알림을 받기로 설정되어있다면 알림 리스트 insert
					insertNotiList(empNo,tmpMsg.getPayload(),"댓글");
					
					// 로그인한 세션갑에서 아이디를 찾아 메세지를 보내준다.
					if (userSessionMap.containsKey(receiver[i])) {
						userSessionMap.get(receiver[i]).sendMessage(tmpMsg);
					} else {
						continue;
					}
				}
			}
			
		}else if(notiType.equals("fevnetBoard")) {
			
			String[] receiver = receiveMessage.split(",");
			String feventTitle = receiver[1];

			TextMessage tmpMsg = new TextMessage("경조사게시판(" + feventTitle + ")에 댓글이 작성되었습니다.");

			if(feventTitle.length()>18) {
				subTitle = feventTitle.substring(0,14);
				subTitle +="...";
				tmpMsg = new TextMessage("경조사게시판(" + subTitle + ")에 댓글이 작성되었습니다.");
			}
			
			
			for (int i = 2; i < receiver.length; i++) {
				
				// 어떤 알림을 받을지 설정 여부 확인
				String empNo = receiver[i];
				EmpVO empVO = empMapper.readByUserId(empNo);
				System.out.println("자유게시판에서  empVO  : " + empVO);
				// empVO 안에 결재 알림을 받을 설정이 되어있다면
				if (empVO.getNotiList() != null && empVO.getNotiList().contains("댓글")) {
					
					// 알림을 받기로 설정되어있다면 알림 리스트 insert
					insertNotiList(empNo,tmpMsg.getPayload(),"댓글");
					
					// 로그인한 세션갑에서 아이디를 찾아 메세지를 보내준다.
					if (userSessionMap.containsKey(receiver[i])) {
						userSessionMap.get(receiver[i]).sendMessage(tmpMsg);
					} else {
						continue;
					}
				}
			}
			
		}else if(notiType.equals("clubBoard")) {
			
			String[] receiver = receiveMessage.split(",");
			String clubBoardTitle = receiver[1];

			TextMessage tmpMsg = new TextMessage("동호회게시판(" + clubBoardTitle + ")에 댓글이 작성되었습니다.");
			
			if(clubBoardTitle.length()>18) {
				subTitle = clubBoardTitle.substring(0,14);
				subTitle +="...";
				tmpMsg = new TextMessage("동호회게시판(" + subTitle + ")에 댓글이 작성되었습니다.");
			}
			
			for (int i = 2; i < receiver.length; i++) {
				
				// 어떤 알림을 받을지 설정 여부 확인
				String empNo = receiver[i];
				EmpVO empVO = empMapper.readByUserId(empNo);
				System.out.println("동호회게시판에서  empVO  : " + empVO);
				// empVO 안에 결재 알림을 받을 설정이 되어있다면
				if (empVO.getNotiList() != null && empVO.getNotiList().contains("댓글")) {
					
					// 알림을 받기로 설정되어있다면 알림 리스트 insert
					insertNotiList(empNo,tmpMsg.getPayload(),"댓글");
					
					// 로그인한 세션갑에서 아이디를 찾아 메세지를 보내준다.
					if (userSessionMap.containsKey(receiver[i])) {
						userSessionMap.get(receiver[i]).sendMessage(tmpMsg);
					} else {
						continue;
					}
				}
			}
			
		}

		super.handleTextMessage(session, message);
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception { // 소켓 연결 종료
		log.info("소켓 연결 종료...!");
		super.afterConnectionClosed(session, status);
	}
	/**
	 * 파라미터를 받아 notifyVO에 정보를 담아 notify에 insert
	 * @param empNo 사번
	 * @param content notify에 저장될 알림 내용
	 * @param notifyTypese notify에 저장될 알림 타입 
	 */
	public void insertNotiList (String empNo, String content, String notifyTypese) {
		
		NotifyVO notifyVO = new NotifyVO();
		
		//DB에 넣기전에 notifyVO 값 셋팅
		notifyVO.setNotifyEmpno(empNo);
		notifyVO.setNotifyContent(content);
		notifyVO.setNotifyTypese(notifyTypese);
		//DB에 인서트
		notiMapper.insertNotify(notifyVO);
		
	}

}

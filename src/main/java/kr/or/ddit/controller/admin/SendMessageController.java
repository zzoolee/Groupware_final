package kr.or.ddit.controller.admin;

import org.springframework.web.bind.annotation.PostMapping;

import kr.or.ddit.vo.EmpVO;
import lombok.extern.slf4j.Slf4j;
import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;

@Slf4j
public class SendMessageController {
	
	final DefaultMessageService messageService;
	
	
	public SendMessageController() {
		this.messageService = NurigoApp.INSTANCE.initialize("NCSVF6XRKROJEZBY", "XR4CY8TGOOUT6IRCICMF87WWCT8IFCMD", "https://api.coolsms.co.kr");
	}
	
	/**
     * 단일 메시지 발송 예제
     */
    public SingleMessageSentResponse sendOne(String empNo, String empHp) {
    	
    	log.info("메세지 컨트롤러에서 empHp"+ empHp);
    	String hp = empHp.replace("-", "");
        Message message = new Message();
        log.info("변환된 번호 확인");
        // 발신번호 및 수신번호는 반드시 01012345678 형태로 입력되어야 합니다.
        message.setFrom("01065737933");
        message.setTo(hp);
        message.setText("귀하의 사번은"+empNo+"이고, 초기 비밀번호는 생년월일6자리입니다");

        SingleMessageSentResponse response = this.messageService.sendOne(new SingleMessageSendingRequest(message));
        System.out.println(response);

        return response;
    }
	
}

package kr.or.ddit.service.impl;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.inject.Inject;
import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SendEmailService {
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월 dd일 HH:mm:ss");
	String date = sdf.format(new Date());
	
	@Inject
	private JavaMailSender emailSender;

	// 메일 세팅
	public MimeMessage setmeMessage(String empEmail, String empPw, String status)
			throws MessagingException, UnsupportedEncodingException {
		log.info("setmeMessage() 실행...!");
		// MimeMessage를 활용한 메세지 작성
		MimeMessage message = emailSender.createMimeMessage();
		// MimeMessageHelper를 이용한 메일 설정
		MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

		// 받는 사람 이메일
		helper.setTo(empEmail);
		if (status.equals("findPw")) {
			// set 메일 제목
			helper.setSubject("I-WORKS 비밀번호 찾기 결과입니다.");
			// 메일 내용 작성 메소드
			String emailContent = createEmailContentFindPw(empPw);
			// set 메일 내용
			helper.setText(emailContent, true);
		} else if (status.equals("authEmail")) {
			// set 메일 제목
			helper.setSubject("I-WORKS 이메일 인증번호 발송 메일입니다.");
			// 메일 내용 작성 메소드
			String emailContent = createEmailContentAuthEmail(empPw);
			// set 메일 내용
			helper.setText(emailContent, true);
		}

		helper.setFrom(new InternetAddress("dhkek567@gmail.com", "I-WORKS"));
		log.info("메일 작성 메세지 확인  >>> " + message);
		return message;
	}

	// 메일 내용 작성
	public String createEmailContentFindPw(String empPw) {
		log.info("createEmailContent() 실행...!");
		String content = "";
		
		content += "<div style='width:45em;'>";
		content += "<div class='modal-dialog' style='padding:5px;'>";
		content += "<div class='modal-content'>";
		content += "<div class='modal-header mt-5'>";
		content += "<p class='modal-title' id='tooltipModalLabel'><label style='color:blue; font-size:30px;'>I-WORKS</label> 회원정보</p>";
		content += "</div>";
		content += "<div class='modal-body'><br>";
		content += "<div style='font-size:30px;'><label style='color:green;'>임시비밀번호</label>가 발송되었습니다.</div>";
		content += "<hr/>";
		content += "<div style='font-weight:bold;'>임시비밀번호 : <label style='color:red'>"+empPw+"</label></div>";
		content += "<hr>";
		content += "<p>변경일시 : "+ date +"</p>";
		content += "<p>주의사항 : 변경 후 첫 로그인 시 반드시 비밀번호를 변경해주세요.</p>";
		content += "</div>";
		content += "<hr>";
		content += "<div style='font-size:13px;'>";
		content += "비밀번호를 변경한 적이 없는데 메일을 받았다면 다른 사람이 내 계정 정보를 알아내어 변경했을 수 있습니다.<br>";
		content += "비밀번호를 다시 설정하시고, 비밀번호가 변경된 수단이 안전한지도 함께 점검하여 주세요.";
		content += "</div></div></div></div>";

		// 최종적으로 보내줄 내용
		return content;
	}

	public String createEmailContentAuthEmail(String empPw) {
		log.info("createEmailContent() 실행...!");
		StringBuilder mailContent = new StringBuilder();
		String content = "";
			
		content += "<div style='width:45em;'>";
		content += "<div class='modal-dialog' style='padding:5px;'>";
		content += "<div class='modal-content'>";
		content += "<div class='modal-header mt-5'>";
		content += "<p class='modal-title' id='tooltipModalLabel'><label style='color:blue; font-size:30px;'>I-WORKS</label> 회원정보</p>";
		content += "</div>";
		content += "<div class='modal-body'><br>";
		content += "<div style='font-size:30px; font-weight:bold;'><label style='color:green;'>인증번호</label>가 발송되었습니다.</div>";
		content += "<hr/>";
		content += "<div style='font-weight:bold;'>인증번호 : <label style='color:red'>"+empPw+"</label></div>";
		content += "<hr>";
		content += "<p>발급일시 : "+date+"</p>";
		content += "<p>주의사항 : 인증번호를 정확히 기입하여 인증을 진행해주세요.</p>";
		content += "</div>";
		content += "<hr>";
		content += "<div style='font-size:13px;'>";
		content += " 인증번호를 정확히 확인하여 인증란에 기입하여 주시고, 오류 발생 시 관리자에게 문의해주세요.";
		content += "</div></div></div></div>";

		
		// 최종적으로 보내줄 내용
		mailContent.append(content);

		return mailContent.toString();
	}

}

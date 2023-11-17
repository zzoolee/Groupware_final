package kr.or.ddit.service.impl;

import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.UUID;

import javax.inject.Inject;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.apache.commons.lang.StringUtils;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.mapper.AdminEmpMapper;
import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.service.IEmpService;
import kr.or.ddit.vo.EmpVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class EmpService implements IEmpService {

	@Inject
	private EmpMapper empMapper;
	@Inject
	private AdminEmpMapper adminMapper;
	@Inject
	private PasswordEncoder pe;
	@Inject
	private JavaMailSender emailSender;
	@Inject
	private SendEmailService sendEmailService;
	

	public List<EmpVO> showDeptEmp(String deptCd) {
		return empMapper.selectDeptEmp(deptCd);
	}

	@Override
	public List<EmpVO> showEmpList() {
		return adminMapper.selectWorkEmp();
	}
	
	/**
	 * 비밀번호 찾기 사원정보 확인, 메일 발송 
	 */
	@Override
	public ServiceResult findPwCheck(EmpVO empVO) {
		
		log.info("findPwCheck() 실헹...! empNo  : "+ empVO.getEmpNo());
		log.info("findPwCheck() 실헹...! empEmail  : "+ empVO.getEmpEmail());
		ServiceResult result = null;
		String newPw = "";

		String selectEmpPw = empMapper.findPwCheck(empVO);
		if (StringUtils.isNotBlank(selectEmpPw)) {
			
			String randomUU = UUID.randomUUID().toString();
			newPw = randomUU.substring(0,8);
			log.info("새로 생성된 비밀번호 : " + newPw);
			String empPw = pe.encode(newPw);
			empVO.setEmpPw(empPw);
			int status = empMapper.updatePw(empVO);
			if (status != 0) {
				try {
					
					// 메일 내용 작성
					String empEmail = empVO.getEmpEmail();
					MimeMessage  message = sendEmailService.setmeMessage(empEmail, newPw, "findPw");
					// 메일 보내주기
					emailSender.send(message);
					result = ServiceResult.OK;
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		} else {
		
			result = ServiceResult.FAILED;
		}

		return result;
	}
	/**
	 * 이메일 인증 확인 메일 발송 
	 * @throws MessagingException 
	 * @throws UnsupportedEncodingException 
	 */
	@Override
	public void authNumberMail(String email, String rnd, String status) throws UnsupportedEncodingException, MessagingException {
		log.info("서비스 타는 지 확인 email : "+email);
		log.info("서비스 타는 지 확인  rnd : "+rnd);
		log.info("서비스 타는 지 확인 status : "+status);
		MimeMessage msg = sendEmailService.setmeMessage(email, rnd, status);
		emailSender.send(msg);
		
	}

	

	
}

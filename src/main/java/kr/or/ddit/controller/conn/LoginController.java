package kr.or.ddit.controller.conn;

import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.service.IEmpService;
import kr.or.ddit.vo.EmpVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class LoginController {
	
	@Inject
	private IEmpService service;
	
	@RequestMapping(value="/login", method = RequestMethod.GET) // 타겟 없는 경우 contextpath(/)로 간다 -> 보통 메인페이지
	public String signIn(String error, String logout, String message, Model model) { // 파라미터까지 필수(error, logout)
		
		log.info("message 넘어온다~~~~ " + message);
		
		if(error != null) {
			model.addAttribute("message", "아이디 또는 비밀번호가 잘못되었습니다.");
			// 다른 분기 처리 위해서는 커스텀 핸들러 필요
			// CustomLoginSuccessHandler : 로그인 성공했으나 거부하고 싶을 때 ex) 퇴사 직원
			// CustomAccessDeniedHandler : 로그인 성공했으나 접근 권한 없을 때
			// HttpServletRequest request 이용해서 session.invalidate(); 처리 후 에러 설정한 뒤 이쪽으로 보내서 메세지 뿌려주기
		}
		
		if(logout != null) {
			model.addAttribute("message", "정상적으로 로그아웃 되었습니다."); // logout으로 보내면 main에 쿼리스트링으로 붙음... ex) /login?logout
		}
		if(message != null) {
			model.addAttribute("message", "퇴사 처리된 사원입니다. 관리자에게 문의하세요."); 
		}
		
		return "conn/signin";
	}
	
//	@RequestMapping(value="/logout", method = RequestMethod.GET)
//	public String logoutForm() {
//		return "redirect:/main.do";
//	}
	
	@RequestMapping(value="/findpw.do", method = RequestMethod.GET)
	public String findPw() {
		return "conn/findpw";
	}
	
	@ResponseBody
	@RequestMapping(value = "/findPwSendEmail.do", produces = "text/plain; charset=utf-8")
	public String findPwSendEmail(@RequestBody Map<String, String> map) {
		String rstMessage = "";
		String empNo = map.get("empNo").toString();
		String empEmail = map.get("empEmail").toString();
		EmpVO empVO = new EmpVO();
		empVO.setEmpNo(empNo);
		empVO.setEmpEmail(empEmail);
		ServiceResult result = service.findPwCheck(empVO);
		if(result.equals(ServiceResult.OK)) {
			rstMessage = "ok";
		}else {
			rstMessage="fail";
		}
		
		return rstMessage;
	}
	
}

package kr.or.ddit.security;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.vo.EmpVO;

@Controller
public class CommonController {

	@RequestMapping(value="/accessError", method = RequestMethod.GET)
	public String accessDenied(HttpServletRequest request, Model model, RedirectAttributes ra) {
		String goPage = "";
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		EmpVO emp = user.getEmp();
		// emp.getEmpNo() = admin
//		ra.addFlashAttribute("message", "접근 권한이 없습니다!");
//		if(emp.getEmpNo().equals("admin")) {
//			goPage = "redirect:/adminmain.do";
//		}else {
//			goPage = "redirect:/";
//		}
//		HttpSession session = request.getSession();
//		session.invalidate();
		return "login/accessError";
//		return goPage;
	}
}

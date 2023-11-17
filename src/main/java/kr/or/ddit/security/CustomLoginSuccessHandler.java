package kr.or.ddit.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

	private RequestCache requestCache = new HttpSessionRequestCache();
 
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		log.info("onAuthenticationSuccess() 실행...!");
		
		CustomUser customUser = (CustomUser)authentication.getPrincipal();
		log.info("username : "+ customUser.getUsername());
		
		clearAuthenticationAttribute(request);
		
		SavedRequest savedRequest = requestCache.getRequest(request, response);
		
		String targetUrl = "";
		if(savedRequest != null) {
			targetUrl = savedRequest.getRedirectUrl();
		}
		
		if(customUser.getEmp().getEmpLoginse().equals("1")) {
			targetUrl = request.getContextPath()+"/";
		}else {
			String empNo = customUser.getEmp().getEmpNo();
			targetUrl = "/myInfoUpdateForm.do?empNo="+empNo;
		}
		
		if(customUser.getEmp().getEmpWorkse() == 0) {
			request.getSession().invalidate();
			targetUrl = "/login?message=0";
		}
		
		if(customUser.getEmp().getEmpNo().equals("admin")) {
			targetUrl = "/adminmain.do";
		}
		
		response.sendRedirect(targetUrl);
	}
	
	public void clearAuthenticationAttribute(HttpServletRequest req) {
		HttpSession session =  req.getSession();
		if(session == null) {
			return;
		}
		
		// SPRING_SECURITY_LAST_EXCEPTION 값
		session.removeAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);
	}
	
	
	
}

package kr.or.ddit.controller.mypage;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.controller.util.UploadFileUtils;
import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.service.IAdminEmpService;
import kr.or.ddit.service.IAttendService;
import kr.or.ddit.service.IEmpService;
import kr.or.ddit.service.IMypageService;
import kr.or.ddit.service.impl.SendEmailService;
import kr.or.ddit.vo.AyannVO;
import kr.or.ddit.vo.EmpVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MyInfoController {

	@Inject
	private IMypageService service;

	@Inject
	private IAdminEmpService adService;
	
	@Inject
	private IAttendService attendService;

	@Inject
	private PasswordEncoder passwordEncoder;

	@Inject
	private EmpMapper empMapper;
	
	@Inject
	private IEmpService empService;

	@Resource(name = "uploadPath")
	private String resourcePath;

	// 내정보 확인
	@RequestMapping(value = "/myinfo.do", method = RequestMethod.GET)
	public String myInfo(Authentication auth, Model model) {
		log.info("myInfo() 실행...!");

		CustomUser customUser = (CustomUser) auth.getPrincipal();

		log.info("customUser 정보 " + customUser);
		
		// 내정보에 연차를 넣어줄 연차VO에 연차값 세팅.
		AyannVO ayannList = new AyannVO();
		ayannList = attendService.selectThisYearAyannMyinfo();

		String empNo = customUser.getEmp().getEmpNo();
		EmpVO empVO = adService.selectOne(empNo);
		log.info("empVO selectOne 실행 : "+ empVO);
	
		if(empVO.getNotiList() !=null) {
			String[]notiList = empVO.getNotiList().split(",");
			model.addAttribute("notiList", notiList);
		}
		
		model.addAttribute("ayannList", ayannList);
		model.addAttribute("myInfo1", "myInfo1");
		model.addAttribute("myInfo", "myInfo");
		model.addAttribute("empVO", empVO);
		return "main/mypage/myinfo";
	}

	// 내정보 업데이트 페이지로 가기
	@RequestMapping(value = "/myInfoUpdateForm.do", method = RequestMethod.GET)
	public String myInfoUpdate(String empNo, Model model) {

		String rawPassword = "1234";
		log.info("1234의 인코드 : " + passwordEncoder.encode(rawPassword));

		EmpVO empVO = adService.selectOne(empNo);
		model.addAttribute("myInfo1", "myInfo1");
		model.addAttribute("myInfo", "myInfo");
		model.addAttribute("empVO", empVO);
		return "main/mypage/myinfoUpdate";
	}

	// 내정보 업데이트
	@PostMapping("/myinfoUpdate.do")
	public String myInfoUpdate(HttpServletRequest req, EmpVO empVO, Model model, RedirectAttributes ra) {

		String goPage = "";

		ServiceResult result = service.myInfoUpdate(req, empVO);
		if (result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "회원정보 수정이 완료 되었습니다.");
			goPage = "redirect:/myinfo.do";
		} else {
			goPage = "/myInfoUpdateForm.do";
		}

		return goPage;
	}

	// 비밀번호 확인
	@ResponseBody
	@PostMapping("/checkPw.do")
	public Map<String, String> pwCheck(@RequestBody Map<String, String> map) {

		String empNo = map.get("empNo").toString();
		String empPw = map.get("empPw").toString();
		log.info("수정에서 " + empNo);
		log.info("수정에서 " + empPw);
		EmpVO emp = new EmpVO();
		emp.setEmpNo(empNo);
		emp.setEmpPw(empPw);
		Map<String, String> hashMap = new HashMap<String, String>();
		hashMap = service.checkPw(emp);

		return hashMap;
	}

	// 회원정보 가져오기
	@ResponseBody
	@PostMapping("/forHeader")
	public EmpVO forHeader(Principal principal) {
		String empNo = principal.getName();

		EmpVO empVO = empMapper.readByUserId(empNo);
		log.info("forHeader->empVO" + empVO);

		return empVO;
	}

	// 이미지 미리보기
	@RequestMapping(value = "/thumnail.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	public ResponseEntity<String> uplaodAjax(MultipartFile file) throws IOException {
		log.info("uplaodAjax 실행...!");

		log.info("originalName : " + file.getOriginalFilename());

		String savedName = UploadFileUtils.uploadFile(resourcePath, file.getOriginalFilename(), file.getBytes());
		return new ResponseEntity<String>(savedName, HttpStatus.CREATED);

	}
	
	// 알림 리스트 업데이트
	@ResponseBody
	@PostMapping(value = "/updateNotiList.do", produces = "text/plain; charset=utf-8")
	public String updateNotiList (@RequestBody Map<String, List<String>> map) {
		log.info("넘어오는 데이터 확인 map : "+map);
		
		int status = service.updateNotiList(map);
		if(status >0) {
			return "성공";
		}else {
			return "실패";
			
		}
	}
	
	// 첫 회원 가입 시 메일 인증 받기 
	@ResponseBody
	@PostMapping("/authNumberMail.do")
	public int authNumberMail (@RequestBody Map<String, String> map) throws UnsupportedEncodingException, MessagingException {
		String status = "authEmail";
		String rnd = map.get("rnd");
		String email = map.get("email");
		log.info("rnd : " + rnd);
		log.info("email : " + email);
		
		empService.authNumberMail(email,rnd,status);
		
		
		return 1;
	}
	
}

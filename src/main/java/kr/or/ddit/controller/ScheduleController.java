package kr.or.ddit.controller;

import java.security.Principal;
import java.util.List;

import javax.inject.Inject;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.service.IScheService;
import kr.or.ddit.vo.ScheVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ScheduleController {
	
	@Inject
	private IScheService scheService;
	
	@RequestMapping(value="/schedule.do", method = RequestMethod.GET)
	public String calendar(Model model) { // 페이지 포워딩
		model.addAttribute("scheduleBar", "scheduleBar");
		return "main/schedule/calendar";
	}
	
	@RequestMapping(value="/admin/schedule.do", method = RequestMethod.GET)
	public String calendarAdmin(Model model) { // 페이지 포워딩(관리자)
		model.addAttribute("scheduleBar", "scheduleBar");
		return "main/schedule/calendarAdmin";
	}
	
	@ResponseBody // 없어도 될 순 있는데 스프링에서 처리해주었을 것이므로 로직상 문제있는 것 -> 그러니까 잊지말고 추가
	@RequestMapping(value="/schedule.do", method = RequestMethod.POST)
	public ResponseEntity<List<ScheVO>> showSchedule(@RequestBody ScheVO scheVO) { // 초기 데이터 요청
		log.info("캘린더 유형 설정 : " + scheVO.toString()); // 기본 모두 true(회사, 부서, 개인 일정 모두 보여주기)
		// 테스트
		// scheVO.setDeptSelect(false);
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		scheVO.setEmpNo(user.getEmp().getEmpNo());
		if(user.getEmp().getDeptCd() != null) { // 관리자가 아니라면 세팅
			scheVO.setDeptCd(user.getEmp().getDeptCd());
		}
		
		//scheVO.setDeptCd("A011");
		List<ScheVO> scheList = scheService.showSche(scheVO);
		for(ScheVO sche : scheList) {
			log.info("스케줄 리스트 : " + sche.toString());
		}
		
		ResponseEntity<List<ScheVO>> entity = new ResponseEntity<List<ScheVO>>(scheList, HttpStatus.OK);
		return entity;
	}
	
	@RequestMapping(value="/addschedule.do", method = RequestMethod.POST)
	public String addSchedule(ScheVO scheVO, Principal principal, RedirectAttributes ra) {
		String goPage = "";
		// 알림에 표시될 스케쥴 등록 넘어온 VO에서 제목을 가져온다. 
		String scheNoti = "일정,"+scheVO.getScTitle();
		
		scheVO.setEmpNo(principal.getName()); // Principal : 매개변수로 받아야하고 기본 정보만 있다.
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal(); // CustomUser : 객체 생성해서 바로 사용 가능하고 모든 정보 있다.
		log.info("로그인 아이디 부서 정보 : " + user.getEmp().getDeptCd());
		if(user.getEmp().getDeptCd() != null) { // 관리자가 아니라면 세팅
			scheVO.setDeptCd(user.getEmp().getDeptCd());
		}
		
		System.out.println("캘린더 scheVO 확인  : "+ scheVO);
		ServiceResult result = scheService.addSche(scheVO);
		
		
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("resultTitle", "일정 등록");
			ra.addFlashAttribute("resultMsg", "정상적으로 등록되었습니다.");
			
			if(principal.getName().equals("admin")) {
				ra.addFlashAttribute("redirectMessage", scheNoti);
				goPage = "redirect:/admin/schedule.do";
			}else {
				goPage = "redirect:/schedule.do";
			}
		}else {
			ra.addFlashAttribute("resultTitle", "일정등록");
			ra.addFlashAttribute("resultMsg", "일정 등록에 실패하였습니다.");
			goPage = "redirect:/";
		}
		
		return goPage;
	}
	
	@RequestMapping(value="/modifyschedule.do", method = RequestMethod.POST)
	public String modifySchedule(Principal principal, ScheVO scheVO, RedirectAttributes ra) {
		String goPage = "";
		
		scheService.modifySche(scheVO);
		ra.addFlashAttribute("resultTitle", "일정 수정");
		ra.addFlashAttribute("resultMsg", "정상적으로 수정되었습니다.");
		
		if(principal.getName().equals("admin")) {
			goPage = "redirect:/admin/schedule.do";
		}else {
			goPage = "redirect:/schedule.do";
		}
		
		return goPage;
	}
	
	@RequestMapping(value="/deleteschedule.do", method = RequestMethod.GET)
	public String deleteschedule(Principal principal, String scCd, RedirectAttributes ra) {
		String goPage = "";
		
		scheService.deleteSche(scCd);
		ra.addFlashAttribute("resultTitle", "일정 삭제");
		ra.addFlashAttribute("resultMsg", "정상적으로 삭제되었습니다.");
		
		if(principal.getName().equals("admin")) {
			goPage = "redirect:/admin/schedule.do";
		}else {
			goPage = "redirect:/schedule.do";
		}
		
		return goPage;
	}
	
	/////////////// 달력에서 클릭이벤트로 실행(ajax) ///////////////
	@RequestMapping(value="/modifysche.do", method = RequestMethod.POST)
	public ResponseEntity<String> modifySche(@RequestBody ScheVO scheVO) {
		log.info("ajax로 처리... : " + scheVO.toString());
		
		scheService.modifyScheDate(scheVO);
		ResponseEntity<String> entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		return entity;
	}
}

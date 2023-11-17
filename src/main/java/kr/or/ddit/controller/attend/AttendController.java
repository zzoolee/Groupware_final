package kr.or.ddit.controller.attend;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.service.IAttendService;
import kr.or.ddit.vo.AtStatusVO;
import kr.or.ddit.vo.AttendVO;
import kr.or.ddit.vo.AyannVO;
import kr.or.ddit.vo.DeptVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class AttendController {
	
	@Inject
	private IAttendService service;
	
	private void setAttendBar(Model model) {
	    String attendBar = "EXIST";
	    model.addAttribute("attendBar", attendBar);
	}
	
	private void setAttendBar1(Model model) {
	    String attendBar = "EXIST";
	    model.addAttribute("attendBar1", attendBar);
	}
	
	private void setAttendBar2(Model model) {
	    String attendBar = "EXIST";
	    model.addAttribute("attendBar2", attendBar);
	}
	
	private void setAttendBar3(Model model) {
	    String attendBar = "EXIST";
	    model.addAttribute("attendBar3", attendBar);
	}

	
	// 근무일정변경 로직수행
	@RequestMapping(value="/attendmain.do", method=RequestMethod.POST)
	public String AttendMainPost(RedirectAttributes ra, String atType) {
		
		AttendVO attendVO = new AttendVO();		
		attendVO.setAtType(atType);	
		attendVO.setAtWeek(service.selectTodayWeek());
		service.insertStartAttendC(attendVO);
		
		String message="["+atType+"]"+" 근무로 변경이 완료되었습니다.";
		
		ra.addFlashAttribute("mainMessage", message);
		
		return "redirect:/attendance.do";
	}
	
	
	
	// 출퇴근 현황조회로 이동
	@RequestMapping(value="/attendance.do", method=RequestMethod.GET)
	public String Attendance(Model model) throws ParseException {
		
		int percent = 0;
		AttendVO attendVO = new AttendVO();
		attendVO = service.selectTodayAttend(attendVO);
		
		
		List<AttendVO> attendThisWeekList = service.selectThisWeekAttend(attendVO);
		for(int i = 0; i < attendThisWeekList.size(); i++) {
			System.out.println("금주일한거 : "+attendThisWeekList.get(i).getAtStart());
		}

		AttendVO attendSum = new AttendVO();
		attendSum = service.sumThisWeekList(attendThisWeekList);
		
		// 셀렉트박스에 달정보를 넣어줄 로직.				
		AttendVO yearmonthCheck = new AttendVO();
		List<AttendVO> monthExist  = service.selectMonthExist(yearmonthCheck);
		AtStatusVO status = new AtStatusVO(); 
		status = service.selectAttendStatus(status);
		
		AttendVO getAttendPercent = new AttendVO();
		if(attendVO==null) {
			
		}else {
			if(attendVO.getAtStart()==null) {
			}else {
				// 프로그래스바의 차이를 가져와서 diff에 담아놓음.
				getAttendPercent = service.selectAttendPercent(getAttendPercent);
				// diff에 담긴 내용을 바탕으로 퍼센트를 뽑아냄.	
				percent = service.getPercent(getAttendPercent);
				System.out.println("인트로 받아낸 값 : "+percent);
			}
		}
		
		System.out.println(attendSum.getAtSum()+"/"+attendSum.getAtOverSum());
		
		model.addAttribute("percent", percent);
		model.addAttribute("status", status);
		model.addAttribute("monthExist", monthExist);
		model.addAttribute("attendSum", attendSum);
		model.addAttribute("attendVO", attendVO);
		setAttendBar1(model);
		setAttendBar(model);
		
		return "main/attend/attendance";
	}
	
	// 출퇴근 현황조회 로직수행
	@RequestMapping(value="/attendance.do", method=RequestMethod.POST)
	public String AttendancePost(RedirectAttributes ra, AttendVO attendVO) throws ParseException {
		log.info("출퇴근등록 POST 진입 : ");
		
		if(attendVO.getYearMonth()==null) {
			String message = service.insertStartAttend(attendVO);
			if(message!=null) {
				ra.addFlashAttribute("message", message);
			}
		}
		
		
		attendVO = service.selectTodayAttend(attendVO);
		
		List<AttendVO> attendThisWeekList = service.selectThisWeekAttend(attendVO);

		AttendVO attendSum = new AttendVO();
		attendSum = service.sumThisWeekList(attendThisWeekList);
		
		// 셀렉트박스에 달정보를 넣어줄 로직.				
		AttendVO yearmonthCheck = new AttendVO();
		List<AttendVO> monthExist  = service.selectMonthExist(yearmonthCheck);
		
		ra.addFlashAttribute("monthExist", monthExist);
		ra.addFlashAttribute("attendSum", attendSum);
		ra.addFlashAttribute("attendVO", attendVO);
		
		return "redirect:/attendance.do";
	}
	
	// 출퇴근 현황조회 로직수행
		@RequestMapping(value="/attendanceMain.do", method=RequestMethod.POST)
		public String AttendancePostMain(Model model, AttendVO attendVO) throws ParseException {
			log.info("출퇴근등록 POST 진입 : ");
			
			if(attendVO.getYearMonth()==null) {
				String message = service.insertStartAttend(attendVO);
				if(message!=null) {
					model.addAttribute("message", message);
				}
			}
			
		
			return "redirect:/";
		}
	
	// 월 근태데이터를 에이잭스로 넘겨주는 로직.
	@ResponseBody
	@RequestMapping(value="/attendanceAjax.do", method = RequestMethod.POST)
	public Map<String, List<AttendVO>> AttendanceAjax(@RequestBody Map<String, Object> param, Model model){
		System.out.println("에이젝스 시작");
		
		String yearMonth = (String)param.get("yearMonth");
		AttendVO attendVO = new AttendVO();
		attendVO.setYearMonth(yearMonth);
	
		System.out.println("몬쓰리스트 들어옴");
		List<AttendVO> monthList = new ArrayList<AttendVO>();
		List<AttendVO> weekList = new ArrayList<AttendVO>();
		monthList = service.selectMonthAttend(attendVO);
		weekList = service.selectWeek(attendVO);

		Map<String, List<AttendVO>> ajaxMap = new HashMap<String, List<AttendVO>>();
		
		for(int i = 0; i < monthList.size(); i++) {
			System.out.println("시작시간 : "+monthList.get(i).getAtStart());
			System.out.println("퇴근시간 : "+monthList.get(i).getAtEnd());
		
		}
		
		ajaxMap.put("monthList", monthList);
		ajaxMap.put("weekList", weekList);
		System.out.println("에이잭스 끝");
		return ajaxMap;	
	}
	
	
	// 주차 근태데이터를 에이잭스로 넘겨주는 로직.
	@ResponseBody
	@RequestMapping(value="/attendanceAjax2.do", method = RequestMethod.POST)
	public Map<String, List<AttendVO>> AttendanceAjax2(@RequestBody Map<String, Object> param, Model model) {
		System.out.println("에이잭스2 시작");
		List<AttendVO> weekAttendList = new ArrayList<AttendVO>();
		AttendVO weekAttend = new AttendVO();
		Map<String, List<AttendVO>> ajaxMap = new HashMap<String, List<AttendVO>>();
		
		String yearMonth = (String)param.get("yearMonth");
		if(param.get("weekData") != null) {
			String weekData = (String)param.get("weekData");
			int atWeek = Integer.parseInt(weekData);
			System.out.println("위크데이터 : "+weekData);
			weekAttend.setAtWeek(atWeek);
		}
		
		System.out.println("이어몬쓰 : "+yearMonth);
		weekAttend.setYearMonth(yearMonth);
		
		weekAttendList = service.selectWeekAttend(weekAttend);
		
		
		ajaxMap.put("weekAttendList", weekAttendList);
		
		return ajaxMap;
	}
	
	// 에이잭스로 근무상태를 바꿔주는 로직
	@RequestMapping(value="/updateAtStatus.do", method=RequestMethod.POST)
	public String AtStatusAjax(AtStatusVO atStatusVO,
			HttpServletRequest req, HttpServletResponse resp) {
		
		service.updateAttendStatus(atStatusVO);
		atStatusVO = service.selectAttendStatus(atStatusVO);
		System.out.println("여기보아라 : "+atStatusVO.getAtStatus());
		
		return "redirect:/attendance.do";
	}
	
	
	@RequestMapping(value="/updateAtStatus2.do", method=RequestMethod.POST)
	public String AtStatusAjax2(AtStatusVO atStatusVO,
			HttpServletRequest req, HttpServletResponse resp) {
		
		service.updateAttendStatus(atStatusVO);
		atStatusVO = service.selectAttendStatus(atStatusVO);
		System.out.println("여기보아라 : "+atStatusVO.getAtStatus());
		
		return "redirect:/";
	}
	
	
	// 근태현황으로 이동
	@RequestMapping(value="/attendsituation.do", method=RequestMethod.GET)
	public String AttendSituation(Model model) {
		
		AttendVO yearmonthCheck = new AttendVO();
		List<AttendVO> monthExist  = service.selectMonthExist(yearmonthCheck);
				
		model.addAttribute("monthExist", monthExist);
		
		setAttendBar(model);
		setAttendBar2(model);
		return "main/attend/attendSituation";
	}
	
	@RequestMapping(value="/POIAjax.do", method=RequestMethod.POST)
	public void POIAjax(HttpServletRequest req, HttpServletResponse response) throws IOException {
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("days", req.getParameter("days"));
		param.put("attendTime", req.getParameter("attendTime"));
		param.put("overTime", req.getParameter("overTime"));
		param.put("kindOfAttend", req.getParameter("kindOfAttend"));
		
		service.dbToExcel(param, response);
		
		Map<String, String> result = new HashMap<String, String>();
//		String message = "근태현황 엑셀자료 저장이 완료되었습니다.<br/>"
//				+ "저장경로 및 파일이름 : "+messagePart;
//		result.put("message", message);
	}
	
	// 관리자 포이
	@RequestMapping(value="/adminPOIForm.do")
	public void adminPOIForm(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("excelAtDate", req.getParameter("excelAtDate"));
		param.put("excelEmpNo", req.getParameter("excelEmpNo"));
		param.put("excelEmpName", req.getParameter("excelEmpName"));
		param.put("excelStartHour", req.getParameter("excelStartHour"));
		param.put("excelEndHour", req.getParameter("excelEndHour"));
		param.put("excelOvertime", req.getParameter("excelOvertime"));
		param.put("excelAtType", req.getParameter("excelAtType"));
		param.put("excelAtResult", req.getParameter("excelAtResult"));
		param.put("excelAtWeek", req.getParameter("excelAtWeek"));
		
		service.adminDBToExcel(param, resp);
	}
	
	
	
	
	//연차
	//연차
	//연차
	//연차
	//연차
	//연차
	//연차
	//연차
	// 연차리스트로 이동
	@RequestMapping(value="/ayannlist.do", method=RequestMethod.GET)
	public String AyannList(Model model) {
		
		Map<String, Object> ayannMap = new HashMap<String, Object>(); 
		ayannMap = service.ayannList();
		
		model.addAttribute("ayannMap", ayannMap);
		setAttendBar(model);
		setAttendBar3(model);
		return "main/attend/ayannList";
	}
	
	// 연차발생내역을 비동기로 바꿔 줄 ajax 컨트롤러
	@ResponseBody
	@RequestMapping(value="/selectYearAyann.do", method=RequestMethod.POST)
	public Map<String, Object> selectYearAyann(@RequestBody Map<String, Object> selectedYear) {
		
		Map<String, Object> ayannMap = new HashMap<String, Object>(); 
		ayannMap = service.selectYearAyann(selectedYear);
		
		return ayannMap;
	}
	
	// 연차사용내역을 비동기로 바꿔 줄 ajax 컨트롤러
	@ResponseBody
	@RequestMapping(value="/selectYearUsedAyann.do", method=RequestMethod.POST)
	public Map<String, Object> selectYearUsedAyann(@RequestBody Map<String, Object> selectedUsedYear) {
		
		Map<String, Object> ayannUsedMap = new HashMap<String, Object>(); 
		ayannUsedMap = service.selectYearUsedAyann(selectedUsedYear);
		
		return ayannUsedMap;
	}
	
	
	// 연차신청으로 이동
	@RequestMapping(value="/ayannapply.do", method=RequestMethod.GET)
	public String AyannApply(Model model) {
		
		setAttendBar(model);
		return "main/attend/ayannApply";
	}
	
	
	
	// 관리자
	// 관리자
	// 관리자
	// 관리자
	// 관리자
	// 관리자
	// 관리자
	// 관리자 근태
	@RequestMapping(value="/adminattend.do", method=RequestMethod.GET)
	public String adminAttend(Model model) {
		List<AttendVO> attendList = service.showAllAttendList();
		List<AttendVO> attendYear = service.selectAttendYearExistAll();
		model.addAttribute("attendYear", attendYear);
		model.addAttribute("attendList", attendList);
		setAttendBar(model);
		setAttendBar1(model);
		return "main/attend/adminAttend";
	}
	
	@RequestMapping(value="/adminattend.do", method=RequestMethod.POST)
	public String adminAttendPost(Model model, HttpServletRequest req, HttpServletResponse resp) throws ParseException {
		AttendVO attendVO = new AttendVO();
		String atDateStr = (req.getParameter("atDate"));
		log.info("값으로 날라온 atDate {} : ",atDateStr);
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM");
        Date date = dateFormat.parse(atDateStr);
        Date now = new Date();
        String nowStr = dateFormat.format(now);
        now = dateFormat.parse(nowStr);
        attendVO.setAtDate(date);
		List<AttendVO> attendList = service.showAllAttendList(attendVO);
		List<AttendVO> attendYear = service.selectAttendYearExistAll();
		if(now.equals(date)) {
			log.info("데이트 시간 : {}", date);
			log.info("나우 시간 : {}", now);
			log.info("시간이 같다.");
		}else {
			log.info("데이트 시간 : {}", date);
			log.info("나우 시간 : {}", now);
			log.info("시간이 다르다.");
			for(int i = 0; i < attendList.size(); i++) {
				attendList.get(i).setAtType("");
			}
		}
		model.addAttribute("atDateStr", atDateStr);
		model.addAttribute("attendYear", attendYear);
		model.addAttribute("attendList", attendList);
		setAttendBar(model);
		setAttendBar1(model);
		return "main/attend/adminAttend";
	}
	
	// 관리자연차
	@RequestMapping(value="/adminAyann.do", method=RequestMethod.GET)
	public String adminAyann(Model model,
			HttpServletRequest req, HttpServletResponse resp) {
		
		List<DeptVO> deptList = new ArrayList<DeptVO>();
		deptList = service.adminAyann();
		List<AyannVO> ayannList = service.selectAllAyannList();
		
		HttpSession session = req.getSession();
		String massage = "";
		if(session.getAttribute("massage")!=null) {
			massage = (String)session.getAttribute("massage");
			session.removeAttribute("massage");
		}
		
		model.addAttribute("massage", massage);
		model.addAttribute("ayannList", ayannList);
		model.addAttribute("deptList", deptList);
		setAttendBar(model);
		setAttendBar2(model);
		return "main/attend/adminAyann";
	}
	
//	@ResponseBody
//	@RequestMapping(value="/adminAyannAjax.do", method=RequestMethod.POST)
//	public Map<String, Object> adminAyannAjax(@RequestBody Map<String, String> deptNoData) {
//		System.out.println("부서별 어쭈구 도착.");
//		String deptNo = deptNoData.get("deptNo");
//		Map<String, Object> ajaxMap = new HashMap<String, Object>();
//		List<AyannVO> ayannList = new ArrayList<AyannVO>();
//		ayannList = service.adminAyannAjax(deptNo);
//		ajaxMap.put("ayannList", ayannList);
//		return ajaxMap;
//	}
	
	
	@RequestMapping(value="/insertAllAyannBtn.do", method=RequestMethod.GET)
	public String insertAllAyannBtn(
			HttpServletRequest req, HttpServletResponse resp) {
		service.insertAllAyannBtn();
		HttpSession session = req.getSession();
		String massage = "일괄 연차부여가 완료되었습니다";
		session.setAttribute("massage", massage);
		return "redirect:/adminAyann.do";
	}
	
	@RequestMapping(value="/ayannMailAllBtn.do", method=RequestMethod.GET)
	public String ayannMailAllBtn(
			HttpServletRequest req, HttpServletResponse resp) {
		service.ayannMailAllBtn();
		HttpSession session = req.getSession();
		String massage = "연차촉진 메일 발송이 완료되었습니다";
		session.setAttribute("massage", massage);
		return "redirect:/adminAyann.do";
	}
	
	@RequestMapping(value="/ayannUpdate.do", method=RequestMethod.POST)
	public String ayannUpdate(AyannVO ayannVO, 
			HttpServletRequest req, HttpServletResponse resp) {
		service.ayannUpdate(ayannVO);
		HttpSession session = req.getSession();
		String massage = "연차수정이 완료되었습니다";
		session.setAttribute("massage", massage);
		return "redirect:/adminAyann.do";
	}
	
	@ResponseBody
	@RequestMapping(value="/selectAdminAjaxAttend.do", method=RequestMethod.POST)
	public Map<String, Object> selectAdminAjaxAttend(
			@RequestBody Map<String, String> param) {
		Map<String, Object> ajaxMap = new HashMap<String, Object>();
		ajaxMap = service.selectAdminAjaxAttend(param);
		// attendList(월별 근무 전체에 해당하는 데이터가 "attendList" attendList 형태로들어감
		return ajaxMap;
	}
	
	@RequestMapping(value="/adminChart.do", method=RequestMethod.GET)
	public String adminChart(Model model){
		
		Map<String, Object> chartMap = new HashMap<String, Object>();
		Map<String, Object> ajaxMap = new HashMap<String, Object>();
		
		chartMap = service.adminChart();
		
		ajaxMap = service.chart2select1Ajax();
		
		
//		chartMap.put("empCount", empCount);
//		chartMap.put("workCount", workCount);
//		chartMap.put("basic", basic);
//		chartMap.put("yuyeonA", yuyeonA);
//		chartMap.put("yuyeonB", yuyeonB);
//		chartMap.put("atHome", atHome);
//		chartMap.put("yearList", yearList);
		model.addAttribute("chartMap", chartMap);
		model.addAttribute("ajaxMap", ajaxMap);
		
		return "main/attend/adminChart";
	}
	
	@RequestMapping(value="/chart1select1Ajax.do", method=RequestMethod.POST)
	public Map<String, Object> chart1select1Ajax(Map<String, String> param){
		
		Map<String, Object> ajaxMap = new HashMap<String, Object>();
		
		return ajaxMap;
	}
	
	@RequestMapping(value="/chart2select1Ajax.do", method=RequestMethod.POST)
	public Map<String, Object> chart2select1Ajax() {
		
		Map<String, Object> ajaxMap = new HashMap<String, Object>();
		
		ajaxMap = service.chart2select1Ajax();
		
		return ajaxMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/chart3select1Ajax.do", method=RequestMethod.POST)
	public Map<String, Object> chart3select1Ajax(@RequestBody Map<String, String> param) {
		
		Map<String, Object> ajaxMap = new HashMap<String, Object>();
		
		// chartAjax.put("chartRes", chartRes);
		ajaxMap = service.chart3select1Ajax(param);
		
		return ajaxMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/chart4select1Ajax.do", method=RequestMethod.POST)
	public Map<String, Object> chart4select1Ajax(@RequestBody Map<String, String> param) {
		
		Map<String, Object> ajaxMap = new HashMap<String, Object>();
		
		// chartAjax.put("chartRes", chartRes);
		ajaxMap = service.chart4select1Ajax(param);
		
		return ajaxMap;
	}
	
	
	
}

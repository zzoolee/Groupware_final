package kr.or.ddit.controller.admin;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.service.IAdminEmpService;
import kr.or.ddit.service.IAttendService;
import kr.or.ddit.vo.EmpVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class AdminEmpController {

	@Inject
	private IAdminEmpService service;

	@Inject
	private IAttendService attendService;
	


	// 직원관리 > 계정조회
	@GetMapping("/adminEmpList.do")
	public String adminEmpList(Model model) {

		List<EmpVO> empList = service.selectList();
		model.addAttribute("empList", empList);
		model.addAttribute("empBar1", "empBar1");
		model.addAttribute("empBar", "empBar");
		
		return "main/admin/adminAccount/empList";
	}

	// 직원 디테일 조회
	@GetMapping("/adminEmpSelect.do")
	public String adminEmpSelect(String empNo, Model model, String msg) {
		log.info("selectOne >>>>>>empNo >>>> : " + empNo);
		EmpVO empVO = service.selectOne(empNo);
		log.info("empVO를 제대로 가져오는가>>> " + empVO);

		if (msg != null) {
			model.addAttribute("status", "u");
		}

		model.addAttribute("empVO", empVO);
		return "main/admin/adminAccount/empDetail";
	}

	// 직원 정보 업데이트
	@PostMapping("/empUpdate.do")
	public String empUpdate(EmpVO empVO, Model model, RedirectAttributes ra) {

		ServiceResult result = null;

		result = service.empUpdate(empVO);
		if (result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "회원 정보를 업데이트하였습니다.");

		} else {
			ra.addFlashAttribute("message", "서버에러, 다시 시도해주세요!");
		}

		return "redirect:/adminEmpSelect.do?empNo=" + empVO.getEmpNo();
	}

	// 직원관리 > 계정등록
	@GetMapping("/adminEmpRegister.do")
	public String adminEmpRegister(Model model) {
		model.addAttribute("empBar2", "empBar2");
		model.addAttribute("empBar", "empBar");
		return "main/admin/adminAccount/empRegister";
	}

	// 개별 직원등록
	@PostMapping("/adminEmpRegisterSingle.do")
	public String adminEmpRegisterSingle(Model model, EmpVO empVO, RedirectAttributes ra) {
		
		log.info("adminEmpRegisterSingle 실행 확인... ! : "+ empVO);
		int result = service.insertEmp(empVO);

		if (result != 0) {
			ra.addFlashAttribute("message", "계정 생성에 성공하였습니다!");
			return "redirect:/adminEmpList.do";
		} else {
			ra.addFlashAttribute("message", "계정 생성에 실패하였습니다...");
			return "main/admin/adminAccount/empRegister";
		}

	}

	// poi를 활용한 다수 직원 등록
	@PostMapping("/uploadExcel.do")
	public String uploadExcel(HttpServletRequest req, @RequestParam("empExcel") MultipartFile multipartFile,
			RedirectAttributes ra) throws ParseException {

		String goPage = "";
		int cnt = service.insertEmpPoi(req, multipartFile);
		
		if(cnt>0) {
			ra.addFlashAttribute("message", cnt+"명 계정 생성 성공!");
			goPage = "redirect:/adminEmpList.do";
		}else {
			ra.addFlashAttribute("message", "파일업로드 실패...!");
			goPage = "redirect:/";
		}
		
		
		
		return goPage;
	}

	// 직원 재직여부 변경
	@PostMapping("/empWorkseUpdate.do")
	public String empWorkseUpdate(String[] empWorkse, Model model, RedirectAttributes ra) {
		log.info("empWorkseUpdate 실행...! : "+empWorkse.toString());
		ServiceResult result = service.empWorkseUpdate(empWorkse);

		if (result.equals(ServiceResult.FAILED)) {
			ra.addFlashAttribute("message", "서버에러, 다시 시도해주세요!");
		}

		return "redirect:/adminEmpList.do";
	}

	// 직원관리 > 서류관리
	@GetMapping("/docmanage.do")
	public String docmanage(Model model) {
		List<EmpVO> empList = service.selectList();
		model.addAttribute("empList", empList);
		model.addAttribute("attendBar3", "attendBar3");
		model.addAttribute("attendBar", "attendBar");

		return "main/admin/adminemp/docmanage";
	}

	// 급여 명세서 업로드
	@PostMapping("/uploadPayFile.do")
	public String uploadPayFile(HttpServletRequest req, @RequestParam("empExcel") MultipartFile multipartFile,
			RedirectAttributes ra) throws ParseException {
		String goPage = "";
		ServiceResult result = service.uploadPayFile(req, multipartFile);
		
		
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "등록 성공!");
			goPage = "redirect:/docmanage.do";
		}else {
			ra.addFlashAttribute("message", "파일업로드 실패...!");
			goPage = "redirect:/";
		}
		
		return goPage;

	}
	
	//가장 최근 급여명세서 가져오기
	@ResponseBody
	@PostMapping(value = "/selectRecentPaystub.do", produces="text/plain; charset=utf-8")
	public String selectRecentPaystub (@RequestBody Map<String, String> map) {
		String empNo = map.get("empNo");
		
		String salNo = service.selectRecentPaystub(empNo);
		
		return salNo;
	}
}

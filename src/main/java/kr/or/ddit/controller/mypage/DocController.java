package kr.or.ddit.controller.mypage;

import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.mapper.DocMapper;
import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.service.IDocService;
import kr.or.ddit.vo.DocHistoryVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.SalaryVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class DocController {

	@Inject
	EmpMapper empMapper;
	@Inject
	DocMapper docMapper;
	@Inject
	IDocService docService;
	SimpleDateFormat sdf = new SimpleDateFormat("yy/MM");
	
	// 증명서 출력
	@RequestMapping(value = "/dochistory.do", method = RequestMethod.GET)
	public String docHistory(Principal principal, Model model) {
		String empNo = principal.getName();
		EmpVO empVO = empMapper.readByUserId(empNo);
		
		// 명세서 지급 내역(empNo : 발급받은 사람)
		List<DocHistoryVO> docSalList = docMapper.selectDocSalHistory(empNo);
		List<DocHistoryVO> docList = docMapper.selectDocHistory(empNo);
		
		// 월급명세서(empNo : 월급 받은 사람)
		List<SalaryVO> salList = docMapper.selectSalHistory(empNo); 
		
		for(int i=0; i< salList.size(); i++) {
			for(int j=0; j< docSalList.size(); j++) {
				if(salList.get(i).getEmpNo().equals(docSalList.get(j).getEmpNo())) {
					
					if(docSalList.get(j).getDocName().equals("급여명세서")) {
						
						String saldate = sdf.format(salList.get(i).getSalActrsfdate());
						
						log.info("slaDAte : "+saldate);	// 지급일자
						
						String docDate = sdf.format(docSalList.get(j).getDocDate());
						
						log.info("docDate : "+docDate);	// 발급일자
						
						if(saldate.equals(docDate)) {
							salList.get(i).setDocCd(docSalList.get(j).getDocCd());
						}
					}
				}
			}
		}
		
		model.addAttribute("empVO", empVO);
		model.addAttribute("myInfo2", "myInfo2");
		model.addAttribute("myInfo", "myInfo");
		model.addAttribute("docSalList", docSalList);
		model.addAttribute("salList", salList);
		model.addAttribute("docList", docList);
		return "main/mypage/dochistory";
	}
	
	// 증명서 신청
	@PostMapping("/appDoc.do")
	public String appDoc (DocHistoryVO docHistoryVO, Principal principal, RedirectAttributes ra, Model model) {
		log.info("appDoc 실행...! docHistoryVO : "+ docHistoryVO);
		// 주민번호 출력 여부
		
		docHistoryVO.setEmpNo(principal.getName());
		
		ServiceResult result =  docService.appDoc(docHistoryVO);
		
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "증명서 신청이 완료되었습니다!");
		}else {
			ra.addFlashAttribute("message", "증명서 신청에 실패하였습니다!");
		}
		
		return "redirect:/dochistory.do";
	}
	
	// 증명서 상태값 변경
	@ResponseBody
	@RequestMapping(value = "/updateDocSe.do", method = RequestMethod.POST, produces="text/plain; charset=utf-8")
	public String updateDocSe (@RequestBody Map<String, String> map) {
		
		String docCd = map.get("docCd");
		log.info("updateDocSe 실행 확인 : "+ docCd);

		String msg = docService.updateDocSe(docCd);
		
		return msg;
	}
	
	//재직증명서 팝업창
	@GetMapping("/historydetail.do")
	public String docHistoryDetail(Principal principal, Model model, String docCd, String regNo) {
		log.info("재직 증명서 컨트롤러 타는지 확인!!!! docCd : "+docCd);
		log.info("재직 증명서 컨트롤러 타는지 확인!!!! regNo : "+regNo);
		// 값 세팅을 위해 emp 정보와 증명서 신청 정보를 가져온다 
		DocHistoryVO docHistoryVO = docService.selectDoc(docCd);
		EmpVO empVO = empMapper.readByUserId(principal.getName());
		
		model.addAttribute("docHistoryVO", docHistoryVO);
		model.addAttribute("empVO", empVO);
		model.addAttribute("regNo", regNo);
		
		return "mypage/historydetail";
	}

	// 경력증명서 팝업창
	@GetMapping("/proofEmp.do")
	public String proofEmp(Principal principal, Model model, String docCd, String regNo) {
		log.info("경력 증명서 컨트롤러 타는지 확인!!!!");
		log.info("재직 증명서 컨트롤러 타는지 확인!!!! regNo : "+regNo);
		DocHistoryVO docHistoryVO = docService.selectDoc(docCd);
		EmpVO empVO = empMapper.readByUserId(principal.getName());
		
		model.addAttribute("docHistoryVO", docHistoryVO);
		model.addAttribute("empVO", empVO);
		model.addAttribute("regNo", regNo);
		return "mypage/proofEmp";
	}
	// 급여명세서 팝업창(직원 본인 조회)
	@GetMapping("/paystub.do")
	public String payStub(Principal principal, Model model, String docCd, String regNo, RedirectAttributes ra) {
		log.info("payStub 컨트롤러 타는지 확인!!!!");
		log.info("setSalNo : "+ docCd);
		log.info("regNo : "+ regNo);
		
		String empNo = principal.getName();
		EmpVO empVO = empMapper.readByUserId(empNo);
		// 급여내역 가져오기
		SalaryVO salVO = new SalaryVO();
		salVO.setSalNo(docCd);
		salVO.setEmpNo(empNo);
		SalaryVO salaryVO = docService.selectPaystub(salVO);
		
		model.addAttribute("empVO", empVO);
		model.addAttribute("salaryVO", salaryVO);
		model.addAttribute("regNo", regNo);
		return "mypage/paystub";
	}
	
	// 급여명세서 팝업창(관리자가 조회)
	@GetMapping("/payStubAdmin.do")
	public String payStubAdmin(Principal principal, Model model, String salNo, String empNo, RedirectAttributes ra) {
		log.info("payStub 컨트롤러 타는지 확인!!!!");
		log.info("setSalNo : "+ salNo);
		
		EmpVO empVO = empMapper.readByUserId(empNo);
		// 급여내역 가져오기
		SalaryVO salVO = new SalaryVO();
		salVO.setSalNo(salNo);
		salVO.setEmpNo(empNo);
		SalaryVO salaryVO = docService.selectPaystub(salVO);
		
		model.addAttribute("empVO", empVO);
		model.addAttribute("salaryVO", salaryVO);
		model.addAttribute("regNo", "secret");
		return "mypage/paystub";
	}
	
	
	
	@RequestMapping(value = "/notifySetting.do", method=RequestMethod.GET)
	public String notifySetting() {
		return "main/mypage/notify";
	}
	

}

package kr.or.ddit.controller.admin;


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
import kr.or.ddit.service.IAuthService;
import kr.or.ddit.vo.AtrzFormVO;
import kr.or.ddit.vo.AtrzPathVO;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.DraftRefVO;
import kr.or.ddit.vo.DraftVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class AdminAuthController {

	@Inject
	private IAuthService authService;
	
	//결재 >기안서
	@GetMapping("/admin/draft.do")
	public String drafting(Model model) {
		List<DraftVO> allDraftList = authService.selectAllDraft();
		List<DeptVO> deptList = authService.selectDeptList();
		model.addAttribute("allDraftList", allDraftList);
		model.addAttribute("deptList", deptList);
		model.addAttribute("draftBar1", "draftBar1");
		model.addAttribute("draftBar", "draftBar");
		return "main/admin/auth/draft";
	}
	
	//pdf로 
	@GetMapping("/admin/draftdetail.do")
	public String draftDetail(Model model, String drftCd, DraftVO draftVO) {
		List<AtrzFormVO> atrzFormVO = authService.selectAtrzForm();
		model.addAttribute("atrzf", atrzFormVO);
		log.info("기안서 양식 >>" + atrzFormVO);
		//기안 코드 세팅
		draftVO.setDrftCd(drftCd);	
		DraftVO draftDetail = authService.authDetail(draftVO);
		model.addAttribute("draftDetail", draftDetail);
		
		//결재자 select
		List<AtrzPathVO> pathSelect= authService.pathSelect(drftCd);
		model.addAttribute("pathList", pathSelect);
		log.info("대기문서 결재자  >> "+ pathSelect);

		//참조자 select
		List<DraftRefVO> refSelect = authService.refSelect(drftCd);
		model.addAttribute("refList", refSelect);
		
		model.addAttribute("draftBar", "draftBar");
		return "main/admin/auth/draftdetail";
	}
	
	//관리자 기안 양식폼 메뉴
	@RequestMapping(value="/admin/draftmanage.do", method = RequestMethod.GET)
	public String draftManage(Model model) {
		
		List<AtrzFormVO> atrzFormList = authService.selectAtrzForm();
		
		model.addAttribute("atrzFormList", atrzFormList);
		log.info("atrzFormList : " +atrzFormList);
		model.addAttribute("draftBar2", "draftBar2");
		model.addAttribute("draftBar", "draftBar");
		return "main/admin/auth/draftmanage";
	}
	
	//기안 양식 폼 디테일 페이지
	@GetMapping("/admin/atrzFormDetail.do")
	public String atrzFormDetail(String atrzfCd, Model model) {
		AtrzFormVO atrzFormVO = authService.selectAtrzContent(atrzfCd);
		
		model.addAttribute("atrzFormVO", atrzFormVO);
		model.addAttribute("draftBar2", "draftBar2");
		model.addAttribute("draftBar", "draftBar");
		return"main/admin/auth/atrzDetailForm";
	}
	// /기안 양식 폼 수정 페이지 
	@GetMapping("/admin/updateAtrzFormDetail.do")
	public String updateAtrzFormDetail(String atrzfCd, Model model) {
		log.info("updateAtrzFormDetail 실행...!"+ "atrzfCd : "+atrzfCd);
		AtrzFormVO atrzFormVO = authService.selectAtrzContent(atrzfCd);
		
		model.addAttribute("atrzFormVO", atrzFormVO);
		model.addAttribute("status", "u");
		model.addAttribute("draftBar2", "draftBar2");
		model.addAttribute("draftBar", "draftBar");
		return"main/admin/auth/atrzDetailForm";
	}
	
	// 기안문서 양식 수정
	@PostMapping("/admin/updateupdateAtrzForm.do")
	public String updateupdateAtrzForm(AtrzFormVO atrzFormVO, RedirectAttributes ra) {
		
		log.info("updateupdateAtrzForm 실행...! : "+ atrzFormVO);
			
		ServiceResult result = authService.updateupdateAtrzForm(atrzFormVO);
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "양식 수정 성공!");
		}else {
			ra.addFlashAttribute("message", "양식 수정 실패!");
		}
		return "redirect:/admin/draftmanage.do";
	}
	// 새로운 기안문서 생성 페이지
	@GetMapping("/admin/createAtrzfForm.do")
	public String createAtrzfForm(Model model) {
		List<AtrzFormVO> docList = authService.selectAtrzForm();
		model.addAttribute("docList", docList);
		model.addAttribute("draftBar2", "draftBar2");
		model.addAttribute("draftBar", "draftBar");
		return "main/admin/auth/createAtrzfForm";
	}
	
	// 새로운 기안문서 생성
	@PostMapping("/admin/createAtrzf.do")
	public String createAtrzf(AtrzFormVO atrzFormVO, RedirectAttributes ra) {
		log.info("createAtrzf()..! " +atrzFormVO);
		ServiceResult result = authService.createAtrzf(atrzFormVO);
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "기안 문서양식 생성 완료!");
		}else {
			ra.addFlashAttribute("message", "기안 문서양식 생성 실패!");
		}
		return "redirect:/admin/draftmanage.do";
	}
	
	// 기안서 양식 폼 삭제
	@ResponseBody
	@RequestMapping(value = "/admin/deleteAtrzfForm.do",method = RequestMethod.POST, produces="text/plain; charset=utf-8")
	public String deleteAtrzfForm (@RequestBody Map<String, List<String>> map) {
		log.info("deleteAtrzfForm 실행 확인...! : " + map);
		String msg = "";
		int status = authService.deleteAtrzfForm(map);
		if(status >0) {
			msg="성공";
		}else {
			msg="실패";
		}
		return msg;
	}
}

package kr.or.ddit.controller.admin;

import java.security.Principal;
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
import kr.or.ddit.service.IAssetService;
import kr.or.ddit.vo.AssRentVO;
import kr.or.ddit.vo.RoomResVO;
import kr.or.ddit.vo.SeatResVO;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Controller
public class AdminAssetController {

	@Inject
	private IAssetService assService;
	
	
	@GetMapping("/admin/asset.do")
	public String assMain(String asCd, Model model) {
		AssRentVO assVO = new AssRentVO();
		//모든 자산 리스트
		List<AssRentVO> assList = assService.selectAssList(assVO);
		model.addAttribute("assList", assList);
		model.addAttribute("resBar", "resBar");
		model.addAttribute("resBar2", "resBar2");
		return "main/admin/reservation/assetAdminMain";
	}
	
	// ajax 모달
//	@ResponseBody
//	@PostMapping("/admin/asset2.do")
//	public AssRentVO assetModal(@RequestBody Map<String, String> map) {
//		String asCd = map.get("asCd").toString();
//		AssRentVO assetModal = assService.selectAssModal(asCd);
//		return assetModal;
//	}
//	
	
	// 대여한 시간 가져오기
	@ResponseBody
	@PostMapping("/admin/assrent.do")
	public List<AssRentVO> assRent(@RequestBody Map<String, String> map, AssRentVO assVO ) {
		//대여한 리스트
		String asCd = map.get("asCd").toString();
		log.info("asCd : "+ asCd);
		assVO.setAsCd(asCd);
		List<AssRentVO> asRentList = assService.selectRentList(asCd);
		return asRentList;
	}
	
	@RequestMapping(value="/admin/assetreservation.do", method = RequestMethod.POST)
	public String assres(RedirectAttributes ra,	String asCd, AssRentVO assVO, Model model, Principal principal) {
		log.info("asCd : {}", asCd);
		
		String goPage = "";

		assVO.setEmpNo(principal.getName()); 	// admin
		assVO.setAsCd(asCd);
		
		ServiceResult result = assService.insertAsRent(assVO);
		
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "정상적으로 처리되었습니다.");
			goPage = "redirect:/admin/asset.do";
		}else {
			ra.addFlashAttribute("message", "다시 시도해주세요.");
			goPage = "redirect:/admin/asset.do";
		}
		return goPage;
	}
	
	@GetMapping("/admin/cancleassetblock.do")
	public String cancleAssetBlock(Principal principal, RedirectAttributes ra, String asCd) {
		AssRentVO assVO = new AssRentVO();
		assVO.setEmpNo(principal.getName());
		assVO.setAsCd(asCd);
		assService.cancleAssetBlock(assVO);
		
		AssRentVO assetInfo = assService.showAssetInfo(asCd);
		
		ra.addFlashAttribute("message", assetInfo.getAsName()+"의 대여불가상태가 정상적으로 해제되었습니다.");
		return "redirect:/admin/asset.do";
	}
	
}

package kr.or.ddit.controller.reservation;

import java.security.Principal;
import java.util.List;

import javax.inject.Inject;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.service.IAssetService;
import kr.or.ddit.vo.AssRentVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/ass")
public class AssRentController {

	@Inject
	private IAssetService assService;
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/asset.do")
	public String mainpage(
			String asCd,
			Model model
			) {
		AssRentVO assVO = new AssRentVO();
		List<AssRentVO> assList = assService.selectAssList(assVO);
		model.addAttribute("assList", assList);
		
		List<AssRentVO> asrentList = assService.selectAssList(assVO);
		assVO.setAsCd(asCd);
		model.addAttribute("asrentList", asrentList);
		model.addAttribute("resBar", "resBar");
		model.addAttribute("resBar2", "resBar2");
		return "main/reservation/assetMain";
	}
	
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/assetreservation.do", method = RequestMethod.POST)
	public String assres(
			RedirectAttributes ra,
			String asCd,
			AssRentVO assVO,
			Model model,
			Principal principal
			) {
		log.info("asCd : {}", asCd);
		
		String goPage = "";

		// 로그인 한 사용자 사원번호(아이디) 가져오기
		String empNo = principal.getName();
		// 예약자명으로 사용자명을 설정
		assVO.setEmpNo(empNo);
		assVO.setAsCd(asCd);
		
		ServiceResult result = assService.insertAsRent(assVO);
		
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "예약에 성공했습니다");
			goPage = "redirect:/myrsv/list.do?#tab-asset";
		}else {
			ra.addFlashAttribute("message", "예약에 실패했습니다.");
			goPage = "redirect:/ass/asset.do";
		}
		return goPage;
	}
	
	/**
	 * 대여 불가 시간 리스트
	 * @param asCd
	 * @return
	 */
	@ResponseBody
	@GetMapping(value = "/todayassetrent.do")
	public ResponseEntity<List<AssRentVO>> todayrent(String asCd) {
		log.debug("asCd : {}", asCd);
		List<AssRentVO> assRentList = assService.selectRentList(asCd); // 오늘 날짜 대여 리스트(사용자, 관리자 모두 포함)
		
		ResponseEntity<List<AssRentVO>> entity = new ResponseEntity<List<AssRentVO>>(assRentList, HttpStatus.OK);
		return entity;
	}
}

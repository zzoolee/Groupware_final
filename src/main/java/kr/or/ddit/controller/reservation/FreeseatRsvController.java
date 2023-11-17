package kr.or.ddit.controller.reservation;

import java.security.Principal;
import java.util.List;

import javax.inject.Inject;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.service.IFreeseatService;
import kr.or.ddit.vo.ScheVO;
import kr.or.ddit.vo.SeatResVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/rsv")
public class FreeseatRsvController {

	@Inject
	private IFreeseatService freeseatService;
	
	@RequestMapping(value="/freeseat.do", method = RequestMethod.GET)
	public String mainpage() {
		return "main/reservation/freeseatMain";
	}
	
	// 자율좌석 선택 페이지
	@RequestMapping(value="/seatlayout.do", method = RequestMethod.GET)
	public String seatLayout(Model model) {
		model.addAttribute("resBar", "resBar");
		model.addAttribute("resBar3", "resBar3");
		return "main/reservation/seatLayout";
	}
	
	// 자율좌석 관리 페이지(관리자)
	@RequestMapping(value="/freeseatadmin.do", method = RequestMethod.GET)
	public String seatLayoutAdmin(Model model) {
		model.addAttribute("resBar", "resBar");
		model.addAttribute("resBar3", "resBar3");
		return "main/reservation/seatLayoutAdmin";
	}
	
	@ResponseBody
	@PostMapping(value="/rsvseatdata.do")
	public ResponseEntity<List<SeatResVO>> showLayout(@RequestBody SeatResVO seatResVO) {
		List<SeatResVO> reservedSeatList = freeseatService.showReservedSeat(seatResVO);
		ResponseEntity<List<SeatResVO>> entity = new ResponseEntity<List<SeatResVO>>(reservedSeatList, HttpStatus.OK);
		return entity;
	}
	
	@ResponseBody
	@PostMapping(value="/blockseatdata.do")
	public ResponseEntity<List<SeatResVO>> showLayoutAdmin(@RequestBody SeatResVO seatResVO) {
		List<SeatResVO> blockedSeatList = freeseatService.showBlockedSeat(seatResVO);
		ResponseEntity<List<SeatResVO>> entity = new ResponseEntity<List<SeatResVO>>(blockedSeatList, HttpStatus.OK);
		return entity;
	}
	
	/**
	 * 
	 * @param principal
	 * @param seatResVO(srCd=null, offCd=3FOPEN, offLoc=null, srNo=B39, srDate=null, empNo=null, fullname=null, offSe=오픈형)
	 * @param ra
	 * @return
	 */
	@RequestMapping(value="/confirmseat.do", method = RequestMethod.POST)
	public String confirmSeat(Principal principal, SeatResVO seatResVO, RedirectAttributes ra) {
		log.info(seatResVO.toString());
		
		if(seatResVO.getSrNo() == null) {
			ra.addFlashAttribute("message", "좌석을 선택해주세요.");
			return "redirect:/rsv/seatlayout.do"; // 좌석예약 페이지
		}

		// 오늘 나의 예약 내역 존재하는지 확인
		ServiceResult result = freeseatService.chkMyFreeseat(principal.getName());
		if(result == ServiceResult.NOTEXIST) {
			seatResVO.setEmpNo(principal.getName());
			ServiceResult result2 = freeseatService.makeRsvFreeseat(seatResVO); // 그새 다른 사람 예약 존재하는지 확인
			if(result2 == ServiceResult.OK) {
				ra.addFlashAttribute("message", "예약이 완료되었습니다.");
			}else {
				ra.addFlashAttribute("message", "다른 직원이 먼저 예약 완료하여 예약 실패했습니다.<br>다시 시도해 주세요.");
			}
		} else if(result == ServiceResult.EXIST) {
			ra.addFlashAttribute("message", "오늘의 예약 내역이 이미 존재합니다.");
		}
		
		return "redirect:/myrsv/list.do?#tab-freeseat"; // 예약내역 페이지
	}
	
	@RequestMapping(value="/cancleseat.do", method = RequestMethod.GET)
	public ResponseEntity<String> cancleSeat(String code) {
		freeseatService.cancleRsvFreeseat(code);
		ResponseEntity<String> entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		return entity;
	}
	
	@RequestMapping(value="/blockseat.do", method = RequestMethod.POST)
	public String blockSeat(Principal principal, RedirectAttributes ra, SeatResVO seatResVO, String[] blockseatList) {
		int cnt = 0;
		
		seatResVO.setEmpNo(principal.getName()); // admin
		freeseatService.cancleAllblockseat(seatResVO); // 해당날짜 예약불가 좌석 모두 삭제
		
		if(blockseatList != null) { // 설정한 예약불가 좌석 있으면 인서트
			for(int i=0; i<blockseatList.length; i++) {
				log.info("offCd_srNo : " + blockseatList[i]);
				String offCd = blockseatList[i].substring(0,blockseatList[i].indexOf("_")); // offCd
				String srNo = blockseatList[i].substring(blockseatList[i].indexOf("_")+1); // srNo
				seatResVO.setOffCd(offCd);
				seatResVO.setSrNo(srNo);
				log.info(seatResVO.toString());
				ServiceResult result = freeseatService.makeRsvFreeseat(seatResVO);
				
				if(result == ServiceResult.FAILED) {
					cnt++;
				}
			}
		}
		
		if(cnt > 0) {
			ra.addFlashAttribute("message", "지정한 좌석을 예약한 직원이 있습니다.<br>해당 좌석 제외한 좌석이 예약 불가 처리되었습니다.");
		} else {
			ra.addFlashAttribute("message", "정상적으로 처리되었습니다.");
		}
		
		return "redirect:/rsv/freeseatadmin.do";
	}
	
}

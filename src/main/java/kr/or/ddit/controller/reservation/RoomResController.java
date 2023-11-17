package kr.or.ddit.controller.reservation;

import java.security.Principal;
import java.util.List;

import javax.inject.Inject;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.service.IRoomService;
import kr.or.ddit.vo.AssRentVO;
import kr.or.ddit.vo.RoomResVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/room")
public class RoomResController {

	@Inject
	private IRoomService roomService;
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/room.do")
	public String mainpage(
			Model model
			) {
		RoomResVO roomVO = new RoomResVO();
		List<RoomResVO> roomList = roomService.selectRoomList(roomVO);
		model.addAttribute("roomList", roomList);
		model.addAttribute("resBar", "resBar");
		model.addAttribute("resBar1", "resBar1");
		return "main/reservation/roomMain";
	}
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/roomreservation.do", method = RequestMethod.POST)
	public String assres(
			RedirectAttributes ra,
			String roomCd,
			RoomResVO roomVO,
			Model model,
			Principal principal
			) {
		log.info("roomCd : {}", roomCd);
		
		String goPage = "";

		// 로그인 한 사용자 사원번호(아이디) 가져오기
		String empNo = principal.getName();
		// 예약자명으로 사용자명을 설정
		roomVO.setEmpNo(empNo);
		roomVO.setRoomCd(roomCd);
		
		ServiceResult result = roomService.insertRoomres(roomVO);
		
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "예약에 성공했습니다");
			goPage = "redirect:/myrsv/list.do?#tab-room";
		}else {
			ra.addFlashAttribute("message", "예약에 실패했습니다.");
			goPage = "redirect:/room/room.do";
		}
		model.addAttribute("resBar", "resBar");
		return goPage;
	}
	
}

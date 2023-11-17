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
import kr.or.ddit.service.IRoomService;
import kr.or.ddit.vo.AssRentVO;
import kr.or.ddit.vo.RoomResVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class AdminRoomController {

	@Inject
	private IRoomService roomService;
	
	@GetMapping("/admin/room.do")
	public String roomMain(Model model) {
		RoomResVO roomVO = new RoomResVO();
		List<RoomResVO> roomList = roomService.selectRoomList(roomVO);
		model.addAttribute("roomList", roomList);
		model.addAttribute("resBar", "resBar");
		model.addAttribute("resBar1", "resBar1");
		return "main/admin/reservation/roomAdminMain";
	}
	
	// ajax 모달
	@ResponseBody
	@RequestMapping(value = "/admin/room2.do", method = RequestMethod.POST) 
	public RoomResVO roomModal(@RequestBody Map<String, String> map) {
		String roomCd = map.get("roomCd").toString();
		RoomResVO roomModal = roomService.selectRoomModal(roomCd);
		return roomModal;
	}
	
	// 시간 가져오기
	@ResponseBody
	@PostMapping("/admin/roomrent.do")
	public List<RoomResVO> roomRent(@RequestBody Map<String, String> map, RoomResVO roomVO ) {
		//대여한 리스트
		String roomCd = map.get("roomCd").toString();
		roomVO.setRoomCd(roomCd);
		List<RoomResVO> roomRentList = roomService.selectRentList(roomCd);
		return roomRentList;
	}
	
	
	@RequestMapping(value="/admin/roomreservation.do", method = RequestMethod.POST)
	public String roomBlock(RedirectAttributes ra, String roomCd, RoomResVO roomVO,
					Model model, Principal principal) {
		log.info("roomCd : {}", roomCd);
		String goPage = "";

		//admin을 empNo에 셋팅
		roomVO.setEmpNo(principal.getName());
		roomVO.setRoomCd(roomCd);
		
		ServiceResult result = roomService.insertRoomres(roomVO);
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "정상적으로 처리되었습니다.");
			goPage = "redirect:/admin/room.do";
		}else {
			ra.addFlashAttribute("message", "다시 시도해주세요.");
			goPage = "redirect:/admin/room.do";
		}
		model.addAttribute("resBar", "resBar");
		return goPage;
	}
	
	@GetMapping("/admin/cancleroomblock.do")
	public String cancleRoomBlock(Principal principal, RedirectAttributes ra, String roomCd) {
		RoomResVO roomVO = new RoomResVO();
		roomVO.setEmpNo(principal.getName());
		roomVO.setRoomCd(roomCd);
		roomService.cancleRoomBlock(roomVO);
		
		RoomResVO roomInfo = roomService.selectRoomModal(roomCd);
		
		ra.addFlashAttribute("message", roomInfo.getRoomName()+"의 예약불가상태가 정상적으로 해제되었습니다.");
		return "redirect:/admin/room.do";
	}
	
}

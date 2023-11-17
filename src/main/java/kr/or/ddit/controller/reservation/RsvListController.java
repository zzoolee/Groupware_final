package kr.or.ddit.controller.reservation;

import java.security.Principal;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.lang.StringUtils;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.service.IAssetService;
import kr.or.ddit.service.IFreeseatService;
import kr.or.ddit.service.IRoomService;
import kr.or.ddit.vo.AssRentVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.RoomResVO;
import kr.or.ddit.vo.SeatResVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class RsvListController {
	
	@Inject
	private IFreeseatService freeseatService;
	
	@Inject
	private IAssetService assService;

	@Inject
	private IRoomService roomService;
	
	// 내예약 페이지(사용자)
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/myrsv/list.do")
	public String mainpage(
			Principal principal, 
			Model model,
			@RequestParam(name="tab", required = false, defaultValue = "room") String tab,
			@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(name="dateSelect", required = false)  String searchDate,
			@RequestParam(name="assdateSelect", required = false)  String searchAssDate
			) {
		// 자율좌석
				List<SeatResVO> freeseatList = freeseatService.myFreeseatRsvList(principal.getName());
				model.addAttribute("freeseatList", freeseatList);
				
		// 회의실 페이징
		// 페이징 정보를 담고 관리할 PaginationInfoVO 객체를 생성합니다. RoomResVO를 사용하여 데이터를 페이징할 것을 지정합니다.
		PaginationInfoVO<RoomResVO> pagingVO = new PaginationInfoVO<RoomResVO>();
		pagingVO.setEmpNo(principal.getName());
		
		// 자산 페이징
		// 페이징 정보를 담고 관리할 PaginationInfoVO 객체를 생성합니다.  AssRentVO를 사용하여 데이터를 페이징할 것을 지정합니다.
		PaginationInfoVO<AssRentVO> asspagingVO = new PaginationInfoVO<AssRentVO>();
		asspagingVO.setEmpNo(principal.getName());
		
 		if(tab.equals("room") && StringUtils.isNotBlank(searchDate)) {
 			// 회의실 날짜 검색이 이뤄지면 아래가 실행됨
 			pagingVO.setSelectedDate(searchDate);
 			model.addAttribute("searchDate", searchDate);
 		}else if(tab.equals("assets") && StringUtils.isNotBlank(searchAssDate)) {
 			// 자산 날짜 검색이 이뤄지면 아래가 실행야 하는데 일단 회의실이랑 이름이 같아서 pass
 			asspagingVO.setSelectedAssetDate(searchAssDate);
 			model.addAttribute("searchAssDate", searchAssDate);
 		}

 		// 회의실 목록 데이터 만들기 ======================
 		// 현재 페이지 번호를 설정
 		pagingVO.setCurrentPage(currentPage);
 		// 전체 게시글 수를 DB에서 가져옴
 		int totalRecord = roomService.selectMyRoomCount(pagingVO);
 		// 페이징 정보에 전체 게시글 수를 설정해 총 페이지 수를 결정
 		pagingVO.setTotalRecord(totalRecord);
 		// 페이징 정보를 사용해 게시글 목록을 DB에서 가져옴
 		List<RoomResVO> roomPList = roomService.myRoomRsvPList(pagingVO);
 		// 페이징 정보 객체에 게시글 목록을 설정
 		pagingVO.setDataList(roomPList);
 		model.addAttribute("pagingVO", pagingVO);
 		// 회의실 목록 데이터 만들기 ====================== End 		
 		
 		// 자산 목록 데이터 만들기 ======================
 		// 현재 페이지 번호를 설정
 		asspagingVO.setCurrentPage(currentPage);
 		// 전체 게시글 수를 DB에서 가져옴
 		totalRecord = assService.selectMyAssetCount(asspagingVO);
 		// 페이징 정보에 전체 게시글 수를 설정해 총 페이지 수를 결정
 		asspagingVO.setTotalRecord(totalRecord);
 		// 페이징 정보를 사용해 게시글 목록을 DB에서 가져옴
 		List<AssRentVO> assPList = assService.myAssRsvPList(asspagingVO);
 		// 페이징 정보 객체에 게시글 목록을 설정
 		asspagingVO.setDataList(assPList);
 		model.addAttribute("asspagingVO", asspagingVO);
 		// 자산 목록 데이터 만들기 ====================== End
 		
 		// Commons Data 셋팅
 		model.addAttribute("tab", tab);
		model.addAttribute("resBar", "resBar");	// navbar 열려있게 하기
		model.addAttribute("resBar4", "resBar4");	// navbar 열려있게 하기
		return "main/reservation/myRsvList";
	}
	
	// 내가 예약한 회의실 취소
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/myroomcancle.do", method = RequestMethod.GET)
	public String cancleRoom(RedirectAttributes ra, String rrCd, Model model) {
		String goPage = "";

		ServiceResult result = roomService.myRoomRsvDel(rrCd);
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "회의실 예약이 정상적으로 취소되었습니다.");
			goPage = "redirect:/myrsv/list.do?#tab-room";
		}else {
			ra.addFlashAttribute("message", "회의실 예약 취소에 실패했습니다.");
			goPage = "redirect:/myrsv/list.do?#tab-room";
		}
		
		return goPage;
	}
	
	// 내가 예약한 자산 취소
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/myassetcancle.do", method = RequestMethod.GET)
	public String cancleAsset(RedirectAttributes ra, String asrCd, Model model) {
		String goPage = "";
		
		ServiceResult result = assService.myAssetRsvDel(asrCd);
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "자산 대여가 정상적으로 취소되었습니다.");
			goPage = "redirect:/myrsv/list.do?#tab-asset";
		}else {
			ra.addFlashAttribute("message", "자산 대여 취소에 실패했습니다.");
			goPage = "redirect:/myrsv/list.do?#tab-asset";
		}
		
		return goPage;
	}
	
	// 자율좌석 날짜 검색
	@ResponseBody
	@RequestMapping(value="/dateseatlist.do", method = RequestMethod.POST)
	public ResponseEntity<List<SeatResVO>> cancleSeat(Principal principal, @RequestBody SeatResVO seatResVO) {
		seatResVO.setEmpNo(principal.getName());
		log.info("seatResVO : " + seatResVO.toString());
		List<SeatResVO> dateFreeseatList = freeseatService.dateFreeSeatRsvList(seatResVO);
		ResponseEntity<List<SeatResVO>> entity = new ResponseEntity<List<SeatResVO>>(dateFreeseatList, HttpStatus.OK);
		return entity;
	}
	
	
	
	// 예약현황 페이지(관리자)
	@PreAuthorize("hasAnyRole('ROLE_ADMIN')")
	@RequestMapping(value="/admin/rsvlist.do")
	public String mainpageAdmin(
			Principal principal, 
			Model model,
			@RequestParam(name="tab", required = false, defaultValue = "room") String tab,
			@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(name="dateSelect", required = false)  String searchDate,
			@RequestParam(name="assdateSelect", required = false)  String searchAssDate
			) {
		// 자율좌석 모든 목록
		List<SeatResVO> freeseatList = freeseatService.allFreeseatRsvList();
		model.addAttribute("freeseatList", freeseatList);
		
		
		// 회의실 페이징
		// 페이징 정보를 담고 관리할 PaginationInfoVO 객체를 생성합니다. RoomResVO를 사용하여 데이터를 페이징할 것을 지정합니다.
		PaginationInfoVO<RoomResVO> pagingVO = new PaginationInfoVO<RoomResVO>();
		
		// 자산 페이징
		// 페이징 정보를 담고 관리할 PaginationInfoVO 객체를 생성합니다.  AssRentVO를 사용하여 데이터를 페이징할 것을 지정합니다.
		PaginationInfoVO<AssRentVO> asspagingVO = new PaginationInfoVO<AssRentVO>();
		
		if(tab.equals("room") && StringUtils.isNotBlank(searchDate)) {
			// 회의실 날짜 검색이 이뤄지면 아래가 실행됨
			pagingVO.setSelectedDate(searchDate);
			model.addAttribute("searchDate", searchDate);
		}else if(tab.equals("assets") && StringUtils.isNotBlank(searchAssDate)) {
			// 자산 날짜 검색이 이뤄지면 아래가 실행야 하는데 일단 회의실이랑 이름이 같아서 pass
			asspagingVO.setSelectedAssetDate(searchAssDate);
			model.addAttribute("searchAssDate", searchAssDate);
		}
	
		// 회의실 목록 데이터 만들기 ======================
		// 현재 페이지 번호를 설정
		pagingVO.setCurrentPage(currentPage);
		// 전체 게시글 수를 DB에서 가져옴
		int totalRecord = roomService.selectAdminRoomCount(pagingVO);
		// 페이징 정보에 전체 게시글 수를 설정해 총 페이지 수를 결정
		pagingVO.setTotalRecord(totalRecord);
		// 페이징 정보를 사용해 게시글 목록을 DB에서 가져옴
		List<RoomResVO> roomPList = roomService.adminRoomRsvPList(pagingVO);
		// 페이징 정보 객체에 게시글 목록을 설정
		pagingVO.setDataList(roomPList);
		model.addAttribute("pagingVO", pagingVO);
		// 회의실 목록 데이터 만들기 ====================== End 		
		
		// 자산 목록 데이터 만들기 ======================
		// 현재 페이지 번호를 설정
		asspagingVO.setCurrentPage(currentPage);
		// 전체 게시글 수를 DB에서 가져옴
		totalRecord = assService.selectAdminAssetCount(asspagingVO);
		// 페이징 정보에 전체 게시글 수를 설정해 총 페이지 수를 결정
		asspagingVO.setTotalRecord(totalRecord);
		// 페이징 정보를 사용해 게시글 목록을 DB에서 가져옴
		List<AssRentVO> assPList = assService.adminAssRsvPList(asspagingVO);
		// 페이징 정보 객체에 게시글 목록을 설정
		asspagingVO.setDataList(assPList);
		model.addAttribute("asspagingVO", asspagingVO);
		// 자산 목록 데이터 만들기 ====================== End
		
		// Commons Data 셋팅
		model.addAttribute("tab", tab);
		model.addAttribute("resBar", "resBar");	// navbar 열려있게 하기
		model.addAttribute("resBar4", "resBar4");	// navbar 열려있게 하기
		return "main/reservation/allRsvListAdmin";
	}
	
	// 관리자 모드에서 예약한 자산 취소
	@PreAuthorize("hasAnyRole('ROLE_MEMBER')")
	@RequestMapping(value="/adminassetcancle.do", method = RequestMethod.GET)
	public String cancleAssetAdmin(RedirectAttributes ra, String asrCd, Model model) {
		String goPage = "";
		
		ServiceResult result = assService.myAssetRsvDel(asrCd);
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "자산 대여가 정상적으로 취소되었습니다.");
			goPage = "redirect:/admin/rsvlist.do?#tab-asset";
		}else {
			ra.addFlashAttribute("message", "자산 대여 취소에 실패했습니다.");
			goPage = "redirect:/admin/rsvlist.do?#tab-asset";
		}
		
		return goPage;
	}
	
	// 관리자 모드에서 예약한 회의실 취소
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/adminroomcancle.do", method = RequestMethod.GET)
	public String cancleRoomAdmin(RedirectAttributes ra, String rrCd, Model model) {
		String goPage = "";

		ServiceResult result = roomService.myRoomRsvDel(rrCd);
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "회의실 예약이 정상적으로 취소되었습니다.");
			goPage = "redirect:/admin/rsvlist.do?#tab-room";
		}else {
			ra.addFlashAttribute("message", "회의실 예약 취소에 실패했습니다.");
			goPage = "redirect:/admin/rsvlist.do?#tab-room";
		}
		
		return goPage;
	}
}

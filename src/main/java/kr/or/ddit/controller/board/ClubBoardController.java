package kr.or.ddit.controller.board;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.controller.util.MediaUtils;
import kr.or.ddit.service.IClubBoardService;
import kr.or.ddit.service.IMailService;
import kr.or.ddit.vo.ClubMemberVO;
import kr.or.ddit.vo.ClubNotMemVO;
import kr.or.ddit.vo.ClubPostVO;
import kr.or.ddit.vo.ClubVO;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.FileVO;
import kr.or.ddit.vo.MailFormVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ClubBoardController {
	
	@Inject
	private IClubBoardService service;
	
	@Inject
	private IMailService mailService;
	
	/**
	 * 동호회메인 페이지
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/clubmain.do", method=RequestMethod.GET)
	public String clubMain(Model model) {
		List<ClubVO> clubList = service.showAllClub();
		List<ClubVO> popClubList = service.showPopularClub();
		model.addAttribute("clubList", clubList);
		model.addAttribute("popClubList", popClubList);
		String boardBar = "EXIST";
		model.addAttribute("boardBar", boardBar);
		model.addAttribute("boardBar4", "boardBar4");
		return "main/board/clubMainpage";
	}
	
	/**
	 * 내동호회 페이지
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/clubmypage.do", method=RequestMethod.GET)
	public String clubMypage(Principal principal, Model model) {
		List<ClubVO> myClubList = service.showMyClub(principal.getName());
		
		model.addAttribute("myClubList", myClubList);
		String boardBar = "EXIST";
		model.addAttribute("boardBar", boardBar);
		model.addAttribute("boardBar5", "boardBar5");
		return "main/board/clubMypage";
	}
	
	/**
	 * 동호회 상세 페이지
	 * @param model
	 * @param clubCd
	 * @return
	 */
	@RequestMapping(value="/clubdetail.do", method=RequestMethod.GET)
	public String clubDetail(Model model, String clubCd, 
			@RequestParam(name="tab", required = false, defaultValue = "main") String tab) {
		ClubVO club = service.showOneClub(clubCd);
		
		model.addAttribute("club", club);
		String boardBar = "EXIST";
		model.addAttribute("boardBar", boardBar);
		model.addAttribute("tab", tab);
		return "main/board/clubDetail";
	}
	
	@ResponseBody
	@RequestMapping(value="/clubboarddetail.do", method=RequestMethod.GET)
	public ResponseEntity<ClubPostVO> clubBoardDetail(String cpNo) {
		ClubPostVO clubPostVO = service.showClubBoardDetail(cpNo);
		
		ResponseEntity<ClubPostVO> entity = new ResponseEntity<ClubPostVO>(clubPostVO, HttpStatus.OK);
		return entity;
	}
	
	/**
	 * 동호회 게시판 글 등록
	 * @param principal
	 * @param model
	 * @param cbCd
	 * @param clubPostVO
	 * @return
	 */
	@PostMapping(value="/clubboard/insert.do")
	public String clubBoardInsert(Principal principal, RedirectAttributes ra, ClubPostVO clubPostVO) {
		clubPostVO.setCpwriterEmpno(principal.getName());
		try {
			service.insertClubPost(clubPostVO);
		} catch (IllegalStateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		String tab = "";
		if(clubPostVO.getCbCd().equals("NO")) {
			tab = "notice";
		} else if(clubPostVO.getCbCd().equals("FR")) {
			tab = "free";
		}
		
		ra.addFlashAttribute("message", "정상적으로 등록되었습니다.");
		return "redirect:/clubdetail.do?clubCd="+clubPostVO.getClubCd()+"&tab="+tab;
	}
	
	
	@PostMapping(value="/clubboard/modify.do")
	public String clubBoardModify(Principal principal, RedirectAttributes ra, ClubPostVO clubPostVO) {
		try {
			service.modifyClubPost(clubPostVO);
		} catch (IllegalStateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		String tab = "";
		if(clubPostVO.getCbCd().equals("NO")) {
			tab = "notice";
		} else if(clubPostVO.getCbCd().equals("FR")) {
			tab = "free";
		}
		
		ra.addFlashAttribute("message", "정상적으로 수정되었습니다.");
		return "redirect:/clubdetail.do?clubCd="+clubPostVO.getClubCd()+"&tab="+tab;
	}
	
	@GetMapping(value="/clubboard/remove.do")
	public String clubBoardRemove(RedirectAttributes ra, ClubPostVO clubPostVO) {
		service.removeClubPost(clubPostVO);
		
		String tab = "";
		if(clubPostVO.getCbCd().equals("NO")) {
			tab = "notice";
		} else if(clubPostVO.getCbCd().equals("FR")) {
			tab = "free";
		} else if(clubPostVO.getCbCd().equals("AC")) {
			tab = "activity";
		}
		
		ra.addFlashAttribute("message", "정상적으로 삭제되었습니다.");
		return "redirect:/clubdetail.do?clubCd="+clubPostVO.getClubCd()+"&tab="+tab;
	}
	
	@PostMapping(value="/clubboard/activity/insert.do")
	public String clubBoardActivityInsert(Principal principal, RedirectAttributes ra, ClubPostVO clubPostVO, MultipartFile picture) {
		log.info("clubBoardActivityInsert 실행...!");
		clubPostVO.setCpwriterEmpno(principal.getName());
		try {
			service.insertClubActivity(clubPostVO, picture);
		} catch (IllegalStateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		ra.addFlashAttribute("message", "정상적으로 추가되었습니다.");
		return "redirect:/clubdetail.do?clubCd="+clubPostVO.getClubCd()+"&tab=activity";
	}
	
	@PostMapping(value="/clubboard/activity/modify.do")
	public String clubBoardActivityModify(RedirectAttributes ra, ClubPostVO clubPostVO, MultipartFile picture) {
		log.info("clubBoardActivityModify 실행...!");
		try {
			service.modifyClubActivity(clubPostVO, picture);
		} catch (IllegalStateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		ra.addFlashAttribute("message", "정상적으로 수정되었습니다.");
		return "redirect:/clubdetail.do?clubCd="+clubPostVO.getClubCd()+"&tab=activity";
	}
	
	/**
	 * 댓글 등록
	 * @param principal
	 * @param commentVO
	 * @return
	 */
	@ResponseBody
	@PostMapping(value="/clubboard/comment/insert.do")
	public ResponseEntity<CommentVO> clubBoardCommentInsert(Principal principal, CommentVO commentVO) { // 자바스크립트 객체 하나... @RequestBody 쓰면 415(미디어타입) 오류
		commentVO.setCmwriterEmpno(principal.getName());
		commentVO.setCmBoardse("CLUB");
		CommentVO insertComment = service.insertComment(commentVO);
		
		ResponseEntity<CommentVO> entity = new ResponseEntity<CommentVO>(insertComment, HttpStatus.OK);
		return entity;
	}
	
	@GetMapping(value="/clubboard/comment/remove.do")
	public ResponseEntity<String> clubBoardCommentRemove(String cmNo) {
		service.removeComment(cmNo);
		
		ResponseEntity<String> entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		return entity;
	}
	
	@PostMapping(value="/clubboard/comment/modify.do")
	public ResponseEntity<String> clubBoardCommentModify(CommentVO commentVO) {
		service.modifyComment(commentVO);
		
		ResponseEntity<String> entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		return entity;
	}
	
	/**
	 * 동호회 가입
	 * @param ra
	 * @param clubNotMemVO
	 * @return
	 */
	@PostMapping(value="/club/joinclub.do")
	public String joinClub(RedirectAttributes ra, ClubNotMemVO clubNotMemVO) {
		ServiceResult result = service.joinClub(clubNotMemVO);
		if(result == ServiceResult.OK) {
			ra.addFlashAttribute("message", "동호회장의 승인 후 가입처리됩니다.");
		}else if(result == ServiceResult.FAILED) {
			ra.addFlashAttribute("message", "승인 대기 내역이 존재합니다.");
		}
		
		return "redirect:/clubdetail.do?clubCd="+clubNotMemVO.getClubCd();
	}
	
	@GetMapping(value="/club/leaveclub.do")
	public String leaveClub(RedirectAttributes ra, ClubMemberVO clubMemberVO) {
		service.leaveClub(clubMemberVO);
		ra.addFlashAttribute("message", "정상적으로 탈퇴처리되었습니다.");
		return "redirect:/clubmypage.do";
	}

	/**
	 * 동호회 회원 승인 관리
	 * @param ra
	 * @param clubNotMemVO : clubCd, cnmEmpno
	 * @return
	 */
	@GetMapping(value="/club/joinconfirm.do")
	public String clubJoinConfirm(RedirectAttributes ra, ClubNotMemVO clubNotMemVO) {
		// 메일 보내기
		ClubVO clubInfo = service.showClubInfo(clubNotMemVO.getClubCd());
		String title = "[동호회] " + clubInfo.getClubName() + "에 가입승인 되었습니다.";
		String content = "가입하신 동호회 정보입니다.<br><br>";
		content += "동호회명 : " + clubInfo.getClubName() + "<br>";
		content += "동호회소개 : " + clubInfo.getClubInfo() + "<br>";
		content += "대표사진 : <img src='" + clubInfo.getClubPhoto() + "' style='width:700px;'><br><br>";
		content += "내동호회 메뉴에서 바로 확인할 수 있습니다.<br>";
		content += "즐거운 동호회 활동을 즐겨보세요!";
		mailService.adminSendMail(clubNotMemVO.getCnmEmpno(), title, content);
		
		service.clubJoinConfirm(clubNotMemVO);
		ra.addFlashAttribute("message", "가입 승인처리 되었습니다.");
		return "redirect:/clubdetail.do?clubCd="+clubNotMemVO.getClubCd()+"&tab=manage";
	}
	
	/**
	 * 동호회 회원 거절 관리
	 * @param ra
	 * @param clubNotMemVO : clubCd, cnmEmpno, cnmNocontent
	 * @return
	 */
	@PostMapping(value="/club/joinreject.do")
	public String clubJoinReject(RedirectAttributes ra, ClubNotMemVO clubNotMemVO) {
		// 메일 보내기
		ClubVO clubInfo = service.showClubInfo(clubNotMemVO.getClubCd());
		String title = "[동호회] " + clubInfo.getClubName() + "에 가입거절 되었습니다.";
		String content = "동호회 [" + clubInfo.getClubName() + "]에 동호회장에 의해 가입거절 되었습니다.<br>";
		content += "거절사유 : " + clubNotMemVO.getCnmNocontent() + "<br><br>";
		content += "기타 궁금한 사항이 있으시면 해당 동호회장에게 문의바랍니다.<br>";
		content += "동호회장 : " + clubInfo.getEmpName() + " / " + clubInfo.getDeptName();
		mailService.adminSendMail(clubNotMemVO.getCnmEmpno(), title, content);
		
		service.clubJoinReject(clubNotMemVO);
		ra.addFlashAttribute("message", "가입 거절처리 되었습니다.");
		return "redirect:/clubdetail.do?clubCd="+clubNotMemVO.getClubCd()+"&tab=manage";
	}
	
	/**
	 * 동호회 정보 관리
	 * @param ra
	 * @param clubVO
	 * @param picture
	 * @return
	 */
	@PostMapping(value="/club/modifyInfo.do")
	public String modifyClubInfo(RedirectAttributes ra, ClubVO clubVO, MultipartFile picture) {
		log.info("modifyClubInfo 실행...!");
		try {
			service.modifyClubInfo(clubVO, picture);
		} catch (IllegalStateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		ra.addFlashAttribute("message", "정상적으로 수정되었습니다.");
		return "redirect:/clubdetail.do?clubCd="+clubVO.getClubCd();
	}
	
	@GetMapping(value="/club/shutdown.do")
	public String shutdownClub(RedirectAttributes ra, String clubCd) {
		service.shutdownClub(clubCd);
		ra.addFlashAttribute("message", "정상적으로 폐쇄되었습니다.");
		return "redirect:/clubmypage.do";
	}

	/**
	 * 동호회개설 페이지(폼)
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/createclub.do", method=RequestMethod.GET)
	public String createClubForm(Model model) {
		String boardBar = "EXIST";
		model.addAttribute("boardBar", boardBar);
		model.addAttribute("boardBar6", "boardBar6");
		return "main/board/createClub";
	}
	
	/**
	 * 폼 제출 처리
	 * @param ClubVO(clubCd=null, clubName=운동하자아자, clubDate=null, clubInfo=바쁘다바빠 현대사회 운동으로 몸과 마음을 지킵시다, clubPhoto=null, clubReason=, clubEmpno=null, clubSe=null)
	 * @param file
	 * @param ra
	 * @return
	 */
	@PostMapping("/createclub.do")
	public String createClub(Principal principal, ClubVO clubVO, MultipartFile picture, RedirectAttributes ra,
			HttpServletRequest req, HttpServletResponse resp) {
		log.info("createClub() 실행...!");
		log.debug("clubVO : {}", clubVO.toString()); // clubVO이 널이면 오류...?
		log.debug("picture : {}", picture);
		
		clubVO.setClubEmpno(principal.getName());
		try {
			service.createClub(clubVO, picture);
			// 메일 보내기 : 개설 요청 완료
			String title = "[동호회] " + clubVO.getClubName() + "가 개설요청 되었습니다.";
			String content = "동호회 개설요청 정보입니다.<br><br>";
			content += "동호회명 : " + clubVO.getClubName() + "<br>";
			content += "동호회소개 : " + clubVO.getClubInfo() + "<br>";
			content += "대표사진 : <img src='" + clubVO.getClubPhoto() + "' style='width:700px;'><br>";
			content += "개설사유 : " + clubVO.getClubReason() + "<br><br>";
			content += "위와 같이 동호회가 개설요청 되었습니다.<br>";
			content += "관리자의 승인 후 동호회가 개설되며 승인 결과는 메일을 통해 알려드립니다.";
			mailService.adminSendMail(clubVO.getClubEmpno(), title, content);
		} catch (IllegalStateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		ra.addFlashAttribute("message", "개설 요청이 완료되었습니다.<br>승인 결과는 메일을 통해 알려드립니다.");
		return "redirect:/createclub.do";
	}
	
	/**
	 * 동호회 관리(관리자)
	 * @param model
	 * @return
	 */
	@GetMapping("/manageclub/admin.do")
	public String manageClubAdmin(Model model) {
		List<ClubVO> clubList = service.showAllClubAdmin();
		model.addAttribute("clubList", clubList);
		model.addAttribute("boardBar", "boardBar");
		model.addAttribute("boardBar4", "boardBar4");
		return "main/board/manageClubAdmin";
	}
	
	@GetMapping("/approveclub/admin.do")
	public String approveClubAdmin(RedirectAttributes ra, String clubCd) {
		service.approveClub(clubCd);
		
		// 메일
		ClubVO clubInfo = service.showClubInfo(clubCd);
		String title = "[동호회] " + clubInfo.getClubName() + "가 개설승인 되었습니다.";
		String content = "동호회 [" + clubInfo.getClubName() + "]가 관리자에 의해 개설승인 되었습니다.<br><br>";
		content += "동호회명 : " + clubInfo.getClubName() + "<br>";
		content += "동호회소개 : " + clubInfo.getClubInfo() + "<br>";
		content += "대표사진 : <img src='" + clubInfo.getClubPhoto() + "' style='width:700px;'><br>";
		content += "개설사유 : " + clubInfo.getClubReason() + "<br><br>";
		content += "위와 같이 동호회가 개설 되었습니다.<br>";
		content += "즐거운 동호회 활동을 즐겨보세요!";
		mailService.adminSendMail(clubInfo.getClubEmpno(), title, content);
		
		ra.addFlashAttribute("message", "정상적으로 승인되었습니다.");
		return "redirect:/manageclub/admin.do";
	}
	
	/**
	 * 
	 * @param ra
	 * @param clubVO : clubCd, clubEmpno, rejectReason
	 * @return
	 */
	@PostMapping("/rejectclub/admin.do")
	public String rejectClubAdmin(RedirectAttributes ra, ClubVO clubVO) {
		// 메일
		ClubVO clubInfo = service.showClubInfo(clubVO.getClubCd());
		String title = "[동호회] " + clubInfo.getClubName() + "가 승인거절 되었습니다.";
		String content = "동호회 [" + clubInfo.getClubName() + "]가 관리자에 의해 승인거절 되었습니다.<br>";
		content += "거절사유 : " + clubVO.getRejectReason() + "<br><br>";
		content += "기타 궁금한 사항이 있으시면 관리자에게 문의바랍니다.";
		mailService.adminSendMail(clubVO.getClubEmpno(), title, content);
		
		service.rejectClub(clubVO.getClubCd());
		ra.addFlashAttribute("message", "정상적으로 승인거절되었습니다.");
		return "redirect:/manageclub/admin.do";
	}
	
	/**
	 * 
	 * @param ra
	 * @param clubVO : clubCd, clubEmpno, shutdownReason
	 * @return
	 */
	@PostMapping("/shutdownclub/admin.do")
	public String shutdownClubAdmin(RedirectAttributes ra, ClubVO clubVO) {
		// 메일 필수
		ClubVO clubInfo = service.showClubInfo(clubVO.getClubCd());
		
		String title = "[동호회] " + clubInfo.getClubName() + "가 폐쇄되었습니다.";
		String content = "동호회 [" + clubInfo.getClubName() + "]가 관리자에 의해 폐쇄되었습니다.<br>";
		content += "폐쇄사유 : " + clubVO.getShutdownReason() + "<br><br>";
		content += "기타 궁금한 사항이 있으시면 관리자에게 문의바랍니다.";
		mailService.adminSendMail(clubVO.getClubEmpno(), title, content);
		
		service.shutdownClub(clubVO.getClubCd());
		ra.addFlashAttribute("message", "정상적으로 폐쇄되었습니다.");
		return "redirect:/manageclub/admin.do";
	}
	
	/**
	 * 파일 다운로드
	 * @param fileSec
	 * @param req
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value="/clubboard/download.do", method = RequestMethod.GET)
	public ResponseEntity<byte[]> fileDownload(int fileSec, HttpServletRequest req) throws IOException{
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;
		
		String fileName = null;
		FileVO fileVO = service.selectFileInfo(fileSec);
		
		if(fileVO != null) {
			fileName = fileVO.getFileOrgname();
			try {
				String formatName = fileVO.getFileType();
				MediaType mType = MediaUtils.getMediaType(formatName);
				HttpHeaders headers = new HttpHeaders();
				in = new FileInputStream(req.getServletContext().getRealPath("/resources/upload/club/board/")+fileVO.getFileSavename());
				
				if(mType != null) {
					headers.setContentType(mType);
				}else {
					fileName = fileName.substring(fileName.lastIndexOf("_") + 1);
					headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
					headers.add("Content-Disposition", "attachment; filename=\"" +
							new String(fileName.getBytes("UTF-8"), "ISO-8859-1") + "\"");
				}
				entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
			}catch(Exception e) {
				e.printStackTrace();
				entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
			}finally {
				if(in != null) {
					in.close();
				}
			}
		}else {
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		}
		return entity;
	}
	
}

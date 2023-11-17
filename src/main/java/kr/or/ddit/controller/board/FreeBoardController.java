package kr.or.ddit.controller.board;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.mail.Session;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.service.IBoardFreeService;
import kr.or.ddit.view.NoticeDownloadView;
import kr.or.ddit.vo.BoardFreeVO;
import kr.or.ddit.vo.BoardNoticeVO;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.FileVO;
import kr.or.ddit.vo.LikeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class FreeBoardController {
	
	@Inject
	private IBoardFreeService freeService;

	// 자유게시판 리스트화면 (메인)으로 가는 맵핑
	@RequestMapping(value="/freemain.do", method=RequestMethod.GET)
	public String FreeBoard(Model model, HttpServletRequest req, HttpServletResponse resp) {
		log.info("FreeBoard() 실행...!");
		String boardBar = "EXITST";
		model.addAttribute("boardBar", boardBar);
		
		HttpSession session = req.getSession();
		String message = "";
		if(session.getAttribute("message")!=null) {
			message = (String)session.getAttribute("message");
			session.removeAttribute("message");
		}
		
		List<BoardFreeVO> freeList = freeService.freeList();
		model.addAttribute("message", message);
		model.addAttribute("freeList", freeList);
		return "main/board/freeMain";
	}
	
	// 자유게시판 작성화면으로 가는 맵핑
	@RequestMapping(value="/freewrite.do", method=RequestMethod.GET)
	public String WriteFreeBoard(Model model) {
		String boardBar = "EXITST";
		model.addAttribute("boardBar", boardBar);
		return "main/board/freeWrite";
	}
	
	// 글 등록
	@RequestMapping(value = "/insertFree", method = RequestMethod.POST)
	public String insertFree(BoardFreeVO free, Model model,
							HttpServletRequest req,
							HttpServletResponse res) {
		log.info("insertFree()실행..!");
		log.info("free : {}", free);
		String boardBar = "EXITST";
		model.addAttribute("boardBar", boardBar);
		String goPage = "";
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String chatuser = user.getEmp().getEmpNo();
		free.setFrWriterEmpNo(chatuser);
		if("Y".equals(free.getFrAnonySe())) {
			free.setFrAnonySe("Y");
		}else {
			free.setFrAnonySe("N");
		}
		freeService.insertFree(free,req,res);
		goPage = "redirect:/freemain.do";
		
		return goPage;
	}
	
	// 자유게시판 상세화면으로 가는 맵핑
	@RequestMapping(value="/freedetail.do")
	public String FreeBoardDetail(Model model, String frNo) {
		log.info("FreeBoardDetail()실행...!");
		String boardBar = "EXITST";
		model.addAttribute("boardBar", boardBar);
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String chatuser = user.getEmp().getEmpNo();
		BoardFreeVO freeVO = freeService.selectFree(frNo);
		List<FileVO> fileVO = freeService.selectFreefilefrNo(frNo);
		List<CommentVO> commentVO = freeService.selectFreeComment(frNo);
		int likeUser = freeService.selectFreeLike(chatuser, frNo);
		if(commentVO != null) {
			for(int i = 0; i < commentVO.size(); i++) {
				String empNo = commentVO.get(i).getCmwriterEmpno();
				String name = freeService.selectUserName(empNo);
				String empPhoto = freeService.selectUserPhoto(empNo);
				commentVO.get(i).setEmpName(name);
				commentVO.get(i).setEmpPhoto(empPhoto);
				
			}
		}
		log.info("fileVO : {}", fileVO);
		log.info("commentVO : {}",commentVO);
		log.info("likeUser : {}",likeUser);
		log.info("chatuser : {}",chatuser);
		// 로그인한 사람
		model.addAttribute("comment", commentVO);
		model.addAttribute("like", likeUser);
		model.addAttribute("user", chatuser);
		model.addAttribute("free", freeVO);
		model.addAttribute("file", fileVO);
		
		return "main/board/freeDetail";
	}
	// 수정
	@RequestMapping(value = "/freeModify.do", method = RequestMethod.GET)
	public String freeBoardModifyForm(String frNo, Model model, String fileNo) {
		log.info("noticeBoardModifyForm()실행 ...!");
		String boardBar = "EXIST";
		model.addAttribute("boardBar", boardBar);
		BoardFreeVO freeVO = freeService.selectFree(frNo);
		List<FileVO> fileVO = freeService.selectFreefile(fileNo);
		log.info("fileVO : {}" , fileVO);
		model.addAttribute("free", freeVO);
		model.addAttribute("file", fileVO);
		model.addAttribute("status", "u");	// 수정 표시 응답
		
		return "main/board/freeWrite";
	}
	
	@RequestMapping(value = "/freeModify", method = RequestMethod.POST)
	public String freeBoardModify(BoardFreeVO freeVO,
								HttpServletRequest req,
								RedirectAttributes ra,
								Model model, String[] fileSec) {
		log.info("freeBoardModify()실행 ...!");
		String goPage = "";
		ServiceResult result = freeService.freeModify(req,freeVO);
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message","수정이 완료되었습니다.");
			String message = "수정이 완료되었습니다!";
			HttpSession session = req.getSession();
			session.setAttribute("message", message);
			goPage = "redirect:/freedetail.do?frNo=" + freeVO.getFrNo();
		}else {
			model.addAttribute("message", "수정에 실패했습니다.");
			model.addAttribute("freeVO", freeVO);
			model.addAttribute("status", "u");
			goPage = "redirect:/freeWrite.do";
		}
		return goPage;
	}
	@RequestMapping(value = "/freeDelete.do", method = RequestMethod.POST)
	public String freeDelete(HttpServletRequest req,
							RedirectAttributes ra,
							String frNo, Model model
							) {
		String goPage = "";
		ServiceResult result = freeService.deleteFree(req, frNo);
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("msg", "삭제가 완료되었습니다!");
			String message = "삭제가 완료되었습니다!";
			HttpSession session = req.getSession();
			session.setAttribute("message", message);
			goPage = "redirect:/freemain.do";
		}else {
			ra.addFlashAttribute("message", "서버 오류, 다시 시도해 주십시오.");
			goPage = "redirect:/freedetail.do?frNo=" + frNo;
		}
		return goPage;
	}
	/**
	 * 댓글 등록
	 * @param principal
	 * @param commentVO
	 * @return
	 */
	@PostMapping(value = "/free/comment/insert.do")
	public ResponseEntity<CommentVO> freeBoardCommentInsert(Principal principal,CommentVO commentVO){
		commentVO.setCmwriterEmpno(principal.getName());
		commentVO.setCmBoardse("FR");
		CommentVO insertComment = freeService.insertComment(commentVO);
		
		ResponseEntity<CommentVO> entity = new ResponseEntity<CommentVO>(insertComment, HttpStatus.OK);
		log.info("emtity : {}", entity);
		return entity;
	}
	
	@GetMapping(value="/free/comment/remove.do")
	public ResponseEntity<String> clubBoardCommentRemove(String cmNo) {
		freeService.removeComment(cmNo);
		
		ResponseEntity<String> entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		return entity;
	}
	
	@PostMapping(value="/free/comment/modify.do")
	public ResponseEntity<String> clubBoardCommentModify(CommentVO commentVO) {
		freeService.modifyComment(commentVO);
		
		ResponseEntity<String> entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		return entity;
	}
	
	@PostMapping(value = "/free/like/insert.do")
	public ResponseEntity<String> freeLikeinsert(Principal principal, String frNo){
		log.info("freeLikeinsert() 실행...!");
		LikeVO likeVO = new LikeVO();
		likeVO.setLikeEmpno(principal.getName());
		likeVO.setFrNo(frNo);
		freeService.likeUpCount(frNo);
		freeService.likeInsert(likeVO);
		ResponseEntity<String> entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		return entity;
	}
	
	@GetMapping(value="/free/like/remove.do")
	public ResponseEntity<String> freeLikeRemove(Principal principal, LikeVO likeVO){
		likeVO.setLikeEmpno(principal.getName());
		String frNo = likeVO.getFrNo();
		freeService.likeDownCount(frNo);
		freeService.removeLike(likeVO);
		
		ResponseEntity<String> entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		return entity;
	}
	
	@RequestMapping(value = "/freedownload.do")
	public View freeProcess(String fileNo,int fileSec, ModelMap model) {
		log.info("noticeProcess()실행...!");
		// 선택한 파일을 다운로드 하기 위한 정보를 파일번호에 해당하는 파일 정보로 얻어온다.
		FileVO fileVO = freeService.freeDownload(fileNo,fileSec);
		
		//데이터 전달자를 통해서 파일 정보를 전달하기 위한 Map 선언
		Map<String, Object> noticeFileMap = new HashMap<String, Object>();
		noticeFileMap.put("fileName", fileVO.getFileOrgname());
		noticeFileMap.put("fileNo", fileVO.getFileNo());
		noticeFileMap.put("fileSize", fileVO.getFileSize());
		noticeFileMap.put("fileSavename", fileVO.getFileSavename());
		noticeFileMap.put("fileSavepath", fileVO.getFileSavepath());
		model.addAttribute("noticeFileMap", noticeFileMap);
		
		return new NoticeDownloadView();
	}
}


















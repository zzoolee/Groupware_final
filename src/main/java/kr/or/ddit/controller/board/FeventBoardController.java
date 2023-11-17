package kr.or.ddit.controller.board;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.service.IBoardfeventService;
import kr.or.ddit.view.NoticeDownloadView;
import kr.or.ddit.vo.BoardFeventVO;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.FileVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class FeventBoardController {
	
	@Inject
	private IBoardfeventService feventService;

	// 자유게시판 리스트화면 (메인)으로 가는 맵핑
	@RequestMapping(value="/feventmain.do", method=RequestMethod.GET)
	public String feventBoard(Model model, HttpServletRequest req, HttpServletResponse resp) {
		log.info("feventBoard() 실행...!");
		String boardBar = "EXITST";
		model.addAttribute("boardBar", boardBar);
		
		HttpSession session = req.getSession();
		String message = "";
		if(session.getAttribute("message")!=null) {
			message = (String)session.getAttribute("message");
			session.removeAttribute("message");
		}
		
		List<BoardFeventVO> feventList = feventService.feventList();
		model.addAttribute("feventList", feventList);
		model.addAttribute("message", message);
		return "main/board/feventMain";
	}
	
	// 자유게시판 작성화면으로 가는 맵핑
	@RequestMapping(value="/feventwrite.do", method=RequestMethod.GET)
	public String WritefeventBoard(Model model) {
		String boardBar = "EXITST";
		model.addAttribute("boardBar", boardBar);
		return "main/board/feventWrite";
	}
	
	// 글 등록
	@RequestMapping(value = "/insertfevent", method = RequestMethod.POST)
	public String insertfevent(BoardFeventVO fevent, Model model,
							HttpServletRequest req,
							HttpServletResponse res) {
		log.info("insertfevent()실행..!");
		log.info("fevent : {}", fevent);
		String boardBar = "EXITST";
		model.addAttribute("boardBar", boardBar);
		String goPage = "";
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String chatuser = user.getEmp().getEmpNo();
		fevent.setFeWriterEmpNo(chatuser);
		feventService.insertFevent(fevent,req,res);
		goPage = "redirect:/feventmain.do";
		
		return goPage;
	}
	
	// 자유게시판 상세화면으로 가는 맵핑
	@RequestMapping(value="/feventdetail.do")
	public String feventBoardDetail(Model model, String feNo) {
		log.info("feventBoardDetail()실행...!");
		String boardBar = "EXITST";
		model.addAttribute("boardBar", boardBar);
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String chatuser = user.getEmp().getEmpNo();
		BoardFeventVO feventVO = feventService.selectfevent(feNo);
		List<FileVO> fileVO = feventService.selectfeventfilefeNo(feNo);
		List<CommentVO> commentVO = feventService.selectfeventComment(feNo);
		if(commentVO != null) {
			for(int i = 0; i < commentVO.size(); i++) {
				String empNo = commentVO.get(i).getCmwriterEmpno();
				String name = feventService.selectUserName(empNo);
				String empPhoto = feventService.selectUserPhoto(empNo);
				commentVO.get(i).setEmpName(name);
				commentVO.get(i).setEmpPhoto(empPhoto);
				
			}
		}
		log.info("fileVO : {}", fileVO);
		log.info("commentVO : {}",commentVO);
		// 로그인한 사람
		model.addAttribute("comment", commentVO);
		model.addAttribute("user", chatuser);
		model.addAttribute("fevent", feventVO);
		model.addAttribute("file", fileVO);
		
		return "main/board/feventDetail";
	}
	// 수정
	@RequestMapping(value = "/feventModify.do", method = RequestMethod.GET)
	public String feventBoardModifyForm(String feNo, Model model, String fileNo) {
		log.info("noticeBoardModifyForm()실행 ...!");
		String boardBar = "EXIST";
		model.addAttribute("boardBar", boardBar);
		BoardFeventVO feventVO = feventService.selectfevent(feNo);
		List<FileVO> fileVO = feventService.selectfeventfile(fileNo);
		log.info("fileVO : {}" , fileVO);
		model.addAttribute("fevent", feventVO);
		model.addAttribute("file", fileVO);
		model.addAttribute("status", "u");	// 수정 표시 응답
		
		return "main/board/feventWrite";
	}
	
	@RequestMapping(value = "/feventModify", method = RequestMethod.POST)
	public String feventBoardModify(BoardFeventVO feventVO,
								HttpServletRequest req,
								RedirectAttributes ra,
								Model model, String[] fileSec) {
		log.info("feventBoardModify()실행 ...!");
		String goPage = "";
		ServiceResult result = feventService.feventModify(req,feventVO);
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message","수정이 완료되었습니다.");
			String message = "수정이 완료되었습니다!";
			HttpSession session = req.getSession();
			session.setAttribute("message", message);
			goPage = "redirect:/feventdetail.do?feNo=" + feventVO.getFeNo();
		}else {
			model.addAttribute("message", "수정에 실패했습니다.");
			model.addAttribute("feventVO", feventVO);
			model.addAttribute("status", "u");
			goPage = "redirect:/feventWrite.do";
		}
		return goPage;
	}
	@RequestMapping(value = "/feventDelete.do", method = RequestMethod.POST)
	public String feventDelete(HttpServletRequest req,
							RedirectAttributes ra,
							String feNo, Model model
							) {
		String goPage = "";
		ServiceResult result = feventService.deletefevent(req, feNo);
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("msg", "삭제가 완료되었습니다!");
			goPage = "redirect:/feventmain.do";
			String message = "삭제가 완료되었습니다!";
			HttpSession session = req.getSession();
			session.setAttribute("message", message);
		}else {
			ra.addFlashAttribute("message", "서버 오류, 다시 시도해 주십시오.");
			goPage = "redirect:/feventdetail.do?feNo=" + feNo;
		}
		return goPage;
	}
	/**
	 * 댓글 등록
	 * @param principal
	 * @param commentVO
	 * @return
	 */
	@PostMapping(value = "/fevent/comment/insert.do")
	public ResponseEntity<CommentVO> feventBoardCommentInsert(Principal principal,CommentVO commentVO){
		commentVO.setCmwriterEmpno(principal.getName());
		commentVO.setCmBoardse("FE");
		
		CommentVO insertComment = feventService.insertComment(commentVO);
		ResponseEntity<CommentVO> entity = new ResponseEntity<CommentVO>(insertComment, HttpStatus.OK);
		log.info("emtity : {}", entity);
		return entity;
	}
	
	@GetMapping(value="/fevent/comment/remove.do")
	public ResponseEntity<String> feventBoardCommentRemove(String cmNo) {
		feventService.removeComment(cmNo);
		
		ResponseEntity<String> entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		return entity;
	}
	
	@PostMapping(value="/fevent/comment/modify.do")
	public ResponseEntity<String> feventBoardCommentModify(CommentVO commentVO) {
		feventService.modifyComment(commentVO);
		
		ResponseEntity<String> entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		return entity;
	}
	
	@RequestMapping(value = "/feventdownload.do")
	public View freeProcess(String fileNo,int fileSec, ModelMap model) {
		log.info("noticeProcess()실행...!");
		// 선택한 파일을 다운로드 하기 위한 정보를 파일번호에 해당하는 파일 정보로 얻어온다.
		FileVO fileVO = feventService.feventDownload(fileNo,fileSec);
		
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


















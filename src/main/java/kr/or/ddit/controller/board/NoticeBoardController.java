package kr.or.ddit.controller.board;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.controller.util.MediaUtils;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.service.IBoardNoticeService;
import kr.or.ddit.view.NoticeDownloadView;
import kr.or.ddit.vo.BoardNoticeVO;
import kr.or.ddit.vo.FileVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class NoticeBoardController {
	
	@Inject
	private IBoardNoticeService noticeService;
	
	
	// 메인 화면 게시글 전체 조회
	@RequestMapping(value="/noticemain.do", method=RequestMethod.GET)
	public String NoticeBoard(Model model) {
		log.info("NoticeBoard() 실행...!");
		String boardBar = "EXIST";
		model.addAttribute("boardBar", boardBar);
		
		List<BoardNoticeVO> noticeList = noticeService.noticeList();
		model.addAttribute("noticeList", noticeList);
		return "main/board/noticeMain";
	}
	
	// 글 등록
	@RequestMapping(value = "/insertNotice", method = RequestMethod.POST)
	public String insertNotice(BoardNoticeVO notice, 
			Model model,
			HttpServletRequest req,
			HttpServletResponse res) {
		log.info("NoticeBoard() 실행...!");
		String boardBar = "EXIST";
		model.addAttribute("boardBar", boardBar);
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String chatuser = user.getEmp().getEmpNo();
		String goPage = "";
		notice.setNoWriterEmpNo(chatuser);
		noticeService.insertNotice(notice,req,res);
		goPage = "redirect:/noticemain.do";
		
		return goPage;
	}
	// 상세 보기
	@RequestMapping(value="/noticedetail.do")
	public String NoticeBoardDetail(Model model, String noNo) {
		log.info("NoticeBoardDetail() 실행....!");
		String boardBar = "EXIST";
		model.addAttribute("boardBar", boardBar);
		CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String chatuser = user.getEmp().getEmpNo();
		BoardNoticeVO noticeVO = noticeService.selectNotice(noNo);
		List<FileVO> fileVO = noticeService.selectNoticefilenoNO(noNo);
		// 로그인한 사람
		model.addAttribute("user", chatuser);
		model.addAttribute("notice", noticeVO);
		model.addAttribute("file", fileVO);
		return "main/board/noticeDetail";
	}
	// 수정
	@RequestMapping(value = "/noticeModify.do", method = RequestMethod.GET)
	public String noticeBoardModifyForm(String noNo, Model model, String fileNo) {
		log.info("noticeBoardModifyForm()실행 ...!");
		String boardBar = "EXIST";
		model.addAttribute("boardBar", boardBar);
		BoardNoticeVO noticeVO = noticeService.selectNotice(noNo);
		List<FileVO> fileVO = noticeService.selectNoticefile(fileNo);
		log.info("fileVO : {}" , fileVO);
		model.addAttribute("notice", noticeVO);
		model.addAttribute("file", fileVO);
		model.addAttribute("status", "u");	// 수정 표시 응답
		
		return "main/board/noticeWrite";
	}
	
	@RequestMapping(value = "/noticeModify", method = RequestMethod.POST)
	public String noticeBoardModify(BoardNoticeVO noticeVO, 
									HttpServletRequest req,
									RedirectAttributes ra,
									Model model, String[] fileSec) {
		log.info("noticeBoardModify()실행 ...!");
		String goPage = "";
		ServiceResult result = noticeService.NoticeModify(req,noticeVO);
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message","수정이 완료되었습니다.");
			goPage = "redirect:/noticedetail.do?noNo=" + noticeVO.getNoNo();
		}else {
			model.addAttribute("message", "수정에 실패했습니다.");
			model.addAttribute("notice", noticeVO);
			model.addAttribute("status", "u");
			goPage = "redirect:/noticeWrite.do";
		}
		return goPage;
	}
	@RequestMapping(value = "/noticeDelte.do", method = RequestMethod.POST)
	public String noticeDelete(HttpServletRequest req,
								RedirectAttributes ra,
								String noNo, Model model
								) {
		String goPage = "";
		ServiceResult result = noticeService.deleteNotice(req, noNo);
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "삭제가 완료되었습니다!");
			goPage = "redirect:/noticemain.do";
		}else {
			ra.addFlashAttribute("message", "서버 오류, 다시 시도해 주십시오.");
			goPage = "redirect:/noticedetail.do?noNo=" + noNo;
		}
		return goPage;
	}
	
//	@RequestMapping(value = "/noticedownload.do")
//	public ResponseEntity<byte[]> fileDownload(int fileSec, HttpServletRequest req) throws IOException{
//		InputStream in = null;
//		ResponseEntity<byte[]> entity = null;
//		
//		String fileName = null;
//		FileVO fileVO = noticeService.selectFileInfo(fileSec);
//		
//		if(fileVO != null) {
//			fileName = fileVO.getFileOrgname();
//			try {
//				String formatName = fileVO.getFileType();
//				MediaType mType = MediaUtils.getMediaType(formatName);
//				HttpHeaders headers = new HttpHeaders();
//				in = new FileInputStream(req.getServletContext().getRealPath("/resources/upload/club/board/")+fileVO.getFileSavename());
//				
//				if(mType != null) {
//					headers.setContentType(mType);
//				}else {
//					fileName = fileName.substring(fileName.lastIndexOf("_") + 1);
//					headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
//					headers.add("Content-Disposition", "attachment; filename=\"" +
//							new String(fileName.getBytes("UTF-8"), "ISO-8859-1") + "\"");
//				}
//				entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
//			}catch(Exception e) {
//				e.printStackTrace();
//				entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
//			}finally {
//				if(in != null) {
//					in.close();
//				}
//			}
//		}else {
//			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
//		}
//		return entity;
//	}
	@RequestMapping(value = "/noticedownload.do")
	public View noticeProcess(String fileNo,int fileSec, ModelMap model) {
		log.info("noticeProcess()실행...!");
		// 선택한 파일을 다운로드 하기 위한 정보를 파일번호에 해당하는 파일 정보로 얻어온다.
		FileVO fileVO = noticeService.noticeDownload(fileNo,fileSec);
		
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
	
	
	
	
	/*
	 * 관리자용
	 */
	
	@RequestMapping(value="/noticewrite.do", method=RequestMethod.GET)
	public String WriteNoticeBoard(Model model) {
		String boardBar = "EXIST";
		model.addAttribute("boardBar", boardBar);
		return "main/board/noticeWrite";
	}

}

package kr.or.ddit.controller.files;


import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.IFileService;
import kr.or.ddit.vo.FolderFileVO;
import kr.or.ddit.vo.FolderVO;

@Controller
public class impFileController {
	
	@Inject
	private IFileService service;
	
	private void setFileBar(Model model) {
		String fileBar = "EXIST";
		model.addAttribute("fileBar", fileBar);
	}
	
	private void setFileBar4(Model model) {
		String fileBar = "EXIST";
		model.addAttribute("fileBar4", fileBar);
	}
	
	// 개인자료실로 이동
	@RequestMapping(value="/impfiles.do", method=RequestMethod.GET)
	public String ImpFiles(Model model, HttpServletRequest req, HttpServletResponse resp) {
		
		// 파일을 업로드하지 않고 순수 get방식으로 접근했을때 처음위치를 보여주는 로직.
		FolderVO folderVO = new FolderVO();
		
		List<FolderFileVO> fileList = new ArrayList<FolderFileVO>();
		
		HttpSession session = req.getSession();
		String sessionInfo = (String)session.getAttribute("DATE");
		session.removeAttribute("DATE");
		if(sessionInfo == null) {
			fileList = service.showImpFiles(folderVO);
		} else {
			fileList = service.showImpFilesDate(folderVO);
		}
		
		model.addAttribute("fileList", fileList);
		setFileBar(model);
		setFileBar4(model);
		return "main/files/importantFiles";
	}
	
	@RequestMapping(value="/impFileDownload.do", method=RequestMethod.GET)
	public ResponseEntity<byte[]> impFileDownload(
			String submitFileCd,
			HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ResponseEntity<byte[]> entity = service.fileDownload(
				submitFileCd, request, response);
		
		return entity;
	}
	
	// 폴더배열과, 파일의배열을받고, req, resp을 이용하여 경로작업 후,
	// 알집데이터를 responseEntity값으로 ajax에 반환하는 컨트롤러.
	@RequestMapping(value="impFileAlzip.do", method=RequestMethod.POST)
	public ResponseEntity<byte[]> impAlzipDownload(
			@RequestParam List<String> folderArray, 
			@RequestParam List<String> fileArray,
			HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		
		return service.alzipDownload(folderArray, fileArray, request, response);
	}
	
	// 파일Cd값으로 좋아요를 업데이트 해줄 서비스로 보낸후 ajax로 리턴하는 컨트롤러.
	@ResponseBody
	@RequestMapping(value="impUpdateLikeSeAjax.do", method=RequestMethod.POST)
	public Map<String, Object> impUpdateLikeSeAjax(
				@RequestBody Map<String, Object> param){
		return service.impUpdateLikeSe(param);
	}
	
	// 파일의Cd값으로 파일 전체값을 리턴시켜줄 ajax 컨트롤러 로직.
	@ResponseBody
	@RequestMapping(value="impImageFileInfoAjax.do", method=RequestMethod.POST)
	public Map<String, FolderFileVO> impImageFileInfoAjax(
			@RequestBody Map<String, Object> param){
		return service.imageFileInfoAjax(param);
	}
	
	@RequestMapping(value="impFileDelete.do", method=RequestMethod.POST)
	public String impFileDelete(@RequestParam List<String> folderArray,
					@RequestParam List<String> fileArray, String folderParent,
					 HttpServletRequest req, HttpServletResponse resp) {
		service.deletefile(folderArray, fileArray, folderParent, req, resp);
		return "redirect:/impfiles.do";
	}
	
	@ResponseBody
	@RequestMapping(value="impSearchAjax.do", method=RequestMethod.POST)
	public Map<String, Object> impSearchAjax(@RequestBody Map<String, String> param){
		System.out.println("도착함");
		return service.impSearchText(param);
	}
	
	@RequestMapping(value="/impSelectChildFileDate.do", method=RequestMethod.POST)
	public String impSelectChildFileDate(FolderVO folderVO,
			HttpServletRequest req, HttpServletResponse resp) {
		HttpSession session = req.getSession();
		session.setAttribute("folderCd", folderVO.getFolderParent());
		session.setAttribute("orderBy", "DATE");
		return "redirect:/impfiles.do";
	}
	
	@RequestMapping(value="/impSelectChildFileBasic.do", method=RequestMethod.POST)
	public String impSelectChildFileBasic(FolderVO folderVO,
			HttpServletRequest req, HttpServletResponse resp) {
		HttpSession session = req.getSession();
		session.setAttribute("folderCd", folderVO.getFolderParent());
		return "redirect:/impfiles.do";
	}
	
	@RequestMapping(value="/impSelectUnlike.do", method=RequestMethod.POST)
	public String impSelectUnlike(@RequestParam List<String> fileArray) {
		return service.impSelectUnlike(fileArray);
	}
	
	@RequestMapping(value="/showImpFilesDate.do", method=RequestMethod.POST)
	public String showImpFilesDate(HttpServletRequest req, HttpServletResponse resp) {
		HttpSession session = req.getSession();
		session.setAttribute("DATE", "자바에몽 시간순으로 정렬해줘!!!");
		return "redirect:/impfiles.do";
	}
	
}



//성민형님 화이팅입니다,,,,,,,, 목이 뻐근할 때에는 Isolation을 합시다.....

























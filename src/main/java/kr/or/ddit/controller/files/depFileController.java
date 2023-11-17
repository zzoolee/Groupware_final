package kr.or.ddit.controller.files;


import java.io.File;
import java.io.FileNotFoundException;
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

import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.service.IFileService;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FolderFileVO;
import kr.or.ddit.vo.FolderVO;

@Controller
public class depFileController {
	
	@Inject
	private IFileService service;
	
	@Inject
	private EmpMapper empMapper;
	
	
	
	private void setFileBar(Model model) {
		String fileBar = "EXIST";
		model.addAttribute("fileBar", fileBar);
	}
	
	private void setFileBar2(Model model) {
		String fileBar = "EXIST";
		model.addAttribute("fileBar2", fileBar);
	}
	
	
	private String UserDepFind() {
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		UserDetails userDetails = (UserDetails)principal;
		String empNo = userDetails.getUsername();
		
		EmpVO userDep = empMapper.readByUserId(empNo);
		String dep = userDep.getDeptCd();
		
		return dep; 
	}
	
	// 개인자료실로 이동
	@RequestMapping(value="/depfiles.do", method=RequestMethod.GET)
	public String depFiles(Model model, HttpServletRequest req, HttpServletResponse resp) {
		
		// 파일을 업로드하고 업로드한 위치로 돌려주는 로직
		HttpSession session = req.getSession();
		
		String folderCd = "";
		String dup = "";
		String fileDup = "";
		String orderBy = "";
		String shareDup = "";
		
		System.out.println(req.getSession().getAttribute("folderCd"));
		if(session==null) {
		}else {
			folderCd = (String)session.getAttribute("folderCd");
			dup = (String)session.getAttribute("dup");
			fileDup = (String)session.getAttribute("fileDup");
			orderBy = (String)session.getAttribute("orderBy");
			shareDup = (String)session.getAttribute("shareDup");
			String deleteMessage = (String)session.getAttribute("deleteMessage");
	         
	        session.removeAttribute("deleteMessage");
			session.removeAttribute("shareDup");
			session.removeAttribute("orderBy");
			session.removeAttribute("fileDup");
			session.removeAttribute("folderCd");
			session.removeAttribute("dup");
			
			if(folderCd==null || folderCd.equals("")) {
			}else {
				List<FolderVO> childFolder = new ArrayList<FolderVO>();
				List<FolderFileVO> childFile = new ArrayList<FolderFileVO>();
				FolderVO folderVO = new FolderVO();
				folderVO.setFolderCd(folderCd);
				
				Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
				UserDetails userDetails = (UserDetails)principal;
				String empNo = userDetails.getUsername();
				
				EmpVO userDep = empMapper.readByUserId(empNo);
				String dep = userDep.getDeptCd();
				
				String back = "";
	      	    
	      	    FolderVO folderInfo = service.selectMyselfFolder(folderVO);
	      	    System.out.print("get방식에서 foderVO의 값 : ");
	      	    System.out.println(folderInfo.getFolderPath());
	      	    
	      	  if(folderInfo.getFolderPath() != null) {
	      	    	System.out.println("널이아니다.");
	      	    	if(!folderInfo.getFolderPath().equals(req.getServletContext().getRealPath("/resources/file/")+dep)) {
	      	    		System.out.println("다른값.");
	      	    		back = "BackButtonOn";
	      	    	}else {
	      	    		System.out.println("같은값.");
	      	    	}
	      	    }

				if(orderBy != null) {
					childFolder = service.selectChildFolderDate(folderVO);
					childFile = service.selectChildFileDate(folderVO);
				}else {
					childFolder = service.selectChildFolder(folderVO);
					childFile = service.selectChildFile(folderVO);
				}
				
				String context = req.getServletContext().getRealPath("/resources/file/"+UserDepFind());
	            String contextReplace = context.replace("\\", "/");
	            System.out.print("contextReplace : ");
	            System.out.println(contextReplace);
	            String folderOwn = folderInfo.getFolderPath();
	            System.out.print("folderOwn : ");
	            System.out.println(folderOwn);
	            String folderOwnReplace = folderOwn.replace("\\", "/");
	            System.out.print("folderOwnReplace : ");
	            System.out.println(folderOwnReplace);
	            String resPath = folderOwnReplace.replace(contextReplace, "");
	            System.out.print("resPath : ");
	            System.out.println(resPath);
	            folderVO.setFolderOwnPath(resPath);
				
	            model.addAttribute("deleteMessage", deleteMessage);
	            model.addAttribute("shareDup", shareDup);
	            model.addAttribute("back", back);
				model.addAttribute("fileDup", fileDup);
				model.addAttribute("folderDup", dup);
				model.addAttribute("fileList", childFile);
				model.addAttribute("FolderList", childFolder);
				model.addAttribute("parentCd", folderVO);
				setFileBar(model);
				setFileBar2(model);
				return "main/files/departmentFiles";
			}
		}
		
		// 파일을 업로드하지 않고 순수 get방식으로 접근했을때 처음위치를 보여주는 로직.
		FolderVO folderVO = new FolderVO();
		
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		UserDetails userDetails = (UserDetails)principal;
		String empNo = userDetails.getUsername();
		
		EmpVO empVO = empMapper.readByUserId(empNo);
		String userDept = empVO.getDeptCd();
		System.out.println("유저 부서번호 : "+userDept);
		
		String fileSavepath = req.getServletContext().getRealPath("/"+"resources"+"/"+"file")+"/"+userDept;
		System.out.println(fileSavepath);
		
		File filePath = new File(fileSavepath);
		
		if(!filePath.exists()) {
			filePath.mkdirs();
			
		}
		folderVO.setEmpNo(empNo);
		folderVO.setFolderCd(userDept);
		folderVO.setFolderPath(req.getServletContext().getRealPath("/resources/file/"+userDept));
		
		if(service.selectDefaultDepFolder(folderVO) < 1) {
			service.insertDefaultDepFolder(folderVO);
		}
		
		System.out.println("디폴트 폴더 가져오기");
		folderVO = service.selectDepFolder(folderVO);
		System.out.print("폴더보 : ");
		System.out.println(folderVO);
		System.out.println("디폴트폴더 차일드 가져오기");
		List<FolderVO> FolderList = service.selectChildFolder(folderVO);
		List<FolderFileVO> childFile = service.selectChildFile(folderVO);
		
		String context = req.getServletContext().getRealPath("/resources/file/"+UserDepFind());
        String contextReplace = context.replace("\\", "/");
        System.out.print("contextReplace : ");
        System.out.println(contextReplace);
        String folderOwn = folderVO.getFolderPath();
        System.out.print("folderOwn : ");
        System.out.println(folderOwn);
        String folderOwnReplace = folderOwn.replace("\\", "/");
        System.out.print("folderOwnReplace : ");
        System.out.println(folderOwnReplace);
        String resPath = folderOwnReplace.replace(contextReplace, "");
        System.out.print("resPath : ");
        System.out.println(resPath);
        folderVO.setFolderOwnPath(resPath);
        
        String deleteMessage = (String)session.getAttribute("deleteMessage");
        
        session.removeAttribute("deleteMessage");
        
        model.addAttribute("deleteMessage", deleteMessage);
        model.addAttribute("shareDup", shareDup);
		model.addAttribute("fileDup", fileDup);
		model.addAttribute("folderDup", dup);
		model.addAttribute("fileList", childFile);
		model.addAttribute("parentCd", folderVO);
		model.addAttribute("FolderList",FolderList);
		setFileBar(model);
		setFileBar2(model);
		
		return "main/files/departmentFiles";
	}
	
	// POST로 데이터를 받아 폴더안쪽으로 이동
	@RequestMapping(value="/depfiles.do", method=RequestMethod.POST)
	public String depFiles(Model model, FolderVO folderVO,
			 HttpServletRequest req, HttpServletResponse resps) {
		
		
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		UserDetails userDetails = (UserDetails)principal;
		String empNo = userDetails.getUsername();
		
		EmpVO userDep = empMapper.readByUserId(empNo);
		String dep = userDep.getDeptCd();
		
		String back = "";
		
		FolderVO folderInfo = service.selectMyselfFolder(folderVO);
		List<FolderVO> childFolder = service.selectChildFolder(folderVO);
		List<FolderFileVO> childFile = service.selectChildFile(folderVO);
			
		if(!folderInfo.getFolderPath().equals(req.getServletContext().getRealPath("/resources/file/")+dep)) {
			back = "BackButtonOn";
		}
		
		String context = req.getServletContext().getRealPath("/resources/file/"+UserDepFind());
        String contextReplace = context.replace("\\", "/");
        System.out.print("contextReplace : ");
        System.out.println(contextReplace);
        String folderOwn = folderInfo.getFolderPath();
        System.out.print("folderOwn : ");
        System.out.println(folderOwn);
        String folderOwnReplace = folderOwn.replace("\\", "/");
        System.out.print("folderOwnReplace : ");
        System.out.println(folderOwnReplace);
        String resPath = folderOwnReplace.replace(contextReplace, "");
        System.out.print("resPath : ");
        System.out.println(resPath);
        folderVO.setFolderOwnPath(resPath);
        
		model.addAttribute("back", back);
		model.addAttribute("fileList", childFile);
		model.addAttribute("FolderList", childFolder);
		model.addAttribute("parentCd", folderVO);
		setFileBar(model);
		setFileBar2(model);
		return "main/files/departmentFiles";
	}
	
	// POST로 폴더이름을 받아 폴더생성.
	@RequestMapping(value="/insertDepFileFolder.do", method=RequestMethod.POST)
	public String insertDepFileFolder(
			FolderVO folderVO, 
			Model model, 
			HttpServletRequest req, HttpServletResponse resp) {
		service.insertDepFolder(folderVO , req, resp);
		return "redirect:/depfiles.do";	
	}
	
	// POST로 파일이름과 형태를 멀티파일형태로 받아 형태저장.
	@RequestMapping(value="/insertDepFileFile.do", method=RequestMethod.POST)
	public String insertdepFileFile(
			FolderVO folderVO,
			Model model,
			HttpServletRequest req, HttpServletResponse resp) throws IOException {
		
		service.insertDepFile(folderVO, req, resp);
		
		return "redirect:/depfiles.do";
	}
	
	@RequestMapping(value="/depFileDownload.do", method=RequestMethod.GET)
	public ResponseEntity<byte[]> depFileDownload(
			String submitFileCd,
			HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ResponseEntity<byte[]> entity = service.fileDownload(
				submitFileCd, request, response);
		
		return entity;
	}
	
	// 폴더배열과, 파일의배열을받고, req, resp을 이용하여 경로작업 후,
	// 알집데이터를 responseEntity값으로 ajax에 반환하는 컨트롤러.
	@RequestMapping(value="/depFileAlzip.do", method=RequestMethod.POST)
	public ResponseEntity<byte[]> depAlzipDownload(
			@RequestParam List<String> folderArray, 
			@RequestParam List<String> fileArray,
			HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		
		return service.alzipDownload(folderArray, fileArray, request, response);
	}
	
	// 파일의Cd값으로 파일 전체값을 리턴시켜줄 ajax 컨트롤러 로직.
	@ResponseBody
	@RequestMapping(value="/depImageFileInfoAjax.do", method=RequestMethod.POST)
	public Map<String, FolderFileVO> depImageFileInfoAjax(
			@RequestBody Map<String, Object> param){
		return service.imageFileInfoAjax(param);
	}
	
	@RequestMapping(value="/depFileDelete.do", method=RequestMethod.POST)
	public String depFileDelete(@RequestParam List<String> folderArray,
					@RequestParam List<String> fileArray, String folderParent,
					 HttpServletRequest req, HttpServletResponse resp) {
		service.deletefile(folderArray, fileArray, folderParent, req, resp);
		return "redirect:/depfiles.do";
	}
	
	@ResponseBody
	@RequestMapping(value="/depSearchAjax.do", method=RequestMethod.POST)
	public Map<String, Object> depSearchAjax(@RequestBody Map<String, String> param){
		System.out.println("도착함");
		return service.searchText(param);
	}
	
	@RequestMapping(value="/depSelectChildFileDate.do", method=RequestMethod.POST)
	public String depSelectChildFileDate(FolderVO folderVO,
			HttpServletRequest req, HttpServletResponse resp) {
		HttpSession session = req.getSession();
		session.setAttribute("folderCd", folderVO.getFolderParent());
		session.setAttribute("orderBy", "DATE");
		return "redirect:/depfiles.do";
	}
	
	@RequestMapping(value="/depSelectChildFileBasic.do", method=RequestMethod.POST)
	public String depSelectChildFileBasic(FolderVO folderVO,
			HttpServletRequest req, HttpServletResponse resp) {
		HttpSession session = req.getSession();
		session.setAttribute("folderCd", folderVO.getFolderParent());
		return "redirect:/depfiles.do";
	}
	
	@RequestMapping(value="/depShare.do", method=RequestMethod.POST)
	public String depShare(@RequestParam List<String> folderArray,
						   @RequestParam List<String> fileArray,
						   HttpServletRequest req, HttpServletResponse resp) throws IOException {
		service.fileShare(folderArray, fileArray, req, resp);
		return "redirect:/depfiles.do";
	}
	
	@RequestMapping(value="/depSelectBack.do", method=RequestMethod.POST)
	   public String depSelectBack(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) {
		   
		   FolderVO grandParentVO = new FolderVO();
		   FolderVO parentVO = new FolderVO();
		   parentVO.setFolderCd(folderVO.getFolderParent());
		   parentVO = service.selectMyselfFolder(parentVO);
		   grandParentVO.setFolderCd(parentVO.getFolderParent());
		   grandParentVO = service.selectMyselfFolder(grandParentVO);
		   
		   HttpSession session = req.getSession();
		   session.setAttribute("folderCd", grandParentVO.getFolderCd());
		   
		   return "redirect:/depfiles.do";
	   }
	
	
	// 개인자료실로 이동
		@RequestMapping(value="/depfilesAdmin.do", method=RequestMethod.GET)
		public String depFilesAdmin(Model model, HttpServletRequest req, HttpServletResponse resp) {
			
			return "main/files/departmentFiles";
		}
}




























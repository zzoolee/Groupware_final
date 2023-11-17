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

import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.service.IFileService;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FolderFileVO;
import kr.or.ddit.vo.FolderVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class comFileController {
	
	@Inject
	private IFileService service;
	
	@Inject
	private EmpMapper empMapper;
	
	
	
	private void setFileBar(Model model) {
		String fileBar = "EXIST";
		model.addAttribute("fileBar", fileBar);
	}
	
	private void setFileBar1(Model model) {
		String fileBar = "EXIST";
		model.addAttribute("fileBar1", fileBar);
	}
	
	private String company = "IWORKS";
	
	// 전사자료실로 이동
	@RequestMapping(value="/comfiles.do", method=RequestMethod.GET)
	public String comFiles(Model model, HttpServletRequest req, HttpServletResponse resp) {
		
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
			
			log.info("폴더 cd : {}", folderCd);
			
			if(folderCd==null || folderCd.equals("")) {
			}else if(folderCd != null){
				List<FolderVO> childFolder = new ArrayList<FolderVO>();
				List<FolderFileVO> childFile = new ArrayList<FolderFileVO>();
				FolderVO folderVO = new FolderVO();
				folderVO.setFolderCd(folderCd);
				
				String back = "";
	      	    
	      	    FolderVO folderInfo = service.selectMyselfFolder(folderVO);
	      	    
	      	  if(folderInfo.getFolderPath() != null) {
	      	    	System.out.println("널이아니다.");
	      	    	if(!folderInfo.getFolderPath().equals(req.getServletContext().getRealPath("/resources/file/")+company)) {
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
				
				
				String context = req.getServletContext().getRealPath("/resources/file/"+company);
		        String contextReplace = context.replace("\\", "/");
		        String folderOwn = folderInfo.getFolderPath();
		        String folderOwnReplace = folderOwn.replace("\\", "/");
		        String resPath = folderOwnReplace.replace(contextReplace, "");
		        folderVO.setFolderOwnPath(resPath);
				
		        model.addAttribute("deleteMessage", deleteMessage);
				model.addAttribute("back", back);
				model.addAttribute("fileDup", fileDup);
				model.addAttribute("folderDup", dup);
				model.addAttribute("fileList", childFile);
				model.addAttribute("FolderList", childFolder);
				model.addAttribute("parentCd", folderVO);
				setFileBar(model);
				setFileBar1(model);
				return "main/files/comFiles";
			}
		}
		
		// 파일을 업로드하지 않고 순수 get방식으로 접근했을때 처음위치를 보여주는 로직.
		FolderVO folderVO = new FolderVO();
		
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		UserDetails userDetails = (UserDetails)principal;
		String empNo = userDetails.getUsername();
		
		EmpVO empVO = empMapper.readByUserId(empNo);
		String company = "IWORKS";
		System.out.println("회사 : "+company);
		
		String fileSavepath = req.getServletContext().getRealPath("/"+"resources"+"/"+"file")+"/"+company;
		System.out.println(fileSavepath);
		
		File filePath = new File(fileSavepath);
		
		if(!filePath.exists()) {
			filePath.mkdirs();
			
		}
		folderVO.setEmpNo(empNo);
		folderVO.setFolderSe(company);
		folderVO.setFolderPath(req.getServletContext().getRealPath("/resources/file/"+company));
		
		if(service.selectDefaultComFolder(folderVO) < 1) {
			service.insertDefaultComFolder(folderVO);
		}
		
		System.out.println("디폴트 폴더 가져오기");
		folderVO = service.selectComFolder(folderVO);
		System.out.print("폴더보 : ");
		System.out.println(folderVO);
		System.out.println("디폴트폴더 차일드 가져오기");
		List<FolderVO> FolderList = service.selectChildFolder(folderVO);
		List<FolderFileVO> childFile = service.selectChildFile(folderVO);
		
		String context = req.getServletContext().getRealPath("/resources/file/"+company);
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
		setFileBar1(model);
		
		return "main/files/comFiles";
	}
	
	// POST로 데이터를 받아 폴더안쪽으로 이동
	@RequestMapping(value="/comfiles.do", method=RequestMethod.POST)
	public String comFiles(Model model, FolderVO folderVO,
			 HttpServletRequest req, HttpServletResponse resps) {
		
		List<FolderVO> childFolder = service.selectChildFolder(folderVO);
		List<FolderFileVO> childFile = service.selectChildFile(folderVO);
		
		String back = "";
  	    
  	    FolderVO folderInfo = service.selectMyselfFolder(folderVO);
  	    System.out.print("get방식에서 foderVO의 값 : ");
  	    System.out.println(folderInfo.getFolderPath());

  	    if(!folderInfo.getFolderPath().equals(req.getServletContext().getRealPath("/resources/file/")+company)) {
  	    	back = "BackButtonOn";
  	    }
  	    
  	  String context = req.getServletContext().getRealPath("/resources/file/"+company);
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
		setFileBar1(model);
		return "main/files/comFiles";
	}
	
	// POST로 폴더이름을 받아 폴더생성.
	@RequestMapping(value="/insertComFileFolder.do", method=RequestMethod.POST)
	public String insertComFileFolder(
			FolderVO folderVO, 
			Model model, 
			HttpServletRequest req, HttpServletResponse resp) {
		service.insertComFolder(folderVO , req, resp);
		return "redirect:/comfiles.do";	
	}
	
	// POST로 파일이름과 형태를 멀티파일형태로 받아 형태저장.
	@RequestMapping(value="/insertComFileFile.do", method=RequestMethod.POST)
	public String insertcomFileFile(
			FolderVO folderVO,
			Model model,
			HttpServletRequest req, HttpServletResponse resp) throws IOException {
		
		service.insertComFile(folderVO, req, resp);
		
		return "redirect:/comfiles.do";
	}
	
	@RequestMapping(value="/comFileDownload.do", method=RequestMethod.GET)
	public ResponseEntity<byte[]> comFileDownload(
			String submitFileCd,
			HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ResponseEntity<byte[]> entity = service.fileDownload(
				submitFileCd, request, response);
		
		return entity;
	}
	
	// 폴더배열과, 파일의배열을받고, req, resp을 이용하여 경로작업 후,
	// 알집데이터를 responseEntity값으로 ajax에 반환하는 컨트롤러.
	@RequestMapping(value="/comFileAlzip.do", method=RequestMethod.POST)
	public ResponseEntity<byte[]> comAlzipDownload(
			@RequestParam List<String> folderArray, 
			@RequestParam List<String> fileArray,
			HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		
		return service.alzipDownload(folderArray, fileArray, request, response);
	}
	
	// 파일의Cd값으로 파일 전체값을 리턴시켜줄 ajax 컨트롤러 로직.
	@ResponseBody
	@RequestMapping(value="/comImageFileInfoAjax.do", method=RequestMethod.POST)
	public Map<String, FolderFileVO> comImageFileInfoAjax(
			@RequestBody Map<String, Object> param){
		return service.imageFileInfoAjax(param);
	}
	
	@RequestMapping(value="/comFileDelete.do", method=RequestMethod.POST)
	public String comFileDelete(@RequestParam List<String> folderArray,
					@RequestParam List<String> fileArray, String folderParent,
					 HttpServletRequest req, HttpServletResponse resp) {
		service.deletefile(folderArray, fileArray, folderParent, req, resp);
		
		String appr = req.getParameter("appr");
		if(appr != null) {
			if(appr.equals("appr")) {
				return "redirect:/comFileAppr.do";
			}
		}
		return "redirect:/comfiles.do";
	}
	
	@ResponseBody
	@RequestMapping(value="/comSearchAjax.do", method=RequestMethod.POST)
	public Map<String, Object> comSearchAjax(@RequestBody Map<String, String> param){
		System.out.println("도착함");
		return service.searchText(param);
	}
	
	@RequestMapping(value="/comSelectChildFileDate.do", method=RequestMethod.POST)
	public String comSelectChildFileDate(FolderVO folderVO,
			HttpServletRequest req, HttpServletResponse resp) {
		HttpSession session = req.getSession();
		session.setAttribute("folderCd", folderVO.getFolderParent());
		session.setAttribute("orderBy", "DATE");
		return "redirect:/comfiles.do";
	}
	
	@RequestMapping(value="/comSelectChildFileBasic.do", method=RequestMethod.POST)
	public String comSelectChildFileBasic(FolderVO folderVO,
			HttpServletRequest req, HttpServletResponse resp) {
		HttpSession session = req.getSession();
		session.setAttribute("folderCd", folderVO.getFolderParent());
		return "redirect:/comfiles.do";
	}
	
	@RequestMapping(value="/comShare.do", method=RequestMethod.POST)
	public String comShare(@RequestParam List<String> folderArray,
						   @RequestParam List<String> fileArray,
						   HttpServletRequest req, HttpServletResponse resp) throws IOException {
		service.fileShare(folderArray, fileArray, req, resp);
		return "redirect:/comfiles.do";
	}
	
	@RequestMapping(value="/comSelectBack.do", method=RequestMethod.POST)
	   public String comSelectBack(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) {
		   
		   FolderVO grandParentVO = new FolderVO();
		   FolderVO parentVO = new FolderVO();
		   parentVO.setFolderCd(folderVO.getFolderParent());
		   parentVO = service.selectMyselfFolder(parentVO);
		   grandParentVO.setFolderCd(parentVO.getFolderParent());
		   grandParentVO = service.selectMyselfFolder(grandParentVO);
		   
		   HttpSession session = req.getSession();
		   session.setAttribute("folderCd", grandParentVO.getFolderCd());
		   
		   return "redirect:/comfiles.do";
	   }
	
	@RequestMapping(value="/comFileAppr.do", method=RequestMethod.GET)
	public String comFileAppr(Model model
			, HttpServletRequest req, HttpServletResponse resp) {
		List<FolderFileVO> fileList = new ArrayList<FolderFileVO>();
		fileList = service.selectAppr();
		
		if(fileList != null) {
			for(int i = 0; i < fileList.size(); i++) {
				String filePath = fileList.get(i).getFileSavepath();
				String basicPath = "resources/file/IWORKS/";
				String showingPath = filePath.replace(basicPath, "전사자료실/");
				fileList.get(i).setFileSavepath(showingPath);
			}
		}
		
		HttpSession session = req.getSession();
		String deleteMessage = (String)session.getAttribute("deleteMessage");
		session.removeAttribute("deleteMessage");
		
		model.addAttribute("deleteMessage",deleteMessage);
		model.addAttribute("fileList", fileList);
		setFileBar(model);
		setFileBar1(model);
		return "main/files/comFilesAppr";
	}
}



































//성민형님 화이팅입니다,,,,,,,, 목이 뻐근할 때에는 Isolation을 합시다.....

























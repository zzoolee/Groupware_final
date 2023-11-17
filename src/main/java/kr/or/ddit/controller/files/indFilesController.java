package kr.or.ddit.controller.files;


import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.server.authentication.HttpBasicServerAuthenticationEntryPoint;
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
public class indFilesController {
   
   @Inject
   private IFileService service;
   
   private void setFileBar(Model model) {
      String fileBar = "EXIST";
      model.addAttribute("fileBar", fileBar);
   }
   
   private void setFileBar3(Model model) {
	      String fileBar = "EXIST";
	      model.addAttribute("fileBar3", fileBar);
	   }
   
   // 개인자료실로 이동
   @RequestMapping(value="/indfiles.do", method=RequestMethod.GET)
   public String IndividualFiles(Model model, HttpServletRequest req, HttpServletResponse resp) {
      
      // 파일을 업로드하고 업로드한 위치로 돌려주는 로직
      HttpSession session = req.getSession();
      System.out.println(req.getSession().getAttribute("folderCd"));
      if(session==null) {
      }else {
         String folderCd = (String)session.getAttribute("folderCd");
         String dup = (String)session.getAttribute("dup");
         String fileDup = (String)session.getAttribute("fileDup");
         String orderBy = (String)session.getAttribute("orderBy");
         String deleteMessage = (String)session.getAttribute("deleteMessage");
         
         session.removeAttribute("deleteMessage");
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
      	    String back = "";
      	    
      	    FolderVO folderInfo = service.selectMyselfFolder(folderVO);
      	    System.out.print("get방식에서 foderVO의 값 : ");
      	    System.out.println(folderInfo.getFolderPath());
      	    
      	    if(folderInfo.getFolderPath() != null) {
      	    	System.out.println("널이아니다.");
      	    	if(!folderInfo.getFolderPath().equals(req.getServletContext().getRealPath("/resources/file/")+empNo)) {
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
            
            String context = req.getServletContext().getRealPath("/resources/file/"+empNo);
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
            model.addAttribute("back", back);
            model.addAttribute("fileDup", fileDup);
            model.addAttribute("folderDup", dup);
            model.addAttribute("fileList", childFile);
            model.addAttribute("FolderList", childFolder);
            model.addAttribute("parentCd", folderVO);
            setFileBar(model);
            setFileBar3(model);
            return "main/files/individualFiles";
         }
      }
      
      // 파일을 업로드하지 않고 순수 get방식으로 접근했을때 처음위치를 보여주는 로직.
      FolderVO folderVO = new FolderVO();
      
      Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
      UserDetails userDetails = (UserDetails)principal;
      String empNo = userDetails.getUsername();
      
      String fileSavepath = req.getServletContext().getRealPath("/"+"resources"+"/"+"file")+"/"+empNo;
      System.out.println(fileSavepath);
      
      File filePath = new File(fileSavepath);
      
      if(!filePath.exists()) {
         filePath.mkdirs();
         
      }
      
      folderVO.setEmpNo(empNo);
      folderVO.setFolderPath(req.getServletContext().getRealPath("/resources/file/"+empNo));
      if(service.selectDefaultIndFolder(folderVO) < 1) {
         service.insertDefaultIndFolder(folderVO);
      }
      
      System.out.println("디폴트 폴더 가져오기");
      folderVO = service.selectIndFolder(folderVO);
      System.out.print("폴더보 : ");
      System.out.println(folderVO);
      System.out.println("디폴트폴더 차일드 가져오기");
      List<FolderVO> FolderList = service.selectChildFolder(folderVO);
      List<FolderFileVO> childFile = service.selectChildFile(folderVO);
      
      String context = req.getServletContext().getRealPath("/resources/file/"+empNo);
      String contextReplace = context.replace("\\", "/");
      String folderOwn = folderVO.getFolderPath();
      String folderOwnReplace = folderOwn.replace("\\", "/");
      String resPath = folderOwnReplace.replace(contextReplace, "");
      folderVO.setFolderOwnPath(resPath);
      
      String deleteMessage = (String)session.getAttribute("deleteMessage");
      
      session.removeAttribute("deleteMessage");
      
      model.addAttribute("deleteMessage", deleteMessage);
      model.addAttribute("fileList", childFile);
      model.addAttribute("parentCd", folderVO);
      model.addAttribute("FolderList",FolderList);
      setFileBar(model);
      setFileBar3(model);
      return "main/files/individualFiles";
   }
   
   // POST로 데이터를 받아 폴더안쪽으로 이동
   @RequestMapping(value="/indfiles.do", method=RequestMethod.POST)
   public String IndevidualFiles(Model model, FolderVO folderVO,
		   HttpServletRequest req, HttpServletResponse resp) {
      
	   Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
	   UserDetails userDetails = (UserDetails)principal;
	   String empNo = userDetails.getUsername();
		
	   String back = "";
		
	   FolderVO folderInfo = service.selectMyselfFolder(folderVO);
	   List<FolderVO> childFolder = service.selectChildFolder(folderVO);
	   List<FolderFileVO> childFile = service.selectChildFile(folderVO);
	   
	   if(!folderInfo.getFolderPath().equals(req.getServletContext().getRealPath("/resources/file/")+empNo)) {
			back = "BackButtonOn";
	   }
	  
	   String context = req.getServletContext().getRealPath("/resources/file/"+empNo);
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
	   setFileBar3(model);
	   return "main/files/individualFiles";
   }
   // POST로 폴더이름을 받아 폴더생성.
   @RequestMapping(value="/InsertIndFileFolder.do", method=RequestMethod.POST)
   public String InsertIndFileFolder(
         FolderVO folderVO, 
         Model model, 
         HttpServletRequest req, HttpServletResponse resp) {
      service.insertIndFolder(folderVO , req, resp);
      return "redirect:/indfiles.do";   
   }
   
   // POST로 파일이름과 형태를 멀티파일형태로 받아 형태저장.
   @RequestMapping(value="/insertIndFileFile.do", method=RequestMethod.POST)
   public String InsertIndFileFile(
         FolderVO folderVO,
         Model model,
         HttpServletRequest req, HttpServletResponse resp) throws IOException {
      
      service.insertIndFile(folderVO, req, resp);
      
      return "redirect:/indfiles.do";
   }
   
   @RequestMapping(value="/fileDownload.do", method=RequestMethod.GET)
   public ResponseEntity<byte[]> fileDownload(
         String submitFileCd,
         HttpServletRequest request,
         HttpServletResponse response) throws Exception {
      
      ResponseEntity<byte[]> entity = service.fileDownload(
            submitFileCd, request, response);
      String deleteMessage = "다운로드가 완료되었습니다";
      HttpSession session = request.getSession();
      session.setAttribute("deleteMessage", deleteMessage);
      return entity;
   }
   
   // 폴더배열과, 파일의배열을받고, req, resp을 이용하여 경로작업 후,
   // 알집데이터를 responseEntity값으로 ajax에 반환하는 컨트롤러.
   @RequestMapping(value="fileAlzip.do", method=RequestMethod.POST)
   public ResponseEntity<byte[]> alzipDownload(
         @RequestParam List<String> folderArray, 
         @RequestParam List<String> fileArray,
         HttpServletRequest request,
         HttpServletResponse response) throws IOException {
      
      return service.alzipDownload(folderArray, fileArray, request, response);
   }
   
   // 파일Cd값으로 좋아요를 업데이트 해줄 서비스로 보낸후 ajax로 리턴하는 컨트롤러.
   @ResponseBody
   @RequestMapping(value="updateLikeSeAjax.do", method=RequestMethod.POST)
   public Map<String, FolderFileVO> updateLikeSeAjax(
            @RequestBody Map<String, Object> param){
      return service.updateLikeSe(param);
   }
   
   // 파일의Cd값으로 파일 전체값을 리턴시켜줄 ajax 컨트롤러 로직.
   @ResponseBody
   @RequestMapping(value="imageFileInfoAjax.do", method=RequestMethod.POST)
   public Map<String, FolderFileVO> imageFileInfoAjax(
         @RequestBody Map<String, Object> param){
      return service.imageFileInfoAjax(param);
   }
   
   @RequestMapping(value="fileDelete.do", method=RequestMethod.POST)
   public String fileDelete(@RequestParam List<String> folderArray,
               @RequestParam List<String> fileArray, String folderParent,
                HttpServletRequest req, HttpServletResponse resp) {
	  service.deletefile(folderArray, fileArray, folderParent, req, resp);
      return "redirect:/indfiles.do";
   }
   
   @ResponseBody
   @RequestMapping(value="searchAjax.do", method=RequestMethod.POST)
   public Map<String, Object> searchAjax(@RequestBody Map<String, String> param){
      System.out.println("도착함");
      return service.searchText(param);
   }
   
   @RequestMapping(value="/selectChildFileDate.do", method=RequestMethod.POST)
   public String selectChildFileDate(FolderVO folderVO,
         HttpServletRequest req, HttpServletResponse resp) {
      HttpSession session = req.getSession();
      session.setAttribute("folderCd", folderVO.getFolderParent());
      session.setAttribute("orderBy", "DATE");
      return "redirect:/indfiles.do";
   }
   
   @RequestMapping(value="/selectChildFileBasic.do", method=RequestMethod.POST)
   public String selectChildFileBasic(FolderVO folderVO,
         HttpServletRequest req, HttpServletResponse resp) {
      HttpSession session = req.getSession();
      session.setAttribute("folderCd", folderVO.getFolderParent());
      return "redirect:/indfiles.do";
   }
   
   @RequestMapping(value="/selectBack.do", method=RequestMethod.POST)
   public String selectBack(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) {
	   
	   FolderVO grandParentVO = new FolderVO();
	   FolderVO parentVO = new FolderVO();
	   parentVO.setFolderCd(folderVO.getFolderParent());
	   parentVO = service.selectMyselfFolder(parentVO);
	   grandParentVO.setFolderCd(parentVO.getFolderParent());
	   grandParentVO = service.selectMyselfFolder(grandParentVO);
	   
	   HttpSession session = req.getSession();
	   session.setAttribute("folderCd", grandParentVO.getFolderCd());
	   
	   return "redirect:/indfiles.do";
   }
   
   @RequestMapping(value="/indSelectBack.do", method=RequestMethod.POST)
   public String depSelectBack(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) {
	   
	   FolderVO grandParentVO = new FolderVO();
	   FolderVO parentVO = new FolderVO();
	   parentVO.setFolderCd(folderVO.getFolderParent());
	   parentVO = service.selectMyselfFolder(parentVO);
	   grandParentVO.setFolderCd(parentVO.getFolderParent());
	   grandParentVO = service.selectMyselfFolder(grandParentVO);
	   
	   HttpSession session = req.getSession();
	   session.setAttribute("folderCd", grandParentVO.getFolderCd());
	   
	   return "redirect:/indfiles.do";
   }
   
}



//성민형님 화이팅입니다,,,,,,,, 목이 뻐근할 때에는 Isolation을 합시다.....
























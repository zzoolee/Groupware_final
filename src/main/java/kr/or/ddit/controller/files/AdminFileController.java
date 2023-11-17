package kr.or.ddit.controller.files;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kotlin.reflect.jvm.internal.impl.load.java.JavaClassFinder.Request;
import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.service.IFileService;
import kr.or.ddit.service.IMailService;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FolderFileVO;
import kr.or.ddit.vo.FolderVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class AdminFileController {

	@Inject
	private IFileService service;

	@Inject
	private IMailService mailService;
	
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
	
	private void setFileBar2(Model model) {
		String fileBar = "EXIST";
		model.addAttribute("fileBar2", fileBar);
	}

	private String company = "IWORKS";

	private String UserNoFind() {
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		UserDetails userDetails = (UserDetails) principal;
		String empNo = userDetails.getUsername();

		return empNo;
	}

	private String UserDepFind() {
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		UserDetails userDetails = (UserDetails) principal;
		String empNo = userDetails.getUsername();

		EmpVO userDep = empMapper.readByUserId(empNo);
		String dep = userDep.getDeptCd();

		return dep;
	}

	// 기본get값으로 들어오는 관리자 부서자료실
	@RequestMapping(value = "/adminDepfiles.do", method = RequestMethod.GET)
	public String adminDepFile(Model model, HttpServletRequest req, HttpServletResponse resp) {

		// 세션에 내용이 있을때 처리할 로직.
		// 파일을 업로드하고 업로드한 위치로 돌려주는 로직
		HttpSession session = req.getSession();
		System.out.println(req.getSession().getAttribute("folderCd"));
		if (session == null) {
		} else {
			String folderCd = (String) session.getAttribute("folderCd");
			String dup = (String) session.getAttribute("dup");
			String fileDup = (String) session.getAttribute("fileDup");
			String orderBy = (String) session.getAttribute("orderBy");
			String deptCd = (String) session.getAttribute("deptCd");
			String deleteMessage = (String)session.getAttribute("deleteMessage");
	         
	        session.removeAttribute("deleteMessage");
			session.removeAttribute("orderBy");
			session.removeAttribute("fileDup");
			session.removeAttribute("folderCd");
			session.removeAttribute("dup");
			if (folderCd == null) {
			} else {
				List<FolderVO> childFolder = new ArrayList<FolderVO>();
				List<FolderFileVO> childFile = new ArrayList<FolderFileVO>();
				FolderVO folderVO = new FolderVO();
				folderVO.setFolderCd(folderCd);

				String empNo = UserNoFind();
				String dep = UserDepFind();

				String back = "";

				FolderVO folderInfo = service.selectMyselfFolder(folderVO);
				System.out.print("get방식에서 foderVO의 값 : ");
				System.out.println(folderInfo.getFolderPath());

				if (folderInfo.getFolderPath() != null) {
					System.out.println("널이아니다.");
					if (!folderInfo.getFolderPath()
							.equals(req.getServletContext().getRealPath("/resources/file/") + deptCd)) {
						System.out.println("다른값.");
						back = "BackButtonOn";
					} else {
						System.out.println("같은값.");
					}
				}
				
				if (orderBy != null) {
					childFolder = service.selectChildFolderDate(folderVO);
					childFile = service.selectChildFileDate(folderVO);
				} else {
					childFolder = service.selectChildFolder(folderVO);
					childFile = service.selectChildFile(folderVO);
				}

				String context = req.getServletContext().getRealPath("/resources/file/" + deptCd);
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
				model.addAttribute("deptCd", deptCd);
				model.addAttribute("back", back);
				model.addAttribute("fileDup", fileDup);
				model.addAttribute("folderDup", dup);
				model.addAttribute("fileList", childFile);
				model.addAttribute("FolderList", childFolder);
				model.addAttribute("parentCd", folderVO);
				setFileBar(model);
				setFileBar2(model);
				return "main/files/adminDepartmentFiles";
			}
		}
		// 아무런 세션없이 들어왔을경우.
		// 부서 전체데이터를 담아준다.
		List<DeptVO> deptList = new ArrayList<DeptVO>();
		deptList = service.selectAllDeptList();

		// 여길 벗어났다가 다시왔을때에 대한 대책도 필요하다.
		if (session.getAttribute("deptCd") == null) {
			String deptCd = "A011";
			session.setAttribute("deptCd", deptCd);
		}
		String deptCd = (String) session.getAttribute("deptCd");

		// 부서전체의 세이브를 잡아주고 폴더자체를 생성해준다.
		// 이후에 DB에 부서별 폴더를 추가해준다.
		for (int i = 0; i < deptList.size(); i++) {
			String fileSavepath = req.getServletContext().getRealPath("/" + "resources" + "/" + "file") + "/"
					+ deptList.get(i).getDeptCd();

			File filePath = new File(fileSavepath);

			if (!filePath.exists()) {
				filePath.mkdirs();
			}

			FolderVO folderVO = new FolderVO();

			folderVO.setEmpNo("admin");
			folderVO.setFolderCd(deptList.get(i).getDeptCd());
			folderVO.setFolderPath(
					req.getServletContext().getRealPath("/resources/file/" + deptList.get(i).getDeptCd()));

			if (service.selectDefaultDepFolder(folderVO) < 1) {
				service.insertDefaultDepFolder(folderVO);
			}
		}

		System.out.println("디폴트 폴더 가져오기");
		FolderVO selectedDep = new FolderVO();
		selectedDep.setFolderCd(deptCd);

		selectedDep = service.selectAdminDepFolder(selectedDep);
		List<FolderVO> FolderList = service.selectChildFolder(selectedDep);
		List<FolderFileVO> childFile = service.selectChildFile(selectedDep);
		
		String context = req.getServletContext().getRealPath("/resources/file/" + selectedDep.getFolderCd());
		String contextReplace = context.replace("\\", "/");

		String folderOwn = selectedDep.getFolderPath();

		String folderOwnReplace = folderOwn.replace("\\", "/");

		String resPath = folderOwnReplace.replace(contextReplace, "");

		selectedDep.setFolderOwnPath(resPath);

		String deleteMessage = (String)session.getAttribute("deleteMessage");
	      
	    session.removeAttribute("deleteMessage");
	      
	    model.addAttribute("deleteMessage", deleteMessage);
		model.addAttribute("deptCd", deptCd);
		model.addAttribute("fileList", childFile);
		model.addAttribute("parentCd", selectedDep);
		model.addAttribute("FolderList", FolderList);

		setFileBar(model);
		setFileBar2(model);
		return "main/files/adminDepartmentFiles";
	}

	// POST로 데이터를 받아 폴더안쪽으로 이동
	@RequestMapping(value = "/adminDepfiles.do", method = RequestMethod.POST)
	public String adminDepfiles(Model model, FolderVO folderVO, HttpServletRequest req, HttpServletResponse resps) {

		HttpSession session = req.getSession();
		String deptCd = (String) session.getAttribute("deptCd");

		String back = "";

		FolderVO folderInfo = service.selectMyselfFolder(folderVO);
		List<FolderVO> childFolder = service.selectChildFolder(folderVO);
		List<FolderFileVO> childFile = service.selectChildFile(folderVO);
		
		if (!folderInfo.getFolderPath().equals(req.getServletContext().getRealPath("/resources/file/") + deptCd)) {
			back = "BackButtonOn";
		}

		String context = req.getServletContext().getRealPath("/resources/file/" + deptCd);
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
		return "main/files/adminDepartmentFiles";
	}

	// POST로 폴더이름을 받아내서 폴더를 생성 후 리다이렉트
	@RequestMapping(value = "/insertDepFolderAdmin.do", method = RequestMethod.POST)
	public String insertDepFolderAdmin(FolderVO folderVO, Model model, HttpServletRequest req,
			HttpServletResponse resp) {
		service.insertDepFolderAdmin(folderVO, req, resp);
		return "redirect:/adminDepfiles.do";
	}

	// POST로 파일이름과 형태를 멀티파일형태로 받아 형태저장 이후 리다이렉트.
	@RequestMapping(value = "/insertDepFileAdmin.do", method = RequestMethod.POST)
	public String insertDepFileAdmin(FolderVO folderVO, Model model, HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		service.insertDepFileAdmin(folderVO, req, resp);
		return "redirect:/adminDepfiles.do";
	}

	// 정렬 기본 가나다순.
	@RequestMapping(value = "/depSelectChildFileBasicAdmin.do", method = RequestMethod.POST)
	public String depSelectChildFileBasicAdmin(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) {
		HttpSession session = req.getSession();
		session.setAttribute("folderCd", folderVO.getFolderParent());
		return "redirect:/adminDepfiles.do";
	}

	// 정렬 날짜순.
	@RequestMapping(value = "/depSelectChildFileDateAdmin.do", method = RequestMethod.POST)
	public String depSelectChildFileDateAdmin(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) {
		HttpSession session = req.getSession();
		session.setAttribute("folderCd", folderVO.getFolderParent());
		session.setAttribute("orderBy", "DATE");
		return "redirect:/adminDepfiles.do";
	}

	// 뒤로가기
	@RequestMapping(value = "/depSelectBackAdmin.do", method = RequestMethod.POST)
	public String depSelectBackAdmin(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) {

		FolderVO grandParentVO = new FolderVO();
		FolderVO parentVO = new FolderVO();
		parentVO.setFolderCd(folderVO.getFolderParent());
		parentVO = service.selectMyselfFolder(parentVO);
		grandParentVO.setFolderCd(parentVO.getFolderParent());
		grandParentVO = service.selectMyselfFolder(grandParentVO);

		HttpSession session = req.getSession();
		session.setAttribute("folderCd", grandParentVO.getFolderCd());

		return "redirect:/adminDepfiles.do";
	}

	// 부서변경
	@RequestMapping(value = "/depChange.do", method = RequestMethod.POST)
	public String depChange(HttpServletRequest req, HttpServletResponse resp) {
		HttpSession session = req.getSession();
		String deptCd = req.getParameter("deptCd");
		session.removeAttribute("deptCd");
		session.setAttribute("deptCd", deptCd);
		return "redirect:/adminDepfiles.do";
	}

	// 파일삭제
	@RequestMapping(value = "/depFileDeleteAdmin.do", method = RequestMethod.POST)
	public String depFileDeleteAdmin(@RequestParam List<String> folderArray, @RequestParam List<String> fileArray,
			String folderParent, HttpServletRequest req, HttpServletResponse resp) {
		service.deletefile(folderArray, fileArray, folderParent, req, resp);
		return "redirect:/adminDepfiles.do";
	}

	// 어드민 전사자료실

	// 전사자료실로 이동
	@RequestMapping(value = "/adminComfiles.do", method = RequestMethod.GET)
	public String adminComfiles(Model model, HttpServletRequest req, HttpServletResponse resp) {

		// 파일을 업로드하고 업로드한 위치로 돌려주는 로직
		HttpSession session = req.getSession();
		System.out.println(req.getSession().getAttribute("folderCd"));
		if (session == null) {
		} else {
			String folderCd = (String) session.getAttribute("folderCd");
			String dup = (String) session.getAttribute("dup");
			String fileDup = (String) session.getAttribute("fileDup");
			String orderBy = (String) session.getAttribute("orderBy");
			String deleteMessage = (String)session.getAttribute("deleteMessage");
	         
	        session.removeAttribute("deleteMessage");
			session.removeAttribute("orderBy");
			session.removeAttribute("fileDup");
			session.removeAttribute("folderCd");
			session.removeAttribute("dup");

			if (folderCd == null) {
			} else {
				List<FolderVO> childFolder = new ArrayList<FolderVO>();
				List<FolderFileVO> childFile = new ArrayList<FolderFileVO>();
				FolderVO folderVO = new FolderVO();
				folderVO.setFolderCd(folderCd);

				String back = "";

				FolderVO folderInfo = service.selectMyselfFolder(folderVO);
				System.out.print("get방식에서 foderVO의 값 : ");
				System.out.println(folderInfo.getFolderPath());

				if (folderInfo.getFolderPath() != null) {
					System.out.println("널이아니다.");
					if (!folderInfo.getFolderPath()
							.equals(req.getServletContext().getRealPath("/resources/file/") + company)) {
						System.out.println("다른값.");
						back = "BackButtonOn";
					} else {
						System.out.println("같은값.");
					}
				}

				if (orderBy != null) {
					childFolder = service.selectChildFolderDate(folderVO);
					childFile = service.selectChildFileDate(folderVO);
				} else {
					childFolder = service.selectChildFolder(folderVO);
					childFile = service.selectChildFile(folderVO);
				}
				
				String context = req.getServletContext().getRealPath("/resources/file/" + company);
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
				setFileBar1(model);
				return "main/files/adminComFiles";
			}
		}

		// 파일을 업로드하지 않고 순수 get방식으로 접근했을때 처음위치를 보여주는 로직.
		FolderVO folderVO = new FolderVO();

		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		UserDetails userDetails = (UserDetails) principal;
		String empNo = userDetails.getUsername();

		EmpVO empVO = empMapper.readByUserId(empNo);
		String company = "IWORKS";
		System.out.println("회사 : " + company);

		String fileSavepath = req.getServletContext().getRealPath("/" + "resources" + "/" + "file") + "/" + company;
		System.out.println(fileSavepath);

		File filePath = new File(fileSavepath);

		if (!filePath.exists()) {
			filePath.mkdirs();

		}
		folderVO.setEmpNo(empNo);
		folderVO.setFolderSe(company);
		folderVO.setFolderPath(req.getServletContext().getRealPath("/resources/file/" + company));

		if (service.selectDefaultComFolder(folderVO) < 1) {
			service.insertDefaultComFolder(folderVO);
		}

		System.out.println("디폴트 폴더 가져오기");
		folderVO = service.selectComFolder(folderVO);
		System.out.print("폴더보 : ");
		System.out.println(folderVO);
		System.out.println("디폴트폴더 차일드 가져오기");
		List<FolderVO> FolderList = service.selectChildFolder(folderVO);
		List<FolderFileVO> childFile = service.selectChildFile(folderVO);
		
		String context = req.getServletContext().getRealPath("/resources/file/" + company);
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
		model.addAttribute("fileList", childFile);
		model.addAttribute("parentCd", folderVO);
		model.addAttribute("FolderList", FolderList);
		setFileBar(model);
		setFileBar1(model);
		return "main/files/adminComFiles";
	}

	// POST로 데이터를 받아 폴더안쪽으로 이동
	@RequestMapping(value = "/adminComfiles.do", method = RequestMethod.POST)
	public String comFiles(Model model, FolderVO folderVO, HttpServletRequest req, HttpServletResponse resps) {

		List<FolderVO> childFolder = service.selectChildFolder(folderVO);
		List<FolderFileVO> childFile = service.selectChildFile(folderVO);

		String back = "";

		FolderVO folderInfo = service.selectMyselfFolder(folderVO);
		System.out.print("get방식에서 foderVO의 값 : ");
		System.out.println(folderInfo.getFolderPath());

		if (!folderInfo.getFolderPath().equals(req.getServletContext().getRealPath("/resources/file/") + company)) {
			back = "BackButtonOn";
		}

		String context = req.getServletContext().getRealPath("/resources/file/" + company);
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
		return "main/files/adminComFiles";
	}

	// POST로 폴더이름을 받아 폴더생성.
	@RequestMapping(value = "/insertComFolderAdmin.do", method = RequestMethod.POST)
	public String insertComFileFolder(FolderVO folderVO, Model model, HttpServletRequest req,
			HttpServletResponse resp) {
		service.insertComFolderAdmin(folderVO, req, resp);
		return "redirect:/adminComfiles.do";
	}

	// POST로 파일이름과 형태를 멀티파일형태로 받아 형태저장.
	@RequestMapping(value = "/insertComFileAdmin.do", method = RequestMethod.POST)
	public String insertComFileAdmin(FolderVO folderVO, Model model, HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		service.insertComFileAdmin(folderVO, req, resp);

		return "redirect:/adminComfiles.do";
	}

	// 가나다순 정렬.
	@RequestMapping(value = "/comSelectChildFileBasicAdmin.do", method = RequestMethod.POST)
	public String comSelectChildFileBasicAdmin(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) {
		HttpSession session = req.getSession();
		session.setAttribute("folderCd", folderVO.getFolderParent());
		return "redirect:/adminComfiles.do";
	}

	// 날짜순 정렬.
	@RequestMapping(value = "/comSelectChildFileDateAdmin.do", method = RequestMethod.POST)
	public String comSelectChildFileDateAdmin(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) {
		HttpSession session = req.getSession();
		session.setAttribute("folderCd", folderVO.getFolderParent());
		session.setAttribute("orderBy", "DATE");
		return "redirect:/adminComfiles.do";
	}
	
	// 뒤로가기 버튼.
	@RequestMapping(value="/comSelectBackAdmin.do", method=RequestMethod.POST)
	   public String comSelectBackAdmin(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) {
		   
		   FolderVO grandParentVO = new FolderVO();
		   FolderVO parentVO = new FolderVO();
		   parentVO.setFolderCd(folderVO.getFolderParent());
		   parentVO = service.selectMyselfFolder(parentVO);
		   grandParentVO.setFolderCd(parentVO.getFolderParent());
		   grandParentVO = service.selectMyselfFolder(grandParentVO);
		   
		   HttpSession session = req.getSession();
		   session.setAttribute("folderCd", grandParentVO.getFolderCd());
		   
		   return "redirect:/adminComfiles.do";
	   }
	
	@RequestMapping(value="/comFileDeleteAdmin.do", method=RequestMethod.POST)
	public String comFileDelete(@RequestParam List<String> folderArray,
					@RequestParam List<String> fileArray, String folderParent,
					 HttpServletRequest req, HttpServletResponse resp) {
		service.deletefile(folderArray, fileArray, folderParent, req, resp);
		return "redirect:/adminComfiles.do";
	}
	
	@RequestMapping(value="/comFileResYes.do", method=RequestMethod.POST)
	public String comFileResYes(FolderFileVO folderFileVO, HttpServletRequest req, HttpServletResponse resp
			, RedirectAttributes ra) {
		log.info("승인처리 들어왔음. 폴더파일보 : {}", folderFileVO);
		
		String appr = req.getParameter("appr");
		
		
		
		FolderFileVO fileVO = new FolderFileVO();
		fileVO.setFileCd(folderFileVO.getFileCd());
		fileVO = service.selectMyselfFile(fileVO);
		String fileName = fileVO.getFileOrgname();
		
		String title = "전사자료실에 등록한 파일("+fileName+")이 승인되었습니다";
		String content = "전사자료실에 등록한 "+fileName+"은 관리자에 의해 승인되었음을 알려드립니다.";
		
		mailService.adminSendMail(folderFileVO.getEmpNo(), title, content);
		
		service.comFileResYes(folderFileVO);
		
		String deleteMessage = "승인처리가 완료되었습니다";
		
		ra.addFlashAttribute("deleteMessageRa", deleteMessage);
		
		if(appr != null) {
			if(appr.equals("appr")) {
				return "redirect:/comFileApprList.do";
			}
		}
		
		return "redirect:/adminComfiles.do";
	}
	
	@RequestMapping(value="/refuseFile.do", method=RequestMethod.POST)
	public String refuseFile(HttpServletRequest req, HttpServletResponse resp, RedirectAttributes ra) {
		String content = req.getParameter("refuseContent");
		String fileCd = req.getParameter("fileCdForm");
		String empNo = req.getParameter("empNoForm");
		
		String appr = req.getParameter("appr");
		
		FolderFileVO fileVO = new FolderFileVO();
		fileVO.setFileCd(fileCd);
		fileVO = service.selectMyselfFile(fileVO);
		String fileName = fileVO.getFileOrgname();
		
		String title = "전사자료실에 등록한 파일("+fileName+")이 반려되었습니다";
		content = "전사자료실에 등록한 "+fileName+"은 관리자에 의해 반려되었음을 알려드립니다. \n반려사유 : "+content;
		
		mailService.adminSendMail(empNo, title, content);
		
		service.deleteRefuse(fileCd);
		
		log.info("콘텐츠 : {} ", content);
		log.info("파일씨디 : {} ", fileCd);
		log.info("이엠피넘버 : {} ", empNo);
		
		String deleteMessage = "반려처리가 완료되었습니다";
		
		ra.addFlashAttribute("deleteMessageRa", deleteMessage);
		
		if(appr != null) {
			if(appr.equals("appr")) {
				return "redirect:/comFileApprList.do";
			}
		}
		
		return "redirect:/adminComfiles.do";
	}
	
	//관리자 전사자료실 승인페이지로 이동.
	@RequestMapping(value="/comFileApprList.do", method=RequestMethod.GET)
	public String comFileApprList(Model model, HttpServletRequest req, HttpServletResponse resp) {
		List<FolderFileVO> fileList = new ArrayList<FolderFileVO>();
		fileList = service.selectApprList();
		if(fileList != null) {
			for(int i = 0; i < fileList.size(); i++) {
				String filePath = fileList.get(i).getFileSavepath();
				String basicPath = "resources/file/IWORKS/";
				log.info("베이직 패쓰 : {}", basicPath);
				String showingPath = filePath.replace(basicPath, "전사자료실/");
				fileList.get(i).setFileSavepath(showingPath);
			}
		}
		model.addAttribute("fileList", fileList);
		setFileBar(model);
		setFileBar1(model);
		return "main/files/adminComFilesAppr";
	}

}

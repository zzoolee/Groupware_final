package kr.or.ddit.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.Principal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.apache.commons.collections.map.HashedMap;
import org.apache.commons.lang.StringUtils; // lang3말고 그냥 lang로 해도 괜찮은건가...?
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.service.ITaskService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.TaskVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class TaskController {

	@Inject
	private ITaskService taskService;
	
	/**
	 * 업무 목록을 가져오는 메서드
	 * @param currentPage
	 * @param searchType
	 * @param searchWord
	 * @param req
	 * @param model
	 * @param principal
	 * @return
	 */
	@PreAuthorize("hasAnyRole('ROLE_MEMBER')")
	@RequestMapping(value="/task.do")
	public String taskList(
			@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "ing") String searchType,
	        HttpServletRequest req,
	        Model model, Principal principal
	) {
	    // 페이징 시작
	    // 페이징 정보를 담고 관리할 PaginationInfoVO 객체를 생성. TaskVO를 사용하여 데이터를 페이징할 것을 지정
	    PaginationInfoVO<TaskVO> pagingVO = new PaginationInfoVO<TaskVO>();
	    pagingVO.setEmpNo(principal.getName());
	    
	    // 내가 업무책임자이면 round를 빨간색으로 처리하기 위함
	    model.addAttribute("loginId", principal.getName());
	    
	    // 검색이 이뤄지면 아래가 실행됨
 		if(StringUtils.isNotBlank(searchType)) {
 			// 검색 조건을 설정
 			pagingVO.setSearchType(searchType);
 			
 			// 검색 조건을 뷰로 전달하기 위해 model에 추가
 			model.addAttribute("searchType", searchType);
 		}
	    
 		// 현재 페이지 번호를 설정
 		pagingVO.setCurrentPage(currentPage);	// startRow, endRow, startPage, endPage가 결정
 		// 총 게시글 수 가져오기
		int totalRecord = taskService.taskCount(pagingVO);	
		
		// 페이징 정보를 사용해 게시글 목록을 데이터베이스에서 가져옴
		pagingVO.setTotalRecord(totalRecord);	// totalPage 결정
		// 페이징 정보를 사용해 게시글 목록을 데이터베이스에서 가져옴
		List<TaskVO> taskList = taskService.selectTaskListPaging(pagingVO); // pagingVO를 이용해 데이터 가져오기
		log.info("taskList : {}", taskList);
		// 페이징 정보 객체에 게시글 목록을 설정
		pagingVO.setDataList(taskList);
		
		model.addAttribute("pagingVO", pagingVO);
		// 페이징 끝
		
	    // 모델에 taskList를 추가합니다.
		model.addAttribute("taskBar", "taskBar");
		model.addAttribute("taskBar1", "taskBar1");
	    return "main/task/task";
	}

	/**
	 * 업무 작성 폼 페이지로 이동하는 메서드
	 * @param model
	 * @return
	 */
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/taskform.do")
	public String taskForm(Model model) {
		model.addAttribute("taskBar", "taskBar");
		model.addAttribute("taskBar1", "taskBar1");
		return "main/task/taskForm";
	}
	
	/**
	 * 업무를 실제로 추가하는 메서드
	 * @param ra
	 * @param taskVO
	 * @param model
	 * @param principal
	 * @return
	 */
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/taskinsert.do", method = RequestMethod.POST)
	public String taskInsert(
			RedirectAttributes ra, 
			TaskVO taskVO,
	        Model model, Principal principal
			) {
		String goPage = "";
		String taskempList = "업무,"+taskVO.getTaskTitle();
		
		// 로그인 한 사용자 사원번호(아이디) 가져오기
		String empNo = principal.getName();
		// 업무 작성자로 사용자명을 설정
	    taskVO.setEmpNo(empNo);
	    
		// 업무를 서비스를 통해 db에 추가
		ServiceResult result = taskService.insertTask(taskVO);
		
		
		if(taskVO.getTeamEmpList() != null) {
			taskService.insertTeamEmp(taskVO);
		}
		
		if(result.equals(ServiceResult.OK) ) {
			ra.addFlashAttribute("message", "업무 생성에 성공했습니다.");

			if(taskVO.getTeamEmpList() != null ) {
				List<String> empNoList = taskVO.getTeamEmpList();
				for(int i = 0; i < empNoList.size(); i++) {
					taskempList += ","+empNoList.get(i);
					// 업무,title,1234,1234,1234
					taskempList += ","+empNoList.get(i);
				}
				ra.addFlashAttribute("taskempList", taskempList);
			}
			
			goPage = "redirect:/taskdetail.do?taskCd=" + taskVO.getTaskCd();

		}else {
			model.addAttribute("taskVO", taskVO);
			ra.addFlashAttribute("message", "업무 생성에 실패했습니다.");
			goPage = "redirect:/task.do";
		}
		return goPage;
	}
	
	/**
	 * 업무를 삭제하는 메서드
	 * @param ra
	 * @param taskCd
	 * @param model
	 * @return
	 */
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/taskdelete.do", method = RequestMethod.GET)
	public String deleteTask(RedirectAttributes ra, String taskCd, Model model) {
		String goPage = "";
		taskService.deleteTdForTask(taskCd);
		ServiceResult result = taskService.deleteTask(taskCd);
		if(result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "업무 삭제에 성공했습니다.");
			goPage = "redirect:/task.do";
		}else {
			ra.addFlashAttribute("message", "업무 삭제에 실패했습니다.");
			goPage = "main/task/task";
		}
		return goPage;
	}
	
	/**
	 * 세부업무를 삭제하는 메서드
	 * @param ra
	 * @param taskCd
	 * @param tdCd
	 * @param model
	 * @param tkdflag
	 * @return
	 */
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/tkdelete.do", method = RequestMethod.POST)
	public String deleteTaskdet(
			RedirectAttributes ra, String taskCd, String tdCd, Model model, String tkdflag) {
		String goPage = "";
		TaskVO taskVO = new TaskVO();
		taskVO.setTaskCd(taskCd);
		taskVO.setTdCd(tdCd);
		ServiceResult result = taskService.deleteTd(taskVO);
		if(result.equals(ServiceResult.OK)) {
			goPage = "redirect:/taskdetail.do?taskCd=" + taskCd;
			ra.addFlashAttribute("message", "세부업무 삭제에 성공했습니다.");
			if(tkdflag != null) { // 세부업무목록에서 요청 들어오면
				goPage = "redirect:/mytaskdetail.do";
			}
		}else {
			model.addAttribute("status","u");
			goPage = "main/task/task";
		}
		return goPage;
	}
	
	/**
	 * 업무를 업데이트하기 위해 정보를 가져오는 메서드
	 * @param taskCd
	 * @param model
	 * @return
	 */
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/updatetask.do", method = RequestMethod.GET)
	public String updateTaskForm(String taskCd, Model model) {
		TaskVO taskVO = taskService.selectTask(taskCd);
		
		// teamemplist추가한거
		List<TaskVO> teamempList = taskService.selectTeamEmpList(taskVO);
	    model.addAttribute("teamempList", teamempList);
		log.info("teamempList : " + teamempList);

	    // 세부업무 담당자(TESTD_EMP) + 세부업무 담당자가 아닌 팀원(NOTD_EMP)
	    List<TaskVO> TdSepEmpList = taskService.TdSeparateEmpList(taskVO);
	    model.addAttribute("TdSepEmpList", TdSepEmpList);
	    log.info("TdSepEmpList {} : " + TdSepEmpList);
		
		model.addAttribute("taskVO", taskVO);
		
		model.addAttribute("taskBar", "taskBar");
		model.addAttribute("taskBar1", "taskBar1");
		return "main/task/taskUpdate";
	}
	
	/**
	 * 업무를 수정하는 메서드
	 * @param req
	 * @param taskCd
	 * @param redirectAttributes
	 * @param model
	 * @param taskVO
	 * @return
	 */
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/updatetask.do", method = RequestMethod.POST)
	public String updateTask(HttpServletRequest req, String taskCd, RedirectAttributes ra, Model model, TaskVO taskVO) {
	    String goPage = "";
	    ServiceResult result = taskService.updateTask(taskVO);

	    String delEmpList = req.getParameter("delEmpList");
	    
	    if(taskVO.getTeamEmpList() != null) {
			log.info("teamEmpList : {}", taskVO.getTeamEmpList());
			taskVO.setTaskCd(taskCd);
			taskService.insertTdTeamEmp(taskVO);
		}
        
	        if (!delEmpList.isEmpty()) {
	        	log.info("delEmpList : " + delEmpList);
	            // 팀원 삭제
	        	taskVO.setTaskCd(taskCd);
//	        	deletedTeamMembers = taskService.deletedTeamMembers(taskVO);
	            taskService.deletedTeamMembers(taskVO);
	        }
	        
	        
	        if (result.equals(ServiceResult.OK)) {
	            goPage = "redirect:/taskdetail.do?taskCd=" + taskVO.getTaskCd();
	            ra.addFlashAttribute("message", "업무 수정에 성공했습니다.");
	        } else {
	            ra.addFlashAttribute("message", "업무 수정에 실패했습니다.");
	            goPage = "main/task/task";
	       
	            model.addAttribute("message", "업무 수정 폼에서의 팀원 삭제에 실패했습니다.");
	            
	        return "redirect:/task.do";
	        }
	    return goPage;
	}

	
	/**
	 * TaskDetail - 세부업무
	 * 업무 + 세부업무 가져오는 메서드
	 * @param taskCd
	 * @param model
	 * @param principal
	 * @return
	 */
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/taskdetail.do", method = RequestMethod.GET)
	public String taskDetail(String taskCd, Model model, Principal principal) {
		// 업무 내용을 가져옴
		TaskVO taskVO = taskService.selectTask(taskCd);
		
	    model.addAttribute("loginId", principal.getName());
	    
		// 세부업무 목록을 가져옴
	    List<TaskVO> taskdetList = taskService.selectDetTaskList(taskVO);
	    // 모델에 taskList를 추가합니다.
	    model.addAttribute("taskdetList", taskdetList);

	    // 팀원을 가져옴
	    List<TaskVO> teamempList = taskService.selectTeamEmpList(taskVO);
	    model.addAttribute("teamempList", teamempList);

	    taskVO.setTaskCd(taskCd);
	    // 세부업무를 담당하지 않는 팀원을 가져옴
	    List<TaskVO> notworkempList = taskService.notWorkEmpList(taskVO);
	    model.addAttribute("notworkempList", notworkempList);
	    
		model.addAttribute("taskVO", taskVO);
		model.addAttribute("taskBar", "taskBar");
		model.addAttribute("taskBar1", "taskBar1");
		return "main/task/taskDetail";
	}
	
	/**
	 * 업무리스트 ajax
	 * @param taskCd
	 * @return
	 */
   @ResponseBody
   @GetMapping("/tasklistajax.do")
   public TaskVO taskajax(String taskCd) {
	  TaskVO taskVO = taskService.selectTask(taskCd);
      return taskVO;
   }

   /**
    * 세부업무 등록 메서드
    * @param taskCd
    * @param taskVO
    * @param model
    * @param principal
    * @return
    */
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/taskdetinsert.do", method = RequestMethod.POST)
	public String taskdetInsert(
			String taskCd,
			TaskVO taskVO,
			Model model,
			Principal principal,
			RedirectAttributes ra
			) {
		log.info("taskCd : {}", taskCd);
		
		// 업무를 서비스를 통해 db에 추가
		ServiceResult result = taskService.insertdetTask(taskVO);
		
		if (result.equals(ServiceResult.OK)) {
            ra.addFlashAttribute("message", "세부업무 등록에 성공했습니다.");
        } else {
            ra.addFlashAttribute("message", "세부업무 등록에 실패했습니다.");
        }
		
		return "redirect:/taskdetail.do?taskCd=" + taskCd;
	}
	
	/**
	 * 세부업무 상태를 y(완료)로 변경하는 메서드 
	 * @param taskCd
	 * @param tdCd
	 * @param model
	 * @param taskVO
	 * @param tkdflag
	 * @return
	 */
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/tkturny.do", method = RequestMethod.POST)
	public String turnYChk(String taskCd, String tdCd, Model model, TaskVO taskVO, String tkdflag) {
		log.info("taskCd : ", taskCd);
		log.info("tdCd : ", tdCd);
		// 아래꺼 실행시키면 주소가 http://localhost/taskdetail.do?taskCd=1&tdCd=4이런 식으로 taskcd뒤에 tdcd가 붙음
//		taskService.turnYChk(tdCd);
//		model.addAttribute("tdCd",tdCd);
		
		String goPage = "";
		ServiceResult result = taskService.turnYChk(tdCd);
		if(result.equals(ServiceResult.OK)) {
			goPage = "redirect:/taskdetail.do?taskCd=" + taskCd;
			if(tkdflag != null) { // 세부업무목록에서 요청 들어오면
				goPage = "redirect:/mytaskdetail.do";
			}
		}else {
			model.addAttribute("status","u");
			goPage = "main/task/task";
		}
		return goPage;
	}

	/**
	 * 세부업무 상태를 n(미완료)로 변경하는 메서드 
	 * @param taskCd
	 * @param tdCd
	 * @param model
	 * @param taskVO
	 * @param tkdflag
	 * @return
	 */
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/tkturnn.do", method = RequestMethod.POST)
	public String turnNChk(String taskCd, String tdCd, Model model, TaskVO taskVO, String tkdflag) {
//		taskService.turnYChk(tdCd);
//		model.addAttribute("tdCd",tdCd);
		
		String goPage = "";
		ServiceResult result = taskService.turnNChk(tdCd);
		if(result.equals(ServiceResult.OK)) {
			goPage = "redirect:/taskdetail.do?taskCd=" + taskCd;
			if(tkdflag != null) { // 세부업무목록에서 요청 들어오면
				goPage = "redirect:/mytaskdetail.do";
			}
		}else {
			model.addAttribute("status","u");
			goPage = "main/task/task";
		}
		return goPage;
	}
	
	/**
	 * 세부업무를 수정하는 메서드
	 * @param redirectAttributes
	 * @param taskCd
	 * @param tdCd
	 * @param model
	 * @param taskVO
	 * @param tkdflag
	 * @return
	 */
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/tkdetailupdate.do", method = RequestMethod.POST)
	public String updateChk(RedirectAttributes redirectAttributes, String taskCd, String tdCd, Model model, TaskVO taskVO, String tkdflag) {
		String goPage = "";
		
		// taskService를 통해 taskList를 가져옵니다.
	    List<TaskVO> taskdetList = taskService.selectDetTaskList(taskVO);
	    // 모델에 taskList를 추가합니다.
	    model.addAttribute("taskdetList", taskdetList);
	    
		List<TaskVO> teamempList = taskService.selectTeamEmpList(taskVO);
	    model.addAttribute("teamempList", teamempList);
	    log.info("teamempList : " + teamempList);
		
		ServiceResult result = taskService.updateTd(taskVO);
		redirectAttributes.addFlashAttribute("contTdcd", tdCd);
		if(result.equals(ServiceResult.OK)) {
			redirectAttributes.addFlashAttribute("message", "세부업무 수정에 성공했습니다.");
			goPage = "redirect:/taskdetail.do?taskCd=" + taskVO.getTaskCd();
			if(tkdflag != null) { // 세부업무목록에서 요청 들어오면
				goPage = "redirect:/mytaskdetail.do";
			}
		}else {
			redirectAttributes.addFlashAttribute("message", "세부업무 수정에 실패했습니다.");
			goPage = "main/task/task";
		}
		model.addAttribute("taskBar", "taskBar");
		model.addAttribute("taskBar1", "taskBar1");
		return goPage;
		
	}
	
	/**
	 * GanttChart - 간트차트
	 * @return
	 */
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/taskgantt.do", method = RequestMethod.GET)
	public String taskGantt(String taskCd, Model model, Principal principal) {
		TaskVO taskVO = taskService.selectTask(taskCd);
	   
		// progressbar때문에...
	    List<TaskVO> taskdetList = taskService.selectDetTaskList(taskVO);
	    model.addAttribute("taskdetList", taskdetList);
	    
	    String empNo = principal.getName();
	    model.addAttribute("loginId", empNo);
	    
		model.addAttribute("taskVO", taskVO);
		
		model.addAttribute("taskBar", "taskBar");
		model.addAttribute("taskBar1", "taskBar1");
		return "main/task/taskGantt";
	}
	
	/**
	 * 세부업무리스트 ajax로 테이블 그리는 메서드
	 * @param taskCd
	 * @return
	 */
	@ResponseBody
	@GetMapping("/taskganttajax.do")
	public List<TaskVO> taskdetajax(String taskCd) {
		  TaskVO taskVO = taskService.selectTask(taskCd);
	   List<TaskVO> taskdetList = taskService.selectDetTaskList(taskVO);
	   return taskdetList;
}
   
   /**
    * 세부업무목록 페이지
    * @param principal
    * @param model
    * @return
    */
   @GetMapping("/mytaskdetail.do")
   public String myTaskDetail(Principal principal, Model model) {
	   List<TaskVO> myTkDetailList = taskService.selectMyTkDetailList(principal.getName());
	   
	   model.addAttribute("myTkDetailList", myTkDetailList);
	   model.addAttribute("taskBar", "taskBar");
	   model.addAttribute("taskBar2", "taskBar2");
	   return "main/task/myTaskDetail";
   }
   

   /**
    * Admin페이지에서 모든 업무 목록을 가져옴
    * @param currentPage
    * @param searchType
    * @param searchWord
    * @param req
    * @param model
    * @param principal
    * @return
    */
	@PreAuthorize("hasAnyRole('ROLE_ADMIN')")
	@RequestMapping(value="/adminTask.do")
	public String AdminTaskList(
			@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "ing") String searchType,
			@RequestParam(required = false) String searchWord,
	        HttpServletRequest req,
	        Model model, Principal principal
	) {
	    // 페이징
	    // 페이징 정보를 담고 관리할 PaginationInfoVO 객체를 생성합니다. TaskVO를 사용하여 데이터를 페이징할 것을 지정합니다.
	    PaginationInfoVO<TaskVO> pagingVO = new PaginationInfoVO<TaskVO>();
	    
	    // 검색이 이뤄지면 아래가 실행됨
  		if(StringUtils.isNotBlank(searchType)) {
  			// 검색 조건을 설정
  			pagingVO.setSearchType(searchType);
  			
  			// 검색 조건을 뷰로 전달하기 위해 model에 추가
  			model.addAttribute("searchType", searchType);
  		}
	    
 		// 현재 페이지 번호를 설정
 		pagingVO.setCurrentPage(currentPage);	// startRow, endRow, startPage, endPage가 결정
 		// 총 게시글 수 가져오기
		int totalRecord = taskService.AdminTaskCount(pagingVO);	
		
		// 페이징 정보를 사용해 게시글 목록을 데이터베이스에서 가져옴
		pagingVO.setTotalRecord(totalRecord);	// totalPage 결정
		// 페이징 정보를 사용해 게시글 목록을 데이터베이스에서 가져옴
		List<TaskVO> taskList = taskService.selectAdminTaskListPaging(pagingVO); // pagingVO를 이용해 데이터 가져오기
		log.info("taskList : {}", taskList);
		// 페이징 정보 객체에 게시글 목록을 설정
		pagingVO.setDataList(taskList);
		
		model.addAttribute("pagingVO", pagingVO);
		// 페이징 끝
	    
		model.addAttribute("taskBar", "taskBar");
		model.addAttribute("taskBar1", "taskBar1");
	    return "main/task/taskAdmin";
	}
}

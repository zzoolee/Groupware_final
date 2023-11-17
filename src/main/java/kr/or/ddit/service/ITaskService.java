package kr.or.ddit.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.TaskVO;

public interface ITaskService {
	public int taskCount(PaginationInfoVO<TaskVO> pagingVO);
	public List<TaskVO> selectTaskListPaging(PaginationInfoVO<TaskVO> pagingVO);
	
	public List<TaskVO> notWorkEmpList(TaskVO taskVO);
	
	// admin
	public int AdminTaskCount(PaginationInfoVO<TaskVO> pagingVO);
	public List<TaskVO> selectAdminTaskListPaging(PaginationInfoVO<TaskVO> pagingVO);
	
	
	//	Task
//	public int selectTaskCount(PaginationInfoVO<TaskVO> pagingVO);
//	public int selectTaskCount(TaskVO taskVO);
//	public List<TaskVO> selectTaskList(PaginationInfoVO<TaskVO> pagingVO);
	public List<TaskVO> selectTaskList(String empNo);
	public ServiceResult insertTask(TaskVO taskVO);
	public TaskVO selectTask(String taskCd);
	public ServiceResult updateTask(TaskVO taskVO);
	public ServiceResult deleteTask(String taskCd);
	public List<TaskVO> selectNoTdEmpList(TaskVO taskVO);
//	public List<TaskVO> deletedTeamMembers(TaskVO taskVO);
	public ServiceResult deletedTeamMembers(TaskVO taskVO);
	public ServiceResult insertTeamEmp(TaskVO taskVO);

	//	TaskDetail
	public List<TaskVO> selectDetTaskList(TaskVO taskVO);
	public List<TaskVO> selectTeamEmpList(TaskVO taskVO);
	public ServiceResult insertdetTask(TaskVO taskVO);
//	public void updateCheckboxState(boolean isChecked);
	public TaskVO updateChk(String tdCd);
	public ServiceResult turnYChk(String tdCd);
	public ServiceResult turnNChk(String tdCd);
	public ServiceResult deleteTdForTask(String taskCd);
	public ServiceResult deleteTd(TaskVO taskVO);
	public ServiceResult updateTd(TaskVO taskVO);
	public List<TaskVO> TdSeparateEmpList(TaskVO taskVO);
	public ServiceResult insertTdTeamEmp(TaskVO taskVO);
	
	public List<TaskVO> selectMyTkDetailList(String empNo);
	public ServiceResult deleteDetTask(String taskCd);
	public List<TaskVO> portletAdminTaskList(TaskVO taskVO);
}

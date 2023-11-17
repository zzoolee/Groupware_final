package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.TaskVO;

public interface TaskMapper {
	public int taskCount(PaginationInfoVO<TaskVO> pagingVO);
	public List<TaskVO> selectTaskListPaging(PaginationInfoVO<TaskVO> pagingVO);
	
	public List<TaskVO> notWorkEmpList(TaskVO taskVO);
	
	// Admin
	public int AdminTaskCount(PaginationInfoVO<TaskVO> pagingVO);
	public List<TaskVO> selectAdminTaskListPaging(PaginationInfoVO<TaskVO> pagingVO);
	
	
	
	//	public int selectTaskCount(PaginationInfoVO<TaskVO> pagingVO);
	public int selectTaskCount(TaskVO taskVO);
//	public List<TaskVO> selectTaskList(PaginationInfoVO<TaskVO> pagingVO);
	public List<TaskVO> selectTaskList(String empNo);
	public int insertTask(TaskVO taskVO);
	public TaskVO selectTask(String taskCd);
	// 업무 삭제 전 세부업무 삭제(taskCd로)
	public int deleteDetTask(String taskCd);
	public int deleteTask(String taskCd);
	public List<TaskVO> selectNoTdEmpList(TaskVO taskVO);
	public List<TaskVO> TdSeparateEmpList(TaskVO taskVO);
//	public List<TaskVO> deletedTeamMembers(TaskVO taskVO);
	public int deletedTeamMembers(TaskVO taskVO);
//	public int insertTeamEmp(String taskCd, String[] teamEmpList);
//	public int insertTeamEmp(List<String> teamEmpList);
	public int insertTeamEmp(TaskVO taskVO);

	// portlet
	public List<TaskVO> portletAdminTaskList(TaskVO taskVO);
	
	public List<TaskVO> selectDetTaskList(TaskVO taskVO);
	public List<TaskVO> selectTeamEmpList(TaskVO taskVO);
	public int insertdetTask(TaskVO taskVO);
//	public void updateCheckboxState(boolean isChecked);
	public TaskVO updateChk(String tdCd);
	public int turnYChk(String tdCd);
	public int turnNChk(String tdCd);
	// tdcd로 세부업무 삭제
	public int deleteTdForTask(String taskCd);
	public int deleteTd(TaskVO taskVO);
	public int updateTask(TaskVO taskVO);
	public int updateTd(TaskVO taskVO);
	public int insertTdTeamEmp(TaskVO taskVO);
	
	public List<TaskVO> selectMyTkDetailList(String empNo);
}

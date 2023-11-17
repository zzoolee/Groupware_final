package kr.or.ddit.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.mapper.TaskMapper;
import kr.or.ddit.service.INotifyService;
import kr.or.ddit.service.ITaskService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.TaskVO;

@Service
public class TaskServiceImpl implements ITaskService {

	@Inject
	private TaskMapper taskMapper;

	@Inject
	private INotifyService notiService;

//	@Override
//	public int selectTaskCount(PaginationInfoVO<TaskVO> pagingVO) {
//		return taskMapper.selectTaskCount(pagingVO);
//	}
//
//	@Override
//	public List<TaskVO> selectTaskList(PaginationInfoVO<TaskVO> pagingVO) {
//		return taskMapper.selectTaskList(pagingVO);
//	}

	@Override
	public int taskCount(PaginationInfoVO<TaskVO> pagingVO) {
		return taskMapper.taskCount(pagingVO);
	}

	@Override
	public List<TaskVO> selectTaskListPaging(PaginationInfoVO<TaskVO> pagingVO) {
		return taskMapper.selectTaskListPaging(pagingVO);
	}

//	@Override
//	public int selectTaskCount(TaskVO taskVO) {
//		return taskMapper.selectTaskCount(taskVO);
//	}

	@Override
	public List<TaskVO> selectTaskList(String empNo) {
		return taskMapper.selectTaskList(empNo);
	}

	@Override
	public ServiceResult insertTask(TaskVO taskVO) {
		ServiceResult result = null;

		// 업무를 db에 추가하는 부분
		int status = taskMapper.insertTask(taskVO);

		if (status > 0) { // 업무 추가 성공시
			result = ServiceResult.OK; // 성공 결과 반환
		} else {
			result = ServiceResult.FAILED; // 실패 결과 반환
		}

		return result;
	}

	@Override
	public ServiceResult insertTeamEmp(TaskVO taskVO) {
		ServiceResult result = null;

		// 업무를 db에 추가하는 부분
		int status = taskMapper.insertTeamEmp(taskVO);

		if (status > 0) { // 업무 추가 성공시
			result = ServiceResult.OK; // 성공 결과 반환
		} else {
			result = ServiceResult.FAILED; // 실패 결과 반환
		}

		return result;
	}

	@Override
	public TaskVO selectTask(String taskCd) {
		return taskMapper.selectTask(taskCd);
	}

	// 업무 삭제 전 세부업무들 삭제
	@Override
	public ServiceResult deleteDetTask(String taskCd) {
		ServiceResult result = null;
		int status = taskMapper.deleteDetTask(taskCd);
		if (status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	// 세부업무 하나씩 삭제
	@Override
	public ServiceResult deleteTask(String tdCd) {

		ServiceResult result = null;
		int status = taskMapper.deleteTask(tdCd);
		if (status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

//	@Override
//	public List<TaskVO> deletedTeamMembers(TaskVO taskVO) {
//		return taskMapper.deletedTeamMembers(taskVO);
//	}
	@Override
	public ServiceResult deletedTeamMembers(TaskVO taskVO) {
		ServiceResult result = null;
		int status = taskMapper.deletedTeamMembers(taskVO);
		if (status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public List<TaskVO> selectDetTaskList(TaskVO taskVO) {
		return taskMapper.selectDetTaskList(taskVO);
	}

	@Override
	public List<TaskVO> selectTeamEmpList(TaskVO taskVO) {
		return taskMapper.selectTeamEmpList(taskVO);
	}

	@Override
	public List<TaskVO> selectNoTdEmpList(TaskVO taskVO) {
		return taskMapper.selectNoTdEmpList(taskVO);
	}

	@Override
	public List<TaskVO> TdSeparateEmpList(TaskVO taskVO) {
		return taskMapper.TdSeparateEmpList(taskVO);
	}

	@Override
	public ServiceResult insertdetTask(TaskVO taskVO) {
		ServiceResult result = null;

		// 업무를 db에 추가하는 부분
		int status = taskMapper.insertdetTask(taskVO);

		if (status > 0) { // 업무 추가 성공시
			result = ServiceResult.OK; // 성공 결과 반환
		} else {
			result = ServiceResult.FAILED; // 실패 결과 반환
		}

		return result;
	}

//	@Override
//	public void updateCheckboxState(boolean isChecked) {
//		taskMapper.updateCheckboxState(isChecked);
//	}

	@Override
	public TaskVO updateChk(String tdCd) {
//		ServiceResult result = null;
//		
//		int status = taskMapper.updateChk(tdCd);
//		
//		if(status > 0) {
//			result = ServiceResult.OK; // 성공 결과 반환
//		}else {
//			result = ServiceResult.FAILED; // 실패 결과 반환
//		}
//		
//		return result;
		return taskMapper.updateChk(tdCd);
	}

	@Override
	public ServiceResult turnYChk(String tdCd) {
		ServiceResult result = null;

		int status = taskMapper.turnYChk(tdCd);

		if (status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public ServiceResult turnNChk(String tdCd) {
		ServiceResult result = null;

		int status = taskMapper.turnNChk(tdCd);

		if (status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
//		return taskMapper.turnNChk(tdCd);
	}

	@Override
	public ServiceResult deleteTd(TaskVO taskVO) {
		ServiceResult result = null;
		int status = taskMapper.deleteTd(taskVO);
		if (status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}
	@Override
	public ServiceResult deleteTdForTask(String taskCd) {
		ServiceResult result = null;
		int status = taskMapper.deleteTdForTask(taskCd);
		if (status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public ServiceResult updateTd(TaskVO taskVO) {
		ServiceResult result = null;
		int status = taskMapper.updateTd(taskVO);
		if (status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public ServiceResult insertTdTeamEmp(TaskVO taskVO) {
		ServiceResult result = null;
		int status = taskMapper.insertTdTeamEmp(taskVO);
		if (status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public ServiceResult updateTask(TaskVO taskVO) {
		ServiceResult result = null;
		int status = taskMapper.updateTask(taskVO);
		if (status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public List<TaskVO> selectMyTkDetailList(String empNo) {
		return taskMapper.selectMyTkDetailList(empNo);
	}

	@Override
	public int AdminTaskCount(PaginationInfoVO<TaskVO> pagingVO) {
		return taskMapper.AdminTaskCount(pagingVO);
	}

	@Override
	public List<TaskVO> selectAdminTaskListPaging(PaginationInfoVO<TaskVO> pagingVO) {
		return taskMapper.selectAdminTaskListPaging(pagingVO);
	}

	@Override
	public List<TaskVO> notWorkEmpList(TaskVO taskVO) {
		return taskMapper.notWorkEmpList(taskVO);
	}
	
	@Override
	public List<TaskVO> portletAdminTaskList(TaskVO taskVO) {
		return taskMapper.portletAdminTaskList(taskVO);
	}

}

package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.DocHistoryVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.TodoListVO;

public interface EmpMapper {
	public EmpVO readByUserId(String empNo);
	public List<EmpVO> selectDeptEmp(String deptCd);
	public EmpVO selectCheckPw(EmpVO emp);
	public int myInfoUpdate(EmpVO empVO);
	public int myInfoUpdateProfile(EmpVO empVO);
	public String findPwCheck(EmpVO empVO);
	public int updatePw(EmpVO empVO);
	public String findName(String empNo);
	public int updateNotiList(EmpVO empVO);
	public String findSenderEmpPhto(String sender);
	
}

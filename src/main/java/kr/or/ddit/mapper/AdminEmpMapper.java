package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.SalaryVO;

public interface AdminEmpMapper {

	public int insertEmp(EmpVO empVO);

	public List<EmpVO> selectList();

	public List<EmpVO> selectEmpNumber(String deptCd);

	public void inserAuth(EmpVO empVO);

	public int empWorkseUpdate(List<EmpVO> empList);
 
	public EmpVO selectOne(String empNo);

	public int empUpdate(EmpVO empVO);

	public List<EmpVO> selectWorkEmp();

	public int uploadPayFile(SalaryVO salaryVO);

}

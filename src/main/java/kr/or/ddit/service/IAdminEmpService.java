package kr.or.ddit.service;

import java.text.ParseException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.SalaryVO;

public interface IAdminEmpService {

	public int insertEmp(EmpVO empVO);

	public List<EmpVO> selectList();

	public ServiceResult empWorkseUpdate(String[] empWorkse);

	public EmpVO selectOne(String empNo);

	public ServiceResult empUpdate(EmpVO empVO);

	public ServiceResult uploadPayFile(HttpServletRequest req, MultipartFile multipartFile) throws ParseException;

	public int insertEmpPoi(HttpServletRequest req, MultipartFile multipartFile)  throws ParseException;

	public String selectRecentPaystub(String empNo);

	
}

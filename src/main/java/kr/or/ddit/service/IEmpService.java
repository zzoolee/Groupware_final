package kr.or.ddit.service;

import java.io.UnsupportedEncodingException;
import java.util.List;

import javax.mail.MessagingException;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.TodoListVO;

public interface IEmpService {
	public List<EmpVO> showDeptEmp(String deptCd);
	public List<EmpVO> showEmpList();
	public ServiceResult findPwCheck(EmpVO empVO);
	public void authNumberMail(String email, String rnd, String status) throws UnsupportedEncodingException, MessagingException ;
}

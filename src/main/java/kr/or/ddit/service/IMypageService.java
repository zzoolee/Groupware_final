package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.EmpVO;

public interface IMypageService {

	public Map<String, String> checkPw(EmpVO emp);

	public ServiceResult myInfoUpdate(HttpServletRequest req, EmpVO empVO);

	public int updateNotiList(Map<String, List<String>> map);



}

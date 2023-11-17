package kr.or.ddit.service;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;

import kr.or.ddit.vo.AtStatusVO;
import kr.or.ddit.vo.AttendVO;
import kr.or.ddit.vo.AyannVO;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.EmpVO;

public interface IAttendService {

	// 계정 생성시 근무상태 '퇴근'으로 해주는 로직
	public void insertAttendStatus(AttendVO attendVO);
	// 계정생성시 근태상태를 하나 설정해놓는 로직
	public void insertDefaultAttend(EmpVO attendVO);
	
	// 근무유형 변경
	public int selectMaxRecentAttend(String empNo);
	public void insertStartAttendC(AttendVO attendVO);
	public void updateStartAttendC(AttendVO attendVO);	
	
	// 출퇴근 관리
	public int selectTodayWeek();
	public AttendVO selectTodayAttend(AttendVO attendVO);
	public int selectTodayAttendCount(AttendVO attendVO);
	public AttendVO selectRecentAttend(AttendVO attendVO);
	public String insertStartAttend(AttendVO attendVO) throws ParseException;
	public void updateStartAttend(AttendVO attendVO);
	public void updateEndAttend(AttendVO attendVO);

	public List<AttendVO> selectThisWeekAttend(AttendVO attendVO);
	public AttendVO sumThisWeekList(List<AttendVO> attendList) throws ParseException;
	public List<AttendVO> selectMonthExist(AttendVO attendVO);
	public List<AttendVO> selectMonthAttend(AttendVO attendVO);
	public List<AttendVO> selectWeek(AttendVO attendVO);
	public List<AttendVO> selectWeekAttend(AttendVO weekAttend);

	public AtStatusVO selectAttendStatus(AtStatusVO atStatusVO);
	public void updateAttendStatus(AtStatusVO atStatusVO);


	public AttendVO selectAttendPercent(AttendVO getAttendPercent);
	public int getPercent(AttendVO getAttendPercent);
	public void dbToExcel(Map<String, Object> parsam, HttpServletResponse response) throws IOException;
	
	public Map<String, Object> ayannList();
	public Map<String, Object> selectYearAyann(Map<String, Object> selectedYear);
	public Map<String, Object> selectYearUsedAyann(Map<String, Object> selectedUsedYear);
	public List<DeptVO> adminAyann();
	public List<AyannVO> adminAyannAjax(String deptNo);
	public void insertAllEmpAayann();
	
	public List<AttendVO> showAllAttendList();
	public List<AyannVO> selectAllAyannList();
	public void insertAllAyannBtn();
	public void ayannMailAllBtn();
	public void ayannUpdate(AyannVO ayannVO);
	public List<AttendVO> selectAttendYearExistAll();
	public List<AttendVO> showAllAttendList(AttendVO attendVO);
	public Map<String, Object> selectAdminAjaxAttend(Map<String, String> param);
	public void adminDBToExcel(Map<String, Object> param, HttpServletResponse resp) throws UnsupportedEncodingException, IOException;
	public AyannVO selectThisYearAyannMyinfo();
	public Map<String, Object> adminChart();
	public Map<String, Object> chart1select1Ajax(Map<String, String> param);
	public Map<String, Object> chart3select1Ajax(Map<String, String> param);
	public Map<String, Object> chart4select1Ajax(Map<String, String> param);
	public Map<String, Object> chart2select1Ajax();
	
}

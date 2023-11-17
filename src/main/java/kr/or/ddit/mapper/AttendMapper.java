package kr.or.ddit.mapper;

import java.util.Date;
import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.AtStatusVO;
import kr.or.ddit.vo.AttendVO;
import kr.or.ddit.vo.AyannUsedVO;
import kr.or.ddit.vo.AyannVO;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.EmpVO;

public interface AttendMapper {
	
	// 계정 생성시 근무상태 '퇴근'으로 해주는 로직
	public void insertAttendStatus(AttendVO attendVO);
	// 계정생성시 근태상태를 하나 설정해놓는 로직
	public void insertDefaultAttend(AttendVO attendVO);

	// 근무유형 변경
	public int selectMaxRecentAttend(String empNo);
	public void insertStartAttendC(AttendVO attendVO);
	public void updateStartAttendC(AttendVO attendVO);
	
	// 출퇴근 관리
	public int selectTodayWeek();
	public AttendVO selectTodayAttend(AttendVO attendVO);
	public int selectTodayAttendCount(AttendVO attendVO);
	public AttendVO selectRecentAttend(AttendVO attendVO);
	public void insertStartAttend(AttendVO attendVO);
	public void updateStartAttend(AttendVO attendVO);
	public void updateEndAttend(AttendVO attendVO);

	public List<AttendVO> selectThisWeekAttend(AttendVO attendVO);
	public int selectMonthExist(int i);
	public List<AttendVO> selectMonthExist(AttendVO attendVO);
	public List<AttendVO> selectMonthAttend(AttendVO attendVO);
	public List<AttendVO> selectWeek(AttendVO attendVO);
	public List<AttendVO> selectWeekAttend(AttendVO attendVO);

	public AtStatusVO selectAttendStatus(AtStatusVO atStatusVO);
	public void updateAttendStatus(AtStatusVO atStatusVO);

	public AttendVO selectAttendPercent(AttendVO getAttendPercent);
	public List<AyannVO> selectAyannYearList(AyannVO ayannVO);
	public AyannVO selectThisYearAyann(AyannVO ayannVO);
	public AyannVO selectYearAyann(AyannVO ayannVO);
	public List<AyannUsedVO> selectYearUsedAyann(AyannUsedVO ayannUsedVO);
	public List<DeptVO> selectDeptList();
	public List<AyannVO> adminAyannAjax(String deptNo);
	public List<AyannVO> adminAyannAjaxAll();
	public List<EmpVO> selectAllEmpList();

	public List<AttendVO> selectAttendStats();
	public List<AyannVO> selectAllAyannList();
	public void insertAyann(AyannVO ayann);
	public void ayannUpdate(AyannVO ayannVO);
	public void insertNewEmpAyann(AyannVO ayannVO);
	public List<AttendVO> selectAttendYearExist(AttendVO attendVO);
	public List<AttendVO> selectAttendYearExistAll();
	public List<AttendVO> selectAttendStats(AttendVO attendVO);
	public AyannVO selectThisYearAyannMyinfo(String userNoFind);
	public Map<String, Object> adminChart();
	public int selectEmpCountForChart();
	public int selectEmpWorkCountForChart();
	public int selectAttendCountForChart(String string);
	public List<AttendVO> selectAttendYearForChart();
	public AttendVO selectOvertimeCountForChart(AttendVO chartRes);
	public AttendVO selectAyannCountForChart(AttendVO chartRes);
	public AttendVO selectTaskForChart();
	public AttendVO selectTaskStartForChart();
	public AttendVO selectTaskEndForChart();

	

}

package kr.or.ddit.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellReference;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mapper.AttendMapper;
import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.mapper.MailMapper;
import kr.or.ddit.service.IAttendService;
import kr.or.ddit.vo.AtStatusVO;
import kr.or.ddit.vo.AttendVO;
import kr.or.ddit.vo.AyannUsedVO;
import kr.or.ddit.vo.AyannVO;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FileVO;
import kr.or.ddit.vo.MailFormVO;
import kr.or.ddit.vo.MailRecVO;
import kr.or.ddit.vo.RMailVO;
import kr.or.ddit.vo.SMailVO;
import lombok.extern.java.Log;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AttendServiceImpl implements IAttendService{
	
	@Inject
	private AttendMapper mapper;
	
	@Inject
	private EmpMapper empMapper;
	
	@Inject
	private MailMapper mailMapper;

	
	
	private String UserNoFind() {
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		UserDetails userDetails = (UserDetails)principal;
		String empNo = userDetails.getUsername();
		return empNo;
	}

	/**
	 * 근무상태생성
	 * 계정 생성시 근무상태를 기본 '퇴근'으로 생성해주는 로직.
	 */
	@Override
	public void insertAttendStatus(AttendVO attend) {
		mapper.insertAttendStatus(attend);
	}
	
	/**
	 * 근태생성
	 * 계정생성시 근태상태를 하나 설정해놓는 로직
	 */
	@Override
	public void insertDefaultAttend(EmpVO empNo) {
		int thisWeek = mapper.selectTodayWeek();
		AttendVO attendVO = new AttendVO();
		attendVO.setEmpNo(empNo.getEmpNo());
		attendVO.setAtWeek(thisWeek);
		System.out.println("기본근무상태입력대기");
		mapper.insertDefaultAttend(attendVO);
		System.out.println("기본 근태입력완료");
		mapper.insertAttendStatus(attendVO);
		System.out.println("기본 근무상태입력완료");
	}
	
	
	/**
	 * 근무상태셀렉트
	 * 가장 빠른 근태의 상태를 셀렉트하는 로직.
	 * 내일날짜를 확인하여 인서트 or 업데이트로 나누어로직을 수행하게한다.
	 */
	@Override
	public int selectMaxRecentAttend(String empNo) {
		int maxAttend = mapper.selectMaxRecentAttend(empNo);
		return maxAttend;
	}
	
	/**
	 * 근태생성(근무유형 루트)
	 * 근무유형을 변경했을때 바뀐 근무유형으로
	 * 익일 근태 테이블을 미리 생성해주는 로직.
	 */
	@Override
	public void insertStartAttendC(AttendVO attendVO) {
		
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		UserDetails userDetails = (UserDetails)principal;
		String empNo = userDetails.getUsername();
		
		attendVO.setEmpNo(empNo);

				
		int maxAttend = mapper.selectMaxRecentAttend(empNo);
		System.out.println(maxAttend);
		
		LocalDate date = LocalDate.now().plusDays(1);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
        int tmr = Integer.valueOf(date.format(formatter));
        Date tmrDate = java.sql.Date.valueOf(date);
        
        System.out.println(tmrDate);
		
		if(maxAttend!=tmr) {
			System.out.println("근태 인서트");
			mapper.insertStartAttendC(attendVO);
		}else {
			System.out.println("근태 업데이트");
			attendVO.setAtDate(tmrDate);
			mapper.updateStartAttendC(attendVO);
		}
	}
	
	/**
	 * 근태수정(근무유형 루트)
	 * 근무유형을 변경했을때 바뀐 근무유형으로 익일 근태테이블을 미리 수정해주는 로직
	 */
	@Override
	public void updateStartAttendC(AttendVO attendVO) {
		mapper.updateStartAttendC(attendVO);
	}

	/**
	 * 근태생성(정상루트)
	 * 출근을 찍었을때 근태테이블을 추가해주는 로직.
	 * @throws ParseException 
	 */
	@Override
	public String insertStartAttend(AttendVO attendVO) throws ParseException {
		
		int weeks = mapper.selectTodayWeek();
		
		attendVO.setEmpNo(UserNoFind());
		attendVO.setAtWeek(weeks);
		
		
		Calendar calendar = Calendar.getInstance();
        
        // 오늘 날짜로 설정
        Date today = calendar.getTime();
        
        // 시간을 설정하려면 Calendar 객체를 사용하여 원하는 시간을 설정
        calendar.set(Calendar.HOUR_OF_DAY, 9); // 08:00로 설정
        calendar.set(Calendar.MINUTE, 0);
        Date basicStart = calendar.getTime();
        
        calendar.set(Calendar.HOUR_OF_DAY, 8); // 07:00로 설정
        calendar.set(Calendar.MINUTE, 0);
        Date yuyeonAStart = calendar.getTime();
		       
        calendar.set(Calendar.HOUR_OF_DAY, 10); // 07:00로 설정
        calendar.set(Calendar.MINUTE, 0);
        Date yuyeonBStart = calendar.getTime();
        
        calendar.set(Calendar.HOUR_OF_DAY, 18); // 17:00로 설정
        calendar.set(Calendar.MINUTE, 0);
        Date basicEnd = calendar.getTime();
        
        calendar.set(Calendar.HOUR_OF_DAY, 17); // 16:00로 설정
        calendar.set(Calendar.MINUTE, 0);
        Date yuyeonAEnd = calendar.getTime();
        
        calendar.set(Calendar.HOUR_OF_DAY, 19); // 18:00로 설정
        calendar.set(Calendar.MINUTE, 0);
        Date yuyeonBEnd = calendar.getTime();
       
		
		if(attendVO.getAtResult().equals("출근")) {
			AttendVO ystdayAttend = new AttendVO();

			int cnt = mapper.selectTodayAttendCount(attendVO);

			if(cnt==0) {
				ystdayAttend = mapper.selectRecentAttend(attendVO);
				attendVO.setAtType(ystdayAttend.getAtType());
				mapper.insertStartAttend(attendVO);
				AttendVO checkdStartAttend = mapper.selectTodayAttend(attendVO);
				
				if(checkdStartAttend.getAtType().equals("기본")) {
					if(checkdStartAttend.getAtStart().after(basicStart)) {
						checkdStartAttend.setAtResult("지각");
						mapper.updateStartAttend(checkdStartAttend);
					}
				} else if(checkdStartAttend.getAtType().equals("유연A")) {
					if(checkdStartAttend.getAtStart().after(yuyeonAStart)) {
						checkdStartAttend.setAtResult("지각");
						mapper.updateStartAttend(checkdStartAttend);
					}
				} else if(checkdStartAttend.getAtType().equals("유연B")) {
					if(checkdStartAttend.getAtStart().after(yuyeonBStart)) {
						checkdStartAttend.setAtResult("지각");
						mapper.updateStartAttend(checkdStartAttend);
					}
				}
				
			}else {
				ystdayAttend = mapper.selectRecentAttend(attendVO);
				if(ystdayAttend.getAtStart()!=null) {
					String message = "이미 출근 등록을 하였습니다.";
					return message;
				}else {
					attendVO.setAtResult("정상출근");
					mapper.updateStartAttend(attendVO);
					
					AttendVO checkdStartAttend = mapper.selectTodayAttend(attendVO);
					
					if(checkdStartAttend.getAtType().equals("기본")) {
						if(checkdStartAttend.getAtStart().after(basicStart)) {
							checkdStartAttend.setAtResult("지각");
							mapper.updateStartAttend(checkdStartAttend);
						}
					} else if(checkdStartAttend.getAtType().equals("유연A")) {
						if(checkdStartAttend.getAtStart().after(yuyeonAStart)) {
							checkdStartAttend.setAtResult("지각");
							mapper.updateStartAttend(checkdStartAttend);
						}
					} else if(checkdStartAttend.getAtType().equals("유연B")) {
						if(checkdStartAttend.getAtStart().after(yuyeonBStart)) {
							checkdStartAttend.setAtResult("지각");
							mapper.updateStartAttend(checkdStartAttend);
						}
					}
				}
			}
		}
		if(attendVO.getAtResult().equals("퇴근")) {
			
			AttendVO finalCheckAttend = new AttendVO();
		    finalCheckAttend.setEmpNo(UserNoFind());
		    finalCheckAttend = selectTodayAttend(finalCheckAttend);
		    log.info("오늘 근무 {} : ", finalCheckAttend);
		    if(finalCheckAttend.getAtResult().equals("지각")) {
		    	attendVO.setAtResult("지각");
		    } else {
		    	attendVO.setAtResult("정상퇴근");
		    }
			
			mapper.updateEndAttend(attendVO);
		    
			SimpleDateFormat sdf = new SimpleDateFormat("HH:MM");
			SimpleDateFormat sdf2 = new SimpleDateFormat("HH");
		    AttendVO checkedEndAttend = mapper.selectTodayAttend(attendVO);
		    
		    if(checkedEndAttend.getAtType().equals("기본")) {
		    	System.out.println("여기 들어왔읍니다.");
		    	System.out.println("끝낸시간 : "+checkedEndAttend.getAtEnd());
		    	System.out.println("끝나야할 시간 : "+basicEnd);
		    	if(checkedEndAttend.getAtEnd().before(basicEnd)) {
		    		checkedEndAttend.setAtResult("조퇴");
		    		checkedEndAttend.setAtOvertime(0);
		    	} else {
		    		String endAttendString = sdf.format(checkedEndAttend.getAtEnd());
		    		String basicEndString = sdf.format(basicEnd);
		    		Date endAttendDate = sdf.parse(endAttendString);
		    		Date basicDate = sdf.parse(basicEndString);
		    		
		    		long overTimeLong = (endAttendDate.getTime()-basicDate.getTime()) / 3600000;
		    		int overTime = (int)overTimeLong;
		    		
		    		System.out.println("기본 연장근무 : "+overTime);
		    		
		    		checkedEndAttend.setAtOvertime(overTime);
		    		
		    	}
		    } else if (checkedEndAttend.getAtType().equals("유연A")) {
		    	if(checkedEndAttend.getAtEnd().before(yuyeonAEnd)) {
		    		checkedEndAttend.setAtResult("조퇴");
		    		checkedEndAttend.setAtOvertime(0);
		    	} else {
		    		String endAttendString = sdf.format(checkedEndAttend.getAtEnd());
		    		String yuyeonAEndString = sdf.format(yuyeonAEnd);
		    		Date endAttendDate = sdf.parse(endAttendString);
		    		Date basicDate = sdf.parse(yuyeonAEndString);
		    		
		    		long overTimeLong = (endAttendDate.getTime()-basicDate.getTime()) / 3600000;
		    		int overTime = (int)overTimeLong;
		    		
		    		System.out.println("유연에이 연장근무 : "+overTime);
		    		
		    		checkedEndAttend.setAtOvertime(overTime);
		    	}
		    } else if (checkedEndAttend.getAtType().equals("유연B")) {
		    	if(checkedEndAttend.getAtEnd().before(yuyeonBEnd)) {
		    		checkedEndAttend.setAtResult("조퇴");
		    		checkedEndAttend.setAtOvertime(0);
		    	} else {
		    		String endAttendString = sdf.format(checkedEndAttend.getAtEnd());
		    		String yuyeonBEndString = sdf.format(yuyeonBEnd);
		    		Date endAttendDate = sdf.parse(endAttendString);
		    		Date basicDate = sdf.parse(yuyeonBEndString);
		    		
		    		long overTimeLong = (endAttendDate.getTime()-basicDate.getTime()) / 3600000;
		    		int overTime = (int)overTimeLong;
		    		
		    		System.out.println("유연비 연장근무 : "+overTime);
		    		
		    		checkedEndAttend.setAtOvertime(overTime);
		    	}
		    	
		    } else if (checkedEndAttend.getAtType().equals("재택")) {

		    	System.out.println("여기 들어왔읍니다.");
		    	System.out.println("끝낸시간 : "+checkedEndAttend.getAtEnd());
		    	System.out.println("끝나야할 시간 : "+basicEnd);
		    	if(checkedEndAttend.getAtEnd().before(basicEnd)) {
		    		checkedEndAttend.setAtResult("조퇴");
		    		checkedEndAttend.setAtOvertime(0);
		    	} else {
		    		String endAttendString = sdf.format(checkedEndAttend.getAtEnd());
		    		String basicEndString = sdf.format(basicEnd);
		    		Date endAttendDate = sdf.parse(endAttendString);
		    		Date basicDate = sdf.parse(basicEndString);
		    		
		    		long overTimeLong = (endAttendDate.getTime()-basicDate.getTime()) / 3600000;
		    		int overTime = (int)overTimeLong;
		    		
		    		System.out.println("기본 연장근무 : "+overTime);
		    		
		    		checkedEndAttend.setAtOvertime(overTime);
		    		
		    	}
		    	
		    }
		    mapper.updateEndAttend(checkedEndAttend);
		}
		return null;
	}

	/**
	 * 근태출근수정(근무유형 루트)
	 * 근무유형 변경으로 근태테이블이 미리 생성되었을 때
	 * 인서트대신 수행할 업데이트 로직.
	 */
	@Override
	public void updateStartAttend(AttendVO attendVO) {		
		mapper.updateStartAttend(attendVO);
	}
	
	/**
	 * 근태퇴근수정(정상루트)
	 * 퇴근시 오늘의 근태를 업데이트 시킬 로직.
	 */
	@Override
	public void updateEndAttend(AttendVO attendVO) {
		
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		UserDetails userDetails = (UserDetails)principal;
		String empNo = userDetails.getUsername();
		
		attendVO.setEmpNo(empNo);
		
		mapper.updateEndAttend(attendVO);
	}


	@Override
	public AttendVO selectRecentAttend(AttendVO attendVO) {
		AttendVO recentAttend = new AttendVO();
		recentAttend = mapper.selectRecentAttend(attendVO);
		return recentAttend;
	}


	@Override
	public int selectTodayAttendCount(AttendVO attendVO) {
		return mapper.selectTodayAttendCount(attendVO);
	}


	@Override
	public AttendVO selectTodayAttend(AttendVO attendVO) {
		
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		UserDetails userDetails = (UserDetails)principal;
		String empNo = userDetails.getUsername();
		
		attendVO.setEmpNo(empNo);
		
		return mapper.selectTodayAttend(attendVO);
	}
	
	public int selectTodayWeek() {
		int weeks = mapper.selectTodayWeek();
		return weeks;
	}


	@Override
	public List<AttendVO> selectThisWeekAttend(AttendVO attendVO) {
		System.out.println("셀렉트디스위크어텐트 실행");
		
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		UserDetails userDetails = (UserDetails)principal;
		String empNo = userDetails.getUsername();		
		
		int thisWeek = mapper.selectTodayWeek();

		AttendVO attendWeek = new AttendVO();
		attendWeek.setEmpNo(empNo);
		attendWeek.setAtWeek(thisWeek);
		
		System.out.println("디스위크어텐트 사원번호 : "+empNo);
		System.out.println("디스위크어텐트 주 번호 : "+thisWeek);
		
		return mapper.selectThisWeekAttend(attendWeek);
	}


	@Override
	public AttendVO sumThisWeekList(List<AttendVO> attendList) throws ParseException {
		System.out.println("썸디스위크리스트 실행 ...");
		
		int sumAttend = 0;
		int sumOvertime = 0;
		
		AttendVO sumAttendVO = new AttendVO();

		for (AttendVO attendVO : attendList) {
			if (attendVO.getAtStart() != null) {
				SimpleDateFormat sdf = new SimpleDateFormat("HH:MM");
				String start = sdf.format(attendVO.getAtStart());
				if (attendVO.getAtEnd() != null) {
					String end = sdf.format(attendVO.getAtEnd());
					Date startTime = sdf.parse(start);
					Date endTime = sdf.parse(end);

					long diffAttend = endTime.getTime() - startTime.getTime();
					String diffAttnedHour = String.valueOf(diffAttend / 3600000);
					int diffAttendHourInt = Integer.parseInt(diffAttnedHour);
					System.out.println("시간차이 ... : " + diffAttendHourInt);

					sumOvertime += attendVO.getAtOvertime();
					sumAttend += diffAttendHourInt;
					System.out.println(sumAttend + "/" + diffAttendHourInt);
				}
			}
		}
		int overallTime = sumAttend+sumOvertime;
		
		System.out.println("근무총합시간 : "+sumAttend);
		System.out.println("총합연장근무시간 : "+sumOvertime);
		System.out.println("근무천체총합시간"+overallTime);
		
		sumAttendVO.setAtSum(sumAttend);
		sumAttendVO.setAtOverSum(sumOvertime);
		sumAttendVO.setOverallSum(overallTime);
		
		return sumAttendVO;
	}


	@Override
	public List<AttendVO> selectMonthExist(AttendVO attendVO) {
		
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		UserDetails userDetails = (UserDetails)principal;
		String empNo = userDetails.getUsername();
		
		attendVO.setEmpNo(empNo);
		
		return mapper.selectMonthExist(attendVO);
	}


	@Override
	public List<AttendVO> selectMonthAttend(AttendVO attendVO) {
		
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		UserDetails userDetails = (UserDetails)principal;
		String empNo = userDetails.getUsername();
		
		attendVO.setEmpNo(empNo);
		
		return mapper.selectMonthAttend(attendVO);
	}


	@Override
	public List<AttendVO> selectWeek(AttendVO attendVO) {	
		
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		UserDetails userDetails = (UserDetails)principal;
		String empNo = userDetails.getUsername();
		
		attendVO.setEmpNo(empNo);
		
		return mapper.selectWeek(attendVO);
	}


	@Override
	public List<AttendVO> selectWeekAttend(AttendVO attendVO) {

		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		UserDetails userDetails = (UserDetails)principal;
		String empNo = userDetails.getUsername();
		
		attendVO.setEmpNo(empNo);
		
		return mapper.selectWeekAttend(attendVO);
	}
	
	@Override
	public AttendVO selectAttendPercent(AttendVO getAttendPercent) {
		
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		UserDetails userDetails = (UserDetails)principal;
		String empNo = userDetails.getUsername();
		
		getAttendPercent.setEmpNo(empNo);
		
		return mapper.selectAttendPercent(getAttendPercent);
	}


	@Override
	public AtStatusVO selectAttendStatus(AtStatusVO atStatusVO) {
		
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		UserDetails userDetails = (UserDetails)principal;
		String empNo = userDetails.getUsername();
		
		atStatusVO.setEmpNo(empNo);
		
		return mapper.selectAttendStatus(atStatusVO);
	}


	@Override
	public void updateAttendStatus(AtStatusVO atStatusVO) {
		
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		UserDetails userDetails = (UserDetails)principal;
		String empNo = userDetails.getUsername();
		
		atStatusVO.setEmpNo(empNo);
		
		mapper.updateAttendStatus(atStatusVO);
	}


	@Override
	public int getPercent(AttendVO getAttendPercent) {
		Double diffH = Double.parseDouble(getAttendPercent.getDiffHour());
		Double diffM = Double.parseDouble(getAttendPercent.getDiffMinute());
		
		AttendVO attendVO = new AttendVO();
		attendVO.setEmpNo(UserNoFind());
		attendVO = selectTodayAttend(attendVO);
		
		Calendar cal = Calendar.getInstance();
		Double diffMinuteDouble = 0.0;
		
		if(attendVO.getAtType().equals("기본")) {
			int sysHour = cal.get(Calendar.HOUR_OF_DAY);
			int sysMinute = cal.get(Calendar.MINUTE);
			int allTime = (sysHour*60+sysMinute)-540;
			int attendTime = 1020-480;
			log.info("올타임과 근무타임 : {}, {}", allTime, attendTime);
			diffMinuteDouble = (double) ((allTime*100/attendTime));
			log.info("기본일때 퍼센트 값 : {}", diffMinuteDouble);
		} else if(attendVO.getAtType().equals("유연A")) {
			int sysHour = cal.get(Calendar.HOUR_OF_DAY);
			int sysMinute = cal.get(Calendar.MINUTE);
			int allTime = (sysHour*60+sysMinute)-480;
			int attendTime = 960-420;
			diffMinuteDouble = (double) ((allTime*100/attendTime));
			log.info("올타임과 근무타임 : {}, {}", allTime, attendTime);
			log.info("기본일때 퍼센트 값 : {}", diffMinuteDouble);
		} else if(attendVO.getAtType().equals("유연B")) {
			int sysHour = cal.get(Calendar.HOUR_OF_DAY);
			int sysMinute = cal.get(Calendar.MINUTE);
			int allTime = (sysHour*60+sysMinute)-600;
			int attendTime = 1080-540;
			diffMinuteDouble = (double) ((allTime*100/attendTime));
			log.info("올타임과 근무타임 : {}, {}", allTime, attendTime);
			log.info("기본일때 퍼센트 값 : {}", diffMinuteDouble);
		} else if(attendVO.getAtType().equals("재택")) {
			int sysHour = cal.get(Calendar.HOUR_OF_DAY);
			int sysMinute = cal.get(Calendar.MINUTE);
			int allTime = (sysHour*60+sysMinute)-540;
			int attendTime = 1020-480;
			log.info("올타임과 근무타임 : {}, {}", allTime, attendTime);
			diffMinuteDouble = (double) ((allTime*100/attendTime));
			log.info("기본일때 퍼센트 값 : {}", diffMinuteDouble);
		}
		
		log.info("퍼센트 값 : {} ", diffMinuteDouble);

		int diffMinute = (int) Math.round(diffMinuteDouble);
		if(diffMinute > 100) {
			diffMinute = 100;
		}
		System.out.println("퍼센트 퍼센트 : "+diffMinute);
		
		return diffMinute;
	}

	@Override
	public void dbToExcel(Map<String, Object> param, HttpServletResponse response) throws IOException {
		
		Object[] days = param.get("days").toString().split(",");
		Object[] attendTime = param.get("attendTime").toString().split(",");
		Object[] overTime = param.get("overTime").toString().split(",");
		Object[] kindOfAttend = param.get("kindOfAttend").toString().split(",");
		
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		UserDetails userDetails = (UserDetails)principal;
		String empNo = userDetails.getUsername();
		
		EmpVO empVO = new EmpVO();
		
		empVO.setEmpNo(empNo);
		empVO = empMapper.readByUserId(empNo);
		
		
		System.out.println((String)days[1]);
		String[] monthSplit = ((String)days[1]).split("\\.");
		System.out.println(Arrays.toString(monthSplit)); // Arrays.toString()로 배열 내용 출력
		String month = monthSplit[1];
		
		String filePath = "D:/";
		String fileNm = empVO.getEmpName()+"사원"+month+"월 근태현황.xlsx";
		String message=filePath+"/"+fileNm;

		// 빈 Workbook 생성
	    XSSFWorkbook workbook = new XSSFWorkbook();

	    // 빈 Sheet를 생성
	    XSSFSheet sheet = workbook.createSheet("employee data");
	    
	    // 폰트 스타일
	 	XSSFFont font = workbook.createFont();
	 	font.setFontName(HSSFFont.FONT_ARIAL); // 폰트 스타일
	 	font.setFontHeightInPoints((short)17); // 폰트 크기
	 	font.setBold(true); // Bold 설정

	 			
	 	
	    
	    	
	    
	    
	    sheet.setColumnWidth(1, 3330); // 1번 열의 너비 설정
	    sheet.setColumnWidth(2, 4440); // 2번 열의 너비 설정
	    sheet.setColumnWidth(3, 4440); // 3번 열의 너비 설정
	    sheet.setColumnWidth(4, 4440); // 4번 열의 너비 설정
	    
	    
	    // Sheet를 채우기 위한 데이터들을 Map에 저장
	    Map<Integer, Object[]> data = new TreeMap<Integer, Object[]>();
	    data.put(1, new Object[]{null});
	    data.put(2, new Object[]{null,empVO.getEmpName()+"사원 "+month+"월 근태현황",null,null,null});
	    data.put(3, new Object[]{null,"근무일자", "근무시간", "연장근무시간", "근무유형"});
	    for(int i = 0; i < days.length; i++) {
	    	data.put(i+4, new Object[]{null,days[i], attendTime[i], overTime[i], kindOfAttend[i]});
	    }
	    
	    
	    
	    CellStyle cellStyle = workbook.createCellStyle();
        cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        cellStyle.setAlignment(HorizontalAlignment.CENTER);
        cellStyle.setBorderTop(BorderStyle.THIN);
        cellStyle.setBorderBottom(BorderStyle.THIN);
        cellStyle.setBorderLeft(BorderStyle.THIN);
        cellStyle.setBorderRight(BorderStyle.THIN);
        
        CellStyle cellTitleStyle = workbook.createCellStyle();
        cellTitleStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        cellTitleStyle.setAlignment(HorizontalAlignment.CENTER);
        cellTitleStyle.setBorderTop(BorderStyle.THIN);
        cellTitleStyle.setBorderBottom(BorderStyle.THIN);
        cellTitleStyle.setBorderLeft(BorderStyle.THIN);
        cellTitleStyle.setBorderRight(BorderStyle.THIN);
        
        // 셀 배경색 지정 
    	// IndexedColors == org.apache.poi.ss.usermodel.IndexedColors
    	// IndexedColors객체에서 원하는 색상의 index를 가져와 적용시킵니다. 
    	// 색상표는 검색하시면 상세히 나와있습니다. 
        cellTitleStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        cellTitleStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
    	
        


        

	    
		// data에서 keySet를 가져온다. 이 Set 값들을 조회하면서 데이터들을 sheet에 입력한다.
	    Set<Integer> keyset = data.keySet();
	    int rownum = 0;
	    
	    int cnt = -1;
		// 알아야할 점, TreeMap을 통해 생성된 keySet는 for를 조회시, 키값이 오름차순으로 조회된다.
	    for (Integer key : keyset) {
	        Row row = sheet.createRow(rownum++);
	        Object[] objArr = data.get(key);
	        int cellnum = 0;
	        
	        for (Object obj : objArr) {
	        	System.out.println(obj);
	            Cell cell = row.createCell(cellnum++);
	            cnt += 1;
	            System.out.println(cnt);
	            if( obj instanceof String && cnt == 2) {
	            	System.out.print("와야하는곳 : ");
                	System.out.println(obj);
                	cell.setCellValue((String)obj);
                	cell.setCellStyle(cellTitleStyle);
                	cellTitleStyle.setFont(font); // cellStyle에 font를 적용
	            }
	            
	            else if (obj instanceof String) {
	            	System.out.println("스트링인스턴스오브");
	                cell.setCellValue((String)obj);
	                cell.setCellStyle(cellStyle); // cell은 해당 셀 객체
	                
	                
	            } else if (obj instanceof Integer) {
	            	System.out.println("인티저인스턴스오브");
	                cell.setCellValue((Integer)obj);
	                Font cellFont = workbook.createFont();
	                cell.setCellStyle(cellStyle); // cell은 해당 셀 객체
	            }   
	            
	        }
	    }
	    
        // 셀병합
	    // 셀병합의 인덱스는 0부터 시작합니다. 
	    // 첫번째 가로셀 0번째셀 부터 1번째셀 세로 0번째셀 부터 0번째셀
	    // 병합이된 셀은 텍스트만 들어가는 경우는 병합의 첫번째 셀에 텍스트와 스타일을 주면 적용되고 
	    // 색상, 외곽선등 은 반복을 통해 병합된 모든셀에 적용시켜야 병합된셀에 스타일이 적용됩니다. 
	    sheet.addMergedRegion(new CellRangeAddress(1,1,1,4));
//	    
//		try (FileOutputStream out = new FileOutputStream(new File(filePath, fileNm))) {
//	        workbook.write(out);
//	    } catch (IOException e) {
//	        e.printStackTrace();
//	    }
//		
		///////////////////////
		
		fileNm = new String(fileNm.getBytes("UTF-8"), "ISO-8859-1");

		response.reset();
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment;filename=\"" + fileNm + "\"");

		workbook.write(response.getOutputStream());
		//////////////////////
		
    }
	
	
	@Override
	public void adminDBToExcel(Map<String, Object> param, HttpServletResponse resp) throws IOException {
		String[] excelAtDate = param.get("excelAtDate").toString().split(",");
		String[] excelEmpNo = param.get("excelEmpNo").toString().split(",");
		String[] excelEmpName = param.get("excelEmpName").toString().split(",");
		String[] excelStartHour = param.get("excelStartHour").toString().split(",");
		String[] excelEndHour = param.get("excelEndHour").toString().split(",");
		String[] excelOvertime = param.get("excelOvertime").toString().split(",");
		String[] excelAtType = param.get("excelAtType").toString().split(",");
		String[] excelAtResult = param.get("excelAtResult").toString().split(",");
		String[] excelAtWeek = param.get("excelAtWeek").toString().split(",");
		
		String[] monthSplit = excelAtDate[0].split("\\.");
		String month = monthSplit[1];
		String year = monthSplit[0];
		
		String filePath = "D:/";
		String fileNm = excelEmpName[0]+" 사원 "+year+"-"+month+" 근태현황.xlsx";
		String message=filePath+"/"+fileNm;
		
		// 빈 Workbook 생성
	    XSSFWorkbook workbook = new XSSFWorkbook();

	    // 빈 Sheet를 생성
	    XSSFSheet sheet = workbook.createSheet("employee data");
	    
	    // 폰트 스타일
	 	XSSFFont font = workbook.createFont();
	 	font.setFontName(HSSFFont.FONT_ARIAL); // 폰트 스타일
	 	font.setFontHeightInPoints((short)17); // 폰트 크기
	 	font.setBold(true); // Bold 설정
	 	
	 	sheet.setColumnWidth(1, 3330); // 1번 열의 너비 설정
		sheet.setColumnWidth(2, 4440); // 2번 열의 너비 설정
		sheet.setColumnWidth(3, 4440); // 3번 열의 너비 설정
		sheet.setColumnWidth(4, 4440); // 4번 열의 너비 설정
		sheet.setColumnWidth(5, 4440); // 5번 열의 너비 설정
		sheet.setColumnWidth(6, 4440); // 6번 열의 너비 설정
		sheet.setColumnWidth(7, 4440); // 7번 열의 너비 설정
		sheet.setColumnWidth(8, 4440); // 8번 열의 너비 설정
		sheet.setColumnWidth(9, 4440); // 9번 열의 너비 설정
		
		Map<Integer, Object[]> data = new TreeMap<Integer, Object[]>();
	    data.put(1, new Object[]{null});
	    data.put(2, new Object[]{null,excelEmpName[0]+" 사원 "+year+"-"+month+" 근태현황",null,null,null,null,null,null,null,null});
	    data.put(3, new Object[]{null,"근무일자", "사원번호", "사원명", "출근시간", "퇴근시간", "연장근무시간", "근무유형", "근무결과", "근무주차"});
	    for(int i = 0; i < excelAtDate.length; i++) {
	    	data.put(i+4, new Object[]{null,excelAtDate[i], excelEmpNo[i], excelEmpName[i], excelStartHour[i], excelEndHour[i], excelOvertime[i], excelAtType[i], excelAtResult[i], excelAtWeek[i]});
	    }
		
	    CellStyle cellStyle = workbook.createCellStyle();
        cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        cellStyle.setAlignment(HorizontalAlignment.CENTER);
        cellStyle.setBorderTop(BorderStyle.THIN);
        cellStyle.setBorderBottom(BorderStyle.THIN);
        cellStyle.setBorderLeft(BorderStyle.THIN);
        cellStyle.setBorderRight(BorderStyle.THIN);
        
        CellStyle cellTitleStyle = workbook.createCellStyle();
        cellTitleStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        cellTitleStyle.setAlignment(HorizontalAlignment.CENTER);
        cellTitleStyle.setBorderTop(BorderStyle.THIN);
        cellTitleStyle.setBorderBottom(BorderStyle.THIN);
        cellTitleStyle.setBorderLeft(BorderStyle.THIN);
        cellTitleStyle.setBorderRight(BorderStyle.THIN);
        
        // 셀 배경색 지정 
    	// IndexedColors == org.apache.poi.ss.usermodel.IndexedColors
    	// IndexedColors객체에서 원하는 색상의 index를 가져와 적용시킵니다. 
    	// 색상표는 검색하시면 상세히 나와있습니다. 
        cellTitleStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        cellTitleStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
	    
        
     // data에서 keySet를 가져온다. 이 Set 값들을 조회하면서 데이터들을 sheet에 입력한다.
	    Set<Integer> keyset = data.keySet();
	    int rownum = 0;
	    
	    int cnt = -1;
		// 알아야할 점, TreeMap을 통해 생성된 keySet는 for를 조회시, 키값이 오름차순으로 조회된다.
	    for (Integer key : keyset) {
	        Row row = sheet.createRow(rownum++);
	        Object[] objArr = data.get(key);
	        int cellnum = 0;
	        
	        for (Object obj : objArr) {
	        	System.out.println(obj);
	            Cell cell = row.createCell(cellnum++);
	            cnt += 1;
	            System.out.println(cnt);
	            if( obj instanceof String && cnt == 2) {
                	cell.setCellValue((String)obj);
                	cell.setCellStyle(cellTitleStyle);
                	cellTitleStyle.setFont(font); // cellStyle에 font를 적용
	            }
	            
	            else if (obj instanceof String) {
	                cell.setCellValue((String)obj);
	                cell.setCellStyle(cellStyle); // cell은 해당 셀 객체
	                
	                
	            } else if (obj instanceof Integer) {
	                cell.setCellValue((Integer)obj);
	                Font cellFont = workbook.createFont();
	                cell.setCellStyle(cellStyle); // cell은 해당 셀 객체
	            }   
	            
	        }
	    }
	    
	 // 셀병합
	    // 셀병합의 인덱스는 0부터 시작합니다. 
	    // 첫번째 가로셀 0번째셀 부터 1번째셀 세로 0번째셀 부터 0번째셀
	    // 병합이된 셀은 텍스트만 들어가는 경우는 병합의 첫번째 셀에 텍스트와 스타일을 주면 적용되고 
	    // 색상, 외곽선등 은 반복을 통해 병합된 모든셀에 적용시켜야 병합된셀에 스타일이 적용됩니다. 
	    sheet.addMergedRegion(new CellRangeAddress(1,1,1,9));
//	    
//		try (FileOutputStream out = new FileOutputStream(new File(filePath, fileNm))) {
//	        workbook.write(out);
//	    } catch (IOException e) {
//	        e.printStackTrace();
//	    }
//		
		///////////////////////
		
		fileNm = new String(fileNm.getBytes("UTF-8"), "ISO-8859-1");

		resp.reset();
		resp.setContentType("application/octet-stream");
		resp.setHeader("Content-Disposition", "attachment;filename=\"" + fileNm + "\"");

		workbook.write(resp.getOutputStream());
		//////////////////////
	}

	@Override
	public Map<String, Object> ayannList() {
		AyannVO ayannVO = new AyannVO();
		ayannVO.setEmpNo(UserNoFind());
		
		List<AyannVO> yearList = new ArrayList<AyannVO>();
		AyannVO thisYearAyann = new AyannVO();
		
		// 연차받은 내역의 연도를 불러옴 (셀렉트 박스에 연도 추가용)
		yearList = mapper.selectAyannYearList(ayannVO);
		// 올해 연차 정보를 표시함
		thisYearAyann = mapper.selectThisYearAyann(ayannVO);
		Map<String, Object> ayannMap = new HashMap<String, Object>();
		
		ayannMap.put("yearList", yearList);
		ayannMap.put("thisYearAyann", thisYearAyann);
		
		return ayannMap;
	}

	@Override
	public Map<String, Object> selectYearAyann(Map<String, Object> selectedYear) {
		AyannVO ayannVO = new AyannVO();
		// 오브젝트로 받은 연도데이터 추가.
		ayannVO.setAyannDt((String)selectedYear.get("year"));
		// 유저데이터 추가
		ayannVO.setEmpNo(UserNoFind());
		// 연도와 유저로 해당 유저의 해당연도의 연차발생내역을 가져오는 로직.
		ayannVO = mapper.selectYearAyann(ayannVO);
		
		Map<String, Object> yearMap = new HashMap<String, Object>();
		yearMap.put("yearAyann", ayannVO);
		
		return yearMap;
	}

	@Override
	public Map<String, Object> selectYearUsedAyann(Map<String, Object> selectedUsedYear) {
		AyannUsedVO ayannUsedVO = new AyannUsedVO();
		// 오브젝트로 받은 연도데이터 추가.
		ayannUsedVO.setAyannDt((String)selectedUsedYear.get("year"));
		// 유저데이터 추가.
		ayannUsedVO.setEmpNo(UserNoFind());
		// 연도와 유저로 해당 유저의 해당연도의 연차사용내역을 가져오는 로직.
		List<AyannUsedVO> ayanUsedList = mapper.selectYearUsedAyann(ayannUsedVO);
		
		Map<String, Object> yearMap = new HashMap<String, Object>();
		yearMap.put("yearAyannUsed", ayanUsedList);
		
		return yearMap;
	}

	@Override
	public List<DeptVO> adminAyann() {
		List<DeptVO> deptList = new ArrayList<DeptVO>();
		deptList = mapper.selectDeptList();
		return deptList;
	}

	@Override
	public List<AyannVO> adminAyannAjax(String deptNo) {
		List<AyannVO> deptAyannList = new ArrayList<AyannVO>();
		if(!deptNo.equals("부서를 선택하세요")) {
			deptAyannList = mapper.adminAyannAjax(deptNo);
			for(int i = 0; i < deptAyannList.size(); i++) {
				int used = deptAyannList.get(i).getAyannCnt() - deptAyannList.get(i).getAyannRest();
				deptAyannList.get(i).setAyannUsed(used);
			}
		}else {
			deptAyannList = mapper.adminAyannAjaxAll();
		}
		return deptAyannList;
	}

	@Override
	public void insertAllEmpAayann() {
		List<EmpVO> empList = new ArrayList<EmpVO>();
		empList = mapper.selectAllEmpList();
		
		for(int i = 0; i < empList.size(); i++) {
			AyannVO ayannSet = new AyannVO();
			ayannSet.setEmpNo(empList.get(i).getEmpNo());
			
			Date date = new Date();
			Calendar cal = Calendar.getInstance();
			cal.setTime(empList.get(i).getEmpHire());
			
			int hireYear = cal.get(Calendar.YEAR);
			ayannSet.setAyannCnt(12);
		}
	}

	@Override
	public List<AttendVO> showAllAttendList() {
		return mapper.selectAttendStats();
	}

	@Override
	public List<AyannVO> selectAllAyannList() {
		return mapper.selectAllAyannList();
	}

	@Override
	public void insertAllAyannBtn() {
		List<EmpVO> empList = new ArrayList<EmpVO>();
		empList = mapper.selectAllEmpList();
		for(int i = 0; i < empList.size(); i++) {
			if(!empList.get(i).getEmpNo().equals("admin")) {
				AyannVO ayann = new AyannVO();
				AyannVO spareAyann = new AyannVO();
				ayann.setEmpNo(empList.get(i).getEmpNo());
				Calendar cal = Calendar.getInstance();
				int thisYear = cal.get(Calendar.YEAR);
				ayann.setAyannDt(String.valueOf(thisYear));
				
				spareAyann = mapper.selectThisYearAyann(ayann);
				if (spareAyann == null) {
					cal.setTime(empList.get(i).getEmpHire());
					int year = cal.get(Calendar.YEAR);
					log.info("이번년도 {} : " + thisYear);
					log.info("입사연도 {} : " + year);
					if (thisYear == year) {
						ayann.setAyannCnt(12);
						ayann.setAyannRest(12);
					} else {
						int diff = (thisYear - year) / 2;
						ayann.setAyannCnt(12 + diff);
						ayann.setAyannRest(12 + diff);
					}
					mapper.insertAyann(ayann);
				}
			}
		}
	}
	
	public void insertNewEmpAyann(AyannVO ayannVO) {
		// 유저아이디를 넣어준다.
		// 캘린더에서 '월'값을 꺼내서 담아둔다.
		Calendar cal = Calendar.getInstance();
		int thisMonth = cal.get(Calendar.MONTH);
		// 12에서 입사달을 뺀 값을 연차로 채워준다.
		ayannVO.setAyannCnt(12-thisMonth);
		ayannVO.setAyannRest(12-thisMonth);
		mapper.insertNewEmpAyann(ayannVO);
	}

	@Override
	public void ayannMailAllBtn() {
		List<EmpVO> empList = mapper.selectAllEmpList();
		Calendar cal = Calendar.getInstance();
		int thisYear = cal.get(Calendar.YEAR);
		int thisMonth = cal.get(Calendar.MONTH);
		int remainMonth = 12-thisMonth;
		String title = thisYear+"년 연차사용 촉진건";
		String content = "<p>"+thisYear+"년 연차사용 기간이 "+remainMonth+"달 남았습니다."+"</p>"+"<p>해당연도가 지나기 전에 잔여연차를 모두 소진해주시면 감사드리겠습니다.</p>";
		String shareId = "";
		String shareFileId = "";
		String shareSmailEmpno = "";

		// 메일 발신자로직
		if (1 == 1) {
			SMailVO mail = new SMailVO();
			SMailVO spareVO = new SMailVO();
			mail.setMailsEmpno("admin");
			mail.setMailTitle(title);
			mail.setMailContent(content);

			// 기본 인서트
			mailMapper.insertSmail(mail);
			// 인서트된것 중에 가장 최신을 불러옴
			spareVO = mailMapper.selectFastestOne(mail);
			mail.setMailNo(spareVO.getMailNo());
			// 위에서 가져온걸 바탕으로 하나의 인서트된 값을 불러옴.
			mail = mailMapper.selectSmailOne(mail);
			// "메일"+메일번호로 첨부파일번호 생성.
			String fileName = mail.getMailNo();
			mail.setMailFileno(fileName);
			// 첨부파일 번호 세팅
			mailMapper.updateSmailFile(mail);

			// 공용으로 쓸 만들어진 메일넘버.
			shareId = mail.getMailNo();
			// 공용으로 쓸 만들어진 파일넘버.
			shareFileId = fileName;
			// 공용으로 쓸 받은사람.
			shareSmailEmpno = mail.getMailsEmpno();
		}

		// 메일 수신자로직
		if (empList != null) {
			// 널 아닐때 리스트를 돌림.
			for (int i = 0; i < empList.size(); i++) {
				AyannVO restYann = new AyannVO();
				restYann.setEmpNo(empList.get(i).getEmpNo());
				restYann = mapper.selectThisYearAyann(restYann);
				// 수신자에 admin이 포함되어있으면 안된다.
				if (!empList.get(i).getEmpNo().equals("admin")) {
					// 수신자의 남은 연차가 1개 이상일 때만 보낸다.
					
					if (restYann != null && restYann.getAyannRest() > 0) {
						System.out.println("rmail수신자 : " + empList.get(i).getEmpNo());
						// 받은메일보 초기화.
						RMailVO mail = new RMailVO();
						// 메일수신참조보 초기화.
						MailRecVO recVO = new MailRecVO();
						// 메일 번호
						mail.setMailNo(shareId);
						// 메일 제목
						mail.setMailTitle(title);
						// 메일 내용
						mail.setMailContent(content);
						// 메일 보낸사람
						mail.setMailsEmpno(shareSmailEmpno);
						// 메일 받는사람
						mail.setMailrEmpno(empList.get(i).getEmpNo());
						// 메일 체크여부
						mail.setMailChkse("1");
						// 메일 삭제여부
						mail.setMailDelse("1");
						// 메일 중요메일여부
						mail.setMailImpse("1");
						// 메일 첨부파일 번호
						mail.setMailFileno(shareFileId);
						// 받은메일 인서트.
						mailMapper.insertRmail(mail);

						// 메일 수신테이블에 추가.
						recVO.setMailNo(shareId);
						recVO.setMailrecEmpno(empList.get(i).getEmpNo());
						// 받은이 인서트.
						mailMapper.insertRecEmp(recVO);
					}
				}
			}
		}
	}

	@Override
	public void ayannUpdate(AyannVO ayannVO) {
		mapper.ayannUpdate(ayannVO);
	}

	@Override
	public List<AttendVO> selectAttendYearExistAll() {
		
		return mapper.selectAttendYearExistAll();
	}
 
	@Override
	public List<AttendVO> showAllAttendList(AttendVO attendVO) {
		return mapper.selectAttendStats(attendVO);
	}

	// 관리자 근태관리에서 ajax로 받아온 파람값을 이용하여 해당해원 월근태 보여줌.
	@Override
	public Map<String, Object> selectAdminAjaxAttend(Map<String, String> param) {
		// 리턴해줄 ajaxMap 초기화
		Map<String, Object> ajaxMap = new HashMap<String, Object>();
		// 데이터를 넣어 쿼리문으로 보내줄 attendVO 초기화
		AttendVO attendVO = new AttendVO();
		// param에서 가져온 이름 값과 년-월 값을 세팅
		String empNo = param.get("empNo");
		String yearMonth = param.get("year");
		attendVO.setEmpNo(empNo);
		attendVO.setYearMonth(yearMonth);
		log.info("회원 넘버 값 : {}", empNo);
		log.info("이어몬쓰 값 : {}", yearMonth);
		// attendList로 해당 사원의 년-월의 근태를 가져옴.
		List<AttendVO> attendList = mapper.selectMonthAttend(attendVO);
		
		// 리턴해줄 ajaxMap에 값을 담아줌. (해당사원의 년-월 근태 데이터가 리스트 형태로 들어있음)
		ajaxMap.put("attendList", attendList);
		
		return ajaxMap;
	}

	@Override
	public AyannVO selectThisYearAyannMyinfo() {
		return mapper.selectThisYearAyannMyinfo(UserNoFind());
	}

	@Override
	public Map<String, Object> adminChart() {

		Map<String, Object> chartMap = new HashMap<String, Object>();
		
		List<AttendVO> yearList = new ArrayList<AttendVO>();
		
		int empCount = mapper.selectEmpCountForChart();
		int workCount = mapper.selectEmpWorkCountForChart();
		int basic = mapper.selectAttendCountForChart("기본");
		int yuyeonA = mapper.selectAttendCountForChart("유연A");
		int yuyeonB = mapper.selectAttendCountForChart("유연B");
		int atHome = mapper.selectAttendCountForChart("재택");
		
		empCount = empCount-workCount;
		
		yearList = mapper.selectAttendYearForChart();
		
		chartMap.put("empCount", empCount);
		chartMap.put("workCount", workCount);
		chartMap.put("basic", basic);
		chartMap.put("yuyeonA", yuyeonA);
		chartMap.put("yuyeonB", yuyeonB);
		chartMap.put("atHome", atHome);
		chartMap.put("yearList", yearList);
		
		return chartMap;
	}
	
	
	@Override
	public Map<String, Object> chart1select1Ajax(Map<String, String> param) {
		// TODO Auto-generated method stub
		return null;
	}


	@Override
	public Map<String, Object> chart2select1Ajax() {
		
		Map<String, Object> chartAjax = new HashMap<String, Object>();
		AttendVO chartRes = new AttendVO();
		
		chartRes = mapper.selectTaskStartForChart();
		chartAjax.put("start", chartRes);
		
		chartRes = mapper.selectTaskEndForChart();
		chartAjax.put("end", chartRes);
		
		return chartAjax;
	}


	@Override
	public Map<String, Object> chart3select1Ajax(Map<String, String> param) {
		
		Map<String, Object> chartAjax = new HashMap<String, Object>();
		AttendVO chartRes = new AttendVO();
		
		chartRes.setAtDateString(param.get("year"));
		chartRes.setDeptName(param.get("dep"));

		log.info("데이트 스트링 : {}", chartRes.getAtDateString());
		log.info("부서이름 : {}", chartRes.getDeptName());
		
		chartRes = mapper.selectOvertimeCountForChart(chartRes);
		chartAjax.put("chartRes", chartRes);
		
		return chartAjax;
	}

	@Override
	public Map<String, Object> chart4select1Ajax(Map<String, String> param) {
		
		Map<String, Object> chartAjax = new HashMap<String, Object>();
		AttendVO chartRes = new AttendVO();
		
		chartRes.setAtDateString(param.get("year"));
		chartRes.setDeptName(param.get("dep"));

		log.info("데이트 스트링 : {}", chartRes.getAtDateString());
		log.info("부서이름 : {}", chartRes.getDeptName());
		
		chartRes = mapper.selectAyannCountForChart(chartRes);
		chartAjax.put("chartRes", chartRes);
		
		return chartAjax;
	}


}
	













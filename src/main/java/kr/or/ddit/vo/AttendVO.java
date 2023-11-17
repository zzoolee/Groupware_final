package kr.or.ddit.vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class AttendVO {
	@DateTimeFormat(pattern = "HH:mm")
	private Date atDate;
	// 날짜를 스트링으로 넘겨서 db에서 to_date를 쓰고싶을때.
	private String atDateString;
	private String empNo;
	private Date atStart;
	private Date atEnd;
	private int atOvertime;
	private String atType;
	private String atResult;
	private int atWeek;
	// 한주 근무 내용 넣어줄 변수
	private int atSum;
	// 한주 연장은무 내용 넣어줄 변수
	private int atOverSum;
	// 한주 전체근무 내용 넣어줄 변수
	private int overallSum;
	// 년도정보와 달정보를 넣어줄 변수
	private String yearMonth;
	// 근무퍼센테이지를 구할때 사용할 시작시간의 '시간'단위를 받아낼 변수
	private String diffHour;
	// 근무퍼센테이지를 구할때 사용할 시작시간의 '분'단위를 받아낼 변수
	private String diffMinute;
	
	private String empName;
	private String deptName;
	private String cdName;
	private int sumOvertime; // 당월 연장근무 시간
	private int sumResultlate; // 당월 지각횟수
	private int sumResultoff; // 당월 조퇴횟수
	
	// 차트에 사용될 부서별 지각 카운트와 부서별 조퇴카운트
	private int lateCount;
	private int offCount;
	
	// 월별 정보를 받아올 변수.
	private int jan;
	private int fab;
	private int mar;
	private int apr;
	private int may;
	private int jun;
	private int jul;
	private int aug;
	private int sep;
	private int oct;
	private int nov;
	private int dec;
}

package kr.or.ddit.vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class RoomResVO {
	private String rrCd; // 회의실 예약 코드
	private Date rrDate; // 회의실 예약 날짜
	private String rrStarttime; // 회의실 예약 시작 시간
	private String rrEndtime; // 회의실 예약 종료 시간
	private String rrReason; // 회의실 예약 사유
	private String empNo; // 사번
	
	private String fullname; // 김서현(2310A01001)/경영지원팀
	
	private String roomCd;// 회의실 코드
	private String roomName; // 회의실명
	private String roomLoc; // 회의실 위치
	
}

package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class AssRentVO {
	// asrent
	private String asrCd; // 자산대여 코드
	private Date asrDate; // 자산대여시작시간
	private String asrStarttime; // 자산대여시작시간
	private String asrEndtime; // 자산대여종료시간
	private String asrReason; // 자산대여사유
	private String empNo; // 사번
	
	private String fullname; // 김서현(2310A01001)/경영지원팀
	
	// asset
	private String asCd; //자산 코드
	private String asSe; // 자산구분
	private String asName; // 자산명
	private String asLoc; // 자산 보관 위치
}

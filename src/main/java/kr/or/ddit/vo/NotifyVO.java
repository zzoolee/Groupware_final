package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class NotifyVO {

	private String notifyCd; // 알림 코드
	private String notifyContent; //알림 내용
	private String notifyTypese; // 알림 종류 구분
	private String notifyEmpno; // 알림받을 사번
	private String notifyCkse; // 알림확인 상태값
	private Date notifyDate; // 알림 등록 날짜

}

package kr.or.ddit.vo;

import lombok.Data;

@Data
public class AppBMLineVO {

	private String applEmpno;	// 즐겨찾는 결재선 결재자
	private String applOrder;	// 우선순위
	private String abmCd;		// 즐겨찾는 결재선 코드

	private String empName;
	private String deptName;
	private String cdName;
	
}

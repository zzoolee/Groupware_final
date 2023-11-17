package kr.or.ddit.vo;

import lombok.Data;

@Data
public class AtrzPathVO {

	private String atrzpCd;			//결재선 코드
	private String atrzpEmpno;		//결재자 사번
	private int atrzpOrder;			//결재우선순위
	private String atrzpStatusse;	//결재상태 구분(대기, 결재, 반려)
	private String atrzpDate;
	private String drftCd;			//기안 코드

	//private String atrzpEmpname;	// 결재자 이름(쿼리문에서 alias 사용함)

	private String deptName;
	private String empNo;
	private String empName;
	private String empSign;
	private String cdName;
	
	
}

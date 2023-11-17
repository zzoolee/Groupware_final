package kr.or.ddit.vo;

import java.sql.Date;
import java.util.List;

import lombok.Data;

@Data
public class DraftVO {

	private String drftCd;				//기안 코드!!
	private String drftTitle;
	private String drftContent;
	private String drftDate;
	private String drftStartdate;
	private String drftEnddate;
	private String drftReason;
	private String drftSubmitse;		//기안 제출 구분 (임시저장, 제출)
	private String drftPrgrsse;			//기안 진행 구분(임시저장, 진행중, 완료, 반려)
	private String drftAprvse; 			//승인 구분(전결, 결재)
	private String drftMemo;			//반려사유
	
	private String atrzfCd;				// 결재 양식 코드!!
	private String empNo;				// 사번
	private String empName;				// 이름
	private String empSign;				
	
	
	private String[] atrzpEmpno;		//결재선 결재자 (3명)
	private String atrzpStatusse;
	private String atrzpDate;
	private AtrzPathVO pathVO;
	
	
	private DraftRefVO refVO;
	private String[] refEmpno;			//참조자
	
	private String deptName;
	private String cdName;
	
}

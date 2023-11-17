package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class SalaryVO {
	
	private String salNo;
	private int salGramt;
	private int salOvertimeamt;
	private int salHolidayamt;
	private int salDdcamt;
	private int salNetamt;
	private Date salActrsfdate;
	private String salBelongmonth;
	private String empNo;
	private String docCd;
	
	
	
	
}

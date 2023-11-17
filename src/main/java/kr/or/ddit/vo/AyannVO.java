package kr.or.ddit.vo;

import java.time.LocalDate;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class AyannVO {
	private String ayannDt;
	private String empNo;
	private int ayannCnt;
	private int ayannRest;
	
	private String empName;
	private String deptCd;
	private String deptName;
	private String cdName;
	private int ayannUsed;
	private Date empHire;
}

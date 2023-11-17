package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class ClubAllMemberVO {

	private String joinEmpno;
	private String empName;
	private String empHp;
	private String deptName;
	private String cdName;
	private String clubCd;
	private String joinContent;
	private Date joinDate;
	private String status;
	
}

package kr.or.ddit.vo;

import lombok.Data;

@Data
public class ExtaddVO {
	private String extCd;
	private String extName;
	private String extCompany;
	private String extRank;
	private String extHp; // 개인 휴대전화번호
	private String extTel; // 업체 전화번호
	private String empNo;
	private String extEmail;
}

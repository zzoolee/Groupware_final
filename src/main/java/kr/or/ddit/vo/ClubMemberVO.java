package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class ClubMemberVO {
	private String cmEmpno;
	private String clubCd;
	private Date cmDate;
	private String cmRankse;
}

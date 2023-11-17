package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class DocHistoryVO {
	
	private String empNo;
	private Date docDate;
	private String docSe;
	private String docName;
	private String docCd;
}

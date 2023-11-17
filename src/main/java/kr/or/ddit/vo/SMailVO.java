package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class SMailVO {
	private String mailNo;
	private String mailTitle;
	private String mailContent;
	private Date mailDate;
	private String mailrEmpno;
	private String mailsEmpno;
	private String mailFileno;
	
	// 보낸사람 이름들.
	private String mailrEmpname;
	private String mailsEmpname;
	
	// 수신자 전원
	private List<MailRecVO> mailRec;
	// 참조자 전원
	private List<MailRecVO> mailRef;
	// 외 명수를 얻어낼 값
	private int recCnt;
	// 파일 리스트 저장할 곳.
	private List<FileVO> fileList;
}

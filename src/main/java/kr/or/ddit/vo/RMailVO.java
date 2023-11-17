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
public class RMailVO {
	private String mailNo; // 시퀀스로 채워줌
	private String mailTitle; // 제목 _필수
	private String mailContent; // 내용 _필수
	private Date mailDate; // 시스데이트로 채워줌
	private String mailrEmpno; // 받는사람사번 _필수
	private String mailsEmpno; // 보낸사람사번 _필수
	private String mailImpse;
	private String mailDelse;
	private String mailFileno;
	private String mailChkse;
	
	// 보낸, 받는사람 이름들.
	private String mailrEmpname;
	private String mailsEmpname;
	
	// 참조자를 받아낼 변수.
	private String mailrefEmpno;
	
	// 수신자 전원
	private List<MailRecVO> mailRec; // 받는사람들 목록
	// 참조자 전원
	private List<MailRecVO> mailRef;
	// 파일 리스트 저장할 곳.
	private List<FileVO> fileList;
}

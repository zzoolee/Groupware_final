package kr.or.ddit.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class MailRecVO {
	private String mailNo;
	private String mailrefEmpno;
	private String mailrefEmpname;
	private String mailrecEmpno; // 필수
	private String mailrecEmpname;
}

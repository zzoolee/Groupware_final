package kr.or.ddit.vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@NoArgsConstructor
public class ChatVO {
	private int chatNo;
	@DateTimeFormat(pattern = "MM-DD HH:mm:ss")
	@JsonFormat(pattern = "MM-dd HH:mm:ss", timezone = "Asia/Seoul")
	private Date chatDate;
	private String chatMsg; 
	private String chasenderEmpno;
	private int chatUncheck;
	private String crNo;
	private String empNo;
}

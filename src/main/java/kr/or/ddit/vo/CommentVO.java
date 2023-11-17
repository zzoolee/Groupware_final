package kr.or.ddit.vo;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@NoArgsConstructor
public class CommentVO {
	private String cmNo;
	private String cmContent;
	private String cmwriterEmpno;
	private String empName;
	private String empPhoto;
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm", timezone = "Asia/Seoul")
	private Date cmDate;
	private String cmBoardse; // 동호회의 경우 'CLUB'
	private String cmBno;	  // CLUBPOST의 cpNo
}

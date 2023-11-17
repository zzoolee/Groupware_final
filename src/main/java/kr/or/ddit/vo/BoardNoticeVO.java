package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data@ToString
@NoArgsConstructor
public class BoardNoticeVO {
	private String noNo;
	private String noTitle;
	private String noContent;
	private Date noDate;
	private int noHit;
	// 공지사항 작성자
	private String noWriterEmpNo;
	// 작성자 이름
	private String empName;
	// 공지사항 첨부파일 리스트
	private List<MultipartFile> noFile;
	// 삭제시킬 파일번호
	public String[] fileSec;
	private String noFix;
}

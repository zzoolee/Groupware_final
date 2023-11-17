package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@NoArgsConstructor
public class BoardFeventVO {
	public String feNo;
	public String feTitle;
	public String feContent;
	public Date feDate;
	// 조회수
	public int feHit;
	// 글쓴이
	public String feWriterEmpNo;
	// 작성자 이름
	private String empName;
	// 자유 게시판 첨부파일 리스트
	private List<MultipartFile> feFile;
	// 삭제시킬 파일번호
	public String[] fileSec;
}

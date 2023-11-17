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
public class BoardFreeVO {
	private String frNo;
	private String frTitle;
	private String frContent;
	private Date frDate;
	private int frHit;
	// 좋아요
	private int frLike;
	// 자유게시판 작성자
	private String frWriterEmpNo;
	// 작성자 이름
	private String empName;
	// 자유 게시판 익명 구분
	private String frAnonySe;
	// 자유 게시판 첨부파일 리스트
	private List<MultipartFile> frFile;
	// 삭제시킬 파일번호
	public String[] fileSec;
}

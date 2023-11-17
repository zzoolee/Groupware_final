package kr.or.ddit.vo;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class ClubPostVO {
	private String cpNo;			// 게시글번호
	private String cpTitle;			// 게시글제목
	private String cpContent;		// 게시글내용
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	@JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date cpDate;			// 게시글작성일
	private int cpHit;				// 게시글조회수
	private String cpwriterEmpno;	// 게시글작성자
	private String empName;
	private String cbCd;			// 게시판코드
	private String clubCd;			// 동호회코드
	
	private String fileNo;
	private String fileSavepath;
	
	private List<CommentVO> commentList;
	private int cmCnt;
	
	private MultipartFile[] files;
	private List<FileVO> fileList;

	private String[] delFileSec;
	
	public void setFiles(MultipartFile[] files) {
		this.files = files;
		if(files != null) {
			List<FileVO> fileList = new ArrayList<FileVO>();
			for(MultipartFile item : files) {
				if(StringUtils.isBlank(item.getOriginalFilename())) {
					continue;
				}
				FileVO fileVO = new FileVO(item);
				fileList.add(fileVO);
			}
			this.fileList = fileList;
		}
	}
}

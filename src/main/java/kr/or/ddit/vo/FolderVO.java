package kr.or.ddit.vo;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class FolderVO {
	
	// 폴더
	private String folderCd;
	private String folderSe;
	private String empNo;
	private String folderName;
	private String folderParent;
	private String folderDelse;
	private String folderPath;
	private Date folderUploaddt;
	
	// 폴더의 크기
	private long folderSize;
	
	private String folderOwnPath;
	
	// 폴더자료
	private String fileCd;
	private int fileSec;
	
	// 멀티파일 자료 모음
	private MultipartFile[] foFile;
	
	// 검색내용
	private String searchText;
}

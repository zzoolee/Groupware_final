package kr.or.ddit.vo;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class FolderFileVO {
	 
	private String fileCd;
	private int fileSec;
	private String fileOrgname;
	private String fileSavename;
	private String fileSavepath;
	private long fileSize;
	private String fileMime;
	private String fileType;
	private int fileDowncnt;
	private Date fileUploaddt;
	private String fileSe;
	private int fileLikese;
	private int fileApprse;
	private String empNo;
	
}

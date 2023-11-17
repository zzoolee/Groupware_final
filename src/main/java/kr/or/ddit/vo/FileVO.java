package kr.or.ddit.vo;

import org.apache.commons.io.FileUtils;
import org.springframework.web.multipart.MultipartFile;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@NoArgsConstructor
public class FileVO {
	private MultipartFile item;
	// 첨부파일 코드
	public String fileNo;
	// 첨부파일 순번
	public int fileSec;
	// 파일 원본 파일명
	public String fileOrgname;
	// 파일 저장 파일명
	public String fileSavename;
	// 파일 저장 경로
	public String fileSavepath;
	// 파일 크기
	public long fileSize;
	// 파일 MIME 타입
	public String fileMime;
	// 파일 확장자
	public String fileType;
	
	public FileVO(MultipartFile item) {
		this.item = item;
		this.fileOrgname = item.getOriginalFilename();
		this.fileSize = item.getSize();
		this.fileMime = item.getContentType();
		this.fileType = fileOrgname.substring(fileOrgname.lastIndexOf(".")+1);
	}

	public FileVO(String fileNo, String fileOrgname, String fileSavename, String fileSavepath,
			long fileSize, String fileMime, String fileType) {
		super();
		this.fileNo = fileNo;
		this.fileOrgname = fileOrgname;
		this.fileSavename = fileSavename;
		this.fileSavepath = fileSavepath;
		this.fileSize = fileSize;
		this.fileMime = fileMime;
		this.fileType = fileType;
	}
	
}

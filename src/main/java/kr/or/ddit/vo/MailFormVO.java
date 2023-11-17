package kr.or.ddit.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class MailFormVO {
	
	private List<String> mailEmpno;
	private List<String> mailRef;
	private String mailTitle;
	private String mailContent;
	private List<MultipartFile> fileList;

}

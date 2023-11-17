package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class EmpVO {
	@JsonProperty("id")
	private String empNo;
	private String empPw;
	private String empPwNew;
	private String empName;
	private String empGender;
	private String empRegno;
	private String empForeig;
	private String deptCd;
	private String empRank;
	private int empLevel;
	private String empHp;
	private String empEmail;
	private String empAdd1;
	private String empAdd2;
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date empHire;
	
	private String empPhoto;
	private MultipartFile imgFile;
	private String empSign;
	private MultipartFile signImgFile;

	private int empWorkse;
	private String empLoginse;
	private int enabled;
	private List<Auth> authList;
	private DeptVO deptVO;
	private CodeVO codeVO;
	
	@JsonProperty("text")
	private String fullName; // 이름 + 직급 ex) 김서현 대리
	private int empCustomNo;
	private String notiList;
}

package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@NoArgsConstructor
public class chatSelectResultVO {
	private String crNo;
	private String crcmTitle;
	private String crTitle;
	private String crSe;
	
	private int chatNo;
	@DateTimeFormat(pattern = "MM-DD HH:mm:ss")
	@JsonFormat(pattern = "MM-dd HH:mm:ss", timezone = "Asia/Seoul")
	private Date chatDate;
	private String chatMsg;
	// 보낸이
	private String chasenderEmpno;
	// 유저리스트
	private List<String> userList;
	// 방리스트
	private List<String> roomList;
	
	
	private String empNo;
	private String empName;
	// 사진
	private String empPhoto;
	// 팀 코드
	private String deptCd;
	// 팀 이름
	private String deptName;
	// 직원의 상태
	private String atStatus;
}

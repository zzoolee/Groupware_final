package kr.or.ddit.vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@NoArgsConstructor
public class ChatRoomDTLVO {	// 채팅방 상세보기 저장
	// ChatVO
	private int chatNo;
	@DateTimeFormat(pattern = "MM-DD HH:mm:ss")
	@JsonFormat(pattern = "MM-dd HH:mm:ss", timezone = "Asia/Seoul")
	private Date chatDate;
	private String chatMsg; 
	private String chasenderEmpno;
	private String crcmTitle;
	// 채팅방에 뿌려줄 제목
	private String title;
	// 로그인 한 사람
	private String chatuser;
	
	private int chatUncheck;
	private String crNo;
	// 채팅 유저 프로필 목록(EmpVO)
	private String empPhoto;
}

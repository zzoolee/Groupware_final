package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class ClubVO {
	private String clubCd;
	private String clubName;
	private Date clubDate;
	private String clubInfo;
	private String clubPhoto;
	private String clubReason;
	private String clubEmpno; // 동호회장
	private String empName; // 동호회장 이름
	private String empHp; // 동호회장 연락처
	private String deptName; // 동호회장 부서
	private String cdName; // 동호회장 직급
	private String clubSe; // 승인상태
	private int memCount; // 회원 수
	
	private String myClub; // 내가 속한 동호회에서 나의 상태 : clubhead-회장, clubstandby-가입승인대기, clubmem-회원

	private String rejectReason;
	private String shutdownReason;
	
	private String clubBoardSe;
	private List<ClubPostVO> clubNOPostList;
	private List<ClubPostVO> clubFRPostList;
	private List<ClubPostVO> clubACPostList;
	
	private List<ClubMemberVO> memberList;
	private List<ClubAllMemberVO> allMemberList;
}

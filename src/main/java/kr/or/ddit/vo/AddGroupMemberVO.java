package kr.or.ddit.vo;

import lombok.Data;

@Data
public class AddGroupMemberVO {
	private String mygrCd;
	private String mygrEmpno; // 그룹에 속해있는 멤버 사번
	private EmpVO empVO;
	
	private int rnum;
}

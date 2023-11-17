package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class MyAddGroupVO {
	private String mygrCd;
	private String mygrName;
	private String empNo;  // 그룹 소유자
	private String mygrSe; // 기본그룹일 경우 'basic'
	private List<AddGroupMemberVO> groupMember; // 일대다테이블 데이터 가져오려면 필수
	
	private String[] mygrEmpno;
}

package kr.or.ddit.vo;



import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class TaskVO {
	private int taskCount; // 업무 개수(로그인한 사용자가 책임자 / 팀원으로 등록된 업무)
	private String taskCd; // 업무코드
	private String taskTitle; // 업무제목
	private String taskContent; // 업무내용
	private String taskStartdate; // 업무시작일
	private String taskEnddate; // 업무종료일
	private String taskType; // 업무유형
	private String taskMemo; // 업무메모
	private String empNo; // 책임자 사번
	private String teamEmp; // 팀원들(쉼표로 구분)
	private String empPhoto; // 책임자 사진
	private String empName; // 사원이름
	private String teamempPhotos; // 팀원들 사진(쉼표로 구분)
	private String tdCd; // 세부업무코드
	private String tdEmpname; // 세부업무담당자이름
	private String tdContent; // 세부업무내용
	private String tdStartdate; // 세부업무시작일
	private String tdEnddate; // 세부업무종료일
	private String tdClosedate; // 세부업무마감일
	private String tdMemo; // 세부업무비고(메모)
	private String tdStatusse; // 세부업무상태
	private String tdEmpno; // 세부업무담당자
	private String tdEmpphoto; // 세부업무담당자사진
	private String chargeEmp; // 책임자 사번
	private String checkvalue; // 체크박스여부
	private String tdYchk; // 세부업무 완료된 상태 개수
	private String tdTotchk; // 세부업무 개수	2310A01002
	private String statusEmp; // 세부업무 담당 여부(1이면 세부업무 담당자, 2이면 세부업무 담당자x)
//	private String deletedTeamMembers; // 삭제할 팀원
	private List<String> delEmpList; // 삭제할 팀원
//	private List<String> dataList;	// 결과를 넣을 데이터 리스트
//	private List<String> empList;	// 결과를 넣을 데이터 리스트 - 팀원
	
	private List<String> teamEmpList; 
//	private String[] teamEmpList;
//	private String[] teamSepEmpList;

	private String myrole; // '책임자' or '팀원'
	private List<TkDetailVO> tkDetailList; // 세부업무목록 리스트
}

package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class TkDetailVO {
	private String tdCd; // 세부업무코드
	private String tdContent; // 세부업무내용
	private String tdStartdate; // 세부업무시작일
	private String tdClosedate; // 세부업무마감일
	private String tdEnddate; // 세부업무종료일
	private String tdMemo; // 세부업무비고(메모)
	private String tdStatusse; // 세부업무상태
	private String tdEmpno; // 세부업무담당자
}

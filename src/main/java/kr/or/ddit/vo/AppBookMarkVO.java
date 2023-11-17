package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class AppBookMarkVO {

	private String abmCd; 		// 즐겨찾는 결재선 코드
	private String abmName; 	// 결재선 이름
	private String empNo; 		// 사번
	
	private List<AppBMLineVO> abmLineList;
	
}

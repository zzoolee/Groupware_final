package kr.or.ddit.vo;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class DeptVO {
	@JsonProperty("id")
	private String deptCd;
	@JsonProperty("text")
	private String deptName;
	private String deptHeadEmpNo;
	@JsonProperty("parent")
	private String deptParent;
	@JsonProperty("icon")
	private String deptIcon;
}

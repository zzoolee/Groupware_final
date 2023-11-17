package kr.or.ddit.vo;

import java.util.Calendar;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class ScheVO {
	private String scCd;
	private String scSe;
	@JsonProperty("title")
	private String scTitle;
	@JsonProperty("content")
	private String scContent;
	@JsonProperty("start")
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	@JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date scStartdate;
	@JsonProperty("end")
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	@JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date scEnddate;
	private String empNo;
	private String deptCd;
	
	private Boolean comSelect;
	private Boolean deptSelect;
	private Boolean empSelect;
	
	@JsonProperty("className")
	private String textColor;
//	private Boolean allDay = true;
	
	public void setScSe(String scSe) {
		this.scSe = scSe;
		switch(scSe) {
		case "A101" : this.textColor = "text-primary"; break; // 회사
		case "A102" : this.textColor = "text-success"; break; // 부서
		case "A103" : this.textColor = "text-secondary"; break; // 일정
		}
	}
}

package kr.or.ddit.vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class SeatResVO {
	private String srCd;
	private String offCd;
	private String offLoc;
	private String srNo;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	@JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date srDate;
	private String empNo;
	
	private String fullname; // 김서현(2310A01001)/경영지원팀
	private String offSe; // 좌석유형
	
	public void setOffCd(String offCd) {
		this.offCd = offCd;
		switch(offCd.substring(2)) {
		case "IMMER" : this.offSe = "몰입형"; break;
		case "OPEN" : this.offSe = "오픈형"; break;
		case "TEAM" : this.offSe = "협업형"; break;
		}
	}
}

package kr.or.ddit.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class AyannUsedVO {
	private String ayannUsedcd;
	private String ayannStartdate;
	private Date ayannEnddate;
	private int ayannUsedamt;
	private String ayannDt;
	private String empNo;
}

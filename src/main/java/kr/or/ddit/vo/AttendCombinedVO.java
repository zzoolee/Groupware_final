package kr.or.ddit.vo;

import lombok.Data;

@Data
public class AttendCombinedVO {
	private AttendVO attendVO;
	private AtStatusVO atStatusVO;
	private int percent;
}

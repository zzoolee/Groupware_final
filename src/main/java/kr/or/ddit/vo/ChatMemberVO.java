package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@NoArgsConstructor
public class ChatMemberVO {
	private String empNo;
	private List<String> empNos;
	private String crNo;
	private int ccFirst;
	private int ccEnd;
	private int cmStatus;
	private String crcmTitle;
	private int chatNo;
}

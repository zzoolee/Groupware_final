package kr.or.ddit.vo;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Data;

@Data
public class BoardListVO {
	@JsonIgnore
	private List<BoardNoticeVO> noticeList;
	@JsonIgnore
	private List<BoardFeventVO> feventList;
}

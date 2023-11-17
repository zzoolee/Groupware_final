package kr.or.ddit.vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class TodoListVO {
	
	private String empNo;
	private String todoContent;
	private String todoCheckse;
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date todoDate;
	private String todoCd;
	private int todoCustomCd;
	// todoList 삭제 시 todoCd를 한번에 담을 배열 
	private String[] todoCdArr;
}

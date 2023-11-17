package kr.or.ddit.vo;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class PortletVO<T> {
	@JsonProperty("id")
	private String portCatecode;
	private String empNo;
	private int portUsese;
	@JsonProperty("x")
	private int portXcoord;
	@JsonProperty("y")
	private int portYcoord;
	@JsonProperty("w")
	private int portWidth;
	@JsonProperty("h")
	private int portHeight;
	
	@JsonIgnore
	private List<T> dataList;
	
	@JsonIgnore
	private T data;
}

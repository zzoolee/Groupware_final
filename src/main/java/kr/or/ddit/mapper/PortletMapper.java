package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.PortletVO;

public interface PortletMapper {
	public void deletePortlet(String empNo);
	public void insertPortlet(PortletVO portlet);
	public List<PortletVO> selectPortletList(String empNo);
}

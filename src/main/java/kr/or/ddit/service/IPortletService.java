package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.PortletVO;

public interface IPortletService {
   
   public void clearPortlet(String empNo);
   public void addPortlet(PortletVO portlet);
   public List<PortletVO> showPortlet(String empNo);
   public List<PortletVO> showAdminPortlet(String name);

}
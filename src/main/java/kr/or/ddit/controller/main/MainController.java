package kr.or.ddit.controller.main;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.or.ddit.service.IAttendService;
import kr.or.ddit.service.IPortletService;
import kr.or.ddit.vo.PortletVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MainController {

   @Inject
   private IPortletService portletService;
   
   @Inject
   private IAttendService attendService;
   
//   @PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
//   @RequestMapping(value="/", method = RequestMethod.GET)
//   public String dashboard() {
//      return "main/mainpage/dashboard";
//   }
   
   @PreAuthorize("hasAnyRole('ROLE_MEMBER')")
   @RequestMapping(value="/", method = RequestMethod.GET)
   public String gridstack(Principal principal, Model model) {
      List<PortletVO> portletList = portletService.showPortlet(principal.getName());
      model.addAttribute("portletList", portletList);
      // 여기에 포틀릿에 나타낼 각각의 데이터 보내야 함 X -> 서비스에서 처리
      return "main/mainpage/gridstack";
   }
   
    @PreAuthorize("hasRole('ROLE_ADMIN')")
	@RequestMapping(value="/adminmain.do", method = RequestMethod.GET)
	public String mainpage(Principal principal, Model model) {
    	List<PortletVO> portletList = portletService.showAdminPortlet(principal.getName());
    	
    	Map<String, Object> chartMap = new HashMap<String, Object>();
		Map<String, Object> ajaxMap = new HashMap<String, Object>();
		
		chartMap = attendService.adminChart();
		
		ajaxMap = attendService.chart2select1Ajax();
		
		
//		chartMap.put("empCount", empCount);
//		chartMap.put("workCount", workCount);
//		chartMap.put("basic", basic);
//		chartMap.put("yuyeonA", yuyeonA);
//		chartMap.put("yuyeonB", yuyeonB);
//		chartMap.put("atHome", atHome);
//		chartMap.put("yearList", yearList);
		model.addAttribute("chartMap", chartMap);
		model.addAttribute("ajaxMap", ajaxMap);
    	
        model.addAttribute("portletList", portletList);
		return "main/mainpage/gridstackAdmin";
	}
   
   @RequestMapping(value="/setgrid.do", method = RequestMethod.GET)
   public String setGrid(Principal principal, Model model) {
      List<PortletVO> portletList = portletService.showPortlet(principal.getName());
      model.addAttribute("portletList", portletList);
      return "main/mainpage/gridstackSetting";
   }
   
   @RequestMapping(value="/grid/{menu}", method = RequestMethod.GET)
   public String gridstack(@PathVariable String menu) {
      return "mainpage/" + menu;
   }
   
   @RequestMapping(value="/savegrid.do", method = RequestMethod.POST)
   public ResponseEntity<String> saveGrid(@RequestBody List<PortletVO> portletList, Principal principal) {
      log.info("포틀릿 아이디 정보 : " + principal.getName());
      
      portletService.clearPortlet(principal.getName());
      for(PortletVO portlet : portletList) {
         portlet.setEmpNo(principal.getName());
         portletService.addPortlet(portlet);
         log.info("포틀릿 정보 : " + portlet);
      }
      
      ResponseEntity<String> entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
      return entity;
   }
   

}
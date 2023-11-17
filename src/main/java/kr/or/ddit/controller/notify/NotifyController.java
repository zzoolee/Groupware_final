package kr.or.ddit.controller.notify;

import java.security.Principal;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.INotifyService;
import kr.or.ddit.vo.NotifyVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class NotifyController {
	
	@Inject
	INotifyService notiService;
	
	
	//미확인 알림 갯수 가져오기 
	@ResponseBody
	@PostMapping("/selecCntNotify.do")
	public int selecCntNotify(Principal principal) {
		String empNo = principal.getName();
		int notiCnt =  notiService.selecCntNotify(empNo);
				
		return notiCnt;
	}
	
	//미확인 알림 리스트 가져오기
	@ResponseBody
	@PostMapping("/selectNotifyList.do")
	public List<NotifyVO> selectNotifyList(Principal principal){
		String empNo = principal.getName();
		List<NotifyVO> notiList =  notiService.selectNotifyList(empNo);
		
		return notiList;
	}
	
	// 알림 상태값 업데이트
	@ResponseBody
	@PostMapping("/updateNotickse.do")
	public int updateNotickse(@RequestBody Map<String, String> map) {
		
		String notifyCd = map.get("notifyCd");
		log.info("notifyCd : {}",notifyCd);
		int status = notiService.updateNotickse(notifyCd);
		return status;
	}
	
	// 알림 전체확인 버튼 클릭 시 알람 상태값 전체 업데이트
	@ResponseBody
	@PostMapping("/notiAllCheck.do")
	public int notiAllCheck (Principal principal) {
		String empNo = principal.getName();
		int status = notiService.notiAllCheck(empNo);
		
		return status;
	}
	
}















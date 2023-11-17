package kr.or.ddit.controller.mail;

import java.io.IOException;
import java.security.Principal;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.service.IMailService;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FileVO;
import kr.or.ddit.vo.MailFormVO;
import kr.or.ddit.vo.RMailVO;
import kr.or.ddit.vo.SMailVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MailController {
	
	@Inject
	private IMailService service;
	
	@Inject
	private EmpMapper empMapper;
	
	private void setMailBar(Model model) {
		String mailBar = "EXIST";
		model.addAttribute("mailBar", mailBar);
	}
	
	private void setMailBar1(Model model) {
		String mailBar = "EXIST";
		model.addAttribute("mailBar1", mailBar);
	}
	
	private void setMailBar2(Model model) {
		String mailBar = "EXIST";
		model.addAttribute("mailBar2", mailBar);
	}
	
	private void setMailBar3(Model model) {
		String mailBar = "EXIST";
		model.addAttribute("mailBar3", mailBar);
	}
	private void setMailBar4(Model model) {
		String mailBar = "EXIST";
		model.addAttribute("mailBar4", mailBar);
	}
	
	private void setMailBar5(Model model) {
		String mailBar = "EXIST";
		model.addAttribute("mailBar5", mailBar);
	}
	
	private void setMailBar6(Model model) {
		String mailBar = "EXIST";
		model.addAttribute("mailBar6", mailBar);
	}

	// 메일 보내기로 이동
	@RequestMapping(value="/sendmail.do", method=RequestMethod.GET)
	public String SendMail(Model model, String mailrEmpno) {
		
		setMailBar(model);
		setMailBar1(model);
		if(mailrEmpno != null) {
			EmpVO empVO = empMapper.readByUserId(mailrEmpno);
			
			model.addAttribute("empVO", empVO);
			return "main/mail/sendMailToSomeone";
		}
		return "main/mail/sendMail";
	}
	
	// 메일의 첨부파일을 받아서 파일명을 보내는 ajax
	@ResponseBody
	@RequestMapping(value="/sendMailAjax.do", method=RequestMethod.POST)
	public Map<String, Object> SendMailAjax(
			@RequestParam List<MultipartFile> selectFileList,
			HttpServletRequest req, HttpServletResponse resp
			) throws IOException {
		return service.SendMailAjax(selectFileList, req, resp);
	}

	// 메일보내기 로직.
	@ResponseBody
	@RequestMapping(value="/sendMailForm.do", method=RequestMethod.POST, produces="text/plain; charset=utf-8")
	public String sendMailToMeForm(MailFormVO mailFormVO,
			HttpServletRequest req, HttpServletResponse resp) throws IOException {
		
		
		System.out.println("샌드메일 폼 도착");
		String mailList = "메일,"+mailFormVO.getMailTitle();
		
		
		log.info("mailFormVO => {}", mailFormVO);
		ServiceResult result = service.sendMailForm(mailFormVO, req, resp);
		if(result.equals(ServiceResult.OK)) {
			// 메일 보내기 성공 시 수신자들에게 알림 발송
			List<String> empList = mailFormVO.getMailEmpno();
			if(empList.size()>0) {
				for(int i=0; i < empList.size(); i++) {
					mailList += ","+empList.get(i);
				}
				
			}
			// 메일 보내기 성공하고 참조자가 있을 경우 
			if(mailFormVO.getMailRef().size()>0) {
				mailList += ",ref";
				List<String> refList = mailFormVO.getMailRef();
				for(int i=0; i < refList.size(); i++) {
						mailList +=","+refList.get(i);
					}
					
			}
		}
		
		return mailList;
	}
	
	// 나에게 보내는 메일 로직
	@ResponseBody
	@RequestMapping(value="/sendMailToMeForm.do", method=RequestMethod.POST)
	public String sendMailForm(MailFormVO mailFormVO,
			HttpServletRequest req, HttpServletResponse resp) throws IOException {
		System.out.println("샌드메일 폼 도착");
		log.info("mailFormVO => {}", mailFormVO);
		service.sendMailToMeForm(mailFormVO, req, resp);
		return "성공적으로 메일이 발신되었습니다";
	}
	
	
	

	// 받은 메일함으로 이동
	@RequestMapping(value="/receivedmail.do", method=RequestMethod.GET)
	public String ReceivedMail(Model model) {
		// 전체 메일리스트를 받아내는 서비스에서 리스트를 받아서 넣어줌.
		List<RMailVO> mailListAll = service.selectAllRmail();
		// 모델넣어주세요.
		model.addAttribute("mailListAll", mailListAll);
		// 기본모델.
		setMailBar(model);
		setMailBar2(model);
		return "main/mail/receivedMail";
	}
	
	// 중요메일함 on/off를 담당하는 로직.
	@ResponseBody
	@RequestMapping(value="/mailLikeAjax.do", method=RequestMethod.POST)
	public Map<String, Object> mailLikeAjax(@RequestBody RMailVO rmailVO) {
		return service.mailLikeAjax(rmailVO);
	}
	
	// 받은메일을 삭제하는 로직.
	@RequestMapping(value="/rmailDelete.do", method=RequestMethod.POST)
	public String rmailDelete(@RequestParam List<String> mailArray, String important) {
		service.rmailDelete(mailArray);
		
		if(important != null) {
			return "redirect:/importantmail.do";
		}
		return "redirect:/receivedmail.do";
	}
	
	@RequestMapping(value="/mailMyselfDelete.do", method=RequestMethod.POST)
	public String mailMyselfDelete(@RequestParam List<String> mailArray) {
		service.rmailDelete(mailArray);
		return "redirect:/receivedmyselfmail.do";
	}
	
	// 보낸메일을 삭제하는 로직.
	// >>> 여기부터 진행 삭제하는 로직 진행 후, 리스트부터 삭제진행, 이후에 디테일 들어갈 것.
	@RequestMapping(value="/smailDelete.do", method=RequestMethod.POST)
	public String smailDelete(@RequestParam List<String> mailArray) {
		service.smailDelete(mailArray);
		return "redirect:/sendedmail.do";
	}
	
	@RequestMapping(value="/deleteMailAll.do", method=RequestMethod.POST)
	public String deleteMailAll(@RequestParam List<String> mailArray) {
		service.deleteMailAll(mailArray);
		return "redirect:/deletedmail.do";
	}
	
	// 받은메일 상세화면으로 이동.
	@RequestMapping(value="/receivedMailDetail.do", method=RequestMethod.GET)
	public String receivedMailDetail(RMailVO rmailVO, Model model) {
		// rmailVO의 메일넘버를 가지고 해당 메일 전체내용을 가져옴.
		RMailVO rmail = service.selectRmailOne(rmailVO);
		// 모델넣어주세요.
		model.addAttribute("mailList", rmail);
		// 기본모델.
		setMailBar(model);
		setMailBar2(model);
		return "main/mail/receivedMailDetail";
	}
	
	// 받은메일 상세에서 첨부파일 미리보기.
	@ResponseBody
	@RequestMapping(value="/mailFileViewAjax.do", method=RequestMethod.POST)
	public Map<String, Object> mailFileViewAjax(@RequestBody FileVO fileVO){
		return service.mailFileViewAjax(fileVO);
	}
	
	// 보낸메일 상세화면으로 이동.
	@RequestMapping(value = "/sendedMailDetail.do", method = RequestMethod.GET)
	public String sendedMailDetail(SMailVO smailVO, Model model) {
		// rmailVO의 메일넘버를 가지고 해당 메일 전체내용을 가져옴.
		SMailVO smail = service.selectSmailOne(smailVO);
		// 모델넣어주세요.
		model.addAttribute("mailList", smail);
		// 기본모델.
		setMailBar(model);
		setMailBar3(model);
		return "main/mail/sendedMailDetail";
	}

	// 보낸 메일함으로 이동
	@RequestMapping(value="/sendedmail.do", method=RequestMethod.GET)
	public String SendedMail(Model model, 
			HttpServletRequest req, HttpServletResponse resp) {
		// 메세지 보낸 후, 세션값을 가져온다.
		HttpSession session = req.getSession();
		// 세션이 널이아니면 세션값을 스트링에 담아준다.
		String sendMail = "";
		if(session != null) {
			sendMail = (String)session.getAttribute("sendMail");
			// 바로 없애버리기.
			session.removeAttribute("sendMail");
		}
		// 보낸메일 전체를 가져옴.
		List<SMailVO> mailList = service.selectAllSmail();
		
		// 보낸메일 리스트를 모델로 쏴준다.
		model.addAttribute("mailList", mailList);
		// 세션에서 담은 샌드메일.
		model.addAttribute("sendMail", sendMail);
		setMailBar(model);
		setMailBar3(model);
		return "main/mail/sendedMail";
	}
	
	// 받은 상세에서 첨부파일 다운로드 받기.
	@RequestMapping(value="/mailFileDownloadAjax.do", method=RequestMethod.GET)
	public ResponseEntity<byte[]> mailFileDownloadAjax(
			int isFile,
			HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ResponseEntity<byte[]> entity = service.fileDownload(
				isFile, request, response);
		return entity;
	}
	
	// 나에게 보낸메일함으로 이동
	@RequestMapping(value = "/receivedmyselfmail.do", method = RequestMethod.GET)
	public String ReceivedMyselfMail(Model model,
			HttpServletRequest req, HttpServletResponse reqp) {
		// 메세지 보낸 후, 세션값을 가져온다.
		HttpSession session = req.getSession();
		// 세션이 널이아니면 세션값을 스트링에 담아준다.
		String sendMail = "";
		if (session != null) {
			System.out.println("외 저긴되고 여긴안됌?");
			sendMail = (String)session.getAttribute("sendMail");
			// 바로 없애버리기.
			session.removeAttribute("sendMail");
		}
		// 나에게 보낸 메일 전체를 가져옴.
		List<RMailVO> mailList = service.selectAllMyselfMail();
		
		// 나에게 보낸 리스트를 모델로 쏴준다.
		model.addAttribute("mailList", mailList);
		// 세션에서 담은 샌드메일.
		model.addAttribute("sendMail", sendMail);
		setMailBar(model);
		setMailBar4(model);
		return "main/mail/receivedMyselfMail";
	}
	
	// 나에게 메일 보내기로 이동
	@RequestMapping(value="/sendtome.do", method=RequestMethod.GET)
	public String sendToMe(Model model) {
		setMailBar(model);
		setMailBar1(model);
		return "main/mail/sendToMe";
	}
	
	// 중요메일함으로 이동
	@RequestMapping(value="/importantmail.do", method=RequestMethod.GET)
	public String importantMail(Model model) {
		List<RMailVO> mailList = service.selectAllImpRmail();
		
		// 메일로 리스트를 쏴준다.
		model.addAttribute("mailListAll", mailList);
		setMailBar(model);
		setMailBar5(model);
		return "main/mail/importantMail";
	}
	
	// 삭제한메일함으로 이동
	@RequestMapping(value="/deletedmail.do", method=RequestMethod.GET)
	public String deletedMail(Model model) {
		List<RMailVO> mailList = service.selectDeletedMail();
		
		model.addAttribute("mailList", mailList);
		setMailBar(model);
		setMailBar6(model);
		return "main/mail/deletedMail";
	}
	
	// 휴지통에 있는 메일은 받은 메일함으로 복구 
	@PostMapping("/resMail.do")
	public String resMail (@RequestParam List<String> mailArray) {
		log.debug("mailArray:{}",mailArray);
		service.resMail(mailArray);
		return "redirect:/receivedmail.do";
	}
	
	// 메일 읽음 여부 업데이트
	@ResponseBody
	@PostMapping("/updateMailCkse.do")
	public  Map<String, Object> updateMailCkse (@RequestBody Map<String, String> map) {
		String mailNo = map.get("mailNo");
		log.info("mailNo:{}",mailNo);
		RMailVO rMailVO = new RMailVO();
		rMailVO.setMailNo(mailNo);
		return service.updateMailChkse(rMailVO);
		 
	}
	
	@GetMapping("/unreadmailcnt.do")
	public ResponseEntity<Integer> unreadMainCnt(Principal principal){
		int cnt = service.showUnreadMailCnt(principal.getName());
		
		ResponseEntity<Integer> entity = new ResponseEntity<Integer>(cnt,HttpStatus.OK);
		return entity;
	}
}















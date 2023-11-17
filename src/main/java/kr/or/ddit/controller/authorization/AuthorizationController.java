package kr.or.ddit.controller.authorization;

import java.security.Principal;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.service.IAdminEmpService;
import kr.or.ddit.service.IAuthService;
import kr.or.ddit.vo.AppBMLineVO;
import kr.or.ddit.vo.AppBookMarkVO;
import kr.or.ddit.vo.AtrzFormVO;
import kr.or.ddit.vo.AtrzPathVO;
import kr.or.ddit.vo.DraftRefVO;
import kr.or.ddit.vo.DraftVO;
import kr.or.ddit.vo.EmpVO;
import lombok.extern.slf4j.Slf4j;
import retrofit2.http.GET;

@Slf4j
@Controller
public class AuthorizationController {

	@Inject
	private IAuthService authService;

	@Inject
	private IAdminEmpService adminEmpService;

	
	/**
	 *  
	 * @param model
	 * @param atrzformVO
	 * @return 기안서 작성 화면 
	 */
	@RequestMapping(value = "/draft/write.do", method = RequestMethod.GET)
	public String draftWrite(Model model, AtrzFormVO atrzformVO) {
		List<AtrzFormVO> atrzfList = authService.selectAtrzForm();
		model.addAttribute("docList", atrzfList);

		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String empNo = user.getUsername();
		List<AppBookMarkVO> abmVO = authService.selectAppBookMark(empNo);
		model.addAttribute("abmVO", abmVO);
		model.addAttribute("draftBar", "draftBar");
		model.addAttribute("draftBar1", "draftBar1");
		log.info("컨트롤러에 들어왔나>> " + atrzfList);
		return "main/draft/draftingwrite";
	}


	/**
	 * 
	 * @param model
	 * @param atrzformVO
	 * @return 기안서 작성 화면 - 연차신청서
	 */
	@RequestMapping(value = "/draft/write/af001.do", method = RequestMethod.GET)
	public String draftWriteAf001(Model model, AtrzFormVO atrzformVO) {
		AtrzFormVO af001Form = authService.selectAf001Form();

		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String empNo = user.getUsername();
		List<AppBookMarkVO> abmVO = authService.selectAppBookMark(empNo);

//		log.debug(af001Form.toString());
		model.addAttribute("af001Form", af001Form);
		model.addAttribute("abmVO", abmVO);
		model.addAttribute("draftBar", "draftBar");
		model.addAttribute("draftBar1", "draftBar1");
		return "main/draft/draftingwriteAf001";
	}

	/**
	 * 기안서(결재) 양식 불러오기(ajax)
	 * @param model
	 * @param map
	 * @return 
	 */
	@ResponseBody
	@RequestMapping(value = "/draft/write.do", method = RequestMethod.POST, consumes = "application/json;")
	public ResponseEntity<String> draftWriteForm(Model model, @RequestBody Map<String, String> map) {
		log.info("draftingWriteForm 실행");
		String atrzfCd = map.get("atrzfCd").toString();
		log.info("넘겨받은 기안서코드 : " + atrzfCd);
		AtrzFormVO atrzFormVO = authService.selectAtrzContent(atrzfCd);
		// model.addAttribute("doc", atrzFormVO);
		log.info("기안서 양식 : " + atrzFormVO);

		// Header 추가 설정[인코딩]
		HttpHeaders resHeaders = new HttpHeaders();
		resHeaders.add("Content-Type", "text/html; charset=UTF-8");
		ResponseEntity<String> entity = new ResponseEntity<String>(atrzFormVO.getAtrzfContent(), resHeaders, HttpStatus.OK);
		return entity;
	}

	/**
	 * 결재선 지정 클릭시 즐겨찾는 결재선 select
	 * @return
	 */
	@ResponseBody
	@GetMapping("/draft/bookMarkAppline.do")
	public List<AppBookMarkVO> bookMarkLine() {
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String empNo = user.getUsername();
		List<AppBookMarkVO> abmVO = authService.selectAppBookMark(empNo);
		return abmVO;
	}

 
	/**
	 * 기안함 > 임시저장 문서함
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/draft/tempsave.do", method = RequestMethod.GET)
	public String tempSaveDoc(Model model) {
		// 스프링 시큐리티를 이용한 사번
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String empNo = user.getUsername();
		List<DraftVO> tempSaveList = authService.selectTempSaveList(empNo);
		model.addAttribute("tempSaveList", tempSaveList);
		model.addAttribute("draftBar", "draftBar");
		model.addAttribute("draftBar2", "draftBar2");
		return "main/draft/tempsavedocument";
	}

	/**
	 * 임시저장 디테일 페이지
	 * @param model
	 * @param draftVO
	 * @param atrzformVO
	 * @param pathVO
	 * @param refVO
	 * @return
	 */
	@RequestMapping(value = "/draft/tempsavedetail.do", method = RequestMethod.GET)
	public String tempSaveDetail(Model model, DraftVO draftVO, AtrzFormVO atrzformVO, AtrzPathVO pathVO, DraftRefVO refVO) {
		// 기안서 양식
		List<AtrzFormVO> atrzfList = authService.selectAtrzForm();
		model.addAttribute("docList", atrzfList);

		// 스프링 시큐리티를 이용한 draftVO에 사번 셋팅
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		draftVO.setEmpNo(user.getUsername());

		// 임시저장 디테일
		DraftVO tempSaveDetail = authService.draftDetail(draftVO);
		model.addAttribute("draftVO", tempSaveDetail);
		log.info("tempSaveDetail >> " + tempSaveDetail);

		// 결재자 select
		List<AtrzPathVO> pathSelect = authService.pathSelect(draftVO.getDrftCd());
		model.addAttribute("pathList", pathSelect);
		log.info("결재자  >> " + pathSelect);

		// 참조자 select
		List<DraftRefVO> refSelect = authService.refSelect(draftVO.getDrftCd());
		model.addAttribute("refList", refSelect);
		model.addAttribute("draftBar", "draftBar");
		model.addAttribute("draftBar2", "draftBar2");

		List<AppBookMarkVO> abmVO = authService.selectAppBookMark(user.getUsername());
		model.addAttribute("abmVO", abmVO);
		return "main/draft/tempsavedetail";
	}

	
	/**
	 * 임시저장 버튼 클릭했을 때
	 * @param model
	 * @param draftVO
	 * @param ra
	 * @param atrzfCd
	 * @param refEmpno
	 * @param atrzpEmpno
	 * @return
	 */
	@RequestMapping(value = "/draft/tempsave.do", method = RequestMethod.POST)
	public String tempSaveDocPost(Model model, DraftVO draftVO, RedirectAttributes ra, String atrzfCd,
			String[] refEmpno, String[] atrzpEmpno) {
		log.info("tempSaveDocPost 실행");
		String goPage = "";

		// 결재양식 코드
		draftVO.setAtrzfCd(atrzfCd);
		// 스프링 시큐리티를 이용한 draftVO에 사번 셋팅
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		draftVO.setEmpNo(user.getUsername());

		ServiceResult result = authService.draftTempSaveInsert(draftVO);
		model.addAttribute("draftVO", draftVO);
		// 결재자 세팅
		// atrzpEmpno >> 2310A01002_2
		AtrzPathVO pathVO = new AtrzPathVO();
		if (atrzpEmpno == null) { // atrzpEmpno 없을 때 insert안함
			log.info("여기까지 되는지 확인");
		} else {
			for (int i = 0; i < atrzpEmpno.length; i++) {
				String pathEmpno = atrzpEmpno[i].substring(0, 10); // 2310A01002
				String pathOrder = atrzpEmpno[i].substring(11, 12); // 우선순위
				log.info("pathEmpno 결재선 결재자 >> " + pathEmpno);
				log.info("pathOrder 결재 우선순위 >> " + pathOrder);
				pathVO.setAtrzpEmpno(pathEmpno);
				// String -> int로
				pathVO.setAtrzpOrder(Integer.parseInt(pathOrder));
				ServiceResult result2 = authService.pathInsert(pathVO);
			}
		}

		// 참조자 세팅
		DraftRefVO refVO = new DraftRefVO();
		if (refEmpno == null) {
		} else {
			for (int i = 0; i < refEmpno.length; i++) {
				if (refEmpno[i].length() == 10) { // (사번:길이가 10일 때 셋팅 //2310A01003)
					refVO.setRefEmpno(refEmpno[i]);
					log.info("참조자  >> " + refEmpno[i]);
					ServiceResult result3 = authService.refInsert(refVO);
				}
			}
		}
		if (result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "임시저장되었습니다!");
			goPage = "redirect:/draft/tempsave.do";
		} else {
			ra.addFlashAttribute("message", "서버 에러, 다시 시도해주세요");
			goPage = "main/draft/draftingwrite";
		}
		return goPage;
	}

	/**
	 * 임시저장 update
	 * @param model
	 * @param draftVO
	 * @param ra
	 * @param atrzfCd
	 * @param refEmpno
	 * @param atrzpEmpno
	 * @return
	 */
	@RequestMapping(value = "/draft/tempsaveupdate.do", method = RequestMethod.POST)
	public String tempSaveUpdate(Model model, DraftVO draftVO, RedirectAttributes ra, String atrzfCd, String[] refEmpno,
			String[] atrzpEmpno) {
		String goPage = "";

		// 결재양식 코드
		draftVO.setAtrzfCd(atrzfCd);
		// 스프링 시큐리티를 이용한 draftVO에 사번 셋팅
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		draftVO.setEmpNo(user.getUsername());

		// 참조자 먼저 삭제
		authService.refDelete(draftVO.getDrftCd());
		// 결재자
		authService.authPathDelete(draftVO.getDrftCd());

		ServiceResult result = authService.tempSaveUpdate(draftVO);
		model.addAttribute("draftVO", draftVO);
		// 결재자 세팅
		// atrzpEmpno >> 2310A01002_2
		AtrzPathVO pathVO = new AtrzPathVO();
		// 기안코드 셋팅
		pathVO.setDrftCd(draftVO.getDrftCd());
		if (atrzpEmpno == null) { // atrzpEmpno 없을 때 insert안함
		} else {
			for (int i = 0; i < atrzpEmpno.length; i++) {
				String pathEmpno = atrzpEmpno[i].substring(0, 10); // 2310A01002
				String pathOrder = atrzpEmpno[i].substring(11, 12); // 우선순위
				log.info("pathEmpno 결재선 결재자 >> " + pathEmpno);
				log.info("pathOrder 결재 우선순위 >> " + pathOrder);
				pathVO.setAtrzpEmpno(pathEmpno);
				// String -> int로
				pathVO.setAtrzpOrder(Integer.parseInt(pathOrder));
				// 임시저장시 pathInsert
				ServiceResult result2 = authService.tsPathInsert(pathVO);
			}
		}

		// 참조자 세팅
		DraftRefVO refVO = new DraftRefVO();
		if (refEmpno == null) {
		} else {
			for (int i = 0; i < refEmpno.length; i++) {
				if (refEmpno[i].length() == 10) { // (사번:길이가 10일 때 셋팅 //2310A01003)
					refVO.setRefEmpno(refEmpno[i]);
					log.info("참조자  >> " + refEmpno[i]);
					ServiceResult result3 = authService.refInsert(refVO);
				}
			}
		}
		if (result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "임시저장이 수정되었습니다!");
			goPage = "redirect:/draft/tempsave.do";
		} else {
			ra.addFlashAttribute("message", "서버 에러, 다시 시도해주세요");
			goPage = "main/draft/draftingwrite";
		}
		return goPage;
	}

	/**
	 * 임시저장 삭제
	 * @param model
	 * @param drftCd
	 * @param ra
	 * @return
	 */
	@RequestMapping(value = "/draft/tempsavedelete.do", method = RequestMethod.POST)
	public String tempSaveDelete(Model model, String[] drftCd, RedirectAttributes ra) {
		String goPage = "";

		for (int i = 0; i < drftCd.length; i++) {
			String draftCode = drftCd[i];
			log.info("draftCode", draftCode);
			ServiceResult result = authService.tempSaveDelete(draftCode);
			if (result.equals(ServiceResult.OK)) {
				ra.addFlashAttribute("message", "삭제가 완료되었습니다!");
				goPage = "redirect:/draft/tempsave.do";
			} else {
				ra.addFlashAttribute("message", "서버오류, 다시 시도해주세요!");
				goPage = "redirect:/draft/tempsave.do?drftCd" + drftCd;
			}
		}
		return goPage;
	}

	/**
	 * 임시저장 -> 결재상신 버튼 클릭
	 * @param model
	 * @param atrzfCd
	 * @param ra
	 * @param draftVO
	 * @param refEmpno
	 * @param atrzpEmpno
	 * @return
	 */
	@RequestMapping(value = "/draft/tsapproval.do", method = RequestMethod.POST)
	public String approval(Model model, String atrzfCd, RedirectAttributes ra, DraftVO draftVO, String[] refEmpno,
			String[] atrzpEmpno) {
		String goPage = "";
		// 메세지 쏴줄 결재자 아이디 저장할 String
		String authNoti = "결재";
		// 메세지 쏴줄 참조자 아이디 저장할 String
		String refNoti = "참조";

		// 결재양식 코드
		draftVO.setAtrzfCd(atrzfCd);
		log.info("atrzfCd >> " + atrzfCd);
		// 스프링 시큐리티를 이용한 draftVO에 사번 셋팅
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		draftVO.setEmpNo(user.getUsername());

		// 참조자 먼저 삭제
		authService.refDelete(draftVO.getDrftCd());
		// 결재자
		authService.authPathDelete(draftVO.getDrftCd());

		draftVO.setDrftCd(draftVO.getDrftCd());
		ServiceResult result = authService.approval(draftVO);
		model.addAttribute("draftVO", draftVO);
		// 결재자 세팅
		// atrzpEmpno >> 2310A01002_2
		AtrzPathVO pathVO = new AtrzPathVO();
		for (int i = 0; i < atrzpEmpno.length; i++) {
			String pathEmpno = atrzpEmpno[i].substring(0, 10); // 2310A01002
			String pathOrder = atrzpEmpno[i].substring(11, 12); // 우선순위
			// log.info("pathEmpno 결재선 결재자 >> " + pathEmpno);
			// log.info("pathOrder 결재 우선순위 >> " + pathOrder);
			pathVO.setAtrzpEmpno(pathEmpno);
			// String -> int로
			pathVO.setAtrzpOrder(Integer.parseInt(pathOrder));
			pathVO.setDrftCd(draftVO.getDrftCd());
			// 메세지를 받을 사번을 담는다.
			authNoti += "," + atrzpEmpno[i].substring(0, 10);
			ServiceResult result2 = authService.tsPathInsert(pathVO);
		}
		// 참조자 세팅
		DraftRefVO refVO = new DraftRefVO();
		if (refEmpno == null) {
			log.info("참조자가 없어요.");
		} else {
			for (int i = 0; i < refEmpno.length; i++) {
				if (refEmpno[i].length() == 10) { // (사번:길이가 10일 때 셋팅 //2310A01003)
					refVO.setRefEmpno(refEmpno[i]);
					log.info("참조자  >> " + refEmpno[i]);
					// 메세지를 받을 참조자 셋팅
					refNoti += "," + refEmpno[i];
					ServiceResult result3 = authService.refInsert(refVO);
				}
			}
		}
		if (result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "기안서가 제출되었습니다.");
			// 결재 메세지
			ra.addFlashAttribute("authNoti", authNoti);
			// 참조 메세지
			ra.addFlashAttribute("refNoti", refNoti);
			goPage = "redirect:/draft/progdoc.do";
		} else {
			ra.addFlashAttribute("message", "서버 에러, 다시 시도해주세요");
			goPage = "main/draft/draftingwrite";
		}
		return goPage;
	}

	/**
	 * 기안서 작성 -> 결재 상신
	 * @param model
	 * @param draftVO
	 * @param ra
	 * @param atrzfCd
	 * @param refEmpno
	 * @param atrzpEmpno
	 * @return
	 */
	@RequestMapping(value = "/draft/dfapproval.do", method = RequestMethod.POST)
	public String dfApproval(Model model, DraftVO draftVO, RedirectAttributes ra, String atrzfCd, String[] refEmpno,
			String[] atrzpEmpno) {
		log.info("dfApproval 실행");
		String goPage = "";
		// 메세지 쏴줄 결재자 아이디 저장할 String
		String authNoti = "결재";
		// 메세지 쏴줄 참조자 아이디 저장할 String
		String refNoti = "참조";

		// 결재양식 코드
		draftVO.setAtrzfCd(atrzfCd);
		// 스프링 시큐리티를 이용한 draftVO에 사번 셋팅
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		draftVO.setEmpNo(user.getUsername());

		ServiceResult result = authService.dfApproval(draftVO);
		model.addAttribute("draftVO", draftVO);
		// 결재자 세팅
		// atrzpEmpno >> 2310A01002_2
		AtrzPathVO pathVO = new AtrzPathVO();
		if (atrzpEmpno == null) { // atrzpEmpno 없을 때 insert안함
			log.info("결재자가 없어?");
		} else {
			for (int i = 0; i < atrzpEmpno.length; i++) {
				String pathEmpno = atrzpEmpno[i].substring(0, 10); // 2310A01002
				// 메세지를 받을 사번을 담는다.
				authNoti += "," + atrzpEmpno[i].substring(0, 10);

				String pathOrder = atrzpEmpno[i].substring(11, 12); // 우선순위
				log.info("pathEmpno 결재선 결재자 >> " + pathEmpno);
				log.info("pathOrder 결재 우선순위 >> " + pathOrder);
				pathVO.setAtrzpEmpno(pathEmpno);
				// String -> int로
				pathVO.setAtrzpOrder(Integer.parseInt(pathOrder));
				ServiceResult result2 = authService.pathInsert(pathVO);
			}
		}
		// 참조자 세팅
		DraftRefVO refVO = new DraftRefVO();
		if (refEmpno == null) {
			log.info("참조자가 없어?");
		} else {
			for (int i = 0; i < refEmpno.length; i++) {
				if (refEmpno[i].length() == 10) { // (사번:길이가 10일 때 셋팅 //2310A01003)
					refVO.setRefEmpno(refEmpno[i]);
					log.info("참조자  >> " + refEmpno[i]);
					// 메세지를 받은 참조자 사번을 담는다.
					refNoti += "," + refEmpno[i];
					ServiceResult result3 = authService.refInsert(refVO);
				}
			}
		}
		if (result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "기안서가 제출되었습니다!");
			// 결재 메세지
			log.info("메세지 보내기 전 확인 authNoti : " + authNoti);
			ra.addFlashAttribute("authNoti", authNoti);
			// 참조 메세지
			ra.addFlashAttribute("refNoti", refNoti);

			goPage = "redirect:/draft/progdoc.do";
		} else {
			ra.addFlashAttribute("message", "서버 에러, 다시 시도해주세요");
			goPage = "main/draft/draftingwrite";
		}
		return goPage;
	}

	
	/**
	 * 기안함 > 진행중문서
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/draft/progdoc.do", method = RequestMethod.GET)
	public String progressDoc(Model model) {
		// 스프링 시큐리티를 이용한 사번
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String empNo = user.getUsername();
		List<DraftVO> progressList = authService.selectProgList(empNo);
		model.addAttribute("progressList", progressList);
		model.addAttribute("draftBar", "draftBar");
		model.addAttribute("draftBar3", "draftBar3");
		return "main/draft/progressdocument";
	}

	/**
	 * 진행중문서 디테일
	 * @param model
	 * @param draftVO
	 * @param drftCd
	 * @param pathVO
	 * @param refVO
	 * @return
	 */
	@RequestMapping(value = "/draft/progdetail.do", method = RequestMethod.GET)
	public String progressDetail(Model model, DraftVO draftVO, String drftCd, AtrzPathVO pathVO, DraftRefVO refVO) {
		// 스프링 시큐리티를 이용한 사번
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		draftVO.setEmpNo(user.getUsername());
		draftVO.setDrftCd(drftCd);

		DraftVO progDetail = authService.draftDetail(draftVO);
		// 내가 올린 기안에 사인
		EmpVO empVO = adminEmpService.selectOne(user.getUsername());
		model.addAttribute("empVO", empVO);
		model.addAttribute("progDetail", progDetail);
		log.info("progDetail >>" + progDetail);

		// 결재자 select
		List<AtrzPathVO> pathSelect = authService.pathSelect(drftCd);
		model.addAttribute("pathList", pathSelect);
		log.info("진행중결재자  >> " + pathSelect);

		// 참조자 select
		List<DraftRefVO> refSelect = authService.refSelect(drftCd);
		model.addAttribute("refList", refSelect);
		log.info("진행중참조자 >>" + refSelect);

		model.addAttribute("draftBar", "draftBar");
		model.addAttribute("draftBar3", "draftBar3");
		return "main/draft/progressdetail";
	}

	/**
	 * 기안함 > 반려문서
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/draft/retdoc.do", method = RequestMethod.GET)
	public String returnDoc(Model model) {
		// 스프링 시큐리티를 이용한 사번
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String empNo = user.getUsername();
		List<DraftVO> returnList = authService.selectRetList(empNo);
		model.addAttribute("returnList", returnList);
		model.addAttribute("draftBar", "draftBar");
		model.addAttribute("draftBar4", "draftBar4");
		return "main/draft/returndocument";
	}

	
	/**
	 * 반려사유(produces - ajax에서 값을 보낼 때 text인 경우 인코딩 필요 )
	 * produces = "text/plain; charset=UTF-8"
	 * @param map
	 * @return
	 */
	@ResponseBody
	@PostMapping(value = "/draft/retdoc2.do")
	public DraftVO returnDoc2(@RequestBody Map<String, String> map) {
		String drftCd = map.get("drftCd").toString();
		DraftVO selectMemo = authService.selectMemo(drftCd);
		return selectMemo;
	}

	/**
	 * 반려문서 디테일
	 * @param model
	 * @param draftVO
	 * @param drftCd
	 * @param pathVO
	 * @param refVO
	 * @return
	 */
	@RequestMapping(value = "/draft/retdetail.do", method = RequestMethod.GET)
	public String returnDetail(Model model, DraftVO draftVO, String drftCd, AtrzPathVO pathVO, DraftRefVO refVO) {
		// 스프링 시큐리티를 이용한 사번
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		draftVO.setEmpNo(user.getUsername());
		draftVO.setDrftCd(drftCd);

		DraftVO retDetail = authService.draftDetail(draftVO);
		model.addAttribute("retDetail", retDetail);
		log.info("retDetail >>" + retDetail);

		// 내가 올린 기안에 사인
		EmpVO empVO = adminEmpService.selectOne(user.getUsername());
		model.addAttribute("empVO", empVO);

		// 결재자 select
		List<AtrzPathVO> pathSelect = authService.pathSelect(draftVO.getDrftCd());
		model.addAttribute("pathList", pathSelect);
		log.info("반려결재자  >> " + pathSelect);

		// 참조자 select
		List<DraftRefVO> refSelect = authService.refSelect(draftVO.getDrftCd());
		model.addAttribute("refList", refSelect);
		log.info("반려참조자 >>" + refSelect);

		// 반려한 사원이름
		DraftVO retName = authService.selectRetName(draftVO);
		model.addAttribute("retName", retName);
		model.addAttribute("draftBar", "draftBar");
		model.addAttribute("draftBar4", "draftBar4");
		return "main/draft/returndetail";
	}

	/**
	 * 기안함 > 완료문서함
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/draft/comdoc.do", method = RequestMethod.GET)
	public String completeDoc(Model model) {
		// 스프링 시큐리티를 이용한 사번
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String empNo = user.getUsername();
		List<DraftVO> completeList = authService.selectComList(empNo);
		model.addAttribute("completeList", completeList);
		model.addAttribute("draftBar", "draftBar");
		model.addAttribute("draftBar5", "draftBar5");
		return "main/draft/completedocument";
	}

	/**
	 * 기안함 > 완료문서 디테일
	 * @param model
	 * @param draftVO
	 * @param drftCd
	 * @param pathVO
	 * @param refVO
	 * @return
	 */
	@RequestMapping(value = "/draft/comdetail.do", method = RequestMethod.GET)
	public String completeDetail(Model model, DraftVO draftVO, String drftCd, AtrzPathVO pathVO, DraftRefVO refVO) {
		// 스프링 시큐리티를 이용한 사번
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		draftVO.setEmpNo(user.getUsername());
		draftVO.setDrftCd(drftCd);

		DraftVO comDetail = authService.draftDetail(draftVO);
		model.addAttribute("comDetail", comDetail);
		log.info("comDetail >>" + comDetail);

		// 내가 올린 기안에 사인
		EmpVO empVO = adminEmpService.selectOne(user.getUsername());
		model.addAttribute("empVO", empVO);

		// 결재자 select
		List<AtrzPathVO> pathSelect = authService.pathSelect(draftVO.getDrftCd());
		model.addAttribute("pathList", pathSelect);
		log.info("완료결재자  >> " + pathSelect);

		// 참조자 select
		List<DraftRefVO> refSelect = authService.refSelect(draftVO.getDrftCd());
		model.addAttribute("refList", refSelect);
		log.info("완료참조자 >>" + refSelect);
		model.addAttribute("draftBar", "draftBar");
		model.addAttribute("draftBar5", "draftBar5");
		return "main/draft/completedetail";
	}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	/**
	 *  결재함 > 결재대기 문서
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/auth/waitdoc.do", method = RequestMethod.GET)
	public String waitingDoc(Model model) {
		// 스프링 시큐리티를 이용한 사번
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String empNo = user.getUsername();
		List<DraftVO> waitList = authService.selectWaitList(empNo);
		model.addAttribute("waitList", waitList);
		model.addAttribute("draftBar", "draftBar");
		model.addAttribute("draftBar6", "draftBar6");
		return "main/authorization/waitdoc";
	}

	
	/**
	 * 결재대기 문서 디테일
	 * @param model
	 * @param draftVO
	 * @param drftCd
	 * @param pathVO
	 * @param refVO
	 * @return
	 */
	@RequestMapping(value = "/auth/waitdetail.do", method = RequestMethod.GET)
	public String waitingDetail(Model model, DraftVO draftVO, String drftCd, AtrzPathVO pathVO, DraftRefVO refVO) {
		// 스프링 시큐리티를 이용한 사번
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		draftVO.setEmpNo(user.getUsername());
		// 기안 코드 세팅
		draftVO.setDrftCd(drftCd);

		DraftVO waitDetail = authService.authDetail(draftVO);
		model.addAttribute("waitDetail", waitDetail);
		log.info("waitDetail >>" + waitDetail);

		// 결재자 select
		List<AtrzPathVO> pathSelect = authService.pathSelect(drftCd);
		model.addAttribute("pathList", pathSelect);
		log.info("대기문서 결재자  >> " + pathSelect);

		// 참조자 select
		List<DraftRefVO> refSelect = authService.refSelect(drftCd);
		model.addAttribute("refList", refSelect);
		log.info("대기문서 참조자 >>" + refSelect);
		model.addAttribute("draftBar", "draftBar");
		model.addAttribute("draftBar6", "draftBar6");
		return "main/authorization/waitdetail";
	}

	
	/**
	 * 결재, 전결 눌렀을 때(UPDATE)
	 * @param model
	 * @param draftVO
	 * @param drftCd
	 * @param pathVO
	 * @param ra
	 * @return
	 */
	@RequestMapping(value = "/auth/sign.do", method = RequestMethod.POST)
	public String sign(Model model, DraftVO draftVO, String drftCd, AtrzPathVO pathVO, RedirectAttributes ra) {
		log.info("sign 실행");
		String goPage = "";

		// 스프링 시큐리티를 이용한 사번 셋팅
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		draftVO.setEmpNo(user.getUsername());
		draftVO.setDrftCd(drftCd);

		ServiceResult result = authService.sign(draftVO);

		// 내 우선순위가 4번이고, 승인상태가 '결재'이면
//		if(pathVO.getAtrzpOrder() == 4 && draftVO.getDrftAprvse().equals("결재")) {
//			draftVO.setDrftAprvse("전결");
//		}

		// 내 결재 순번이 4번이고, 승인상태가 '결재'이면
		if (pathVO.getAtrzpOrder() == 4 && draftVO.getDrftAprvse().equals("결재")) {
			ServiceResult lastOrderAuth = authService.lastOrderComplete(draftVO);
			authService.updateStatus(draftVO);
		} else {
			log.info("마지막 순위 제외 결재, 전결 >> ");
			ServiceResult updateProgress = authService.updateProgress(draftVO);
			ServiceResult updateStatus = authService.updateStatus(draftVO);
		}
		// 결재 -진행중, 전결-완료
		if (result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "결재가 승인되었습니다.");
			goPage = "redirect:/auth/comdoc.do";
		} else {
			ra.addFlashAttribute("message", "서버 에러, 다시 시도해주세요");
			goPage = "main/authorization/waitdetail";
		}
		return goPage;
	}

	/**
	 * 반려버튼 눌렀을 때
	 * @param model
	 * @param ra
	 * @param drftCd
	 * @param draftVO
	 * @return
	 */
	@RequestMapping(value = "/auth/retrun.do", method = RequestMethod.POST)
	public String retrunDocPost(Model model, RedirectAttributes ra, String drftCd, DraftVO draftVO) {
		log.info("retrunDocPost 실행");
		String goPage = "";

		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		draftVO.setEmpNo(user.getUsername());
		draftVO.setDrftCd(drftCd);

		// 반려사유
		ServiceResult result = authService.returnMemo(draftVO);
		// 내 결재선 상태 update
		ServiceResult returnStatus = authService.returnStatus(draftVO);

		if (result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "해당 기안이 반려되었습니다!");
			goPage = "redirect:/auth/retdoc.do";
		} else {
			ra.addFlashAttribute("message", "서버 에러, 다시 시도해주세요");
			goPage = "main/authorization/waitdetail";
		}
		return goPage;
	}

	
	/**
	 * 결재함 > 반려문서(페이지를 여는 용도)
	 * @param model
	 * @return
	 */
	@GetMapping("/auth/retdoc.do")
	public String retDoc(Model model) {
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String empNo = user.getUsername();
		List<DraftVO> retList = authService.selectReturnList(empNo);
		model.addAttribute("retList", retList);
		model.addAttribute("draftBar", "draftBar");
		model.addAttribute("draftBar8", "draftBar8");
		return "main/authorization/retdoc";
	}

	// 반려문서 ajax로 테이블 그리는 용도
//	@ResponseBody
//	@GetMapping("/auth/retdoc2.do")
//	public List<DraftVO> retDoc2() {
//		// 스프링 시큐리티를 이용한  사번 
//		User user = (User)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
//		String empNo = user.getUsername();
//		List<DraftVO> retList = authService.selectReturnList(empNo);
//		return retList;
//	}

	
	/**
	 * 반려 디테일
	 * @param model
	 * @param draftVO
	 * @param drftCd
	 * @return
	 */
	@RequestMapping(value = "/auth/retdetail.do", method = RequestMethod.GET)
	public String retDetail(Model model, DraftVO draftVO, String drftCd) {
		// 스프링 시큐리티를 이용한 사번
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		draftVO.setEmpNo(user.getUsername());
		// 기안 코드 세팅
		draftVO.setDrftCd(drftCd);

		DraftVO authDetail = authService.authDetail(draftVO);
		model.addAttribute("authDetail", authDetail);
		log.info("retDetail >>" + authDetail);

		// 결재자 select
		List<AtrzPathVO> pathSelect = authService.pathSelect(drftCd);
		model.addAttribute("pathList", pathSelect);
		log.info(" 결재자  >> " + pathSelect);

		// 참조자 select
		List<DraftRefVO> refSelect = authService.refSelect(drftCd);
		model.addAttribute("refList", refSelect);
		log.info(" 참조자 >>" + refSelect);
		model.addAttribute("draftBar", "draftBar");
		model.addAttribute("draftBar8", "draftBar8");
		return "main/authorization/retdetail";
	}

	
	/**
	 * 결재함 > 참조 문서함
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/auth/refdoc.do", method = RequestMethod.GET)
	public String referDoc(Model model) {
		// 스프링 시큐리티를 이용한 사번
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String empNo = user.getUsername();
		List<DraftVO> referenceList = authService.selectRefList(empNo);
		model.addAttribute("referenceList", referenceList);
		model.addAttribute("draftBar", "draftBar");
		model.addAttribute("draftBar7", "draftBar7");
		return "main/authorization/referdoc";
	}

	/**
	 * 참조문서 디테일
	 * @param model
	 * @param draftVO
	 * @param drftCd
	 * @param pathVO
	 * @param refVO
	 * @return
	 */
	@RequestMapping(value = "/auth/refdetail.do", method = RequestMethod.GET)
	public String referDetail(Model model, DraftVO draftVO, String drftCd, AtrzPathVO pathVO, DraftRefVO refVO) {
		// 스프링 시큐리티를 이용한 draftVO에 사번 셋팅
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		draftVO.setEmpNo(user.getUsername());
		draftVO.setDrftCd(drftCd);

		DraftVO authDetail = authService.authDetail(draftVO);
		model.addAttribute("authDetail", authDetail);
		log.info("authDetail >>" + authDetail);

		// 결재자 select
		List<AtrzPathVO> pathSelect = authService.pathSelect(drftCd);
		model.addAttribute("pathList", pathSelect);
		log.info("참조문서의 결재자  >> " + pathSelect);

		// 참조자 select
		List<DraftRefVO> refSelect = authService.refSelect(drftCd);
		model.addAttribute("refList", refSelect);
		log.info("참조문서의 참조자 >>" + refSelect);
		model.addAttribute("draftBar", "draftBar");
		model.addAttribute("draftBar7", "draftBar7");
		return "main/authorization/referdetail";
	}

	/**
	 * 결재함 > 완료문서
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/auth/comdoc.do", method = RequestMethod.GET)
	public String comDoc(Model model) {
		// 스프링 시큐리티를 이용한 사번
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String empNo = user.getUsername();
		List<DraftVO> completeList = authService.selectCompleteList(empNo);
		model.addAttribute("completeList", completeList);
		model.addAttribute("draftBar", "draftBar");
		model.addAttribute("draftBar9", "draftBar9");
		return "main/authorization/comdoc";
	}
	// 결재함 > 완료문서(ajax로 테이블 그리는 용도)
//	@GetMapping("/auth/comdoc2.do")
//	@ResponseBody
//	public List<DraftVO> comDoc2() {
//		// 스프링 시큐리티를 이용한  사번 
//		User user = (User)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
//		String empNo = user.getUsername();
//		List<DraftVO> comList = authService.selectCompleteList(empNo);
//		return comList;
//	}

	
	/**
	 * 완료문서 디테일
	 * @param model
	 * @param draftVO
	 * @param drftCd
	 * @return
	 */
	@GetMapping("/auth/comdetail.do")
	public String comDetail(Model model, DraftVO draftVO, String drftCd) {
		// 스프링 시큐리티를 이용한 draftVO에 사번 셋팅
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		draftVO.setEmpNo(user.getUsername());
		draftVO.setDrftCd(drftCd);

		DraftVO completDetail = authService.authDetail(draftVO);
		model.addAttribute("completDetail", completDetail);
		log.info("completDetail >>" + completDetail);

		// 결재자 select
		List<AtrzPathVO> pathSelect = authService.pathSelect(drftCd);
		model.addAttribute("pathList", pathSelect);
		log.info("완료 결재자  >> " + pathSelect);

		// 참조자 select
		List<DraftRefVO> refSelect = authService.refSelect(drftCd);
		model.addAttribute("refList", refSelect);
		log.info("완료 참조자 >>" + refSelect);
		model.addAttribute("draftBar", "draftBar");
		model.addAttribute("draftBar9", "draftBar9");
		return "main/authorization/comdetail";
	}

	/**
	 * 결재함 > 결재선 관리
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/auth/appline.do", method = RequestMethod.GET)
	public String applineManage(Model model) {
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String empNo = user.getUsername();
		List<AppBookMarkVO> abmVO = authService.selectAppBookMark(empNo);
		model.addAttribute("abmVO", abmVO);
		model.addAttribute("draftBar", "draftBar");
		model.addAttribute("draftBar10", "draftBar10");		
		return "main/authorization/appline";
	}

	/**
	 * 
	 * @param model
	 * @param ra
	 * @param abmVO
	 * @param applEmpno
	 * @param abmName
	 * @return
	 */
	@PostMapping("/auth/bmline.do")
	public String abmInsert(Model model, RedirectAttributes ra, AppBookMarkVO abmVO, String[] applEmpno,
			String abmName) {
		String goPage = "";
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String empNo = user.getUsername();
		// 내 사번
		abmVO.setEmpNo(empNo);
		// 즐겨찾는 결재선명
		abmVO.setAbmName(abmName);
		ServiceResult result = authService.abmInsert(abmVO);

		AppBMLineVO bmLine = new AppBMLineVO();
		// 즐겨찾는 결재선 결재자 2310A01002_3
		if (applEmpno == null) {
			log.info("즐겨찾는 결재선 없음.");
		} else {
			for (int i = 0; i < applEmpno.length; i++) {
				String appLine = applEmpno[i].substring(0, 10);
				String order = applEmpno[i].substring(11, 12);
				// 셋팅
				bmLine.setApplEmpno(appLine);
				bmLine.setApplOrder(order);

				log.info("결재선 : " + appLine);
				log.info("우선순위 : " + order);
				ServiceResult result2 = authService.bmLineInsert(bmLine);
			}
		}
		if (result.equals(ServiceResult.OK)) {
			ra.addFlashAttribute("message", "즐겨찾는 결재선이 등록되었습니다!");
			goPage = "redirect:/auth/appline.do";
		} else {
			ra.addFlashAttribute("message", "서버에러, 다시 시도해주세요.");
			goPage = "main/authorization/appline";
		}
		return goPage;
	}

	/**
	 * 결재선 삭제
	 * @param ra
	 * @param abmCd
	 * @return
	 */
	@PostMapping("/auth/abmdel.do")
	public String bmlinedel(RedirectAttributes ra, String[] abmCd) {
		String goPage = "";
		for (int i = 0; i < abmCd.length; i++) {
			String abmCode = abmCd[i];
			log.info("appLineCode" + abmCode);
			ServiceResult result = authService.abmDel(abmCode);

			if (result.equals(ServiceResult.OK)) {
				ra.addFlashAttribute("message", "해당 결재선이 삭제되었습니다!");
				goPage = "redirect:/auth/appline.do";
			} else {
				ra.addFlashAttribute("message", "서버 에러, 다시 시도해주세요.");
				goPage = "main/authorization/appline";
			}
		}
		return goPage;
	}
	
	
	@ResponseBody
	@GetMapping("/draftCnt/{draftCnt}.do")
	public int tsDocCnt(Principal principal, Model model, @PathVariable String draftCnt) {
		int cnt = 0;
		if(draftCnt.equals("tsCnt")) {
			cnt = authService.tsDocCnt(principal.getName());
		} else if(draftCnt.equals("progCnt")) {
			cnt = authService.progDocCnt(principal.getName());
		} else if(draftCnt.equals("retCnt")) {
			cnt = authService.retDocCnt(principal.getName());
		} else if(draftCnt.equals("comCnt")) {
			cnt = authService.comDocCnt(principal.getName());
		} else if(draftCnt.equals("waitCnt")) {
			cnt = authService.waitDocCnt(principal.getName());
		} else if(draftCnt.equals("refCnt")) {
			cnt = authService.refDocCnt(principal.getName());
		} else if(draftCnt.equals("returnCnt")) {
			cnt = authService.returnDocCnt(principal.getName());
		} else if(draftCnt.equals("completeCnt")) {
			cnt = authService.completeCnt(principal.getName());
		}
		return cnt;
	}
	

	
}

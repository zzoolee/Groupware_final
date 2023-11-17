package kr.or.ddit.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.security.Principal;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;

import org.jxls.common.Context;
import org.jxls.util.JxlsHelper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.service.IAddService;
import kr.or.ddit.service.IEmpService;
import kr.or.ddit.vo.AddGroupMemberVO;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.ExtaddVO;
import kr.or.ddit.vo.MyAddGroupVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/add")
public class AddController {
	
	@Inject
	private IAddService addService;
	@Inject
	private IEmpService empService;
	
	/**
	 * 전체주소록 페이지
	 * @param principal
	 * @param model
	 * @return
	 */
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/comadd.do", method = RequestMethod.GET)
	public String comAdd(Principal principal, Model model) {
		// 모든 사원(퇴사자 제외)
		List<EmpVO> empList = empService.showEmpList();
		// 나의 그룹명
		List<MyAddGroupVO> groupList = addService.showMyGroup(principal.getName());
		model.addAttribute("empList", empList);
		model.addAttribute("groupList", groupList);
		model.addAttribute("addBar", "addBar");
		model.addAttribute("addBar1", "addBar1");
		return "main/add/comAdd";
	}
	
	/**
	 * 관리자
	 * @param principal
	 * @param model
	 * @return
	 */
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/admin.do", method = RequestMethod.GET)
	public String comAddAdmin(Principal principal, Model model) {
		// 모든 사원(퇴사자 제외)
		List<EmpVO> empList = empService.showEmpList();
		model.addAttribute("empList", empList);
		model.addAttribute("addBar", "addBar");
		model.addAttribute("addBar1", "addBar1");
		return "main/add/comAddAdmin";
	}
	
	@ResponseBody
	@GetMapping("/exceldownload.do")
	public ResponseEntity<Void> excelDownload(RedirectAttributes ra, HttpServletResponse resp) {
		List<EmpVO> empList = empService.showEmpList();
	      
	      try {
	         resp.setContentType("ms-vnd/excel");
	         resp.setHeader("Content-Disposition", "attachment; filename=iworks_addlist.xlsx");
	         
	         InputStream is = new FileInputStream("D:\\99.JSP_SPRING\\02.SPRING2\\workspace_spring2\\Groupware_final\\src\\main\\webapp\\resources\\assets\\gw\\iworks_addlist.xlsx");
	         OutputStream os = resp.getOutputStream();
	         Context context = new Context();
	         context.putVar("empList", empList);
	         JxlsHelper.getInstance().processTemplate(is, os, context);
	         ra.addFlashAttribute("message", "[다운로드] 폴더에<br>[iworks_addlist.xlsx]가 저장되었습니다.");
	      } catch(Exception e) {
	         e.printStackTrace();
	      } finally {
	      }
	      
//	      return "redirect:/add/admin.do";
	      return new ResponseEntity<Void>(HttpStatus.OK);
	}
	
	/**
	 * 조직도 생성(부서 부분)
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/treelist.do")
	public ResponseEntity<List<DeptVO>> treeList(){
		List<DeptVO> treeList = addService.showTreeList();
		ResponseEntity<List<DeptVO>> entity = new ResponseEntity<List<DeptVO>>(treeList, HttpStatus.OK);
		return entity;
	}
	
	/**
	 * 조직도 생성(팀원 부분)
	 * @param deptCd
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/deptemp.do", method = RequestMethod.GET)
	public ResponseEntity<List<EmpVO>> treeList(String deptCd){
		List<EmpVO> deptEmpList = empService.showDeptEmp(deptCd);
		ResponseEntity<List<EmpVO>> entity = new ResponseEntity<List<EmpVO>>(deptEmpList, HttpStatus.OK);
		return entity;
	}
	
	/**
	 * 내 주소록에 추가(전체주소록)
	 * @param principal
	 * @param myGroupVO 그룹 하나, 멤버 여러명
	 * @return
	 */
	@RequestMapping(value="/addgroupmem.do", method = RequestMethod.POST)
	public ResponseEntity<String> addGroupMember(Principal principal, MyAddGroupVO myGroupVO) { // 자바스크립트 객체 하나
		ResponseEntity<String> entity = null;
		
		myGroupVO.setEmpNo(principal.getName()); // 세션 아이디 값 세팅
		log.info("MyAddGroupVO : " + myGroupVO.toString());
		ServiceResult result = addService.addGroupMember(myGroupVO);
		if(result == ServiceResult.OK) {
			entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		} else if(result == ServiceResult.HALFOK) {
			entity = new ResponseEntity<String>("HALFSUCCESS", HttpStatus.OK);
		}
		return entity;
	}
	
	/**
	 * 내부주소록 페이지
	 * @param principal
	 * @param model
	 * @return
	 */
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/myadd.do", method = RequestMethod.GET)
	public String myAdd(Principal principal, Model model) {
		// 나의 그룹명
		List<MyAddGroupVO> groupList = addService.showMyGroup(principal.getName());
		model.addAttribute("groupList", groupList);
		List<MyAddGroupVO> memberList = addService.showMyAllGroupMember(principal.getName());
		model.addAttribute("memberList", memberList);
		model.addAttribute("addBar", "addBar");
		model.addAttribute("addBar2", "addBar2");
		return "main/add/myAdd";
	}
	
	/**
	 * 내 주소록에서 해제(내부주소록)
	 * @param principal
	 * @param myGroupVO : mygrEmpno, mygrCd
	 * @return
	 */
	@RequestMapping(value="/delgroupmem.do", method = RequestMethod.POST)
	public ResponseEntity<String> delGroupMember(@RequestBody List<AddGroupMemberVO> groupMemberList) { // 자바스크립트 객체 배열을 json으로 변환 -> 왜 배열 쓴걸까?
		log.info("/delgroupmem.do 실행");
		for(AddGroupMemberVO groupMember : groupMemberList) {
			log.info("groupMember : " + groupMember.toString());
			addService.delGroupMember(groupMember);
		}
		ResponseEntity<String> entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);;
		return entity;
	}
	
	/**
	 * 내부주소록 > 그룹관리 페이지
	 * @param principal
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/myaddgroup.do", method = RequestMethod.GET)
	public String myAddGroup(Principal principal, Model model) {
		// 나의 그룹명
		List<MyAddGroupVO> groupList = addService.showMyGroup(principal.getName());
		model.addAttribute("groupList", groupList);
		List<MyAddGroupVO> memberList = addService.showMyAllGroupMember(principal.getName());
		model.addAttribute("memberList", memberList);
		model.addAttribute("addBar", "addBar");
		model.addAttribute("addBar2", "addBar2");
		return "main/add/myAddGroup";
	}
	
	/**
	 * 그룹이동
	 * @param groupMemberList
	 * @param newGrCd
	 * @return
	 */
	@RequestMapping(value="/movegroupmem.do", method = RequestMethod.POST)
	public ResponseEntity<String> moveGroupMember(@RequestBody List<AddGroupMemberVO> groupMemberList, String newGrCd){
		ResponseEntity<String> entity = null;
		log.info("새로운 그룹 코드 : " + newGrCd);
		
		String[] mygrEmpno = new String[groupMemberList.size()];
		for(int i=0; i<groupMemberList.size(); i++) {
			log.info("groupMember : " + groupMemberList.get(i).toString());
			mygrEmpno[i] = groupMemberList.get(i).getMygrEmpno(); // 배열에 추가(주소록에 추가 메소드가 이렇게 짜여져 있음...)
			addService.delGroupMember(groupMemberList.get(i)); // 기존 그룹에서 삭제
		}
		
		MyAddGroupVO myGroupVO = new MyAddGroupVO();
		myGroupVO.setMygrEmpno(mygrEmpno);
		myGroupVO.setMygrCd(newGrCd);
		log.info("MyAddGroupVO : " + myGroupVO.toString());
		ServiceResult result = addService.addGroupMember(myGroupVO); // 새로운 그룹에 추가
		if(result == ServiceResult.OK) {
			entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		} else if(result == ServiceResult.HALFOK) {
			entity = new ResponseEntity<String>("HALFSUCCESS", HttpStatus.OK);
		}
		
		return entity;
	}
	
	/**
	 * 그룹추가
	 * @param principal
	 * @param mygrNameList
	 * @return
	 */
	@RequestMapping(value="/createnewgroup.do", method = RequestMethod.POST)
	public ResponseEntity<String> createNewGroup(Principal principal, @RequestBody List<String> mygrNameList){ // 자바스크립트 배열을 json으로 변환
		ResponseEntity<String> entity = null;
		Boolean insertFlag = false;
		
		for(String mygrName : mygrNameList) {
			if(mygrName != "") {
				MyAddGroupVO myGroupVO = new MyAddGroupVO();
				myGroupVO.setEmpNo(principal.getName()); // 세션 아이디 값 세팅
				myGroupVO.setMygrName(mygrName);
				log.info("MyAddGroupVO : " + myGroupVO.toString());
				addService.addGroupMember(myGroupVO);
				insertFlag = true; // 한번이라도 그룹 생성 이루어지면 바뀐다
			}
		}
		
		if(insertFlag) {
			entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		}else {
			entity = new ResponseEntity<String>("NOTINSERT", HttpStatus.OK);
		}
		return entity;
	}
	
	/**
	 * 그룹삭제
	 * @param mygrCd
	 * @return
	 */
	@RequestMapping(value="/delgroup.do", method = RequestMethod.GET)
	public ResponseEntity<String> delGroup(String mygrCd) { // 자바스크립트 배열을 json으로 변환
		addService.delGroup(mygrCd);
		
		ResponseEntity<String> entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		return entity;
	}
	
	/**
	 * 그룹수정
	 * @param myGroupVO
	 * @return
	 */
	@RequestMapping(value="/modifygroup.do", method = RequestMethod.POST)
	public ResponseEntity<String> delGroup(MyAddGroupVO myGroupVO) { // 자바스크립트 객체 하나
		addService.modifyGroup(myGroupVO);
		
		ResponseEntity<String> entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		return entity;
	}
	
	/**
	 * 외부주소록 페이지
	 * @param principal
	 * @param model
	 * @return
	 */
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@RequestMapping(value="/myextadd.do", method = RequestMethod.GET)
	public String myExtAdd(Principal principal, Model model) {
		List<ExtaddVO> extList = addService.showMyExtMember(principal.getName());
		model.addAttribute("extList", extList);
		model.addAttribute("addBar", "addBar");
		model.addAttribute("addBar3", "addBar3");
		return "main/add/myExtAdd";
	}
	
	/**
	 * 외부관계자 등록
	 * @param principal
	 * @param extaddVO
	 * @param ra
	 * @return
	 */
	@RequestMapping(value="/addextmem.do", method = RequestMethod.POST)
	public String addExtMember(Principal principal, ExtaddVO extaddVO, RedirectAttributes ra) { // 폼 전송
		extaddVO.setEmpNo(principal.getName()); // 세션 아이디 값 세팅
		log.info("추가될 ExtaddVO : " + extaddVO.toString());
		addService.addExtMember(extaddVO);
		ra.addFlashAttribute("resultType", "등록");
		ra.addFlashAttribute("resultMsg", "정상적으로 등록되었습니다.");
		return "redirect:/add/myextadd.do";
	}
	
	/**
	 * 내 주소록에서 삭제
	 * @param principal
	 * @param extCdList
	 * @return
	 */
	@RequestMapping(value="/delextmem.do", method = RequestMethod.POST)
	public ResponseEntity<String> delGroupMember(Principal principal, @RequestBody List<String> extCdList) { // 자바스크립트 배열을 json으로 변환
		if(extCdList != null) {
			for(String extCd : extCdList) {
				ExtaddVO extaddVO = new ExtaddVO();
				extaddVO.setEmpNo(principal.getName());
				extaddVO.setExtCd(extCd);
				
				log.info("삭제되는 ExtaddVO : " + extaddVO);
				addService.delExtMember(extaddVO);
			}
		}
		ResponseEntity<String> entity = new ResponseEntity<String>("SUCCESS", HttpStatus.OK);
		return entity;
	}
	
	/**
	 * 외부관계자 수정
	 * @param principal
	 * @param extaddVO
	 * @param ra
	 * @return
	 */
	@RequestMapping(value="/modifyextmem.do", method = RequestMethod.POST)
	public String modifyExtMember(Principal principal, ExtaddVO extaddVO, RedirectAttributes ra) { // 폼 전송
		extaddVO.setEmpNo(principal.getName()); // 세션 아이디 값 세팅
		log.info("수정될 ExtaddVO : " + extaddVO.toString());
		addService.modifyExtMember(extaddVO);
		ra.addFlashAttribute("resultType", "수정");
		ra.addFlashAttribute("resultMsg", "정상적으로 수정되었습니다.");
		return "redirect:/add/myextadd.do";
	}
	
}

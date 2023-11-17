package kr.or.ddit.controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.service.ITodoService;
import kr.or.ddit.vo.TodoListVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class TodoListController {

	@Inject
	private ITodoService todoService;

	/**
	 * todo list 등록
	 * 
	 * @param todoContent todo list 내용
	 * @param principal   로그인한 사번
	 * @return 메인페이지
	 */
	@PostMapping("/registerTodo.do")
	public String registerTodo(String todoContent, Principal principal, RedirectAttributes ra) {
		log.info("registerTodo() 실행...! 값 확인 : " + todoContent + " and " + principal.getName());

		String goPage = "";
		TodoListVO todoListVO = new TodoListVO();
		todoListVO.setEmpNo(principal.getName());
		todoListVO.setTodoContent(todoContent);
		ServiceResult result = todoService.registerTodo(todoListVO);
		// 로그인한 아이디가 관리자일 경우
		if (principal.getName().equals("admin")) {

			goPage = "redirect:/adminmain.do";

			if (!result.equals(ServiceResult.OK)) {
				ra.addFlashAttribute("msg", "서버에러 다시 시도해주세요!");
			}
		} else {// 로그인한 아이디가 사원일 경우
			goPage = "redirect:/";
			if (!result.equals(ServiceResult.OK)) {
				ra.addFlashAttribute("msg", "서버에러 다시 시도해주세요!");
			}
		}

		return goPage;
	}

	/**
	 * todo list 수정
	 * 
	 * @param todoListVO todolist 내용, todoCd
	 * @return 메인페이지
	 */
	@PostMapping("/updateTodo.do")
	public String updateTodo(TodoListVO todoListVO, RedirectAttributes ra) {
		log.info("/updateTodo.do 실행...! : " + todoListVO);

		String goPage = "";

		ServiceResult result = todoService.updateTodo(todoListVO);

		String empNo = SecurityContextHolder.getContext().getAuthentication().getName();
		log.info("empNo : {}",empNo);
		
		
		// 로그인한 아이디가 관리자일 경우
		if (empNo.equals("admin")) {

			goPage = "redirect:/adminmain.do";

			if (!result.equals(ServiceResult.OK)) {
				ra.addFlashAttribute("msg", "서버에러 다시 시도해주세요!");
			}
		} else {// 로그인한 아이디가 사원일 경우
			goPage = "redirect:/";
			if (!result.equals(ServiceResult.OK)) {
				ra.addFlashAttribute("msg", "서버에러 다시 시도해주세요!");
			}
		}

		return goPage;
	}

	/**
	 * todo list 체크
	 * 
	 * @param map todoListVO todo체크값, todoCd
	 * @return 메인페이지
	 */
	@ResponseBody
	@PostMapping("/updateTodoCheckse.do")
	String updateTodoCheckse(@RequestBody Map<String, String> map) {
		log.info("updateTodoCheckse 실행 확인...!");
		log.info("map : " + map);
		String msg = "";
		ServiceResult result = todoService.updateTodoCheckse(map);
		if (result.equals(ServiceResult.OK)) {
			msg = "수정 성공";
		} else {
			msg = "수정 실패";
		}
		return msg;
	}

	/**
	 * todo list 삭제
	 * 
	 * @param todoCd
	 * @return 메인페이지
	 */
	/*
	 * 골뱅이RequestBody를 쓰려면 넘어오는 형식이 JSON : {"memId":"a001","memNm":"김철수"} 이어야 함 아까는
	 * {"a001","김철수"}
	 */
	@ResponseBody
	@RequestMapping(value = "/deleteTodoList.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	public String deleteTodoList(TodoListVO todoListVO) {

		String msg = "";
		// todoCdArr=[2310A010025, 2310A010024, 2310A010023, 2310A010021])
		log.info("deleteTodoList 실행...! 넘어오는 값 확인 : " + todoListVO);
		
		ServiceResult result = todoService.deleteTodoList(todoListVO);
		if (result.equals(ServiceResult.OK)) {
			msg = "삭제 완료!";
		} else {
			msg = "서버에러, 삭제 실패!";
		}
		return msg;
	}

	/**
	 * todo list 총 갯수 가져오기
	 * 
	 * @param principal 로그인한 사번
	 * @return 메인페이지
	 */
	@ResponseBody
	@PostMapping("/selectTodoCnt.do")
	public int selectTodoCnt(Principal principal) {
		String empNo = principal.getName();
		int cnt = todoService.selectTodoCnt(empNo);
		return cnt;
	}

}

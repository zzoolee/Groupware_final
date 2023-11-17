package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.mapper.TodoMapper;
import kr.or.ddit.service.ITodoService;
import kr.or.ddit.vo.TodoListVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class TodoServiceImpl implements ITodoService {

	@Inject
	private TodoMapper todoMapper;

	// todolist 전체 조회
	@Override
	public List<TodoListVO> selectTodoList(String empNo) {

		return todoMapper.selectTodoList(empNo);
	}

	// todolist 등록
	@Override
	public ServiceResult registerTodo(TodoListVO todoListVO) {
		ServiceResult result = null;

		String empNo = todoListVO.getEmpNo();

		int status = todoMapper.registerTodo(todoListVO);

		if (status != 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	// todolist 내용 수정
	@Override
	public ServiceResult updateTodo(TodoListVO todoListVO) {
		ServiceResult result = null;

		int status = todoMapper.updateTodo(todoListVO);
		if (status != 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}

		return result;
	}

	// todolist 체크여부 수정
	@Override
	public ServiceResult updateTodoCheckse(Map<String, String> map) {
		TodoListVO todoListVO = new TodoListVO();
		ServiceResult result = null;
		todoListVO.setTodoCd(map.get("todoCd"));

		String checkse = map.get("checkse");

		if (checkse.equals("true")) {
			todoListVO.setTodoCheckse("Y");
		} else {
			todoListVO.setTodoCheckse("N");
		}

		int status = todoMapper.updateTodoCheckse(todoListVO);
		if (status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public ServiceResult deleteTodoList(TodoListVO todoListVO) {
		log.info("delete 서비스 실행 확인 ");
		ServiceResult result = null;
		for(int i=0; i<todoListVO.getTodoCdArr().length; i++) {
			String todoCd = todoListVO.getTodoCdArr()[i];
			int status = todoMapper.deleteTodoList(todoCd);
			if (status > 0) {
				result = ServiceResult.OK;
			} else {
				result = ServiceResult.FAILED;
			}
		}

		return result;
	}

	@Override
	public int selectTodoCnt(String empNo) {
		int todoCnt = todoMapper.selectTodoCnt(empNo);
		return todoCnt;
	}

}

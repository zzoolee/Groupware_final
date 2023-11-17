package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.TodoListVO;

public interface ITodoService {
	
	/**
	 * todolist 등록
	 * @param todoListVO todlist 정보
	 * @return ServiceResult 상태값 (등록 성공여부)
	 */
	public ServiceResult registerTodo(TodoListVO todoListVO);
	/**
	 * todolist 목록 가져오기
	 * @param empNo 사번
	 * @return List<TodoListVO> todoListVO 정보를 가진 List
	 */
	public List<TodoListVO> selectTodoList(String empNo);
	/**
	 * todolist 내용 수정
	 * @param todoListVO todoContent 수정 정보
	 * @return ServiceResult 상태값 (수정 성공여부)
	 */
	public ServiceResult updateTodo(TodoListVO todoListVO);
	/**
	 * todolist 체크 여부 상태값 업데이트
	 * @param map key : todoCd , value : todoCd
	 * @return ServiceResult 상태값 (업데이트 성공여부)
	 */
	public ServiceResult updateTodoCheckse(Map<String, String> map);
	/**
	 * todolist 삭제
	 * @param todoListVO
	 * @return ServiceResult 상태값 (삭제 성공여부)
	 */
	public ServiceResult deleteTodoList(TodoListVO todoListVO);
	/**
	 * todolist 총 갯수 가져오기
	 * @param empNo 사번
	 * @return cnt 총갯수
	 */
	public int selectTodoCnt(String empNo);


}

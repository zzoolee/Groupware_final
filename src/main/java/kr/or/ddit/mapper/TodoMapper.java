package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.TodoListVO;

public interface TodoMapper {
	
	public int registerTodo(TodoListVO todoListVO);

	public List<TodoListVO> selectTodoList(String empNo);

	public int updateTodo(TodoListVO todoListVO);

	public int updateTodoCheckse(TodoListVO todoListVO);

	public int deleteTodoList(String todoCd);

	public int selectTodoCnt(String empNo);

}

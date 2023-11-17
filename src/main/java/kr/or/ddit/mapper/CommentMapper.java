package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.CommentVO;

public interface CommentMapper {

	public int insertComment(CommentVO commentVO);
	public CommentVO selectComment(String cmNo);
	public void deleteComment(String cmNo);
	public void updateComment(CommentVO commentVO);
	public List<CommentVO> selectCommentFree(@Param("cmBno")String frNo,@Param("cmBoardse") String cmBoardse);

}

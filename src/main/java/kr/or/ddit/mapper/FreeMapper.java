package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.BoardFreeVO;
import kr.or.ddit.vo.LikeVO;

public interface FreeMapper {
	// 자유게시판 조회
	public List<BoardFreeVO> freeList();
	// 글쓴이 사번으로 이름 조회
	public String selectUserName(String empNo);
	// 자유게시판 글 등록
	public void insertFree(BoardFreeVO free);
	// 조회수 증가
	public void incrementHit(String frNo);
	// 자유게시판 글 조회
	public BoardFreeVO selectFree(String frNo);
	// 게시글 수정
	public int updateFree(BoardFreeVO freeVO);
	// 게시글 삭제
	public int deleteFree(String frNo);
	// 사용자 사진 조회
	public String selectUserPhoto(String empNo);
	// 좋아요 정보입력
	public void likeInsert(LikeVO likeVO);
	public void likeUpCount(String frNo);
	// 좋아요 취소
	public void removeLike(LikeVO likeVO);
	public void likeDownCount(String frNo);
	// 좋아요 조회
	public int selectFreeLike(@Param("frNo") String frNo,@Param("likeEmpno") String chatuser);
	// 좋아요 삭제
	public void deleteFreeLike(String frNo);
	// 댓글 삭제
	public void deleteFreeComment(@Param("cmBoardse")String cmBoardse,@Param("cmBno")String frNo);
}

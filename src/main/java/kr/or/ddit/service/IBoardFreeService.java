package kr.or.ddit.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.BoardFreeVO;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.FileVO;
import kr.or.ddit.vo.LikeVO;

public interface IBoardFreeService {
	// 자유게시판 조회
	public List<BoardFreeVO> freeList();
	// 자유게시판 글 등록
	public void insertFree(BoardFreeVO free, HttpServletRequest req, HttpServletResponse res);
	// 게시글 조회
	public BoardFreeVO selectFree(String frNo);
	// 게시글 파일 조회
	public List<FileVO> selectFreefilefrNo(String frNo);
	public List<FileVO> selectFreefile(String fileNo);
	// 게시글 수정
	public ServiceResult freeModify(HttpServletRequest req, BoardFreeVO freeVO);
	// 게시글 삭제
	public ServiceResult deleteFree(HttpServletRequest req, String frNo);
	// 댓글 입력
	public CommentVO insertComment(CommentVO commentVO);
	// 게시글 댓글 조회,삭제,수정
	public List<CommentVO> selectFreeComment(String frNo);
	public void removeComment(String cmNo);
	public void modifyComment(CommentVO commentVO);
	// 사용자 이름 조회
	public String selectUserName(String empNo);
	// 사용자 사진 조회
	public String selectUserPhoto(String empNo);
	// 좋아요 입력
	public void likeInsert(LikeVO likeVO);
	public void likeUpCount(String frNo);
	// 좋아요 삭제
	public void removeLike(LikeVO likeVO);
	public void likeDownCount(String frNo);
	public int selectFreeLike(String chatuser, String frNo);
	public FileVO freeDownload(String fileNo, int fileSec);
}

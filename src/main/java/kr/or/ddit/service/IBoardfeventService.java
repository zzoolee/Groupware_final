package kr.or.ddit.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.BoardFeventVO;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.FileVO;

public interface IBoardfeventService {
	public List<BoardFeventVO> feventList();
	public void insertFevent(BoardFeventVO fevent, HttpServletRequest req, HttpServletResponse res);
	public BoardFeventVO selectfevent(String frNo);
	public List<FileVO> selectfeventfilefeNo(String frNo);
	public List<CommentVO> selectfeventComment(String frNo);
	public String selectUserName(String empNo);
	public String selectUserPhoto(String empNo);
	public List<FileVO> selectfeventfile(String fileNo);
	public ServiceResult feventModify(HttpServletRequest req, BoardFeventVO feventVO);
	public ServiceResult deletefevent(HttpServletRequest req, String frNo);
	public CommentVO insertComment(CommentVO commentVO);
	public void removeComment(String cmNo);
	public void modifyComment(CommentVO commentVO);
	public FileVO feventDownload(String fileNo, int fileSec);
}

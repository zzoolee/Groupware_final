package kr.or.ddit.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.BoardNoticeVO;
import kr.or.ddit.vo.FileVO;

public interface IBoardNoticeService {
	// 공지사항 조회
	public List<BoardNoticeVO> noticeList();
	// 공지사항 등록
	public void insertNotice(BoardNoticeVO notice, HttpServletRequest req, HttpServletResponse res);
	// 게시판 글 조회
	public BoardNoticeVO selectNotice(String noNo);
	// 파일에서 공지사항 파일 조회(noNo로 검색,fileNo로 검색)
	public List<FileVO> selectNoticefilenoNO(String noNo);
	public List<FileVO> selectNoticefile(String fileNo);
	// 공지사항 수정
	public ServiceResult NoticeModify(HttpServletRequest req,BoardNoticeVO noticeVO);
	// 공지사항 글 삭제
	public ServiceResult deleteNotice(HttpServletRequest req, String noNo);
	// 파일 다운로드 하기위한 정보 조회
	public FileVO noticeDownload(String fileNo, int fileSec);
//	public FileVO selectFileInfo(int fileSec);
}

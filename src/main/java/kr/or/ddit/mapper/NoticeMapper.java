package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.BoardNoticeVO;
import kr.or.ddit.vo.FileVO;

public interface NoticeMapper {
	// 공지사항 리스트 조회
	public List<BoardNoticeVO> noticeList();
	// 공지사항 글 작성
	public void insertNotice(BoardNoticeVO notice);
	// 게시글 상세보기
	public BoardNoticeVO selectNotice(String noNo);
	// 게시글 조회수 증가
	public void incrementHit(String noNo);
	// 사번으로 글쓴이 이름 검색
	public String selectUserName(String empNo);
	// 공지사항 수정
	public int updateNotice(BoardNoticeVO noticeVO);
	// 공지사항 게시글 삭제
	public int deleteNotice(String noNo);
	// 파일 다운로드 위한 정보조회
	public FileVO noticeDownload(String fileNo);
	
	public List<BoardNoticeVO> noticePortletList();
}

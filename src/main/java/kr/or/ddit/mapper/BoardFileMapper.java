package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.FileVO;

public interface BoardFileMapper {
	// 첨부파일 입력
	public void insertFile(FileVO file);
	// 공지사항 파일 검색
	public List<FileVO> selectNoticefile(String fileNo);
	public List<FileVO> selectNoticefileSec(String fileSeci);
	// 파일 삭제
	public void deleteFile(String string);
	public void deleteFileList(String[] delFileNo);
	// 폴더 삭제
	public void deleteFolder(String fileNo);
	// 다운로드 위한 파일 검색
	public FileVO noticeDownload(@Param("fileNo")String fileNo, @Param("fileSec")int fileSec);
	public FileVO selectFileInfo(int fileSec);
	// 게시글 번호로 파일 검색
	public List<FileVO> selectFreefile(String fileNo);
}

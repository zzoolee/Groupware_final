package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.FolderFileVO;
import kr.or.ddit.vo.FolderVO;

public interface FileMapper {

	void insertIndFolder(FolderVO folderVO);
	FolderVO selectIndFolder(FolderVO folderVO);
	FolderVO selectParentFolder(String motherFolder);
	FolderVO selectMyselfFolder(FolderVO folderVO);
	List<FolderVO> selectChildFolder(FolderVO folderVO);
	void insertIndFile(FolderFileVO fileVO);
	void insertFolderFile(FolderVO folderFile);
	List<FolderFileVO> selectChildFile(FolderVO folderVO);
	void insertDefaultIndFolder(FolderVO folderVO);
	int selectDefaultIndFolder(FolderVO folderVO);
	FolderFileVO selectMyselfFile(FolderFileVO folderFileVO);
	void updateLikeSe(FolderFileVO folderFileVO);
	void deleteFile(FolderFileVO deleteFile);
	void deleteFolder(FolderVO folderVO);
	void deleteFolderFile(FolderFileVO fileVO);
	List<FolderVO> searchFolderText(FolderVO folderVO);
	List<FolderFileVO> searchFileText(FolderVO folderVO);
	List<FolderFileVO> selectChildFileDate(FolderVO folderVO);
	List<FolderVO> selectChildFolderDate(FolderVO folderVO);
	
	
	
	// 부서 시작
	int selectDefaultDepFolder(FolderVO folderVO);
	void insertDefaultDepFolder(FolderVO folderVO);
	FolderVO selectDepFolder(FolderVO folderVO);
	void insertDepFolder(FolderVO folderVO);
	
	// 전사 시작
	void insertDefaultComFolder(FolderVO folderVO);
	FolderVO selectComFolder(FolderVO folderVO);
	void insertComFolder(FolderVO folderVO);
	int selectDefaultComFolder(FolderVO folderVO);
	FolderVO selectImpFolder(FolderVO folderVO);
	
	// 중요 시작
	void insertDefaultImpFolder(FolderVO folderVO);
	int selectDefaultImpFolder(FolderVO folderVO);
	List<FolderFileVO> showImpFiles(FolderVO folderVO);
	List<FolderFileVO> impSearchText(FolderVO folderVO);
	List<FolderFileVO> showImpFilesDate(FolderVO folderVO);
	
	// 공유
	void folderShare(FolderVO shareFolder);
	void insertShareFile(FolderFileVO fileList);
	void insertShareFolderFile(FolderVO folderFile);
	FolderVO selectMyFolderFile(FolderFileVO fileList);
	void insertDepFile(FolderFileVO fileVO);
	void folderShareUpdate(FolderVO folderSave);
	void depInsertFolderFile(FolderVO folderFile);
	void comInsertFolderFile(FolderVO folderFile);
	void insertComFile(FolderFileVO fileVO);
	List<FolderVO> selectAllIndFiles(String userNoFind);
	List<DeptVO> selectAllDeptList();
	List<FolderVO> selectAllIndFolders(String userNoFind);
	void updateFolderSize(String folderParent);
	String selectMyselfFolderFile(String fileCd);
	void comFileResYes(FolderFileVO folderFileVO);
	List<FolderFileVO> selectApprList();
	List<FolderFileVO> selectAppr(String empNo);
	
}

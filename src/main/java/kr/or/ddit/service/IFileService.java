package kr.or.ddit.service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.ResponseEntity;

import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.FolderFileVO;
import kr.or.ddit.vo.FolderVO;

public interface IFileService {
	
	// 공통 //
	
	/**
	 * FolderVO를 파라미터로 받고,
	 * 폴더부모값을 받아
	 * 폴더부모값이 폴더코드인 폴더값을 리턴해주는 로직
	 */
	public FolderVO selectParentFolder(String motherFolder);
	
	/**
	 * FolderVO를 파라미터로 받고,
	 * 폴더코드를 받아
	 * parma의 폴더코드를 부모폴더로 가지고있는 리스트를 리턴해주는 로직
	 */
	public List<FolderVO> selectChildFolder(FolderVO folderVO);
	
	/**
	 * 폴더코드를 받아
	 * param의 폴더코드를 부모폴더로 가지고있는 파일리스트를 리턴해주는 로직
	 */
	public List<FolderFileVO> selectChildFile(FolderVO folderVO);

	/**
	 * 조회를 날짜순으로 하기위한 로직 
	 */
	public List<FolderVO> selectChildFolderDate(FolderVO folderVO);
	
	/**
	 * 조회를 날짜순으로 하기위한 로직 
	 */
	public List<FolderFileVO> selectChildFileDate(FolderVO folderVO);
	
	/**
	 * FolderVO를 파라미터로 받고,
	 * 폴더코드값을 받아
	 * 본인의 폴더값을 리턴해오는 로직
	 */
	public FolderVO selectMyselfFolder(FolderVO myself);
	
	/**
	 * 폴더파일VO의 fileCd를 받아 자신의 정보를 반환하는 로직
	 */
	public FolderFileVO selectMyselfFile(FolderFileVO folderFileVO);
	
	/**
	 * ajax param값으로 받은 폴더리스트와 파일리스트를 받아서
	 * 선택된 파일을 삭제할수 있게하는 로직. 
	 */
	public void deletefile(List<String> folderArray, List<String> fileArray,
							String folderParent, HttpServletRequest req, HttpServletResponse resp);
	
	/**
	 * 파일다운로드 로직을 완수하고 ResponseEntity 타입으로 반환해주는 로직. 
	 * @throws UnsupportedEncodingException 
	 */
	public ResponseEntity<byte[]> fileDownload(String submitFileCd, HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException;
	
	/**
	 * ajax param값으로 받은 FileCd값을 이용하여
	 * 컨트롤러에서 설정해준 fileLikese를 수정해주는 로직.
	 * @return 
	 */
	public Map<String, FolderFileVO> updateLikeSe(Map<String, Object> param);

	/**
	 * ajax param값으로 폴더리스트와 파일리스트를 받아서
	 * 선택된 파일을 알집으로 다운로드를 해주게하는 로직. 
	 */
	public ResponseEntity<byte[]> alzipDownload(List<String> folderArray, List<String> fileArray, HttpServletRequest request,
			HttpServletResponse response) throws IOException;

	/**
	 * 이미지파일의 정보를 가져오기위한 로직
	 * mapper로는 가지 않고 서비스에서 끝난다. 
	 */
	public Map<String, FolderFileVO> imageFileInfoAjax(Map<String, Object> param);

	/**
	 * ajax param값으로 받은 검색내용과 현재폴더상태를 받아서
	 * 현재폴더안에서 검색된 값을 찾아내는 로직. 
	 */
	public Map<String, Object> searchText(Map<String, String> param);
	
	/** 
	 * 파일리스트와 폴더리스트를 받아 개인자료실에 파일을 복사해주는 로직. 
	 * @return 
	 * @throws FileNotFoundException 
	 * @throws IOException 
	 */
	public String fileShare(List<String> folderArray, List<String> fileArray, HttpServletRequest req,
			HttpServletResponse resp) throws FileNotFoundException, IOException;
	
	
	
	
	
	
	
	
	
	
	// 개인 //
	
	/**
	 * 디폴트폴더의 갯수를 알려주는 로직
	 * 해당 숫자가 1일경우 '존재함', 아닐경우 '존재하지 않음'으로 나뉜다.
	 */
	public int selectDefaultIndFolder(FolderVO folderVO);
	
	/**
	 * 폴더VO의 empNo를 받아 코드, 명칭, empNo를 본인의 empNo로
	 * 생성되는 기본 디폴트 폴더
	 */
	public void insertDefaultIndFolder(FolderVO folderVO);
	
	/**
	 * FolderVO를 파라미터로 받고,
	 * 사번, 폴더부모의 값을 받아
	 * 개인자료실의 폴더를 셀렉트 값을 리턴해주는 로직
	 */
	public FolderVO selectIndFolder(FolderVO folderVO);
	
	/**
	 * folderVO를 파라미터로 받아 해당 폴더에 파일을 인서트시키고,
	 * 파일공간정보를 session에 담아 해당페이지로 이동하게하는 로직
	 * @param folderVO
	 * @param req
	 * @param resp
	 * @return 
	 * @throws IOException 
	 */
	public String insertIndFile(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) throws IOException;
	
	/**
	 * FolderVO를 파라미터로 받고,
	 * 사번, 폴더이름, 폴더상위부모의 값을 받아
	 * 폴더를 생성해주는 로직
	 * @return 
	 */
	public String insertIndFolder(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp);
	
	
	
	
	
	
	
	
	
	
	// 부서 //
	
	/**
	 * 디폴트폴더의 갯수를 알려주는 로직
	 * 해당 숫자가 1일경우 '존재함', 아닐경우 '존재하지 않음'으로 나뉜다.
	 */
	public int selectDefaultDepFolder(FolderVO folderVO);
	
	/**
	 * 폴더VO의 depCd를 받아 코드, 이름, folderSe를 본인의 depCd로
	 * 생성되는 기본 디폴트 폴더
	 */
	public void insertDefaultDepFolder(FolderVO folderVO);
	
	/**
	 * FolderVO를 파라미터로 받고,
	 * depCd, 폴더부모의 값을 받아
	 * 개인자료실의 폴더를 셀렉트 값을 리턴해주는 로직
	 */
	public FolderVO selectDepFolder(FolderVO folderVO);
	
	/**
	 * folderVO를 파라미터로 받아 해당 폴더에 파일을 인서트시키고,
	 * 파일공간정보를 session에 담아 해당페이지로 이동하게하는 로직
	 */
	public String insertDepFile(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) throws IOException;
	
	/**
	 * FolderVO를 파라미터로 받고,
	 * depCd, 폴더이름, 폴더상위부모의 값을 받아
	 * 폴더를 생성해주는 로직
	 */
	public String insertDepFolder(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp);
	
	
	
	
	
	
	
	
	
	
	// 전사 //
	
	/**
	 * 디폴트폴더의 갯수를 알려주는 로직
	 * 해당 숫자가 1일경우 '존재함', 아닐경우 '존재하지 않음'으로 나뉜다.
	 */
	public int selectDefaultComFolder(FolderVO folderVO);
	
	/**
	 * 폴더VO의 depCd를 받아 코드, 이름, folderSe를 본인의 depCd로
	 * 생성되는 기본 디폴트 폴더
	 */
	public void insertDefaultComFolder(FolderVO folderVO);
	
	/**
	 * FolderVO를 파라미터로 받고,
	 * depCd, 폴더부모의 값을 받아
	 * 개인자료실의 폴더를 셀렉트 값을 리턴해주는 로직
	 */
	public FolderVO selectComFolder(FolderVO folderVO);
	
	/**
	 * folderVO를 파라미터로 받아 해당 폴더에 파일을 인서트시키고,
	 * 파일공간정보를 session에 담아 해당페이지로 이동하게하는 로직
	 */
	public String insertComFile(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) throws IOException;
	
	/**
	 * FolderVO를 파라미터로 받고,
	 * depCd, 폴더이름, 폴더상위부모의 값을 받아
	 * 폴더를 생성해주는 로직
	 */
	public String insertComFolder(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp);

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// 즐겨찾는자료
	public int selectDefaultImpFolder(FolderVO folderVO);

	public void insertDefaultImpFolder(FolderVO folderVO);

	public FolderVO selectImpFolder(FolderVO folderVO);

	public List<FolderFileVO> showImpFiles(FolderVO folderVO);

	Map<String, Object> impUpdateLikeSe(Map<String, Object> param);

	Map<String, Object> impSearchText(Map<String, String> param);

	public String impSelectUnlike(List<String> fileArray);

	public List<FolderFileVO> showImpFilesDate(FolderVO folderVO);
	
	
	
	
	
	
	
	
	
	
	
	// 관리자

	public List<DeptVO> selectAllDeptList();

	public FolderVO selectAdminDepFolder(FolderVO selectedDep);

	public String insertDepFolderAdmin(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp);

	public String insertDepFileAdmin(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) throws IOException;

	public String insertComFolderAdmin(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp);

	public String insertComFileAdmin(FolderVO folderVO, HttpServletRequest req, HttpServletResponse resp) throws IOException;

	public void comFileResYes(FolderFileVO folderFileVO);

	public void deleteRefuse(String fileCd);

	public List<FolderFileVO> selectApprList();

	public List<FolderFileVO> selectAppr();


	
	
	

	

}

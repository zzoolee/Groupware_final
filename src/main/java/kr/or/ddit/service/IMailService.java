package kr.or.ddit.service;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.FileVO;
import kr.or.ddit.vo.MailFormVO;
import kr.or.ddit.vo.RMailVO;
import kr.or.ddit.vo.SMailVO;

public interface IMailService {

	/**
	 * 사원번호를 가지고 받은메일 전체정보를 가져오는 로직 
	 */
	List<RMailVO> selectAllRmail();
	
	/**
	 * rmailVO의 메일 아이디를 가지고 들어와 전체내용을 반환해주는 로직. 
	 */
	RMailVO selectRmailOne(RMailVO rmailVO);

	/**
	 * ajax에서 가져온 멀티파일을 이용하여
	 * 데이터를 모두 넣어주고, 데이터값을 반환하는 ajax서비스 로직. 
	 * @throws IOException 
	 */
	Map<String, Object> SendMailAjax(List<MultipartFile> selectFileList, HttpServletRequest req,
			HttpServletResponse resp) throws IOException;

	ServiceResult sendMailForm(MailFormVO mailFormVO, HttpServletRequest req, HttpServletResponse resp) throws IOException;

	void sendMailToMeForm(MailFormVO mailFormVO, HttpServletRequest req, HttpServletResponse resp) throws IOException;

	List<SMailVO> selectAllSmail();

	List<RMailVO> selectAllMyselfMail();

	Map<String, Object> mailLikeAjax(RMailVO rmailVO);

	List<RMailVO> selectAllImpRmail();

	Map<String, Object> mailFileViewAjax(FileVO fileVO);

	ResponseEntity<byte[]> fileDownload(int isFile, HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException;

	SMailVO selectSmailOne(SMailVO smailVO);

	List<RMailVO> selectDeletedMail();

	void rmailDelete(List<String> mailArray);

	void smailDelete(List<String> mailArray);

	void deleteMailAll(List<String> mailArray);

	void adminSendMail(String empNo, String title, String content);

	void resMail(List<String> mailArray);

	Map<String, Object> updateMailChkse(RMailVO rMailVO);

	int showUnreadMailCnt(String name);


}

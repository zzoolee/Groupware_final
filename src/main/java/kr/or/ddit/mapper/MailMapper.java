package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.FileVO;
import kr.or.ddit.vo.MailRecVO;
import kr.or.ddit.vo.RMailVO;
import kr.or.ddit.vo.SMailVO;

public interface MailMapper {

	List<RMailVO> selectAllRmail(String userNoFind);
	RMailVO selectRmailOne(RMailVO rmailVO);
	
	void insertSmail(SMailVO mail);
	SMailVO selectFastestOne(SMailVO mail);
	SMailVO selectSmailOne(SMailVO mail);
	void updateSmailFile(SMailVO mail);
	
	void insertRmail(RMailVO mail);
	int insertRecEmp(MailRecVO recVO);
	int insertRefEmp(MailRecVO recVO);
	void insertRefEmp(FileVO fileVO);
	void insertMailFile(FileVO fileVO);
	
	List<SMailVO> selectAllSmail(String userNoFind);
	List<MailRecVO> selectAllRecEmp(MailRecVO recVO);
	List<MailRecVO> selectAllRefEmp(MailRecVO recVO);
	List<RMailVO> selectAllMyselfMail(String userNoFind);
	void mailLikeAjax(RMailVO rmailVO);
	List<RMailVO> selectAllImpRmail(String mailrEmpno);
	void rmailDelete(RMailVO rMailVO);
	List<RMailVO> selectDeletedMail(RMailVO rmailVO);
	void smailDelete(SMailVO smailVO);
	void deleteMailAll(RMailVO rmailVO);
	void resMail(RMailVO mailVO);
	void updateMailChkse(String mailNo);
	int updateMailChkse(RMailVO rMailVO);
	void updateMailChkse2(RMailVO rmailVO);
	
	List<RMailVO> selectUnreadRmailList(String empNo);
	int selectUnreadRmailCnt(String empNo);

}

package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.DocHistoryVO;
import kr.or.ddit.vo.SalaryVO;

public interface DocMapper {
	
	public List<DocHistoryVO> selectDocHistory(String empNo);

	public int appDoc(DocHistoryVO docHistoryVO);

	public int updateDocSe(String docCd);

	public DocHistoryVO selectDoc(String docCd);

	public SalaryVO selectPaystub(SalaryVO salaryVO);

	public List<SalaryVO> selectSalHistory(String empNo);

	public List<DocHistoryVO> selectDocSalHistory(String empNo);

	public String selectRecentPaystub (DocHistoryVO docHistoryVO);

}

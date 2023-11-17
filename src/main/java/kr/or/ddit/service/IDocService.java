package kr.or.ddit.service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.DocHistoryVO;
import kr.or.ddit.vo.SalaryVO;

public interface IDocService {

	// 증명서 신청
	public ServiceResult appDoc(DocHistoryVO docHistoryVO);
	// 증명서 상태값 업데이트
	public String updateDocSe(String docCd);
	public DocHistoryVO selectDoc(String docCd);
	public SalaryVO selectPaystub(SalaryVO salVO);

}

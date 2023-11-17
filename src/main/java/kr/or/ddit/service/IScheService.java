package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.ScheVO;

public interface IScheService {

	public ServiceResult addSche(ScheVO scheVO);
	public List<ScheVO> showSche(ScheVO scheVO);
	public void modifySche(ScheVO scheVO);
	public void deleteSche(String scCd);
	// 달력에서 이벤트로 실행
	public void modifyScheDate(ScheVO scheVO);

}

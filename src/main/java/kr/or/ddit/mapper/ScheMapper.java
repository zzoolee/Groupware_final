package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.ScheVO;

public interface ScheMapper {

	public int insertSche(ScheVO scheVO);
	public List<ScheVO> selectSche(ScheVO scheVO);
	public void updateSche(ScheVO scheVO);
	public void deleteSche(String scCd);
	// 달력에서 이벤트로 실행
	public void updateScheDate(ScheVO scheVO);

}

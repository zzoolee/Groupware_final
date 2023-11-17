package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.AssRentVO;
import kr.or.ddit.vo.PaginationInfoVO;

public interface IAssetService {
	public List<AssRentVO> selectAssList(AssRentVO assVO);
	public ServiceResult insertAsRent(AssRentVO assVO);
	
	public AssRentVO selectAsRentTodayList(String asCd);

	
	
	// 나의 예약 목록
	public List<AssRentVO> myAssRsvList(String empNo);
	public int selectMyAssetCount(PaginationInfoVO<AssRentVO> asspagingVO);
	public List<AssRentVO> myAssRsvPList(PaginationInfoVO<AssRentVO> asspagingVO);
	public ServiceResult myAssetRsvDel(String asrCd);
	
	//관리자쪽 자산 예약 
	public List<AssRentVO> selectRentList(String asCd);
	public int selectAdminAssetCount(PaginationInfoVO<AssRentVO> asspagingVO);
	public List<AssRentVO> adminAssRsvPList(PaginationInfoVO<AssRentVO> asspagingVO);
	public void cancleAssetBlock(AssRentVO assVO);
	public AssRentVO showAssetInfo(String asCd);
}

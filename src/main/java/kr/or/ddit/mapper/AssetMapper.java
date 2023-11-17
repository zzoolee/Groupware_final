package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.AssRentVO;
import kr.or.ddit.vo.PaginationInfoVO;

public interface AssetMapper {
	public List<AssRentVO> selectAssList(AssRentVO assVO);
	public int insertAsRent(AssRentVO assVO);
	public List<AssRentVO> myAssRsvList(String empNo);
	public AssRentVO selectAsRentTodayList(String asCd);
	public List<AssRentVO> selectRentList(String asCd);
	public int selectMyAssetCount(PaginationInfoVO<AssRentVO> asspagingVO);
	public List<AssRentVO> myAssRsvPList(PaginationInfoVO<AssRentVO> asspagingVO);
	public int myAssetRsvDel(String asrCd);

	// admin
	public int selectAdminAssetCount(PaginationInfoVO<AssRentVO> asspagingVO);
	public List<AssRentVO> adminAssRsvPList(PaginationInfoVO<AssRentVO> asspagingVO);
	public void deleteAssetBlock(AssRentVO assVO);
	public AssRentVO selectAssetInfo(String asCd);
}

package kr.or.ddit.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.mapper.AssetMapper;
import kr.or.ddit.service.IAssetService;
import kr.or.ddit.vo.AssRentVO;
import kr.or.ddit.vo.PaginationInfoVO;

@Service
public class AssetServiceImpl implements IAssetService{

	@Inject
	private AssetMapper assMapper;
	
	@Override
	public List<AssRentVO> selectAssList(AssRentVO assVO) {
		return assMapper.selectAssList(assVO);
	}

	@Override
	public ServiceResult insertAsRent(AssRentVO assVO) {
		ServiceResult result = null;
		
		int status = assMapper.insertAsRent(assVO);
		
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public List<AssRentVO> myAssRsvList(String empNo) {
		return assMapper.myAssRsvList(empNo);
	}

	@Override
	public AssRentVO selectAsRentTodayList(String asCd) {
		return assMapper.selectAsRentTodayList(asCd);
	}

	@Override
	public List<AssRentVO> selectRentList(String asCd) {
		return assMapper.selectRentList(asCd);
	}

	@Override
	public int selectMyAssetCount(PaginationInfoVO<AssRentVO> asspagingVO) {
		return assMapper.selectMyAssetCount(asspagingVO);
	}

	@Override
	public List<AssRentVO> myAssRsvPList(PaginationInfoVO<AssRentVO> asspagingVO) {
		return assMapper.myAssRsvPList(asspagingVO);
	}

	@Override
	public ServiceResult myAssetRsvDel(String asrCd) {
		ServiceResult result = null;
		
		int status = assMapper.myAssetRsvDel(asrCd);
		
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public int selectAdminAssetCount(PaginationInfoVO<AssRentVO> asspagingVO) {
		return assMapper.selectAdminAssetCount(asspagingVO);
	}

	@Override
	public List<AssRentVO> adminAssRsvPList(PaginationInfoVO<AssRentVO> asspagingVO) {
		return assMapper.adminAssRsvPList(asspagingVO);
	}

	@Override
	public void cancleAssetBlock(AssRentVO assVO) {
		assMapper.deleteAssetBlock(assVO);
	}

	@Override
	public AssRentVO showAssetInfo(String asCd) {
		return assMapper.selectAssetInfo(asCd);
	}

}

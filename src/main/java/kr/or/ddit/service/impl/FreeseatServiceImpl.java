package kr.or.ddit.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.mapper.FreeseatMapper;
import kr.or.ddit.service.IFreeseatService;
import kr.or.ddit.vo.SeatResVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FreeseatServiceImpl implements IFreeseatService {
	
	@Inject
	private FreeseatMapper mapper;

	@Override
	public List<SeatResVO> showReservedSeat(SeatResVO seatResVO) {
		return mapper.selectReservedSeat(seatResVO);
	}
	
	@Override
	public List<SeatResVO> showBlockedSeat(SeatResVO seatResVO) {
		return mapper.selectBlockedSeat(seatResVO);
	}

	@Override
	public ServiceResult chkMyFreeseat(String empNo) {
		SeatResVO seatResVO = mapper.chkMyFreeseat(empNo);
		if(seatResVO == null) {
			return ServiceResult.NOTEXIST;
		}else {
			return ServiceResult.EXIST;
		}
	}

	@Override
	public ServiceResult makeRsvFreeseat(SeatResVO seatResVO) {
		SeatResVO result = mapper.chkNowFreeseat(seatResVO);
		if(result == null) {
			mapper.insertRsvFreeseat(seatResVO);
			return ServiceResult.OK;
		}else {
			return ServiceResult.FAILED;
		}
	}

	@Override
	public List<SeatResVO> myFreeseatRsvList(String empNo) {
		return mapper.myFreeseatRsvList(empNo);
	}

	@Override
	public void cancleRsvFreeseat(String srCd) {
		mapper.deleteRsvFreeseat(srCd);
	}

	@Override
	public List<SeatResVO> dateFreeSeatRsvList(SeatResVO seatResVO) {
		return mapper.selectDateRsvFreeSeat(seatResVO);
	}

	@Override
	public void cancleAllblockseat(SeatResVO seatResVO) {
		mapper.deleteAllblockseat(seatResVO);
	}

	@Override
	public List<SeatResVO> allFreeseatRsvList() {
		return mapper.allFreeseatRsvList();
	}

}

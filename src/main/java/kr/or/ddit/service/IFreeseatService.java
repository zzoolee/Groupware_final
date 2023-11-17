package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.SeatResVO;

public interface IFreeseatService {

	public List<SeatResVO> showReservedSeat(SeatResVO seatResVO);
	public List<SeatResVO> showBlockedSeat(SeatResVO seatResVO);
	public ServiceResult chkMyFreeseat(String empNo);
	public ServiceResult makeRsvFreeseat(SeatResVO seatResVO);
	public List<SeatResVO> myFreeseatRsvList(String empNo);
	public void cancleRsvFreeseat(String srCd);
	public List<SeatResVO> dateFreeSeatRsvList(SeatResVO seatResVO);
	
	public void cancleAllblockseat(SeatResVO seatResVO);
	public List<SeatResVO> allFreeseatRsvList();

}

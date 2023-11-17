package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.SeatResVO;

public interface FreeseatMapper {

	public List<SeatResVO> selectReservedSeat(SeatResVO seatResVO);
	public List<SeatResVO> selectBlockedSeat(SeatResVO seatResVO);
	public SeatResVO chkMyFreeseat(String empNo);
	public void insertRsvFreeseat(SeatResVO seatResVO);
	public SeatResVO chkNowFreeseat(SeatResVO seatResVO);
	public List<SeatResVO> myFreeseatRsvList(String empNo);
	public void deleteRsvFreeseat(String srCd);
	public List<SeatResVO> selectDateRsvFreeSeat(SeatResVO seatResVO);
	
	public void deleteAllblockseat(SeatResVO seatResVO);
	public List<SeatResVO> allFreeseatRsvList();

}

package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.RoomResVO;
import kr.or.ddit.vo.TaskVO;

public interface IRoomService {
	public int selectMyRoomCount(PaginationInfoVO<RoomResVO> pagingVO);
	public List<RoomResVO> myRoomRsvPList(PaginationInfoVO<RoomResVO> pagingVO);
	
	public List<RoomResVO> selectRoomList(RoomResVO roomVO);
	public ServiceResult insertRoomres(RoomResVO roomVO);
	
	// 나의 예약 목록
	public List<RoomResVO> myRoomRsvList(String empNo);
//	public List<RoomResVO> myRoomRsvPList(String empNo);
	public ServiceResult myRoomRsvDel(String rrCd);
	
	
	
	//ajax로 모달 가져오기
	public RoomResVO selectRoomModal(String roomCd);
	public List<RoomResVO> selectRentList(String roomCd);
	
	// admin페이지 예약 리스트
	public int selectAdminRoomCount(PaginationInfoVO<RoomResVO> pagingVO);
	public List<RoomResVO> adminRoomRsvPList(PaginationInfoVO<RoomResVO> pagingVO);
	
	public void cancleRoomBlock(RoomResVO roomVO);


}

package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.RoomResVO;

public interface RoomMapper {
	public List<RoomResVO> selectRoomList(RoomResVO roomVO);
	public int insertRoomres(RoomResVO roomVO);
	public List<RoomResVO> myRoomRsvList(String empNo);
//	public List<RoomResVO> myRoomRsvPList(String empNo);
//	public List<RoomResVO> selectRoomList(PaginationInfoVO<RoomResVO> pagingVO);
	public List<RoomResVO> myRoomRsvPList(PaginationInfoVO<RoomResVO> pagingVO);
	public int selectMyRoomCount(PaginationInfoVO<RoomResVO> pagingVO);
	public RoomResVO selectRoomModal(String roomCd);
	public List<RoomResVO> selectRentList(String roomCd);
	public int myRoomRsvDel(String rrCd);
	
	// Admin
	public int selectAdminRoomCount(PaginationInfoVO<RoomResVO> pagingVO);
	public List<RoomResVO> adminRoomRsvPList(PaginationInfoVO<RoomResVO> pagingVO);
	
	public void deleteRoomBlock(RoomResVO roomVO);
}

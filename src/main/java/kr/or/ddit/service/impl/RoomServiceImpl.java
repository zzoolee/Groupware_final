package kr.or.ddit.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.mapper.RoomMapper;
import kr.or.ddit.service.IRoomService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.RoomResVO;

@Service
public class RoomServiceImpl implements IRoomService{

	@Inject
	private RoomMapper roomMapper;
	
	@Override
	public List<RoomResVO> selectRoomList(RoomResVO roomVO) {
		return roomMapper.selectRoomList(roomVO);
	}

	@Override
	public ServiceResult insertRoomres(RoomResVO roomVO) {
		ServiceResult result = null;
		
		int status = roomMapper.insertRoomres(roomVO);
		
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}
	
	@Override
	public List<RoomResVO> myRoomRsvList(String empNo){
		return roomMapper.myRoomRsvList(empNo);
	}
	
	@Override
	public List<RoomResVO> myRoomRsvPList(PaginationInfoVO<RoomResVO> pagingVO) {
		return roomMapper.myRoomRsvPList(pagingVO);
	}

	@Override
	public int selectMyRoomCount(PaginationInfoVO<RoomResVO> pagingVO) {
		return roomMapper.selectMyRoomCount(pagingVO);
	}

	@Override
	public RoomResVO selectRoomModal(String roomCd) {
 		return roomMapper.selectRoomModal(roomCd);
	}

	@Override
	public List<RoomResVO> selectRentList(String roomCd) {
 		return roomMapper.selectRentList(roomCd);
	}

	@Override
	public ServiceResult myRoomRsvDel(String rrCd) {
		ServiceResult result = null;
		
		int status = roomMapper.myRoomRsvDel(rrCd);
		
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public int selectAdminRoomCount(PaginationInfoVO<RoomResVO> pagingVO) {
		return roomMapper.selectAdminRoomCount(pagingVO);
	}

	@Override
	public List<RoomResVO> adminRoomRsvPList(PaginationInfoVO<RoomResVO> pagingVO) {
		return roomMapper.adminRoomRsvPList(pagingVO);
	}

	@Override
	public void cancleRoomBlock(RoomResVO roomVO) {
		roomMapper.deleteRoomBlock(roomVO);
	}

}

package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.chatSelectResultVO;

public interface ChatTilesMapper {
	public List<chatSelectResultVO> selectRoomList(String chatuser);
	public String selectRecentChat(String chatuser);
	public List<EmpVO> selectChatUserTiles(String chatuser);
	// <a>태그 리스트 키워드로 검색
	public List<EmpVO> searchUsers(@Param("empName")String keyword);
}

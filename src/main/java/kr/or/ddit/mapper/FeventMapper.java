package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.BoardFeventVO;

public interface FeventMapper {
	public List<BoardFeventVO> feventList();
	public String selectUserName(String empNo);
	public void insertFevent(BoardFeventVO fevent);
	public BoardFeventVO selectFevent(String feNo);
	public void incrementHit(String feNo);
	public String selectUserPhoto(String empNo);
	public int updateFevent(BoardFeventVO feventVO);
	public int deleteFevent(String feNo);
	public void deleteFeventComment(@Param("cmBoardse")String cmBoardse, @Param("cmBno")String feNo);
}

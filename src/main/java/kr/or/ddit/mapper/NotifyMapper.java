package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.NotifyVO;

public interface NotifyMapper {

	public void insertNotify(NotifyVO notifyVO);

//	public List<NotifyVO> selectNotiList(String notifyTypese);

	public int selecCntNotify(String empNo);

	public List<NotifyVO> selectNotifyList(String empNo);

	public int updateNotickse(String notifyCd);

	public int notiAllCheck(String empNo);
	
}

package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.NotifyVO;

public interface INotifyService {

	public int selecCntNotify(String empNo);

	public List<NotifyVO> selectNotifyList(String empNo);

	public int updateNotickse(String notifyCd);

	public int notiAllCheck(String empNo);
	
//	public void insertNoti(String empNo, String msg, String content);
}

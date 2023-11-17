package kr.or.ddit.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.mapper.NotifyMapper;
import kr.or.ddit.service.INotifyService;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.NotifyVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class NotifyServiceImpl implements INotifyService {

	@Inject
	NotifyMapper notiMapper;
	
	@Inject
	EmpMapper empMapper;

	/**
	 * 미확인 알림 갯수 가져오기
	 */
	@Override
	public int selecCntNotify(String empNo) {

		int cnt = notiMapper.selecCntNotify(empNo);
		return cnt;
	}

	/**
	 * 미확인 알림 리스트 가져오기
	 */
	@Override
	public List<NotifyVO> selectNotifyList(String empNo) {

		List<NotifyVO> notiList = notiMapper.selectNotifyList(empNo);

		return notiList;
	}

	/**
	 * 알람 상태값 변경하기
	 */
	@Override
	public int updateNotickse(String notifyCd) {
		int status = notiMapper.updateNotickse(notifyCd);
		return status;
	}

	/**
	 * 알람 상태값 전체 업데이트
	 */
	@Override
	public int notiAllCheck(String empNo) {
		int status = notiMapper.notiAllCheck(empNo);
		return status;
	}

	/**
	 * 직원들의 알림 수신 여부 확인 후 DB 인서트
	 */
//	@Override
//	public void insertNoti(String empNo, String msg, String content) {
//		NotifyVO notifyVO = new NotifyVO();
//		
//		String newMsg = "";
//		
//		if (msg.equals("결재")) {
//			notifyVO.setNotifyContent("결재 문서가 도착하였습니다.");
//			newMsg = msg;
//		} else if (msg.equals("참조")) {
//			notifyVO.setNotifyContent("참조 문서가 도착하였습니다.");
//			newMsg = msg;
//		} else if (msg.equals("일정")) {
//			notifyVO.setNotifyContent("회사 일정(" + content + ")이 추가되었습니다.");
//			newMsg = msg;
//		} else if (msg.equals("업무")) {
//			notifyVO.setNotifyContent("업무 요청(" + content + ")이 도착하였습니다.");
//			newMsg = msg;
//		} else if (msg.equals("메일")) {
//			notifyVO.setNotifyContent("메일(" + content + ")이 도착하였습니다.");
//			newMsg =msg;
//		} else if (msg.equals("메일참조")) {
//			notifyVO.setNotifyContent("참조 메일(" + content + ")이 도착하였습니다.");
//			newMsg ="메일";
//		} else if (msg.equals("자유댓글")) {
//			notifyVO.setNotifyContent("자유게시판(" + content + ")게시글에 댓글이 작성되었습니다.");
//			newMsg ="댓글";
//		} else if (msg.equals("경조사댓글")) {
//			notifyVO.setNotifyContent("경조사게시판(" + content + ")게시글에 댓글이 작성되었습니다.");
//			newMsg ="댓글";
//		} else if (msg.equals("클럽댓글")) {
//			notifyVO.setNotifyContent("동호회게시판(" + content + ")게시글에 댓글이 작성되었습니다.");
//			newMsg ="댓글";
//		}
//
//		notifyVO.setNotifyEmpno(empNo);
//		notifyVO.setNotifyTypese(msg);
//		
//		EmpVO empVO = empMapper.readByUserId(empNo);
//		
//		if(empVO.getNotiList() != null && empVO.getNotiList().contains(newMsg)) {
//			notiMapper.insertNotify(notifyVO);
//		}
//		
//	}

}

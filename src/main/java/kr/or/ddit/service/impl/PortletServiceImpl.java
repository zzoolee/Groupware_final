package kr.or.ddit.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.AddMapper;
import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.mapper.FeventMapper;
import kr.or.ddit.mapper.MailMapper;
import kr.or.ddit.mapper.NoticeMapper;
import kr.or.ddit.mapper.PortletMapper;
import kr.or.ddit.mapper.TaskMapper;
import kr.or.ddit.mapper.TodoMapper;
import kr.or.ddit.service.IAttendService;
import kr.or.ddit.service.IAuthService;
import kr.or.ddit.service.IMailService;
import kr.or.ddit.service.IPortletService;
import kr.or.ddit.vo.AddGroupMemberVO;
import kr.or.ddit.vo.AtStatusVO;
import kr.or.ddit.vo.AttendCombinedVO;
import kr.or.ddit.vo.AttendVO;
import kr.or.ddit.vo.BoardFeventVO;
import kr.or.ddit.vo.BoardListVO;
import kr.or.ddit.vo.BoardNoticeVO;
import kr.or.ddit.vo.DraftVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.MyAddGroupVO;
import kr.or.ddit.vo.PortletVO;
import kr.or.ddit.vo.RMailVO;
import kr.or.ddit.vo.TaskVO;
import kr.or.ddit.vo.TodoListVO;

@Service
public class PortletServiceImpl implements IPortletService {
   
   @Inject
   private PortletMapper mapper;
   @Inject
   private TodoMapper todoMapper;
   @Inject
   private AddMapper addMapper;
   @Inject
   private MailMapper mailMapper;
   @Inject
   private TaskMapper taskMapper;
   @Inject
   private EmpMapper empMapper;
   @Inject
   private NoticeMapper noticeMapper;
   @Inject
   private FeventMapper feventMapper;
   
   @Inject
   private IAttendService attendService;
   @Inject
   private IAuthService authService;
   
   @Override
   public void clearPortlet(String empNo) {
      mapper.deletePortlet(empNo);
   }
   
   @Override
   public void addPortlet(PortletVO portlet) {
      mapper.insertPortlet(portlet);
   }

   @Override
   public List<PortletVO> showPortlet(String empNo) {
      List<PortletVO> portletList = mapper.selectPortletList(empNo); // 포틀릿 좌표 정보
      if(portletList != null && portletList.size() > 0) {
         for(int i = 0; i < portletList.size(); i++) {
            PortletVO portletVO = portletList.get(i);
			if (portletVO != null) {
				String code = portletVO.getPortCatecode();
				if (code.equals("attend")) {
					// 근태시간
					int percent = 0;
					// 금일 일한 내용넣어줄 VO
					AtStatusVO atStatusVO = new AtStatusVO();
					atStatusVO = attendService.selectAttendStatus(atStatusVO);
					AttendVO attendVO = new AttendVO();
					attendVO = attendService.selectTodayAttend(attendVO);
					System.out.println(attendVO);
					// 금일 일한 퍼센테이지를 넣어줄 VO
					AttendVO getAttendPercent = new AttendVO();
					if (attendVO == null) {
					} else {
						if (attendVO.getAtStart() == null) {
						} else {
							// 프로그래스바의 차이를 가져와서 diff에 담아놓음.
							getAttendPercent = attendService.selectAttendPercent(getAttendPercent);
							// diff에 담긴 내용을 바탕으로 퍼센트를 뽑아냄.
							percent = attendService.getPercent(getAttendPercent);
						}
					}
					AttendCombinedVO attendCombinedVO = new AttendCombinedVO();
					attendCombinedVO.setAttendVO(attendVO);
					attendCombinedVO.setAtStatusVO(atStatusVO);
					attendCombinedVO.setPercent(percent);
					portletVO.setData(attendCombinedVO);
				} else if (code.equals("mail")) {
					List<RMailVO> unreadMailList = mailMapper.selectUnreadRmailList(empNo);
					int unreadMailCnt = mailMapper.selectUnreadRmailCnt(empNo);
					portletVO.setDataList(unreadMailList);
					portletVO.setData(unreadMailCnt);
				} else if (code.equals("addr")) {
					List<AddGroupMemberVO> groupList = addMapper.selectRecentMember(empNo);
					portletVO.setDataList(groupList);
				} else if (code.equals("schedule")) {

				} else if (code.equals("task")) {
					List<TaskVO> taskList = taskMapper.selectTaskList(empNo);
					portletVO.setDataList(taskList);
				} else if (code.equals("auth")) {
					List<DraftVO> waitList = authService.selectWaitList(empNo);
					portletVO.setDataList(waitList);
				} else if (code.equals("board")) {
					BoardListVO boardListVO = new BoardListVO();
					List<BoardNoticeVO> noticeList = noticeMapper.noticePortletList();
					if (noticeList != null) {
						for (int j = 0; j < noticeList.size(); j++) {
							String boarduser = empMapper.findName(noticeList.get(j).getNoWriterEmpNo());
							noticeList.get(j).setEmpName(boarduser);
						}
						boardListVO.setNoticeList(noticeList);
					}
					List<BoardFeventVO> feventList = feventMapper.feventList();
					if (feventList != null) {
						for (int j = 0; j < feventList.size(); j++) {
							String boarduser = empMapper.findName(feventList.get(j).getFeWriterEmpNo());
							feventList.get(j).setEmpName(boarduser);
						}
						boardListVO.setFeventList(feventList);
					}
					portletVO.setData(boardListVO);
               } else if(code.equals("todolist")) {
                  List<TodoListVO> todoList = todoMapper.selectTodoList(empNo);
                  portletVO.setDataList(todoList);
               }
            }
         }
      }
      return portletList;
   }

	@Override
	public List<PortletVO> showAdminPortlet(String empNo) {
		List<PortletVO> portletList = mapper.selectPortletList(empNo); // 포틀릿 좌표 정보
		if (portletList != null && portletList.size() > 0) {
			for (int i = 0; i < portletList.size(); i++) {
				PortletVO portletVO = portletList.get(i);
				if (portletVO != null) {
					String code = portletVO.getPortCatecode();
					if (code.equals("attend")) {
						
					} else if (code.equals("mail")) {
						List<RMailVO> unreadMailList = mailMapper.selectUnreadRmailList(empNo);
						int unreadMailCnt = mailMapper.selectUnreadRmailCnt(empNo);
						portletVO.setDataList(unreadMailList);
						portletVO.setData(unreadMailCnt);
					} else if (code.equals("addr")) {
						List<EmpVO> empList = addMapper.selectRecentMemberAdmin();
						portletVO.setDataList(empList);
					} else if (code.equals("schedule")) {

					} else if (code.equals("task")) {
						TaskVO taskVO = new TaskVO();
						List<TaskVO> taskList = taskMapper.portletAdminTaskList(taskVO);
						portletVO.setDataList(taskList);
					} else if (code.equals("auth")) {
						List<DraftVO> allDraftList = authService.selectAllDraft();
						portletVO.setDataList(allDraftList);
					} else if (code.equals("board")) {
						BoardListVO boardListVO = new BoardListVO();
						List<BoardNoticeVO> noticeList = noticeMapper.noticePortletList();
						if (noticeList != null) {
							for (int j = 0; j < noticeList.size(); j++) {
								String boarduser = empMapper.findName(noticeList.get(j).getNoWriterEmpNo());
								noticeList.get(j).setEmpName(boarduser);
							}
							boardListVO.setNoticeList(noticeList);
						}
						List<BoardFeventVO> feventList = feventMapper.feventList();
						if (feventList != null) {
							for (int j = 0; j < feventList.size(); j++) {
								String boarduser = empMapper.findName(feventList.get(j).getFeWriterEmpNo());
								feventList.get(j).setEmpName(boarduser);
							}
							boardListVO.setFeventList(feventList);
						}
						portletVO.setData(boardListVO);
					} else if (code.equals("todolist")) {
						List<TodoListVO> todoList = todoMapper.selectTodoList(empNo);
						portletVO.setDataList(todoList);
					}
				}
			}
		}
		return portletList;
	}

}
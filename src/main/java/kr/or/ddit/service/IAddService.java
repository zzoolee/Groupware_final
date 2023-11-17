package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.AddGroupMemberVO;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.ExtaddVO;
import kr.or.ddit.vo.MyAddGroupVO;

public interface IAddService {

	public List<DeptVO> showTreeList();
	public List<MyAddGroupVO> showMyGroup(String name);
	public ServiceResult addGroupMember(MyAddGroupVO myGroupVO);
	public List<MyAddGroupVO> showMyAllGroupMember(String name);
	public void delGroupMember(AddGroupMemberVO groupMember);
	public void delGroup(String mygrCd);
	public void modifyGroup(MyAddGroupVO myGroupVO);
	public List<ExtaddVO> showMyExtMember(String name);
	public void addExtMember(ExtaddVO extaddVO);
	public void delExtMember(ExtaddVO extaddVO);
	public void modifyExtMember(ExtaddVO extaddVO);

}

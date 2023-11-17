package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.AddGroupMemberVO;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.ExtaddVO;
import kr.or.ddit.vo.MyAddGroupVO;

public interface AddMapper {
	public List<DeptVO> selectTreeList();
	public void createBasicGroup(String empNo);
	
	public List<MyAddGroupVO> selectMyGroup(String empNo);
	public void createNewGroup(MyAddGroupVO myGroupVO);
	public void insertGroupMember(AddGroupMemberVO groupMemberVO);
	public AddGroupMemberVO checkGroupMember(AddGroupMemberVO groupMemberVO);
	
	public List<MyAddGroupVO> selectMyAllGroupMember(String empNo);
	public void deleteGroupMember(AddGroupMemberVO groupMember);
	public void deleteGroup(String mygrCd);
	public void updateGroup(MyAddGroupVO myGroupVO);
	
	public List<ExtaddVO> selectMyExtMember(String empNo);
	public void insertExtMember(ExtaddVO extaddVO);
	public void deleteExtMember(ExtaddVO extaddVO);
	public void updateExtMember(ExtaddVO extaddVO);
	
	public List<AddGroupMemberVO> selectRecentMember(String empNo);
	public List<EmpVO> selectRecentMemberAdmin();
}

package kr.or.ddit.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.mapper.AddMapper;
import kr.or.ddit.service.IAddService;
import kr.or.ddit.vo.AddGroupMemberVO;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.ExtaddVO;
import kr.or.ddit.vo.MyAddGroupVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AddServiceImpl implements IAddService {

	@Inject
	private AddMapper mapper;
	
	@Override
	public List<DeptVO> showTreeList() {
		return mapper.selectTreeList();
	}

	@Override
	public List<MyAddGroupVO> showMyGroup(String empNo) {
		return mapper.selectMyGroup(empNo);
	}

	@Override
	public ServiceResult addGroupMember(MyAddGroupVO myGroupVO) {
		Boolean flag = true; // 추가되지 않은 직원이 있는지 확인
		
		if(myGroupVO.getMygrName() != null && myGroupVO.getMygrName() != "") { // 값 있는지 없는지 검증할 때 쓰던거 뭐였더라?
			// mygrName을 통해 그룹 생성 후 - MYADDGROUP 테이블
			mapper.createNewGroup(myGroupVO);
		}
			
		// 생성된 그룹(mygrCd)에 추가 : 위 쿼리 실행 후  mygrCd에 세팅 - ADDGROUPMEMBER 테이블
		// 기존 그룹(mygrCd)에 추가 - ADDGROUPMEMBER 테이블
		if(myGroupVO.getMygrEmpno() != null) {
			int memberNum = myGroupVO.getMygrEmpno().length;
			for(int i=0; i<memberNum; i++) {
				AddGroupMemberVO groupMemberVO = new AddGroupMemberVO();
				groupMemberVO.setMygrCd(myGroupVO.getMygrCd());
				groupMemberVO.setMygrEmpno(myGroupVO.getMygrEmpno()[i]);
				
				AddGroupMemberVO check = mapper.checkGroupMember(groupMemberVO);
				if(check == null) { // 그룹에 존재하지 않으면 추가
					mapper.insertGroupMember(groupMemberVO);
				} else {
					log.info(i + "번째 직원은 이미 그룹에 존재하므로 추가되지 않음");
					flag = false;
				}
			}
		}
		
		if(flag) {
			return ServiceResult.OK;
		} else {
			return ServiceResult.HALFOK;
		}
	}

	@Override
	public List<MyAddGroupVO> showMyAllGroupMember(String empNo) {
		return mapper.selectMyAllGroupMember(empNo);
	}

	/**
	 * 내 주소록에서 해제 : 그룹안에 멤버들만 삭제
	 */
	@Override
	public void delGroupMember(AddGroupMemberVO groupMember) {
		mapper.deleteGroupMember(groupMember);
	}
	
	/**
	 * 그룹삭제 : 그룹안에 멤버들 삭제 후 그룹 삭제
	 */
	@Override
	public void delGroup(String mygrCd) {
		AddGroupMemberVO groupMember = new AddGroupMemberVO();
		groupMember.setMygrCd(mygrCd);
		mapper.deleteGroupMember(groupMember); // 그룹안에 멤버 삭제
		mapper.deleteGroup(mygrCd); // 그룹 삭제
	}
	
	@Override
	public void modifyGroup(MyAddGroupVO myGroupVO) {
		mapper.updateGroup(myGroupVO);
	}

	@Override
	public List<ExtaddVO> showMyExtMember(String empNo) {
		return mapper.selectMyExtMember(empNo);
	}

	@Override
	public void addExtMember(ExtaddVO extaddVO) {
		mapper.insertExtMember(extaddVO);
	}

	@Override
	public void delExtMember(ExtaddVO extaddVO) {
		mapper.deleteExtMember(extaddVO);
	}

	@Override
	public void modifyExtMember(ExtaddVO extaddVO) {
		mapper.updateExtMember(extaddVO);
	}

}

package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.mapper.AuthMapper;
import kr.or.ddit.service.IAuthService;
import kr.or.ddit.vo.AppBMLineVO;
import kr.or.ddit.vo.AppBookMarkVO;
import kr.or.ddit.vo.AtrzFormVO;
import kr.or.ddit.vo.AtrzPathVO;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.DraftRefVO;
import kr.or.ddit.vo.DraftVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AuthServiceImpl implements IAuthService {

	@Inject
	private AuthMapper authMapper;
	
	//모든 결재 양식 불러오기
	@Override
	public List<AtrzFormVO> selectAtrzForm() {
		return authMapper.selectAtrzForm();
	}
	//결재양식 코드를 통해 1개 양식 불러오기
	@Override
	public AtrzFormVO selectAtrzContent(String atrzfCd) {
		return authMapper.selectAtrzContent(atrzfCd);
	}
	
	//임시저장 버튼
	@Override
	public ServiceResult draftTempSaveInsert(DraftVO draftVO) {
 		ServiceResult result = null;
 		//참조자 삭제
		authMapper.refDelete(draftVO.getDrftCd());
		//결재선 삭제
		authMapper.authPathDelete(draftVO.getDrftCd());
 		//임시저장(기안)
 		int status = authMapper.draftTempSaveInsert(draftVO);
 		if(status > 0) {
 			result = ServiceResult.OK;
 		}else {
 			result = ServiceResult.FAILED;
 		}
		return result;
	}
	
	// 결재선 결재자
	public ServiceResult pathInsert(AtrzPathVO pathVO) {
		ServiceResult result = null;
		int status = authMapper.atrzPathInsert(pathVO);
		if(status > 0) {
 			result = ServiceResult.OK;
 		}else {
 			result = ServiceResult.FAILED;
 		}
		return result;
	}

	// 참조자도 여러명
	@Override
	public ServiceResult refInsert(DraftRefVO refVO) {
		ServiceResult result = null;
		int status = authMapper.refInsert(refVO);
		if(status > 0) {
 			result = ServiceResult.OK;
 		}else {
 			result = ServiceResult.FAILED;
 		}
		return result;
	}

	//임시저장된 문서 리스트
	@Override
	public List<DraftVO> selectTempSaveList(String empNo) {
		return authMapper.selectTempSaveList(empNo);
	}
	
	// 디테일 페이지
	@Override
	public DraftVO draftDetail(DraftVO draftVO) {
  		return authMapper.draftDetail(draftVO);
	}
	@Override
	public List<AtrzPathVO> pathSelect(String drftCd) {
		return authMapper.pathSelect(drftCd);
	}
	@Override
	public List<DraftRefVO> refSelect(String drftCd) {
		return authMapper.refSelect(drftCd);
	}

	//임시저장 삭제
	@Override
	public ServiceResult tempSaveDelete(String drftCd) {
		ServiceResult result = null;
		authMapper.refDelete(drftCd);
		authMapper.authPathDelete(drftCd);
		int status = authMapper.tempSaveDelete(drftCd);
		if(status > 0) {
 			result = ServiceResult.OK;
 		}else {
 			result = ServiceResult.FAILED;
 		}
		return result;
	}

	@Override	//임시저장 -> 결재상신
	public ServiceResult approval(DraftVO draftVO) {
		ServiceResult result = null;
 		int status = authMapper.approval(draftVO);
 		if(status > 0) {
 			result = ServiceResult.OK;
 		}else {
 			result = ServiceResult.FAILED;
 		}
		return result;
	}
	
//	임시저장 수정
	@Override
	public ServiceResult tempSaveUpdate(DraftVO draftVO) {
		ServiceResult result = null;
 		int status = authMapper.tempSaveUpdate(draftVO);
 		if(status > 0) {
 			result = ServiceResult.OK;
 		}else {
 			result = ServiceResult.FAILED;
 		}
		return result;
	}
	
	
	@Override
	public ServiceResult tsPathInsert(AtrzPathVO pathVO) {
		ServiceResult result = null;
 		int status = authMapper.tsPathInsert(pathVO);
 		if(status > 0) {
 			result = ServiceResult.OK;
 		}else {
 			result = ServiceResult.FAILED;
 		}
		return result;
	}
	
	
	
	
	//진행중문서 리스트
	@Override
	public List<DraftVO> selectProgList(String empNo) {
		return authMapper.selectProgList(empNo);
	}
	
	//반려문서함
	@Override
	public List<DraftVO> selectRetList(String empNo) {
		return authMapper.selectRetList(empNo);
	}
	
	//완료문서함
	@Override
	public List<DraftVO> selectComList(String empNo) {
		return authMapper.selectComList(empNo);
	}
	
	//기안서 작성 -> 결재상신
	@Override
	public ServiceResult dfApproval(DraftVO draftVO) {
		ServiceResult result = null;
 		//임시저장(기안)
 		int status = authMapper.dfApproval(draftVO);
 		if(status > 0) {
 			result = ServiceResult.OK;
 		}else {
 			result = ServiceResult.FAILED;
 		}
		return result;
	}
	
	@Override
	public void refDelete(String drftCd) {
		authMapper.refDelete(drftCd);
	}
	@Override
	public void authPathDelete(String drftCd) {
		authMapper.authPathDelete(drftCd);
	}
	
	
/////////////////////////////////////////////////////////////////////////////////////////
	
	//결재대기 문서 리스트
	@Override
	public List<DraftVO> selectWaitList(String empNo) {
		return authMapper.selectWaitList(empNo);
	}
	@Override
	public DraftVO authDetail(DraftVO draftVO) {
		return authMapper.authDetail(draftVO);
	}
	
	//전결, 결재
	@Override
	public ServiceResult sign(DraftVO draftVO) {
		ServiceResult result = null;
		int status = authMapper.sign(draftVO);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}
	
	// 진행구분 update 완료/진행중
	@Override
	public ServiceResult updateProgress(DraftVO draftVO) {
		ServiceResult result = null;
		int status =  authMapper.updateProgress(draftVO);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	// 내 결재선 진행상태 업데이트
	@Override
	public ServiceResult updateStatus(DraftVO draftVO) {
		ServiceResult result = null;
		int status =  authMapper.updateStatus(draftVO);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}
	
	@Override
	public ServiceResult lastOrderComplete(DraftVO draftVO) {
		ServiceResult result = null;
		int status =  authMapper.lastOrderComplete(draftVO);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}
	
	
	@Override
	public ServiceResult returnMemo(DraftVO draftVO) {
		ServiceResult result = null;
		int status = authMapper.returnMemo(draftVO);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
 		return result;
	}
	@Override
	public ServiceResult returnStatus(DraftVO draftVO) {
		ServiceResult result = null;
		int status = authMapper.returnStatus(draftVO);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
 		return result;
	}

	// 반려문서
	@Override
	public List<DraftVO> selectReturnList(String empNo) {
 		return authMapper.selectReturnList(empNo);
	}
	
	//반려사유(ajax)
	@Override
	public DraftVO selectMemo(String drftCd) {
		return authMapper.selectMemo(drftCd);
	}
	@Override
	public DraftVO selectRetName(DraftVO draftVO) {
 		return authMapper.selectRetName(draftVO);
	}
	
	
	//참조문서 리스트
	@Override
	public List<DraftVO> selectRefList(String empNo) {
		return authMapper.selectRefList(empNo);
	}
	
	//내가 결재한 문서(완료문서함)
	@Override
	public List<DraftVO> selectCompleteList(String empNo) {
		return authMapper.selectCompleteList(empNo);
	}
	
	//결재선 관리
	@Override
	public ServiceResult abmInsert(AppBookMarkVO abmVO) {
		ServiceResult result = null;
		int status = authMapper.abmInsert(abmVO);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}
	
	@Override
	public ServiceResult bmLineInsert(AppBMLineVO bmLine) {
		ServiceResult result = null;
		int status = authMapper.bmLineInsert(bmLine);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}
	
	//즐겨찾는 결재선 리스트
	@Override
	public List<AppBookMarkVO> selectAppBookMark(String empNo) {
		return authMapper.selectAppBookMark(empNo);
	}
	
	//즐겨찾는 결재선 삭제
	@Override
	public ServiceResult abmDel(String abmCd) {
		ServiceResult result = null;
		//결재선 결재자(applineEmpno)
		authMapper.bmLineDel(abmCd);
		//즐겨찾는 결재선 삭제
		int status = authMapper.abmDel(abmCd);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}
	
	
	
	
	
	
///////////////////////////////////////////////////////////////////////////////////
	
	// 기안문서 양식 수정
	@Override
	public ServiceResult updateupdateAtrzForm(AtrzFormVO atrzFormVO) {
		ServiceResult result = null;
		
		int status = authMapper.updateupdateAtrzForm(atrzFormVO);
		
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}
	//기안문서 양식 폼 생
	@Override
	public ServiceResult createAtrzf(AtrzFormVO atrzFormVO) {
		ServiceResult result = null;
		String atrzfCd = "af";
		// atrzfCd 생성을 위한 끝번호 추출
		List<AtrzFormVO> newAtrzFormVOCd = authMapper.getatrzfCd();
		
		if(newAtrzFormVOCd.size() > 0) {
			int num = newAtrzFormVOCd.get(0).getAtrzfCustomCd();
			
				num += 1;
			if(num < 10) {
				atrzfCd+="00"+num;
			}else if(num>9 && num<100){
				atrzfCd+="0"+num;
			}else {
				atrzfCd+=num;
			}
		}else {
			atrzfCd+="001";
			atrzFormVO.setAtrzfCd(atrzfCd);
		}
		atrzFormVO.setAtrzfCd(atrzfCd);
		
		int status = authMapper.createAtrzf(atrzFormVO);
		if(status >0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}
	// 기안서 양식 폼 삭제
	@Override
	public int deleteAtrzfForm(Map<String, List<String>> map) {
		AtrzFormVO atrzFormVO = new AtrzFormVO();
		List<String> atrzfNoList = map.get("atrzfCd");
		int status = 0;
		for(int i=0; i<atrzfNoList.size(); i++) {
			 atrzFormVO.setAtrzfCd(atrzfNoList.get(i));
			 status = authMapper.deleteAtrzfForm(atrzFormVO);
		}
		return status;
	}
	
	
	//관리자 파트
	@Override
	public List<DraftVO> selectAllDraft() {
		return authMapper.selectAllDraft();
	}
	@Override
	public List<DeptVO> selectDeptList() {
 		return authMapper.selectDeptList();
	}
	
	// 연차신청서
	@Override
	public AtrzFormVO selectAf001Form() {
		return authMapper.selectAf001Form();
	}
	@Override
	public int tsDocCnt(String empNo) {
		return authMapper.tsDocCnt(empNo);
 	 
	}
	@Override
	public int progDocCnt(String empNo) {
 		return authMapper.progDocCnt(empNo);
	}
	@Override
	public int retDocCnt(String empNo) {
 		return authMapper.retDocCnt(empNo);
	}
	@Override
	public int comDocCnt(String empNo) {
 		return authMapper.comDocCnt(empNo);
	}
	@Override
	public int waitDocCnt(String empNo) {
 		return authMapper.waitDocCnt(empNo);
	}
	@Override
	public int refDocCnt(String empNo) {
 		return authMapper.refDocCnt(empNo);
	}
	@Override
	public int returnDocCnt(String empNo) {
 		return authMapper.returnDocCnt(empNo);
	}
	@Override
	public int completeCnt(String empNo) {
 		return authMapper.completeCnt(empNo);
	}

}

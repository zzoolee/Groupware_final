package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.AppBMLineVO;
import kr.or.ddit.vo.AppBookMarkVO;
import kr.or.ddit.vo.AtrzFormVO;
import kr.or.ddit.vo.AtrzPathVO;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.DraftRefVO;
import kr.or.ddit.vo.DraftVO;

public interface IAuthService {
	//결재양식 모두 select
	public List<AtrzFormVO> selectAtrzForm();
	public AtrzFormVO selectAtrzContent(String atrzfCd);
	//임시저장
	public ServiceResult draftTempSaveInsert(DraftVO draftVO);
	//결재자(결재선)
	public ServiceResult pathInsert(AtrzPathVO pathVO);
	//참조자
	public ServiceResult refInsert(DraftRefVO refVO);
	
	//임시저장인 문서
	public List<DraftVO> selectTempSaveList(String empNo);
	//기안 > 진행중문서함
	public List<DraftVO> selectProgList(String empNo);
	//기안 >반려문서함
	public List<DraftVO> selectRetList(String empNo);
	//기안 > 완료문서함
	public List<DraftVO> selectComList(String empNo);
	
	//기안함들의(임시, 진행중, 반려, 완료) 디테일 
	public DraftVO draftDetail(DraftVO draftVO);
	
	public List<AtrzPathVO> pathSelect(String drftCd);
	public List<DraftRefVO> refSelect(String drftCd);
	//임시저장 삭제
	public ServiceResult tempSaveDelete(String drftCd);
	//임시저장 ->결재상신
	public ServiceResult approval(DraftVO draftVO);
	//기안서작성 -> 결재상신
	public ServiceResult dfApproval(DraftVO draftVO);
	public ServiceResult tempSaveUpdate(DraftVO draftVO);
	public ServiceResult tsPathInsert(AtrzPathVO pathVO);

	
	//참조자, 결재자 삭제
	public void refDelete(String drftCd);
	public void authPathDelete(String drftCd);

	
	//////////////////////////////////////////////////////////////////////////////////////
	
	//결재함 > 결재대기 문서
	public List<DraftVO> selectWaitList(String empNo);
	//결재함 > 참조문서
	public List<DraftVO> selectRefList(String empNo);
	//결재함 > 완료문서
	public List<DraftVO> selectCompleteList(String empNo);
	//결재함 디테일(결재대기, 참조, 반려, 완료)
	public DraftVO authDetail(DraftVO draftVO);
	
	//결재,전결
	public ServiceResult sign(DraftVO draftVO);
	public ServiceResult updateProgress(DraftVO draftVO);
	public ServiceResult updateStatus(DraftVO draftVO);
	//우선순위가 4번일 때 -> 완료
	public ServiceResult lastOrderComplete(DraftVO draftVO);
	
	//반려했을 때 (반려사유, 내 결재상태 update)  
	public ServiceResult returnMemo(DraftVO draftVO);
	public ServiceResult returnStatus(DraftVO draftVO);

	//반려문서 리스트
	public List<DraftVO> selectReturnList(String empNo);
	//반려 사유(ajax)
	public DraftVO selectMemo(String drftCd);
	public DraftVO selectRetName(DraftVO draftVO);

	//결재선 관리
	public ServiceResult abmInsert(AppBookMarkVO abmVO);
	public ServiceResult bmLineInsert(AppBMLineVO bmLine);
	//결재선 리스트
	public List<AppBookMarkVO> selectAppBookMark(String empNo);
	//결재선 삭제
	public ServiceResult abmDel(String abmCd);


	/////////////////////////////////////////////////////////////////////////////////

	// 기안문서 양식 수정	
	public ServiceResult updateupdateAtrzForm(AtrzFormVO atrzFormVO);
	// 기안 문서 양식폼 생성
	public ServiceResult createAtrzf(AtrzFormVO atrzFormVO);
	// 기안 문서 양식폼 삭제
	public int deleteAtrzfForm(Map<String, List<String>> map);

	
	// 관리자 파트 
	public List<DraftVO> selectAllDraft();
	public List<DeptVO> selectDeptList();
	
	
	// 연차신청서
	public AtrzFormVO selectAf001Form();
	
	//문서 갯수cnt
	public int tsDocCnt(String empNo);
	public int progDocCnt(String empNo);
	public int retDocCnt(String empNo);
	public int comDocCnt(String empNo);
	public int waitDocCnt(String empNo);
	public int refDocCnt(String empNo);
	public int returnDocCnt(String empNo);
	public int completeCnt(String empNo);
	
}

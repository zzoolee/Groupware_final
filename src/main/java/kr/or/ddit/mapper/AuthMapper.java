package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.AppBMLineVO;
import kr.or.ddit.vo.AppBookMarkVO;
import kr.or.ddit.vo.AtrzFormVO;
import kr.or.ddit.vo.AtrzPathVO;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.DraftRefVO;
import kr.or.ddit.vo.DraftVO;

public interface AuthMapper {

	public List<AtrzFormVO> selectAtrzForm();
	public AtrzFormVO selectAtrzContent(String atrzfCd);
	//임시저장
	public int draftTempSaveInsert(DraftVO draftVO);
	public int atrzPathInsert(AtrzPathVO pathVO);
	public void refInsert(String drftCd);
	public int refInsert(DraftRefVO refVO);
	public List<DraftVO> selectTempSaveList(String empNo);
	//임시저장 디테일
	public DraftVO draftDetail(DraftVO draftVO);
	public List<AtrzPathVO> pathSelect(String drftCd);
	public List<DraftRefVO> refSelect(String drftCd);
	// 수정
	public int tempSaveUpdate(DraftVO draftVO);
	public int tsPathInsert(AtrzPathVO pathVO);
	
	//임시저장 삭제 > 결재선, 참조자 같이 삭제
	public void refDelete(String drftCd);
	public void authPathDelete(String drftCd);
	public int tempSaveDelete(String drftCd);
	//결재상신
	public int approval(DraftVO draftVO);
	public int dfApproval(DraftVO draftVO);
	//진행중문서
	public List<DraftVO> selectProgList(String empNo);
	//반려
	public List<DraftVO> selectRetList(String empNo);
	//완료문서
	public List<DraftVO> selectComList(String empNo);
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//디테일
	public DraftVO authDetail(DraftVO draftVO);
	
	//승인(결재,전결)
	public int sign(DraftVO draftVO);
	public int updateProgress(DraftVO draftVO);
	public int updateStatus(DraftVO draftVO);
	public int updateProg(DraftVO draftVO);
	//우선순위 4번이고 결재면 완료
	public int lastOrderComplete(DraftVO draftVO);
	
	//결재함 > 결재대기 문서
	public List<DraftVO> selectWaitList(String empNo);
	//결재함 > 참조문서
	public List<DraftVO> selectRefList(String empNo);
	//결재함 > 완료문서
	public List<DraftVO> selectCompleteList(String empNo);
	//결재함 > 반려문서
	public List<DraftVO> selectReturnList(String empNo);
	
	//반려 (사유/상태)
	public int returnMemo(DraftVO draftVO);
	public int returnStatus(DraftVO draftVO);
	public DraftVO selectMemo(String drftCd);
	public DraftVO selectRetName(DraftVO draftVO);
	
	// 결재선 관리
	public int abmInsert(AppBookMarkVO abmVO);
	public int bmLineInsert(AppBMLineVO bmLine);
	public List<AppBookMarkVO> selectAppBookMark(String empNo);
	// 삭제
	public void bmLineDel(String abmCd);
	public int abmDel(String abmCd);
	
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// 기안서 문서 양식 폼 수정
	public int updateupdateAtrzForm(AtrzFormVO atrzFormVO);
	// 기안서 문서 양식 폼 생성
	public int createAtrzf(AtrzFormVO atrzFormVO);
	// 기안서 문서 양식 폼 생성시 문서 코드 생성을 위한 끝번호 추출
	public List<AtrzFormVO> getatrzfCd();
	// 기안서 문서 양식 폼 삭제
	public int deleteAtrzfForm(AtrzFormVO atrzFormVO);
	
	// 모든 기안서
	public List<DraftVO> selectAllDraft();
	public List<DeptVO> selectDeptList();
	
	// 연차신청서
	public AtrzFormVO selectAf001Form();
	
	//문서 갯수 cnt
	public int tsDocCnt(String empNo);
	public int progDocCnt(String empNo);
	public int retDocCnt(String empNo);
	public int comDocCnt(String empNo);
	public int waitDocCnt(String empNo);
	public int refDocCnt(String empNo);
	public int returnDocCnt(String empNo);
	public int completeCnt(String empNo);
	
}

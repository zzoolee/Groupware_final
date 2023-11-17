package kr.or.ddit.service.impl;

import java.util.Calendar;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.mapper.AdminEmpMapper;
import kr.or.ddit.mapper.ScheMapper;
import kr.or.ddit.service.INotifyService;
import kr.or.ddit.service.IScheService;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.ScheVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ScheServiceImpl implements IScheService {
	
	@Inject
	private ScheMapper mapper;
	@Inject
	private AdminEmpMapper adinMapper;
	// 알림 인서트 클래스 
	@Inject
	private INotifyService notiService;
	
	@Override
	public ServiceResult addSche(ScheVO scheVO) {
		ServiceResult result = null;
		Calendar calendar = Calendar.getInstance();
	    calendar.setTime(scheVO.getScEnddate());
	    calendar.add(Calendar.DAY_OF_MONTH, 1); // 하루를 더함
	    scheVO.setScEnddate(calendar.getTime()); // 변경된 날짜를 저장 -> 캘린더에는 15일 0시가 14일까지 표시
		
		if(scheVO.getScSe().equals("A103") || scheVO.getScSe().equals("A101")) { // 개인일정, 회사일정일 경우 부서 필드는 비운다
			scheVO.setDeptCd("null");
		}
		
		log.info(scheVO.toString());
		
		int status = mapper.insertSche(scheVO);
		if(status != 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public List<ScheVO> showSche(ScheVO scheVO) {
		return mapper.selectSche(scheVO);
	}

	@Override
	public void modifySche(ScheVO scheVO) {
		Calendar calendar = Calendar.getInstance();
	    calendar.setTime(scheVO.getScEnddate());
	    calendar.add(Calendar.DAY_OF_MONTH, 1); // 하루를 더함
	    scheVO.setScEnddate(calendar.getTime()); // 변경된 날짜를 저장 -> 캘린더에는 15일 0시가 14일까지 표시

		mapper.updateSche(scheVO);
	}

	@Override
	public void deleteSche(String scCd) {
		mapper.deleteSche(scCd);
	}

	@Override
	public void modifyScheDate(ScheVO scheVO) {
		Calendar calendar = Calendar.getInstance();
	    calendar.setTime(scheVO.getScEnddate());
	    calendar.add(Calendar.DAY_OF_MONTH, 1); // 하루를 더함
	    scheVO.setScEnddate(calendar.getTime()); // 변경된 날짜를 저장 -> 캘린더에는 15일 0시가 14일까지 표시
		
		mapper.updateScheDate(scheVO);
	}

}

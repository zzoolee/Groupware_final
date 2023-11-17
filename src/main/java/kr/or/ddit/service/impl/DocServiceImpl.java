package kr.or.ddit.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.mapper.DocMapper;
import kr.or.ddit.service.IDocService;
import kr.or.ddit.vo.DocHistoryVO;
import kr.or.ddit.vo.SalaryVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class DocServiceImpl implements IDocService {
	
	@Inject
	DocMapper docMapper;
	
	// 증명서 신청
	@Override
	public ServiceResult appDoc(DocHistoryVO docHistoryVO) {
		ServiceResult result = null;
		int status = docMapper.appDoc(docHistoryVO);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}
	// 증명서 상태값 업데이트
	@Override
	public String updateDocSe(String docCd) {
		String msg = "";
		int status = docMapper.updateDocSe(docCd);
		if(status > 0) {
			msg= "업데이트 완료";
		}else {
			msg= "업데이트 실패";
		}
		return msg;
	}
	// 값 세팅을 위해 emp 정보와 증명서 신청 정보를 가져온다 
	@Override
	public DocHistoryVO selectDoc(String docCd) {
		return docMapper.selectDoc(docCd);
	}
	@Override
	public SalaryVO selectPaystub(SalaryVO salaryVO) {
		return docMapper.selectPaystub(salaryVO);
	}

}

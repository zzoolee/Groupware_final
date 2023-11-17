package kr.or.ddit.service.impl;


import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.controller.admin.SendMessageController;
import kr.or.ddit.mapper.AddMapper;
import kr.or.ddit.mapper.AdminEmpMapper;
import kr.or.ddit.mapper.AttendMapper;
import kr.or.ddit.mapper.DocMapper;
import kr.or.ddit.service.IAdminEmpService;
import kr.or.ddit.vo.AttendVO;
import kr.or.ddit.vo.AyannVO;
import kr.or.ddit.vo.DocHistoryVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.SalaryVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AdminEmpServiceImpl implements IAdminEmpService {
	
	@Inject
	private AdminEmpMapper mapper;
	@Inject
	private DocMapper docMapper;
	@Inject
	private PasswordEncoder pe;
	@Inject 
	private AttendMapper attendMapper;
	@Inject
	private AttendServiceImpl attendService; 
	@Inject
	private AddMapper addMapper;
	//직원 등록 시 문자 전송 컨트롤러
	private SendMessageController sendM = new SendMessageController();
	// poi에서 일자를 받아서 포맷 지정을 위한 용도
	SimpleDateFormat sdf = new SimpleDateFormat("yy/MM/dd");
	
	/**
	 * 사원 등록
	 */
	@Override
	public int insertEmp(EmpVO empVO) {
		int result;
		
		// 직원 접근 권한 설정
		if (empVO.getEmpRank().equals("A201") || empVO.getEmpRank().equals("A202")) {
			empVO.setEmpLevel(1);
		} else if (empVO.getEmpRank().equals("A203") || empVO.getEmpRank().equals("A204")
				|| empVO.getEmpRank().equals("A205")) {
			empVO.setEmpLevel(2);
		} else {
			empVO.setEmpLevel(3);
		}
		
		// 비밀번호 추출하여 암호화
		String empPw = pe.encode(empVO.getEmpRegno().substring(0,6));
		
		log.info("empPw 확인 : "+empPw);
		empVO.setEmpPw(empPw);
		
//		log.info("서비스에서 empNo>>>>>>>>>>>" + empNo);
		// 사번생성 메소드
		empVO = registerEmpNumber(empVO);
		log.info("사번 생성이 완료된 후 empVO 사번 확인 : "+ empVO);
		empVO.setNotiList("일정");
		result = mapper.insertEmp(empVO);
		// 문자전송
		sendM.sendOne(empVO.getEmpNo(), empVO.getEmpHp());
		
		// 근태 시작
		// 기본근태 추가하기.
		AttendVO attendVO = new AttendVO();
		AyannVO ayannVO = new AyannVO();
		ayannVO.setEmpNo(empVO.getEmpNo());
		// empNo값 넣어주기.
		attendVO.setEmpNo(empVO.getEmpNo());
		log.info("어드민 서비스에서 받아 set한 empNo값 : {}", ayannVO.getEmpNo());
		// 이번주가 몇째주인지 넣어주기.
		attendVO.setAtWeek(attendService.selectTodayWeek());
		// 기본 근무상태 추가.
		attendMapper.insertAttendStatus(attendVO);
		// 기본 근무유형 추가.
		attendMapper.insertDefaultAttend(attendVO);
		// 입사월에 따른 기본연차 차등 연차부여.
		attendService.insertNewEmpAyann(ayannVO);
		// 근태 끝.
		
		// 시큐리티 권한 부여
		if(result != 0) {
			mapper.inserAuth(empVO);
			addMapper.createBasicGroup(empVO.getEmpNo()); // 주소록 기본그룹 생성
		}
		return result;
	}
	
	/**
	 * poi를 활용한 다수의 사원 등록 
	 */
	@Override
	public int insertEmpPoi(HttpServletRequest req, MultipartFile multipartFile) throws ParseException {
		////////////////////////////////////////////////////////////
		int status = 0;
		// 몇명의 직원이 등록 됐는지 확인을 위한 cnt
		int cnt=0;
		
		String newFileName = "";
		// 업로드 파일을 저장할 경로
		String uploadPath = req.getServletContext().getRealPath("/resources/profile");
		log.info("uploadExcel() 여기에서 넘어오는 파일 이름 확인 >>>>" + multipartFile.getOriginalFilename());
		File fileupload = new File(uploadPath);
		if (!fileupload.exists()) {
			fileupload.mkdirs();
		}

		try {
			if (multipartFile.getOriginalFilename() != null && !multipartFile.getOriginalFilename().equals("")) {
				newFileName = UUID.randomUUID().toString();
				newFileName += "_" + multipartFile.getOriginalFilename();
				uploadPath += "/" + newFileName;
				// 파일 복사
				multipartFile.transferTo(new File(uploadPath));
				// 복사한 파일 불러오기
			}

			FileInputStream file = new FileInputStream(uploadPath);
			// 엑셀 객체에 해당 파일 보냄
			XSSFWorkbook workbook = new XSSFWorkbook(file);

			// 현재 행 번호
			int rowNo = 0;
			// 현재 열 번호
			int cellIndex = 0;

			XSSFSheet sheet = workbook.getSheetAt(0);

			// row 총 길이
			int rows = sheet.getPhysicalNumberOfRows();
			// 행 반복문(행의 총 길이만큼)
			for (rowNo = 2; rowNo < rows; rowNo++) {
				
				EmpVO empVO = new EmpVO();
				XSSFRow row = sheet.getRow(rowNo);
				if (row != null) {
					// 열의 총 길이
					int cells = row.getPhysicalNumberOfCells();
					// 열의 총 길이만큼 반복
					for (cellIndex = 0; cellIndex < cells; cellIndex++) {
						XSSFCell cell = row.getCell(cellIndex);
						String value = "";

						if (cell == null) {
							continue;
						} else {
							switch (cell.getCellType()) {
							case FORMULA:
								value = cell.getCellFormula(); // 수식반환
								break;
							case NUMERIC:
								if(DateUtil.isCellDateFormatted(cell)) {
									Date date = cell.getDateCellValue();
									value = sdf.format(date);
								}
								value = cell.getNumericCellValue() + ""; // 숫자 반환 더블타입으로 반환
								break;
							case STRING:
								value = cell.getStringCellValue() + ""; // 문자열 반환/빈 셀은 빈 문자열
								break;
							case BLANK:
								value = cell.getBooleanCellValue() + "";
								break;
							case ERROR:
								value = cell.getErrorCellValue() + ""; // 셀값을 오류코드로

							}
						}
						log.info(rowNo + "번 행 : " + cellIndex + "번 열 값은: " + value);
					}
					empVO.setEmpName(row.getCell(0).getStringCellValue());
					empVO.setEmpRank(row.getCell(1).getStringCellValue());
					empVO.setDeptCd(row.getCell(2).getStringCellValue());
					// double 타입으로 데이터가 들어온다 > int로 형변환하여 받아줌
					// 더블을 스트링으로 형변환 처리해하여 empVO.setEmpPw 셋팅
					empVO.setEmpHp(row.getCell(3).getStringCellValue());
					empVO.setEmpRegno(row.getCell(4).getStringCellValue());
					empVO.setEmpGender(row.getCell(5).getStringCellValue());
					empVO.setEmpForeig(row.getCell(6).getStringCellValue());
					Date hire = row.getCell(7).getDateCellValue();
//					Date hireDate = sdf.parse(hire);
					log.info("패턴확인 " + hire);
					empVO.setEmpHire(hire);
					log.info("empVO 값 확인 " + empVO);

					status = insertEmp(empVO);
					if (status != 0) {
						cnt++;
					}else {
						cnt--;
					}
				}
				workbook.close();
			}

		} catch (IOException e) {
			e.printStackTrace();
		}

		
		//////////////////////////////////////////////////////////////
		
		return cnt;
	}
	/**
	 * 사번 생성을 위한 메소드 
	 * @param empVO
	 * @return
	 */
	private EmpVO registerEmpNumber(EmpVO empVO) {
		
		// 사번 생성을 위한 년 월 추출
		DateFormat dateFormat = new SimpleDateFormat("yyMM");
		Date today = new Date();
		String dateRes = dateFormat.format(today);
		
		// 년월 과 부서코드를 조합한 사번 생성
		StringBuffer empNo = new StringBuffer();
		empNo.append(dateRes);
		// 팀 코드에서 부서코드추출
		String empDeptCd = empVO.getDeptCd().substring(0,3);
		log.info("서비스에서 부서코드 추출  3자리만 나와야 함"+ empDeptCd);
		empNo.append(empDeptCd);
		EmpVO newEmpVO = new EmpVO();
		newEmpVO.setDeptCd(empDeptCd);
		
		// 사번에서 날짜 + 부서번호를 제외하고 나머지를 가져온다.
		// 나머지의 숫자가 1-9 범위안에 들어 있는지
		// 나머지의 숫자가 10-99범위안에 들어 있는지
		// 나머지의 숫자가 100범위 상위에 있는지를 체크
		List<EmpVO> empList = mapper.selectEmpNumber(newEmpVO.getDeptCd());
		
		if(empList.size()>0) {
			
			int customNum = empList.get(0).getEmpCustomNo();
			log.info("가져오는 customNum : "+customNum);
			customNum += 1;
			
			if(customNum < 10) {	// 10보다 아래 (1-9)
				empNo.append("00"+customNum);
			}else if(customNum > 9 && customNum < 100) {	// (10-99)
				empNo.append("0"+customNum);
			}else {	// 100이상
				empNo.append(customNum);
			}
			empVO.setEmpNo(empNo.toString());
			
		}else {
			empNo.append("001");
			empVO.setEmpNo(empNo.toString());
		}
		
		
		return empVO;
	}

	/**
	 * 전체 사원 조회
	 */
	@Override
	public List<EmpVO> selectList() {
		return mapper.selectList();
	}
	
	/**
	 * 재직여부 변경
	 */
	@Override
	public ServiceResult empWorkseUpdate(String[] empWorkse) {
		ServiceResult result = null;
		List<EmpVO> empList = null;
		if(empWorkse != null) {
			empList = new ArrayList<EmpVO>();
			for(String empWork : empWorkse) {
				String empNo = empWork.split("@")[0];
				int empStatus = Integer.parseInt(empWork.split("@")[1]);
				EmpVO empVO = new EmpVO();
				empVO.setEmpNo(empNo);
				empVO.setEmpWorkse(empStatus);
				empList.add(empVO);
			}
		}
		
		int status = mapper.empWorkseUpdate(empList);
		
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
			if(status == -1) {	// PL/SQL로 인한 update 처리
				result = ServiceResult.OK;
			}
		}
		
		return result;
	}
	/**
	 * 직원 한명 조회
	 */
	@Override
	public EmpVO selectOne(String empNo) {
		return mapper.selectOne(empNo);
	}
	
	/**
	 * 직원 정보 업데이트(부서, 직급)
	 */
	@Override
	public ServiceResult empUpdate(EmpVO empVO) {
		ServiceResult result = null;
		
		if (empVO.getEmpRank().equals("A201") || empVO.getEmpRank().equals("A202")) {
			empVO.setEmpLevel(1);
		} else if (empVO.getEmpRank().equals("A203") || empVO.getEmpRank().equals("A204")
				|| empVO.getEmpRank().equals("A205")) {
			empVO.setEmpLevel(2);
		} else {
			empVO.setEmpLevel(3);
		}
		int updateSuccess = mapper.empUpdate(empVO);
		if(updateSuccess != 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}
	
	
	// 급여명세서 업로드 
	@Override
	public ServiceResult uploadPayFile(HttpServletRequest req, MultipartFile multipartFile) throws ParseException {
		
		ServiceResult result = null;
		
		///////////////////////////////////////////////////////////
		
		String sal = "sal";
		String newFileName = "";
		// 업로드 파일을 저장할 경로
		String uploadPath = req.getServletContext().getRealPath("/resources/salList");
		File fileupload = new File(uploadPath);
		if (!fileupload.exists()) {
			fileupload.mkdirs();
		}

		try {
			// 파일 복사
			if (multipartFile.getOriginalFilename() != null && !multipartFile.getOriginalFilename().equals("")) {
				newFileName = UUID.randomUUID().toString();
				newFileName += "_" + multipartFile.getOriginalFilename();
				uploadPath += newFileName;
				multipartFile.transferTo(new File(uploadPath));
			}
			FileInputStream file = new FileInputStream(uploadPath);
			// 엑셀 객체에 해당 파일 보냄
			XSSFWorkbook workbook = new XSSFWorkbook(file);
			// 현재 행번호
			int rowNo = 0;
			// 현재 열번호
			int cellIndex = 0;

			XSSFSheet sheet = workbook.getSheetAt(0);

			// row 총길이
			int rows = sheet.getPhysicalNumberOfRows();
			// 행 반복문(행의 총 길이만큼)
			for (rowNo = 3; rowNo < rows; rowNo++) {
				SalaryVO salaryVO = new SalaryVO();
				DocHistoryVO docHistoryVO = new DocHistoryVO();
				XSSFRow row = sheet.getRow(rowNo);
				if (row != null) {
					// 열의 총길이
					int cells = row.getPhysicalNumberOfCells();
					// 열의 총 길이만큼 반복
					for (cellIndex = 0; cellIndex < cells; cellIndex++) {
						XSSFCell cell = row.getCell(cellIndex);
						String value = "";

						if (cell == null) {
							continue;
						} else {

							switch (cell.getCellType()) {
							case FORMULA:
								value = cell.getCellFormula(); // 수식반환
								break;
							case NUMERIC:
								if(DateUtil.isCellDateFormatted(cell)) {
									Date date = cell.getDateCellValue();
									value = sdf.format(date);
								}
								value = cell.getNumericCellValue() + ""; // 숫자 반환
								break;
							case STRING:
								value = cell.getStringCellValue() + ""; // 문자열 반환/빈 셀은 빈 문자열
								break;
							case BLANK:
								value = cell.getBooleanCellValue() + "";
								break;
							case ERROR:
								value = cell.getErrorCellValue() + ""; // 셀값을 오류코드로
							}
						}
						System.out.println(rowNo + "번 행 : " + cellIndex + "번 열 값은 :" + value);
					}
					// 0 . 지급총액	1. 연장수당	2. 휴일수당	3. 공제총액	4. 실지급액	5. 이체날짜	6.사번
					int gramt = (int) row.getCell(0).getNumericCellValue();
					salaryVO.setSalGramt(gramt);
					
					int overTimeAmt = (int) row.getCell(1).getNumericCellValue();
					salaryVO.setSalOvertimeamt(overTimeAmt);
					
					int holidayAmt = (int) row.getCell(2).getNumericCellValue();
					salaryVO.setSalHolidayamt(holidayAmt);
					
					int ddcAMt = (int) row.getCell(3).getNumericCellValue();
					salaryVO.setSalDdcamt(ddcAMt);
					
					int netAmt = (int) row.getCell(4).getNumericCellValue();
					salaryVO.setSalNetamt(netAmt);
					Date actrsfdate = row.getCell(5).getDateCellValue();
					salaryVO.setSalActrsfdate(actrsfdate);
					
					salaryVO.setEmpNo(row.getCell(6).getStringCellValue());
					// 귀속 날짜
					String salBelong = sdf.format(actrsfdate);
					String salBelongmonth = salBelong.substring(0, 5);
					salaryVO.setSalBelongmonth(salBelongmonth);
					log.info("salBelongmonth : "+salBelongmonth);
					String salReplace = salBelongmonth.replace("/", "");
					
					String salCd = sal +row.getCell(6).getStringCellValue() + salReplace;
					
					salaryVO.setSalNo(salCd);
					
					docHistoryVO.setDocName("급여명세서");
					docHistoryVO.setEmpNo(row.getCell(6).getStringCellValue());
					
					log.info("salaryVO 확인 : "+ salaryVO);
					
					int status = mapper.uploadPayFile(salaryVO);
					docMapper.appDoc(docHistoryVO);
					
					if(status != 0) {
						result = ServiceResult.OK;
					}else {
						result = ServiceResult.FAILED;
					}
				}
				workbook.close();
			}
		} catch (IOException e) {
			e.printStackTrace();

		}
		/////////////////////////////////////////////////////////////
		
		return result;
	}

	@Override
	public String selectRecentPaystub(String empNo) {
		DocHistoryVO docHistoryVO = new DocHistoryVO();
		docHistoryVO.setEmpNo(empNo);
		docHistoryVO.setDocName("급여명세서");
		String docCd = docMapper.selectRecentPaystub(docHistoryVO);
		if(docCd == null) {
			docCd= "급여지급내역이 존재하지 않습니다.";
		}
		return docCd;
	}

	
}

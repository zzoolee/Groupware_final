package kr.or.ddit.service.impl;

import java.io.File;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.service.IMypageService;
import kr.or.ddit.vo.EmpVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MypageServiceImpl implements IMypageService {

	@Inject
	private EmpMapper mapper;

	@Inject
	private PasswordEncoder pe;
	
	 
	@Override
	public Map<String, String> checkPw(EmpVO emp) {

		Map<String, String> map = new HashMap<String, String>();
		
		log.info("emp 비번"+emp.getEmpPw());
		
		EmpVO empVO = mapper.selectCheckPw(emp);
		boolean flag = pe.matches(emp.getEmpPw(), empVO.getEmpPw());

		if (flag) {
			map.put("msg", "비밀번호 일치");
		} else {
			map.put("msg", "비밀번호 불일치");
		}
		return map;
	}

	@Override
	public ServiceResult myInfoUpdate(HttpServletRequest req, EmpVO empVO) {

		ServiceResult result = null;
		
		/* 프로필 사진 처리 */
		///////////////////////////////////////////////////////////////////////////
		String uploadPath = req.getServletContext().getRealPath("/resources/profile");

		File file = new File(uploadPath);
		if (!file.exists()) {
			file.mkdirs();
		}

		String profileImg = ""; // 회원 정보에 추가될 프로필 이미지 경로

		try {
			MultipartFile profileImgFile = empVO.getImgFile();

			if (profileImgFile.getOriginalFilename() != null && !profileImgFile.getOriginalFilename().equals("")) {
				String fileName = UUID.randomUUID().toString(); // UUID 파일명 생성
				fileName += "_" + profileImgFile.getOriginalFilename(); // UUID_원본파일명
				uploadPath += "/" + fileName; // 최종 업로드하기윈한 파일 경로
				profileImgFile.transferTo(new File(uploadPath)); // 해당 위치 경로에 파일복사
				profileImg = "/resources/profile/" + fileName; // 파일 복사가 일어난 파일의 위치로 접근하기 위한 URI 설정
			}
			empVO.setEmpPhoto(profileImg);
		} catch (Exception e) {
			e.printStackTrace();
		}
		///////////////////////////////////////////////////////////////////////////////////////////////

		/* 서명 사진 처리 */
		String signUploadPath = req.getServletContext().getRealPath("/resources/sign");

		File signFile = new File(signUploadPath);
		if (!signFile.exists()) {
			signFile.mkdirs();
		}

		String signImg = ""; // 회원정보에 추가될 서명 이미지 정보

		try {

			MultipartFile signImgFile = empVO.getSignImgFile();

			if (signImgFile.getOriginalFilename() != null && !signImgFile.getOriginalFilename().equals("")) {
				String signFileName = UUID.randomUUID().toString();
				signFileName += "_" + signImgFile.getOriginalFilename();
				signUploadPath += "/" + signFileName;
				signImgFile.transferTo(new File(signUploadPath));
				signImg = "/resources/sign/" + signFileName;
			}
			empVO.setEmpSign(signImg);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		log.info("empVO.getEmpPwNew().length() : " + empVO.getEmpPwNew().length());
		// 비밀번호 변경 시 활용
		if(empVO.getEmpPwNew().length()>0) {
			empVO.setEmpPw(pe.encode(empVO.getEmpPwNew()));
		}else {
			empVO.setEmpPw("");
		}
		
		int status = mapper.myInfoUpdate(empVO);
		
		if (status > 0) {
			result = ServiceResult.OK;
			
		} else {
			result = ServiceResult.FAILED;
		}
		
		
		 //세션 등록
		 
		
		return result;

	}

	@Override
	public int updateNotiList(Map<String, List<String>> map) {
		List<String> notiCheckList = map.get("values");
		
		log.info("notiCheckList : "+notiCheckList);
		String notiList ="";
		
		if(notiCheckList.size()  == 1) {
			
			notiList = notiCheckList.get(0);
			
		}else if(notiCheckList.size() > 1) {
			notiList = notiCheckList.get(0);
			
			for(int i=1; i < notiCheckList.size(); i++) {
				
				notiList += ","+notiCheckList.get(i);
				log.info(i+"번째 값 확인  : "+notiCheckList.get(i));
			}
		}
		
		log.info("notiList 최종 결과값 확인 : "+notiList);
		EmpVO empVO = new EmpVO();
		User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		empVO.setEmpNo(user.getUsername());
		empVO.setNotiList(notiList);
		int status = mapper.updateNotiList(empVO);
		
		if(status >0) {
			return 1;
		}else {
			return 0;
		}
	}
}

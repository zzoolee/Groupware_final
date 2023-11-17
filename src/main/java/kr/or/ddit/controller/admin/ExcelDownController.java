package kr.or.ddit.controller.admin;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jxls.common.Context;
import org.jxls.util.JxlsHelper;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.IAdminEmpService;
import kr.or.ddit.vo.EmpVO;

@Controller
public class ExcelDownController {

	@Inject
	private IAdminEmpService service;
	@Inject
	private ResourceLoader resourceLoader;
	
	// 급여명세서 양식 다운로드
	@ResponseBody
	@GetMapping(value = "/excelFormDown.do")
	public ResponseEntity<Void> ExcelFormDown(HttpServletResponse response) throws IOException {
		List<EmpVO> empList = service.selectList();
		
		try{
			
			response.setContentType("ms-vnd/excel");
			response.setHeader("Content-Disposition", "attachment; filename=payForm.xlsx");
			
			InputStream is = new FileInputStream("D:\\99.JSP_SPRING\\02.SPRING2\\workspace_spring2\\Groupware_final\\src\\main\\webapp\\resources\\assets\\gw\\payForm.xlsx");
			OutputStream os = response.getOutputStream();
			Context context = new Context();
			context.putVar("empList", empList);
			
			JxlsHelper.getInstance().processTemplate(is, os, context);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return new ResponseEntity<Void>(HttpStatus.OK);
	}

	@ResponseBody
	@GetMapping(value = "/regiserFormDown.do")
	public ResponseEntity<Void> regiserFormDown(HttpServletResponse response) {
		System.out.println("registerForm 을 타나 ");

		try {
			response.setContentType("ms-vnd/excel");
			response.setHeader("Content-Disposition", "attachment; filename=regiserForm.xlsx");
			
			InputStream is = new FileInputStream("D:\\99.JSP_SPRING\\02.SPRING2\\workspace_spring2\\Groupware_final\\src\\main\\webapp\\resources\\assets\\gw\\regiserForm.xlsx");
			OutputStream os = response.getOutputStream();
			
			Context context = new Context();
			JxlsHelper.getInstance().processTemplate(is, os, context);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return new ResponseEntity<Void>(HttpStatus.OK);
	}

}

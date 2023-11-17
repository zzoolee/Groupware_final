package kr.or.ddit.base;

import java.util.List;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import kr.or.ddit.mapper.AddMapper;
import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.ExtaddVO;

public class Test {
	public static void main(String[] args) {
		ApplicationContext context = new ClassPathXmlApplicationContext(
				new String[] {"/kr/or/ddit/base/context-test.xml"});
		
		EmpMapper empMapper = (EmpMapper)context.getBean("empMapper");
		EmpVO readEmpVO = empMapper.readByUserId("2310A01001");
		
		AddMapper addMapper = (AddMapper)context.getBean("addMapper");
		List<ExtaddVO> selectMyExtMember = addMapper.selectMyExtMember("2310A01001");
		System.out.println(selectMyExtMember.get(0));
	}
}

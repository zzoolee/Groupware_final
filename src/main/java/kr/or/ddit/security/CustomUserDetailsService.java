package kr.or.ddit.security;

import javax.inject.Inject;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.vo.EmpVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomUserDetailsService implements UserDetailsService {

	@Inject
	private EmpMapper empMapper;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		log.info("loadUserByUsername() 실행...!");
		EmpVO emp;
		try {
			emp = empMapper.readByUserId(username);
			log.info("로그인 emp 정보 : " + emp.toString());
			return emp == null ? null : new CustomUser(emp);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}

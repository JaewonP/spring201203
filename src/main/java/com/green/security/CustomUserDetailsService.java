package com.green.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.green.domain.CustomUser;
import com.green.domain.MemberVO;
import com.green.mapper.MemberMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomUserDetailsService implements UserDetailsService{
	
	@Setter(onMethod_=@Autowired)
	private MemberMapper memberMapper;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		
		log.warn("Load user by username : " + username);
		
		
		//userName means userid
		MemberVO vo = memberMapper.read(username);
		
		log.warn("queried by member mapper : " + vo);
		
		return vo == null ? null : new CustomUser(vo);
	}
	
	

}

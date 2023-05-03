package com.boardGameMarket.project;

import java.util.Date;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.boardGameMarket.project.domain.MemberAddressVO;
import com.boardGameMarket.project.domain.MemberVO;
import com.boardGameMarket.project.mapper.MemberMapper;
import com.boardGameMarket.project.service.MemberService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class MemberTests {

	@Setter(onMethod_=@Autowired)
	private MemberService service;
	
	
//	@Test
	public void member_registrationTest() {
		MemberVO mVo = new MemberVO();
		MemberAddressVO mAVo = new MemberAddressVO();
		mAVo.setMember_address1("address1");
		mAVo.setMember_address2("address2");
		mAVo.setMember_address3("address3");
		mVo.setMember_id("gang");
		mVo.setMember_password("1234");
		mVo.setMember_name("이강균");
		mVo.setMember_email("aaaa@aaaa.com");
		mVo.setMember_phone("010-2319-4977");
		mVo.setMember_role(1);
		mVo.setMember_address(mAVo);
		mVo.setMember_regDate(new Date());
		mVo.setMember_updateDate(new Date());
		
		service.member_registration(mVo);
	}
	
//	@Test
	public void member_loginTest() {
		MemberVO mVo = new MemberVO();
		
		mVo.setMember_id("유효성");
		mVo.setMember_password("5555");
		
		service.member_login(mVo);
		System.out.println("결과 값 : " + service.member_login(mVo));
		
	}
}

package com.boardGameMarket.project.service;

import com.boardGameMarket.project.domain.MemberAddressVO;
import com.boardGameMarket.project.domain.MemberVO;

public interface MemberService {
	
	public void member_registration(MemberVO mVo);
	
	public int idCheck(String member_id);
	
	public MemberVO member_login(MemberVO mVo);
	
	
	
}

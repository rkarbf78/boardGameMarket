package com.boardGameMarket.project.service;

import java.util.List;

import com.boardGameMarket.project.domain.Criteria;
import com.boardGameMarket.project.domain.MemberAddressVO;
import com.boardGameMarket.project.domain.MemberVO;

public interface MemberService {
	
	public void member_registration(MemberVO mVo);
	
	public int idCheck(String member_id);
	
	public MemberVO member_login(MemberVO mVo);
	
	public List<MemberVO> getMemberList(Criteria cri);
	
	public int memberGetTotal(Criteria cri);
	
	public MemberAddressVO getMemberAddress(String member_id);
	
	public MemberVO getMember(String member_id);
	
	public int member_remove(String member_id);
	
}

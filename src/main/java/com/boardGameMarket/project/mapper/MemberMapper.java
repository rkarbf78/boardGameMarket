package com.boardGameMarket.project.mapper;

import java.util.List;

import com.boardGameMarket.project.domain.Criteria;
import com.boardGameMarket.project.domain.MemberAddressVO;
import com.boardGameMarket.project.domain.MemberVO;

public interface MemberMapper {

	public void member_registration(MemberVO mVo);
	
	public void member_address_registration(MemberAddressVO mAVO);
	
	public MemberVO member_login(MemberVO mVo);
	
	public int idCheck(String member_id);
	
	public List<MemberVO> getMemberList(Criteria cri);
	
	public int memberGetTotal(Criteria cri);
	
	public MemberAddressVO getMemberAddress(String member_id);
	
}

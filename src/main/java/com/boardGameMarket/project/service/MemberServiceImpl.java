package com.boardGameMarket.project.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.boardGameMarket.project.domain.Criteria;
import com.boardGameMarket.project.domain.MemberAddressVO;
import com.boardGameMarket.project.domain.MemberVO;
import com.boardGameMarket.project.mapper.MemberMapper;

import lombok.Setter;

@Service
public class MemberServiceImpl implements MemberService {
	
	@Setter(onMethod_=@Autowired)
	private MemberMapper mapper;
	
	@Override
	public void member_registration(MemberVO mVo) {
		mapper.member_registration(mVo);
		MemberAddressVO address = mVo.getMember_address();
		address.setMember_id(mVo.getMember_id());
		mapper.member_address_registration(address);
	}

	@Override
	public int idCheck(String member_id) {
		return mapper.idCheck(member_id);
	}

	@Override
	public MemberVO member_login(MemberVO mVo) {
		return mapper.member_login(mVo);
	}

	@Override
	public List<MemberVO> getMemberList(Criteria cri) {
		List<MemberVO> memberList = mapper.getMemberList(cri);
		return memberList;
	}

	@Override
	public int memberGetTotal(Criteria cri) {
		return mapper.memberGetTotal(cri);
	}

	@Override
	public MemberAddressVO getMemberAddress(String member_id) {
		return mapper.getMemberAddress(member_id);
	}

	@Override
	public MemberVO getMember(String member_id) {
		return mapper.getMember(member_id);
	}
	
	@Transactional
	@Override
	public int member_remove(String member_id) {
		mapper.member_address_remove(member_id);
		int result = mapper.member_remove(member_id);
		return result;
	}
	
	
}

package com.boardGameMarket.project.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

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
	
	public MemberVO getMember(String member_id);
	
	public int member_remove(String member_id);
	
	public void member_address_remove(String member_id);
	
	public void member_modify(MemberVO mVo);
	
	public void member_address_modify(MemberVO mVo);
	
	
	//보통 하나만 전달하거나 같은 데이터타입의 변수를 인자로 넘긴적이없어서
	//몰랐는데 @Param 안붙이면 마이바티스에서 구분 못함
	//매개변수를 여러개 줄때는 @Param을 이용하자!!!
	public String member_idSearch(@Param("member_name") String member_name ,@Param("member_phone") String member_phone);
	
	public int member_pwSearch(@Param("member_id") String member_id ,@Param("member_email") String member_email);
	
	//임시비밀번호로 변경하기(패스워드찾기 통하여)
	public void member_update_tempPw(@Param("member_id") String member_id ,@Param("member_email") String member_email ,@Param("member_password") String member_password);
	
	
	
	
}

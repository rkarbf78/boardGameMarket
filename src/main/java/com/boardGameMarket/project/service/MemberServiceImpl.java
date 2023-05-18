package com.boardGameMarket.project.service;

import java.util.List;

import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
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
	@Autowired
	private JavaMailSender mailSender;
	
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

	@Override
	public String member_idSearch(String member_name, String member_phone) {
		return mapper.member_idSearch(member_name, member_phone);
	
	}

	@Override
	public String member_pwSearch(String member_id, String member_email) {
		
		
		int searchResult = mapper.member_pwSearch(member_id, member_email);
		
		if(searchResult == 1) {
			
			//난수 생성
			
			int randomIdx = 0;
			String tempPassword = "";
			char[] charSet = new char[] {
					'0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
					'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
					'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
			};
			
			
			for (int i=0; i<10; i++) {
				randomIdx = (int)(charSet.length * Math.random());
				tempPassword += charSet[randomIdx];
			}
			
			String setFrom = "rkarbf78@naver.com";
		    String toMail = member_email;
		    String title = "임시 비밀번호입니다.";
		    String content = 
		                "임시비밀번호 전송 메일입니다." +
		                "<br><br>" + 
		                "임시 비밀번호는 " + tempPassword + "입니다." + 
		                "<br>" + 
		                "해당 비밀번호로 로그인해주세요.";
			  try {
		            
		            MimeMessage message = mailSender.createMimeMessage();
		            MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");
		            helper.setFrom(setFrom);
		            helper.setTo(toMail);
		            helper.setSubject(title);
		            helper.setText(content,true);
		            mailSender.send(message);
		            
		        }catch(Exception e) {
		            e.printStackTrace();
		        }
			  return "1";
		}else {
			return "0";
		}	
	}
}

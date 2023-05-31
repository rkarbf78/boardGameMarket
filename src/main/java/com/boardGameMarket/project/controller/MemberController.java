package com.boardGameMarket.project.controller;

import java.util.List;
import java.util.Random;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.boardGameMarket.project.domain.CategoryVO;
import com.boardGameMarket.project.domain.MemberAddressVO;
import com.boardGameMarket.project.domain.MemberVO;
import com.boardGameMarket.project.service.MemberService;
import com.boardGameMarket.project.service.ProductService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/pages/*")
@Log4j
public class MemberController {

	@Setter(onMethod_=@Autowired)
	private MemberService m_service;
	@Setter(onMethod_=@Autowired)
	private ProductService p_service;
	
	@Autowired
	private JavaMailSender mailSender;
	
	@GetMapping("/loginPage")
	public String loginPage(Model model) {
		List<CategoryVO> categoryList = p_service.categoryList();
		model.addAttribute("categoryList" , categoryList);
		return "/pages/loginPage";
	}

	@GetMapping("/joinPage")
	public String joinPage(Model model) {
		List<CategoryVO> categoryList = p_service.categoryList();
		model.addAttribute("categoryList" , categoryList);
		return "/pages/joinPage";
	}
		
	@PostMapping("/join")
	public String member_join(MemberVO mVo) {
		m_service.member_registration(mVo);
		return "redirect:/pages/mainPage";
	}
	
	@GetMapping("/memberModifyPage/{member_id}")
	public String modifyPage(@PathVariable("member_id")String member_id,Model model) {
		MemberVO member = m_service.getMember(member_id);
		MemberAddressVO address = m_service.getMemberAddress(member_id);
		member.setMember_address(address);
		model.addAttribute("member",member);
		List<CategoryVO> categoryList = p_service.categoryList();
		model.addAttribute("categoryList" , categoryList);
		return "/pages/memberModifyPage";
	}
	
	@PostMapping("/memberModify")
	public String member_modify(MemberVO member) {
		m_service.member_modify(member);
		return "redirect:/pages/mainPage";
	}
	
	
	@ResponseBody
	@PostMapping("/member_id_check")
	public String member_id_check(String member_id) {

		int result = m_service.idCheck(member_id);
		
		if(result != 0) {
			return "fail";
		} else {
			return "success";
		}
	}
	
	
	//메일 인증번호 송신
	@GetMapping("/mailCheck")
	@ResponseBody
	public String mailCheckGET(String email) {
		//난수 생성
		Random random = new Random();
		int checkNum = random.nextInt(888888) + 111111;

		String setFrom = "rkarbf78@naver.com";
	    String toMail = email;
	    String title = "인증 번호 이메일 입니다.";
	    String content = 
	                "인증번호 확인을 위한 메일입니다." +
	                "<br><br>" + 
	                "인증 번호는 " + checkNum + "입니다." + 
	                "<br>" + 
	                "해당 인증번호를 인증번호 확인란에 기입하여 주세요.";
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
	    String num = Integer.toString(checkNum);
	    return num;			
	}
	
	//로그인
	@PostMapping("/login")
	public String loginPOST(HttpServletRequest request, MemberVO mVo, RedirectAttributes rttr) {
		
		HttpSession session = request.getSession();
		MemberVO loginMvo = m_service.member_login(mVo);
		
		//로그인 패스워드 불일치시
		if(loginMvo == null) {
			int loginResult = 0;
			rttr.addFlashAttribute("loginResult", loginResult);
			return "redirect:/pages/loginPage";
		}
		
		//로그인 패스워드 일치시
		session.setAttribute("member", loginMvo);
		return "redirect:/pages/mainPage";
	}
	
	//비동기 로그아웃
	@PostMapping("/logout")
	@ResponseBody
	public void logoutPost(HttpServletRequest request) {
		log.info("비동기 로그아웃 실행");
		HttpSession session = request.getSession();
		session.invalidate();
	}
	
	@GetMapping("/idSearch")
	@ResponseBody
	public String memberIdSearch(MemberVO member) {
		String member_name = member.getMember_name();
		String member_phone = member.getMember_phone();
		return m_service.member_idSearch(member_name, member_phone);
	}
	
	@GetMapping("/pwSearch")
	@ResponseBody
	public String memberPwSearch(MemberVO member) {
		String member_id = member.getMember_id();
		String member_email = member.getMember_email();
		return m_service.member_pwSearch(member_id, member_email);
				
	}
}

package com.boardGameMarket.project.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.boardGameMarket.project.domain.CategoryVO;
import com.boardGameMarket.project.domain.MemberAddressVO;
import com.boardGameMarket.project.domain.MemberVO;
import com.boardGameMarket.project.domain.OrderDTO;
import com.boardGameMarket.project.domain.OrderPageDTO;
import com.boardGameMarket.project.service.MemberService;
import com.boardGameMarket.project.service.OrderService;
import com.boardGameMarket.project.service.ProductService;

import lombok.Setter;

@Controller
@RequestMapping("/pages/*")
public class OrderController {
	
	@Setter(onMethod_=@Autowired)
	private OrderService o_service;
	@Setter(onMethod_=@Autowired)
	private MemberService m_service;
	@Setter(onMethod_=@Autowired)
	private ProductService p_service;
	
	@GetMapping("/orderPage/{member_id}")
	public String orderPage(@PathVariable("member_id") String member_id,OrderPageDTO odd,Model model) {
		
		model.addAttribute("orderList" , o_service.get_products_info(odd.getOrders()));
		
		MemberVO mVo =  m_service.getMember(member_id);
		MemberAddressVO mAvo = m_service.getMemberAddress(member_id);
		mVo.setMember_address(mAvo);
		
		model.addAttribute("member_info" , mVo);
		
		List<CategoryVO> categoryList = p_service.categoryList();
		
		model.addAttribute("categoryList" , categoryList);
		
		return "/pages/orderPage";
	}
	
	@PostMapping("/order")
	public String order(OrderDTO odd,HttpServletRequest request) {
				
		o_service.order(odd);
		
		HttpSession session = request.getSession();
		
		MemberVO member = (MemberVO)session.getAttribute("member");
		
		return "redirect:/pages/orderListPage/" + member.getMember_id();
	}
	
	@GetMapping("/orderListPage/{member_id}")
	public String orderResultPage(@PathVariable("member_id") String member_id,Model model) {
		
		List<OrderDTO> orderList = o_service.getOrderList(member_id);
		
		System.out.println(orderList);
		
		model.addAttribute("orderList" , orderList);
		
		List<CategoryVO> categoryList = p_service.categoryList();
		
		model.addAttribute("categoryList" , categoryList);
		
		return "/pages/orderListPage";
	}
	
	
	
}

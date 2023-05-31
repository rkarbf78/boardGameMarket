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
import org.springframework.web.bind.annotation.ResponseBody;

import com.boardGameMarket.project.domain.CartDTO;
import com.boardGameMarket.project.domain.CategoryVO;
import com.boardGameMarket.project.domain.MemberVO;
import com.boardGameMarket.project.service.CartService;
import com.boardGameMarket.project.service.ProductService;

import lombok.Setter;

@Controller
@RequestMapping("/pages/*")
public class CartController {
	
	@Setter(onMethod_=@Autowired)
	private CartService c_service;
	@Setter(onMethod_=@Autowired)
	private ProductService p_service;
	
	
	//장바구니 추가 비동기
	@ResponseBody
	@PostMapping("/cart/add")
	public String addCart(CartDTO cart, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		MemberVO mVo = (MemberVO)session.getAttribute("member");
		
		if(mVo == null) {
			return "5";
		}
		
		int result = c_service.addCart(cart);
		
		return result + "";
	}
	
	//장바구니 목록 가져오기
	@GetMapping("/cartPage/{member_id}")
	public String cartPage(@PathVariable("member_id") String member_id, Model model) {
		
		model.addAttribute("cartInfo",c_service.getCartList(member_id));
		
		List<CategoryVO> categoryList = p_service.categoryList();
		
		model.addAttribute("categoryList" , categoryList);
		
		return "/pages/cartPage";
	
	}
	
	//장바구니 수량수정
	@PostMapping("/cart/modify")
	public String cartModify(CartDTO cart) {
		c_service.modifyCount(cart);
		
		return "redirect:/pages/cartPage/"+cart.getMember_id();
	}
	
	//장바구니 상품삭제
	@PostMapping("/cart/delete")
	public String cartDelete(CartDTO cart) {
		
		c_service.deleteCart(cart.getCart_id());
		
		return "redirect:/pages/cartPage/" + cart.getMember_id();
		
	}	
}
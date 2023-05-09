package com.boardGameMarket.project.service;

import java.util.List;

import com.boardGameMarket.project.domain.CartDTO;

public interface CartService {

	//카트 추가
	public int addCart(CartDTO cart);
	
	//카트 목록
	public List<CartDTO> getCartList(String member_id);
	
	//카트 수량 수정
	public int modifyCount(CartDTO cart);
	
	//카트 삭제
	public int deleteCart(int cart_id);
	
}

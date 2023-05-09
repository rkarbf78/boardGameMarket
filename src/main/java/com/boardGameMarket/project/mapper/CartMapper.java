package com.boardGameMarket.project.mapper;

import java.util.List;

import com.boardGameMarket.project.domain.CartDTO;

public interface CartMapper {
	
	//카트 추가
	public int addCart(CartDTO cart) throws Exception;
	
	//카트 삭제
	public int deleteCart(int cart_id);
	
	//카트 수량 수정
	public int modifyCount(CartDTO cart);
	
	//카트 목록
	public List<CartDTO> getCartList(String member_id);
	
	//카트 확인
	public CartDTO checkCart(CartDTO cart);
	
	//카트 주문 제거하기
	public int delete_order_cart(CartDTO cart);
}

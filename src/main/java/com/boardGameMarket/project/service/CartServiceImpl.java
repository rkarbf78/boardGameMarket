package com.boardGameMarket.project.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boardGameMarket.project.domain.AttachFileDTO;
import com.boardGameMarket.project.domain.CartDTO;
import com.boardGameMarket.project.mapper.CartMapper;
import com.boardGameMarket.project.mapper.ProductMapper;

import lombok.Setter;

@Service
public class CartServiceImpl implements CartService {

	
	@Setter(onMethod_=@Autowired)
	private CartMapper c_mapper;
	@Setter(onMethod_=@Autowired)
	private ProductMapper p_mapper;
	
	@Override
	public int addCart(CartDTO cart) {
		
		CartDTO checkCart = c_mapper.checkCart(cart);
		
		if(checkCart != null) {
			return 2;
		}
		
		try {
			return c_mapper.addCart(cart);
		} catch (Exception e) {
			return 0;
		}
	}

	@Override
	public List<CartDTO> getCartList(String member_id) {
		
		List<CartDTO> cartList = c_mapper.getCartList(member_id);
		
		for(CartDTO cart : cartList) {
			AttachFileDTO image = p_mapper.getAttachFile(cart.getProduct_id());
			cart.setImage(image);
			cart.initPriceTotal();
		}
		
		return cartList;
	}

	@Override
	public int modifyCount(CartDTO cart) {
		
		return c_mapper.modifyCount(cart); 
	}

	@Override
	public int deleteCart(int cart_id) {
		
		return c_mapper.deleteCart(cart_id);
	}

}

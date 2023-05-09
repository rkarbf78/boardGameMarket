package com.boardGameMarket.project.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.boardGameMarket.project.domain.CartDTO;
import com.boardGameMarket.project.domain.MemberVO;
import com.boardGameMarket.project.domain.OrderDTO;
import com.boardGameMarket.project.domain.OrderElementDTO;
import com.boardGameMarket.project.domain.OrderPageElementDTO;
import com.boardGameMarket.project.domain.ProductVO;
import com.boardGameMarket.project.mapper.CartMapper;
import com.boardGameMarket.project.mapper.MemberMapper;
import com.boardGameMarket.project.mapper.OrderMapper;
import com.boardGameMarket.project.mapper.ProductMapper;

import lombok.Setter;

@Service
public class OrderServiceImpl implements OrderService{

	@Setter(onMethod_=@Autowired)
	private OrderMapper o_mapper;
	@Setter(onMethod_=@Autowired)
	private MemberMapper m_mapper;
	@Setter(onMethod_=@Autowired)
	private CartMapper c_mapper;
	@Setter(onMethod_=@Autowired)
	private ProductMapper p_mapper;

	@Override
	public List<OrderPageElementDTO> get_products_info(List<OrderPageElementDTO> orders) {
		
		List<OrderPageElementDTO> result = new ArrayList<>();
		
		for(OrderPageElementDTO oed : orders) {
			
			OrderPageElementDTO product_info = o_mapper.get_product_info(oed.getProduct_id());
			
			product_info.setProduct_count(oed.getProduct_count());
			
			product_info.initPriceTotal();
			
			result.add(product_info);
		}
		
		return result;
	}

	
	@Override
	@Transactional
	public void order(OrderDTO odd) {
		/* 회원정보 가져오기 */
		MemberVO member = m_mapper.getMember(odd.getMember_id());
		
		/* 주문 정보 */
		List<OrderElementDTO> odedList = new ArrayList<OrderElementDTO>();
		
		for(OrderElementDTO odeds : odd.getOrders()) {
			// 기본 정보 세팅
			odeds.initPriceTotal();
			//List에 객체 추가
			odedList.add(odeds);
		
		}
		// OrderDTO 세팅
		odd.setOrders(odedList);
		odd.get_order_price_info();
		
		/* DB주문, 주문상품, 배송정보 넣기 */
		Date date = new Date();
		SimpleDateFormat format = new SimpleDateFormat("_yyyyMMddmm");
		
		/* 오더아이디는 멤버아이디 + 날짜 */
		String order_id = member.getMember_id() + format.format(date);
		odd.setOrder_id(order_id);
		
		/* element DB에 넣기 (order 를 먼저 넣어야 id 참조키로 사용가능함)*/
		o_mapper.order_registration(odd);
		
		for(OrderElementDTO odeds : odd.getOrders()) {
			
			//order_id 세팅
			odeds.setOrder_id(order_id);
			
			//orderElement DB에 넣기
			o_mapper.order_element_registration(odeds);
			
			//변동 재고 값 구해서 DB 적용 디비
			ProductVO product = p_mapper.getProduct(odeds.getProduct_id());
			product.setProduct_stock(product.getProduct_stock() - odeds.getProduct_count());
			o_mapper.deduction_stock(product);
			
			//장바구니에서 제거하기
			CartDTO cart = new CartDTO();
			cart.setMember_id(odd.getMember_id());
			cart.setProduct_id(odeds.getProduct_id());
			c_mapper.delete_order_cart(cart);
			
		}
	}
	
}
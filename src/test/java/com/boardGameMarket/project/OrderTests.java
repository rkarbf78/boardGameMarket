package com.boardGameMarket.project;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.boardGameMarket.project.domain.OrderDTO;
import com.boardGameMarket.project.domain.OrderElementDTO;
import com.boardGameMarket.project.domain.ProductVO;
import com.boardGameMarket.project.mapper.OrderMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class OrderTests {
	
	@Setter(onMethod_=@Autowired)
	private OrderMapper mapper;
	
//	@Test
	public void get_order_info_test() {
		
		System.out.println(mapper.get_order_info(30));
		
	}
	
//	@Test
	public void order_registration_test() {
		OrderDTO odd = new OrderDTO();
		List<OrderElementDTO> odds = new ArrayList<>();
			
		
		 for(int i=0; i<5; i++) { 
			  OrderElementDTO order1 = new OrderElementDTO();
			  order1.setOrder_id("그래프테스트오더"+i); 
			  order1.setProduct_id(106);
			  order1.setProduct_name("모노폴리");
			  order1.setProduct_count((int)(Math.random()*5)+1); 
			  order1.setProduct_price(3000);
			  order1.initPriceTotal(); 
			  odds.add(order1);
			 }
		 
		for(int i=0; i<5; i++) {
			odd.setOrders(odds);
			odd.setOrder_id("그래프테스트오더"+i);
			odd.setReceiver("그래프맨");
			odd.setMember_id("master");
			odd.setMember_address1("add1");
			odd.setMember_address2("add2");
			odd.setMember_address3("add3");
			odd.setOrder_state("배송준비");
			odd.setDelivery_price(3000);
			odd.get_order_price_info();
			  
			mapper.order_registration(odd);

		}
			 			 
		
	}
	
	@Test
	public void order_element_registration_test() {
		 
	
			OrderElementDTO order1 = new OrderElementDTO();
			  order1.setOrder_id("테스트오더0530"); 
			  order1.setProduct_id(43);
			  order1.setProduct_name("다빈치 코드");
			  order1.setProduct_count((int)(Math.random()*10)+1); 
			  order1.setProduct_price(1000);
			  order1.initPriceTotal(); 
			  mapper.order_element_registration(order1);
		
			  
	}
	
//	@Test
	public void deductStockTest() {
		ProductVO product = new ProductVO();
		
		product.setProduct_id(12);
		product.setProduct_stock(20);
		
		mapper.deduction_stock(product);
	}
	
//	@Test
	public void getListTest() {
		List<OrderDTO> orderList = mapper.getOrderList("user");
		orderList.forEach(i -> {
			log.info("로그로 찍어보자" + i.getOrders());
		});
	}
}

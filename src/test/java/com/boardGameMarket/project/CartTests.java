package com.boardGameMarket.project;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.boardGameMarket.project.domain.CartDTO;
import com.boardGameMarket.project.service.CartService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class CartTests {
	
	@Setter(onMethod_=@Autowired)
	private CartService service;
	
	//등록 테스트
		@Test
		public void addCartTest() {
			//given
				String member_id = "rororororo";
				int product_id = 22;
				int product_count = 5;
				
				CartDTO dto = new CartDTO(); 
				dto.setMember_id(member_id);
				dto.setProduct_id(product_id);
				dto.setProduct_count(product_count);
			
			//when
				int result = service.addCart(dto);
			
			//then
				System.out.println("** result : " + result);
			
			
		}
}

package com.boardGameMarket.project;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.boardGameMarket.project.domain.CartDTO;
import com.boardGameMarket.project.domain.ReplyDTO;
import com.boardGameMarket.project.mapper.ReplyMapper;
import com.boardGameMarket.project.service.CartService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyTests {
	
	@Setter(onMethod_=@Autowired)
	private ReplyMapper mapper;
	
	@Test
	public void reply_registration_test() {
		
		for(int i=0; i<62; i++) {
			
			for(int j=0; j<(int)(Math.random()*30); j++) {
				ReplyDTO reply = new ReplyDTO();
				
				reply.setProduct_id(i+1);
				reply.setMember_id("TEST_USER");
				reply.setContent("TEST REPLY");
				reply.setRating((int)(Math.random()*5+1));
				
				mapper.reply_registration(reply);
			}
		}
	}
}

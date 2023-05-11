package com.boardGameMarket.project.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.boardGameMarket.project.domain.Criteria;
import com.boardGameMarket.project.domain.ReplyDTO;
import com.boardGameMarket.project.domain.ReplyPageDTO;
import com.boardGameMarket.project.service.ReplyService;

import lombok.Setter;

@RestController
@RequestMapping("/pages/reply/*")
public class ReplyController {
	
	@Setter(onMethod_=@Autowired)
	private ReplyService service;
	
	
	/* 댓글 등록 */
	@Transactional
	@PostMapping(value="/register",produces="application/text;charset=utf8") //ajax로 리턴시 한글 깨짐현상 해결위해 프로듀시스 설정
	public String reply_registration(ReplyDTO reply) {
		System.out.println(reply);
		
		String check = service.reply_check(reply);
		
		if(check == "0") {
			service.reply_registration(reply);
			return "댓글 등록을 완료했습니다.";
		}else {
			return "이미 등록된 댓글이 존재합니다.";
		}		
	}
	
	@GetMapping(value="/list",produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	public ReplyPageDTO replyList(Criteria cri) {
		return service.replyList(cri);
	}
}

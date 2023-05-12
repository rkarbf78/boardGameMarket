package com.boardGameMarket.project.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boardGameMarket.project.domain.Criteria;
import com.boardGameMarket.project.domain.PageDTO;
import com.boardGameMarket.project.domain.ReplyDTO;
import com.boardGameMarket.project.domain.ReplyPageDTO;
import com.boardGameMarket.project.mapper.ReplyMapper;

import lombok.Setter;

@Service
public class ReplyServiceImpl implements ReplyService {

	@Setter(onMethod_=@Autowired)
	private ReplyMapper r_mapper;
	
	@Override
	public int reply_registration(ReplyDTO reply) {
	
		int result = r_mapper.reply_registration(reply);
		
		return result;
		
	}

	@Override
	public String reply_check(ReplyDTO reply) {
		
		Integer result = r_mapper.reply_check(reply);
		
		if(result == null) {
			return "0";
		} else {
			return "1";
		}
	}

	@Override
	public ReplyPageDTO replyList(Criteria cri) {

		ReplyPageDTO rpDto = new ReplyPageDTO();
		
		rpDto.setReply_list(r_mapper.getReplyList(cri));
		
		rpDto.setPage_info(new PageDTO(cri, r_mapper.getReplyTotal(cri.getProduct_id())));
		
		return rpDto;
	}

	@Override
	public int reply_modify(ReplyDTO dto) {
	
		int result = r_mapper.reply_modify(dto);
		
		return result;
	}

	@Override
	public ReplyDTO getReply(int reply_id) {
		
		return r_mapper.getReply(reply_id);
	}

	@Override
	public int reply_remove(int reply_id) {
	
		int result = r_mapper.reply_remove(reply_id);
		
		return result;
		
	}

}

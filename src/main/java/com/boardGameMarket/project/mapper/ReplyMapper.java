package com.boardGameMarket.project.mapper;

import java.util.List;

import com.boardGameMarket.project.domain.Criteria;
import com.boardGameMarket.project.domain.ReplyDTO;

public interface ReplyMapper {

	/* 댓글 등록 */
	public int reply_registration(ReplyDTO reply);
	
	/* 중복 댓글 존재 여부 */
	public Integer reply_check(ReplyDTO reply);
	
	/* 댓글 리스트 가져오기 */
	public List<ReplyDTO> getReplyList(Criteria cri);
	
	/* 댓글 총 갯수(페이징) */
	public int getReplyTotal(int product_id);
}

package com.boardGameMarket.project.service;

import com.boardGameMarket.project.domain.Criteria;
import com.boardGameMarket.project.domain.ReplyDTO;
import com.boardGameMarket.project.domain.ReplyPageDTO;

public interface ReplyService {

	/* 댓글 등록 */
	public int reply_registration(ReplyDTO reply);
	
	/* 중복 댓글 존재 여부 */
	public String reply_check(ReplyDTO reply);
	
	/* 댓글 페이징 */
	public ReplyPageDTO replyList(Criteria cri);
	
}

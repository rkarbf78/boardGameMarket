package com.boardGameMarket.project.mapper;

import java.util.List;

import com.boardGameMarket.project.domain.Criteria;
import com.boardGameMarket.project.domain.ReplyDTO;

public interface ReplyMapper {

	/* 댓글 등록 */
	public int reply_registration(ReplyDTO reply);
	
	/* 중복 댓글 존재 여부 */
	public Integer reply_check(ReplyDTO reply);
	
	/* 댓글 리스트 레이팅 가져오기(전체) 레이팅 평균값을 위함 */
	public List<Double> getReplyAllRating(int product_id);
	
	/* 댓글 리스트 가져오기(페이징) */
	public List<ReplyDTO> getReplyList(Criteria cri);
	
	/* 댓글 총 갯수(페이징) */
	public int getReplyTotal(int product_id);
	
	/* 댓글 수정 */
	public int reply_modify(ReplyDTO dto);
	
	/* 작성자 댓글 가져오기 */
	public ReplyDTO getReply(int reply_id);
	
	/* 댓글 삭제 */
	public int reply_remove(int reply_id);
}

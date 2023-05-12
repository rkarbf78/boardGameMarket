package com.boardGameMarket.project.domain;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class ReplyDTO {

	private int reply_id;
	
	private int product_id;
	
	private String member_id;
	
	//데이터 형식 바꾸기! 뷰에서 이 형식에 맞춘대로 데이터나옴
	@JsonFormat(shape=JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date regDate;

	@JsonFormat(shape=JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date updateDate;
		
	private String content;
	
	private double rating;
	
}

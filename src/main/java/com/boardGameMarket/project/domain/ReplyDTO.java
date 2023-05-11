package com.boardGameMarket.project.domain;

import java.util.Date;

import lombok.Data;

@Data
public class ReplyDTO {

	private int reply_id;
	
	private int product_id;
	
	private String member_id;
	
	private Date regDate;
	
	private String content;
	
	private double rating;
	
}

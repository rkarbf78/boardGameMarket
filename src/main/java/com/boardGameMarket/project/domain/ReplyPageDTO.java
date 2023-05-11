package com.boardGameMarket.project.domain;

import java.util.List;

import lombok.Data;

@Data
public class ReplyPageDTO {

	List<ReplyDTO> reply_list;
	
	PageDTO page_info;
	
}

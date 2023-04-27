package com.boardGameMarket.project.domain;

import lombok.Data;

@Data
public class AttachFileDTO {
	private String fileName;
	private String uploadPath;
	private String uuid;
	private int product_id;
}

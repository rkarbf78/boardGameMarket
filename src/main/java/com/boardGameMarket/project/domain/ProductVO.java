package com.boardGameMarket.project.domain;

import java.util.Date;

import lombok.Data;

@Data
public class ProductVO {

	private int product_id;
	private String product_name;
	private int product_price;
	private String product_info;
	private int product_stock;
	private int product_sell;
	private int product_category_code;
	private Date product_regDate;
	private AttachFileDTO image;
	
}

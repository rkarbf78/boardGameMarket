package com.boardGameMarket.project.domain;

import lombok.Data;

@Data
public class CartDTO {
	
	private int cart_id;
	
	private String member_id;
	
	private int product_id;
	
	private int product_count;
	
	private String product_name;
	
	private int product_price;
	
	private AttachFileDTO image;
	
	private int product_price_total;
	
	public void initPriceTotal() {
		this.product_price_total = this.product_count * this.product_price;
	}

}

package com.boardGameMarket.project.domain;

import lombok.Data;

@Data
public class OrderElementDTO {

	private String order_id;
	
	private int order_element_id;
	
	private int product_id;
	
	private String product_name;
	
	private int product_count;
	
	private int product_price;
	
	private int product_price_total;
	
	public void initPriceTotal() {
		this.product_price_total = this.product_price * this.product_count;
	}
	
}

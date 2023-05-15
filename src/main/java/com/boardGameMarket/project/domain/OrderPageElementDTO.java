package com.boardGameMarket.project.domain;

import lombok.Data;

@Data
public class OrderPageElementDTO {

	/* view 로 부터 전달받을 데이터 */
	private int product_id;
	
	private int product_count;
	
	private String product_name;
	
	/* DB로부터 전달받을 데이터 */
	
	private int product_price;
	
	/* 생성 할 데이터 */
	private int product_price_total;
	
	public void initPriceTotal() {
		this.product_price_total = this.product_price * this.product_count;
	}
	
}

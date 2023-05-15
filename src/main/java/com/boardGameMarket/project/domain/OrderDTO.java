package com.boardGameMarket.project.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class OrderDTO {

	private String order_id;
	
	private String receiver;
	
	private String member_id;
	
	private String member_address1;
	
	private String member_address2;
	
	private String member_address3;
	
	private String order_state;
	
	private List<OrderElementDTO> orders;
	
	private int delivery_price;
	
	private Date orderDate;
	
	/* DB테이블에 존재하지 않음 */
	private int order_price_total;
	
	/* 배송비까지 포함한 최종 금액 */
	private int order_price_total_final;
	
	//최종금액 결정하는 메서드
	public void get_order_price_info() {
		
		/* 총 상품비용 */ 
		for(OrderElementDTO order : orders) {
			order_price_total += order.getProduct_price_total();
		}
		
		/* 배송비용 결정 */
		if(order_price_total >= 30000) {
			delivery_price = 0;
		}else {
			delivery_price = 3000;
		}
		
		/* 최종비용 */
		order_price_total_final = order_price_total + delivery_price;
		
		
	}
}

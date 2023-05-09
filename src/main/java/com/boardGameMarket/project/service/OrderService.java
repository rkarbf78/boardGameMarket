package com.boardGameMarket.project.service;

import java.util.List;

import com.boardGameMarket.project.domain.OrderDTO;
import com.boardGameMarket.project.domain.OrderPageElementDTO;

public interface OrderService {

	
	/* 주문 정보 */
	public List<OrderPageElementDTO> get_products_info(List<OrderPageElementDTO> orders);
	
	/* 주문 */
	public void order(OrderDTO odd);
	
}

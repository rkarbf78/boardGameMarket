package com.boardGameMarket.project.mapper;

import com.boardGameMarket.project.domain.OrderDTO;
import com.boardGameMarket.project.domain.OrderElementDTO;
import com.boardGameMarket.project.domain.OrderPageElementDTO;
import com.boardGameMarket.project.domain.ProductVO;

public interface OrderMapper {

	/* 주문 상품 정보 */
	public OrderPageElementDTO get_product_info(int product_id);
	
	/* 주문 상품 정보(주문처리) */
	public OrderElementDTO get_order_info(int product_id);
	
	/* 주문 테이블 등록 */
	public int order_registration(OrderDTO odd);
	
	/* 주문 요소 테이블 등록 */
	public int order_element_registration(OrderElementDTO oded);
	
	/* 주문 재고 차감 */
	public int deduction_stock(ProductVO product);
	
	
}

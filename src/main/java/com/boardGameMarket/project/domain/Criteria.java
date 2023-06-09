package com.boardGameMarket.project.domain;

import lombok.Data;

@Data
public class Criteria {
	
    /* 현재 페이지 번호 */
    private int pageNum;
    
    /* 페이지 표시 개수 */
    private int amount;
    
    /* 검색 타입 */
    private String type;
    
    /* 검색 키워드 */
    private String keyword;
    
	/* 카테고리 코드 */
    private int page_category_code;
    
	/* 정렬 기준 */
    private String order_by;
    
	/* 상품 번호 (댓글 기능에서 필요해서 추가함) */
    private int product_id;
    
    /* Criteria 생성자 */
    public Criteria(int pageNum, int amount) {
        this.pageNum = pageNum;
        this.amount = amount;
    }
    
    /* Criteria 기본 생성자 */
    public Criteria(){
        this(1,12);
    }
    
    /* 검색 타입 데이터 배열 변환 */
    public String[] getTypeArr() {
        return type == null? new String[] {}:type.split("");
    }
}

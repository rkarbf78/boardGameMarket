package com.boardGameMarket.project;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.boardGameMarket.project.domain.AttachFileDTO;
import com.boardGameMarket.project.domain.Criteria;
import com.boardGameMarket.project.domain.ProductVO;
import com.boardGameMarket.project.mapper.ProductMapper;
import com.boardGameMarket.project.service.ProductService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ProductTests {

	@Setter(onMethod_=@Autowired)
	private ProductMapper mapper;
	@Setter(onMethod_=@Autowired)
	private ProductService service;
	
	//�̹��� ��� �׽�Ʈ
//	@Test
	public void image_registrationTest() {
		AttachFileDTO aDto = new AttachFileDTO();
		
		aDto.setProduct_id(1);
		aDto.setFileName("test");
		aDto.setUploadPath("test");
		aDto.setUuid("test");
		
		mapper.image_registration(aDto);
	}
	
//	@Test
	public void Product_registrationTest() {
		ProductVO pVo = new ProductVO();
		
		pVo.setProduct_name("��ǰ�׽�Ʈ");
		pVo.setProduct_price(20000);
		pVo.setProduct_info("�׽�Ʈ�����Դϴ�");
		pVo.setProduct_stock(1);
		pVo.setProduct_sell(1);
		
		mapper.product_registration(pVo);
	}
	
	@Test
	public void ProductAndImage_registrationTest() {	
		
		for(int i =50; i<100; i++) {
			ProductVO pVo = new ProductVO();
			
			pVo.setProduct_name("더미상품 이름"+i);
			pVo.setProduct_price((int)(Math.random()*10000));
			pVo.setProduct_info("더미상품 정보"+i);
			pVo.setProduct_stock((int)(Math.random()*100));
			pVo.setProduct_sell(0);
			pVo.setProduct_category_code((int)(Math.random()*3+1));			
			service.Product_registration(pVo);	
			
		}
	}
	
//	@Test
	public void Product_Category_GetListTest() {
		System.out.println("카테고리 리스트 : " + mapper.categoryList());
	}
	
//	@Test
	public void Product_pagingTest() {
		
		Criteria cri = new Criteria(1,10);
		cri.setKeyword("27");
		
		List<ProductVO> productList = service.getProductList(cri);
		
		for(int i = 0; i < productList.size(); i++) {
			System.out.println("list" + i + "......" + productList.get(i));
		}
		
	}
	
//	@Test
	public void Product_getTotalTest() {
		
		Criteria cri = new Criteria();
		
		int total = mapper.productGetTotal(cri);
		
		System.out.println("total....." + total);
		
	}
}

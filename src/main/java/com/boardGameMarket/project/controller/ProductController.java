package com.boardGameMarket.project.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.boardGameMarket.project.domain.CategoryVO;
import com.boardGameMarket.project.domain.Criteria;
import com.boardGameMarket.project.domain.PageDTO;
import com.boardGameMarket.project.domain.ProductVO;
import com.boardGameMarket.project.service.ProductService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("/pages/*")
public class ProductController {

	@Setter(onMethod_=@Autowired)
	private ProductService service;
	
	
	@GetMapping("/mainPage")
	public void mainPage(Model model, Criteria cri) {
				
		List<ProductVO> productList = service.getProductList(cri);
		
		if(!productList.isEmpty()) {
			model.addAttribute("productList",productList); // 검색시 상품 존재 경우
		}else {
			model.addAttribute("productListCheck" , "empty"); // 검색시 상품 존재하지 않을 경우
		}
		
		List<CategoryVO> categoryList = service.categoryList();
		
		model.addAttribute("categoryList" , categoryList);
		
		int total = service.productGetTotal(cri);
		
		PageDTO pageMaker = new PageDTO(cri, total);
		
		model.addAttribute("pageMaker", pageMaker);
		
		int page_category_code = cri.getPage_category_code();
		
		model.addAttribute("page_category_code" , page_category_code);
		
	}
	
	@GetMapping("/detailPage")
	public void detailPage(int product_id , Model model , Criteria cri , HttpServletRequest request) {
		
		ProductVO product = service.getProduct(product_id);
		
		int page_category_code = cri.getPage_category_code();
		
		model.addAttribute("page_category_code" , page_category_code);
		
		model.addAttribute("cri",cri);
		
		model.addAttribute("product",product);
		
		List<CategoryVO> categoryList = service.categoryList();
		
		model.addAttribute("categoryList" , categoryList);
		
		
		//최근 본 상품 구현
		HttpSession session = request.getSession();
		
		if(session.getAttribute("recent_product") == null) {
			List<Integer> products_id = new ArrayList<Integer>();
			products_id.add(0,product_id);
			if(products_id.size() > 3) {
				products_id.remove(3);
			}
			session.setAttribute("recent_product", products_id);
		}else {
			//세션 반환시 데이터타입 오브젝트임 변환필요
			@SuppressWarnings("unchecked")
			List<Integer> products_id = (List<Integer>)session.getAttribute("recent_product");
			products_id.add(0,product_id);
			if(products_id.size() > 3) {
				products_id.remove(3);
			}
			session.setAttribute("recent_product", products_id);
		}
	
		
	}	
}

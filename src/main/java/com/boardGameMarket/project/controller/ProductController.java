package com.boardGameMarket.project.controller;

import java.awt.Graphics2D;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.imageio.ImageIO;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.boardGameMarket.project.domain.AttachFileDTO;
import com.boardGameMarket.project.domain.CategoryVO;
import com.boardGameMarket.project.domain.Criteria;
import com.boardGameMarket.project.domain.PageDTO;
import com.boardGameMarket.project.domain.ProductVO;
import com.boardGameMarket.project.service.ProductService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnails;

@Log4j
@Controller
@RequestMapping("/pages/*")
public class ProductController {

	@Setter(onMethod_=@Autowired)
	private ProductService service;
	
	
	@GetMapping("/mainPage")
	public void mainPage(Model model, Criteria cri) {
		
		System.out.println(cri);
				
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
	public void detailPage(int product_id , Model model , Criteria cri) {
		
		ProductVO product = service.getProduct(product_id);
		
		int page_category_code = cri.getPage_category_code();
		
		model.addAttribute("page_category_code" , page_category_code);
		
		model.addAttribute("cri",cri);
		
		model.addAttribute("product",product);
	}
	
	@GetMapping("/apitest")
	public String apitest() {
		return "/pages/apitest";
	}

	
	
}

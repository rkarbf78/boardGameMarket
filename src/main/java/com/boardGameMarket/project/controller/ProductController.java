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
		
		List<ProductVO> productList = service.getProductList(cri);
		
		model.addAttribute("productList",productList);
		
		int total = service.productGetTotal(cri);
		
		PageDTO pageMaker = new PageDTO(cri, total);
		
		model.addAttribute("pageMaker", pageMaker);
	}
	
	@GetMapping("/detailPage")
	public void detailPage(@RequestParam("product_id") int product_id , Model model) {
		ProductVO product = service.getProduct(product_id);
		model.addAttribute("product",product);
	}

	
	
}

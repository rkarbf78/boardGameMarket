package com.boardGameMarket.project.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.boardGameMarket.project.domain.CategoryVO;
import com.boardGameMarket.project.domain.Criteria;
import com.boardGameMarket.project.domain.PageDTO;
import com.boardGameMarket.project.domain.ProductVO;
import com.boardGameMarket.project.service.ProductService;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/pages/admin/*")
@Log4j
public class AdminController {
	
	@Setter(onMethod_=@Autowired)
	private ProductService service;
	
	@GetMapping("/adminPage")
	public void adminGET() {
		log.info("관리자 페이지 이동");
	}
	
	@GetMapping("/registerPage")
	public void registerPage(Model model) throws Exception {
		
		//json 형식 데이터로 카테고리리스트 보내기 Jackson-databind 라이브러리 사용.
		//추후 상위 카테고리에 따라 선택할 수 있는 하위 카테고리가 달라져야 한다는점을 위해 이방식을 선택.
		//하지만 실제로 이 프로젝트에선 하위 카테고리를 만들지 않을 예정이기때문에 이 방식을 고수하지 않아도 괜찮음.
		//경험상 이 방식으로 진행함.
		ObjectMapper objm = new ObjectMapper();
		
		List<CategoryVO> categoryList = service.categoryList();
		
		//기존 List를 String타입의 json형식 데이터로 변환
		String jsonCategoryList = objm.writeValueAsString(categoryList);
		
		model.addAttribute("categoryList",jsonCategoryList);
		
		log.info("제이슨으로 변경전....." + categoryList);
		log.info("변경 후....." + jsonCategoryList);
	}
	
	@PostMapping("/register")
	public String ProductRegister(ProductVO pVo, RedirectAttributes rttr) {
		log.info("Product Post..." + pVo);
		service.Product_registration(pVo);
		rttr.addFlashAttribute("register_result" , pVo.getProduct_name());
		return "redirect:/pages/mainPage";
	}
	
	@GetMapping("/productListPage")
	public void mainPage(Model model, Criteria cri) {
		
		cri.setAmount(10);
		
		List<ProductVO> productList = service.getProductList(cri);
		
		if(!productList.isEmpty()) {
			model.addAttribute("productList",productList); // 검색시 상품 존재 경우
		}else {
			model.addAttribute("productListCheck" , "empty"); // 검색시 상품 존재하지 않을 경우
		}
		
		int total = service.productGetTotal(cri);
		
		PageDTO pageMaker = new PageDTO(cri, total);
		
		model.addAttribute("pageMaker", pageMaker);
		
		List<CategoryVO> categoryList = service.categoryList();
		
		model.addAttribute("categoryList" , categoryList);
	}
	
}

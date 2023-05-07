package com.boardGameMarket.project.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.boardGameMarket.project.domain.CategoryVO;
import com.boardGameMarket.project.domain.Criteria;
import com.boardGameMarket.project.domain.MemberAddressVO;
import com.boardGameMarket.project.domain.MemberVO;
import com.boardGameMarket.project.domain.PageDTO;
import com.boardGameMarket.project.domain.ProductVO;
import com.boardGameMarket.project.service.MemberService;
import com.boardGameMarket.project.service.ProductService;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/pages/admin/*")
@Log4j
public class AdminController {
	
	@Setter(onMethod_=@Autowired)
	private ProductService p_service;
	
	@Setter(onMethod_=@Autowired)
	private MemberService m_service;
	
	@GetMapping("/adminPage")
	public void adminGET() {
		log.info("관리자 페이지 이동");
	}
	
	@GetMapping("/registerPage")
	public void productRegisterPage(Model model) throws Exception {
		
		/* 최초에 이방식을 사용했으나 어차피 하위카테고리는 없기때문에 다른 페이지들과 통일 시켜
		 * 충돌 없애기위해 변경함 2023.05.04
		 * //json 형식 데이터로 카테고리리스트 보내기 Jackson-databind 라이브러리 사용. //추후 상위 카테고리에 따라 선택할 수
		 * 있는 하위 카테고리가 달라져야 한다는점을 위해 이방식을 선택. //하지만 실제로 이 프로젝트에선 하위 카테고리를 만들지 않을 예정이기때문에
		 * 이 방식을 고수하지 않아도 괜찮음. //경험상 이 방식으로 진행함. ObjectMapper objm = new ObjectMapper();
		 * 
		 * List<CategoryVO> categoryList = p_service.categoryList();
		 * 
		 * //기존 List를 String타입의 json형식 데이터로 변환 String jsonCategoryList =
		 * objm.writeValueAsString(categoryList);
		 * 
		 * model.addAttribute("categoryList",jsonCategoryList);
		 * log.info("제이슨으로 변경전....." + categoryList);
		 * log.info("변경 후....." + jsonCategoryList);
		 */
		
		List<CategoryVO> categoryList = p_service.categoryList();
		
		model.addAttribute("categoryList" , categoryList);
		
		
	}
	
	@PostMapping("/register")
	public String productRegister(ProductVO pVo, RedirectAttributes rttr) {
		int result = p_service.Product_registration(pVo);
		rttr.addFlashAttribute("register_result" , result);
		return "redirect:/pages/admin/productListPage";
	}
	
	@GetMapping("/productListPage")
	public void productListPage(Model model, Criteria cri) {
		
		cri.setAmount(10);
		
		List<ProductVO> productList = p_service.getProductList(cri);
		
		if(!productList.isEmpty()) {
			model.addAttribute("productList",productList); // 검색시 상품 존재 경우
		}else {
			model.addAttribute("productListCheck" , "empty"); // 검색시 상품 존재하지 않을 경우
		}
		
		int total = p_service.productGetTotal(cri);
		
		PageDTO pageMaker = new PageDTO(cri, total);
		
		model.addAttribute("pageMaker", pageMaker);
		
		List<CategoryVO> categoryList = p_service.categoryList();
		
		model.addAttribute("categoryList" , categoryList);
	}
	
	@GetMapping("/productDetailPage")
	public void productDetailPage(int product_id, Criteria cri, Model model) {
		ProductVO product = p_service.getProduct(product_id);
		model.addAttribute("product",product);
		List<CategoryVO> categoryList = p_service.categoryList();
		model.addAttribute("categoryList" , categoryList);
		model.addAttribute("cri",cri);
		
	}
	
	@GetMapping("/productModifyPage")
	public void productModifyPage(int product_id, Criteria cri, Model model) throws Exception {
		ProductVO product = p_service.getProduct(product_id);
		model.addAttribute("product",product);
		model.addAttribute("cri",cri);
		
		/* 최초에 이방식을 사용했으나 어차피 하위카테고리는 없기때문에 다른 페이지들과 통일 시켜
		 * 충돌 없애기위해 변경함 2023.05.04
		 * //json 형식 데이터로 카테고리리스트 보내기 Jackson-databind 라이브러리 사용. //추후 상위 카테고리에 따라 선택할 수
		 * 있는 하위 카테고리가 달라져야 한다는점을 위해 이방식을 선택. //하지만 실제로 이 프로젝트에선 하위 카테고리를 만들지 않을 예정이기때문에
		 * 이 방식을 고수하지 않아도 괜찮음. //경험상 이 방식으로 진행함. ObjectMapper objm = new ObjectMapper();
		 * 
		 * List<CategoryVO> categoryList = p_service.categoryList();
		 * 
		 * //기존 List를 String타입의 json형식 데이터로 변환 String jsonCategoryList =
		 * objm.writeValueAsString(categoryList);
		 * 
		 * model.addAttribute("categoryList",jsonCategoryList);
		 * log.info("제이슨으로 변경전....." + categoryList);
		 * log.info("변경 후....." + jsonCategoryList);
		 */
		
		List<CategoryVO> categoryList = p_service.categoryList();
		
		model.addAttribute("categoryList" , categoryList);
	}
	
	@PostMapping("/productModify")
	public String productModify(ProductVO pVo , RedirectAttributes rttr) {
		int result = p_service.product_modify(pVo);
		rttr.addFlashAttribute("modify_result" , result);
		return "redirect:/pages/admin/productListPage";
	}
	
	@PostMapping("/productRemove")
	public String productRemove(int product_id , RedirectAttributes rttr) {
		int result = p_service.product_remove(product_id);
		rttr.addFlashAttribute("remove_result",result);
		return "redirect:/pages/admin/productListPage";
	}
	
	@GetMapping("/memberListPage")
	public void memberListPage(Model model, Criteria cri) {
		
		cri.setAmount(10);
		
		List<MemberVO> memberList = m_service.getMemberList(cri);
		
		if(!memberList.isEmpty()) {
			memberList.forEach(i -> {
				MemberAddressVO address = m_service.getMemberAddress(i.getMember_id());
				i.setMember_address(address);
			});
			model.addAttribute("memberList",memberList); // 검색시 회원 존재 경우
		}else {
			model.addAttribute("memberListCheck" , "empty"); // 검색시 회원 존재하지 않을 경우
		}
		
		int total = m_service.memberGetTotal(cri);
		
		PageDTO pageMaker = new PageDTO(cri, total);
		
		model.addAttribute("pageMaker", pageMaker);
		
	}
	
	@GetMapping("/memberDetailPage")
	public void memberDetailPage(@RequestParam("member_id") String member_id, Criteria cri, Model model) {
		MemberVO member = m_service.getMember(member_id);
		MemberAddressVO address = m_service.getMemberAddress(member_id);
		member.setMember_address(address);
		model.addAttribute("member",member);
		model.addAttribute("cri",cri);
	}
	
	@PostMapping("/memberRemove")
	public String memberRemove(String member_id , RedirectAttributes rttr) {
		int result = m_service.member_remove(member_id);
		rttr.addFlashAttribute("remove_result",result);
		return "redirect:/pages/admin/memberListPage";
	}
}

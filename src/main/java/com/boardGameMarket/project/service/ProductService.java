package com.boardGameMarket.project.service;

import java.util.List;

import com.boardGameMarket.project.domain.AttachFileDTO;
import com.boardGameMarket.project.domain.CategoryVO;
import com.boardGameMarket.project.domain.Criteria;
import com.boardGameMarket.project.domain.ProductVO;

public interface ProductService {
	
	public List<ProductVO> getProductList(Criteria cri);
	
	public ProductVO getProduct(int product_id);
	
	public void Product_registration(ProductVO pVo);
	
	public AttachFileDTO getAttachFile(int product_id);
	
	public List<CategoryVO> categoryList();
	
	public int productGetTotal(Criteria cri);
}

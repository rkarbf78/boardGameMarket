package com.boardGameMarket.project.mapper;

import java.util.List;

import com.boardGameMarket.project.domain.AttachFileDTO;
import com.boardGameMarket.project.domain.CategoryVO;
import com.boardGameMarket.project.domain.Criteria;
import com.boardGameMarket.project.domain.ProductVO;

public interface ProductMapper {
	
	public List<ProductVO> getProductList(Criteria cri);
	
	public ProductVO getProduct(int product_id);

	public int product_registration(ProductVO pVo);
	
	public void image_registration(AttachFileDTO aDto);

	public AttachFileDTO getAttachFile(int product_id);
	
	public void deleteImage(int product_id);
	
	public List<CategoryVO> categoryList();
	
	public int productGetTotal(Criteria cri);
	
	public int product_modify(ProductVO pVo);
}

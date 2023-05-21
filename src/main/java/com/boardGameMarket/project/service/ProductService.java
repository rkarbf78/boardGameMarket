package com.boardGameMarket.project.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.boardGameMarket.project.domain.AttachFileDTO;
import com.boardGameMarket.project.domain.CategoryVO;
import com.boardGameMarket.project.domain.ChartDTO;
import com.boardGameMarket.project.domain.Criteria;
import com.boardGameMarket.project.domain.ProductVO;

public interface ProductService {
	
	public List<ProductVO> getProductList(Criteria cri);
	
	public ProductVO getProduct(int product_id);
	
	public int Product_registration(ProductVO pVo);
	
	public AttachFileDTO getAttachFile(int product_id);
	
	public List<CategoryVO> categoryList();
	
	public int productGetTotal(Criteria cri);
	
	public int product_modify(ProductVO pVo);
	
	public int product_remove(int product_id);
	
	public List<ChartDTO> getChartData(@Param("product_id") int product_id,@Param("startDay") String startDay,@Param("endDay") String endDay);

}

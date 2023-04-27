package com.boardGameMarket.project.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.boardGameMarket.project.domain.AttachFileDTO;
import com.boardGameMarket.project.domain.CategoryVO;
import com.boardGameMarket.project.domain.Criteria;
import com.boardGameMarket.project.domain.ProductVO;
import com.boardGameMarket.project.mapper.ProductMapper;

import lombok.Setter;


@Service
public class ProductServiceImpl implements ProductService {

	@Setter(onMethod_=@Autowired)
	private ProductMapper mapper;
	
	
	@Override
	public List<ProductVO> getProductList(Criteria cri) {
		
		List<ProductVO> pList = mapper.getProductList(cri);
		
		pList.forEach(pVo -> {
			int product_id = pVo.getProduct_id();
			AttachFileDTO image = mapper.getAttachFile(product_id);
			pVo.setImage(image);
		});
		
		return pList;
		
	}


	@Override
	public ProductVO getProduct(int product_id) {
		return mapper.getProduct(product_id);
	}

	@Transactional
	@Override
	public void Product_registration(ProductVO pVo) {
		mapper.product_registration(pVo);
		
		//이미지 없는경우
		if(pVo.getImage() == null) {
			return;
		}
		
		AttachFileDTO attach = pVo.getImage();
		attach.setProduct_id(pVo.getProduct_id());
		mapper.image_registration(attach);
	}


	@Override
	public AttachFileDTO getAttachFile(int product_id) {
		
		return mapper.getAttachFile(product_id);
		
	}


	@Override
	public List<CategoryVO> categoryList() {
		return mapper.categoryList();
	}


	@Override
	public int productGetTotal(Criteria cri) {
		return mapper.productGetTotal(cri);
	}

	
	
}

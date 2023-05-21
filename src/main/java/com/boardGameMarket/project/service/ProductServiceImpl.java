package com.boardGameMarket.project.service;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.boardGameMarket.project.domain.AttachFileDTO;
import com.boardGameMarket.project.domain.CategoryVO;
import com.boardGameMarket.project.domain.ChartDTO;
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
	public int Product_registration(ProductVO pVo) {
		int result = mapper.product_registration(pVo);
		
		//이미지 없는경우
		if(pVo.getImage() == null) {
			return result;
		}
		
		AttachFileDTO attach = pVo.getImage();
		attach.setProduct_id(pVo.getProduct_id());
		mapper.image_registration(attach);
		
		return result;
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

	@Transactional
	@Override
	public int product_modify(ProductVO pVo) {
		int result = mapper.product_modify(pVo);
		
		if(result ==1 && pVo.getImage() != null) {
			mapper.deleteImage(pVo.getProduct_id());
			//이미지 없는경우
			if(pVo.getImage() == null) {
				return result;
			}
			
			AttachFileDTO attach = pVo.getImage();
			attach.setProduct_id(pVo.getProduct_id());
			mapper.image_registration(attach);
			
		}
		return result;
	}

	@Transactional
	@Override
	public int product_remove(int product_id) {
		
		AttachFileDTO image = mapper.getAttachFile(product_id);
		
		if(image != null) {
			
			Path path = Paths.get("C:\\upload", image.getUploadPath(), image.getUuid() + "_" + image.getFileName());
			path.toFile().delete();		
			mapper.deleteImage(product_id);
		}
		
		int result = mapper.product_remove(product_id);
		
		return result;
	}


	@Override
	public List<ChartDTO> getChartData(int product_id, String startDay, String endDay) {
		
		List<ChartDTO> chartDataList = mapper.getChartData(product_id, startDay, endDay);
		
		//중복날짜 count 합치고 중복 없애기
		for(int i=0; i<chartDataList.size()-1; i++) {
			if(chartDataList.get(i).getSell_Date().equals(chartDataList.get(i+1).getSell_Date())) {
				chartDataList.get(i).setSell_count(chartDataList.get(i).getSell_count() + chartDataList.get(i+1).getSell_count());
				chartDataList.remove(i+1);
				i--;
			}
		}
		
		
		return null;
	}
}

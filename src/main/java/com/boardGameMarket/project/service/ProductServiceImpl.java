package com.boardGameMarket.project.service;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
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
		
		if(chartDataList.isEmpty()) {
			return chartDataList;
		}else {
			//검색 시작날짜에 해당하는 db데이터가 없을시
			if(chartDataList.get(0).getSell_date() != startDay) {
				ChartDTO chart = new ChartDTO();
				chart.setSell_date(startDay);
				chart.setSell_count(0);
				chartDataList.add(0,chart);
			}
			//검색 끝날짜에 해당하는 db데이터가 없을시
			if(chartDataList.get(chartDataList.size()-1).getSell_date() != endDay){
				ChartDTO chart = new ChartDTO();
				chart.setSell_date(endDay);
				chart.setSell_count(0);
				chartDataList.add(chart);
			}
			
			//중복날짜 count 합치고 중복 없애기
			for(int i=0; i<chartDataList.size()-1; i++) {
				if(chartDataList.get(i).getSell_date().equals(chartDataList.get(i+1).getSell_date())) {
					chartDataList.get(i).setSell_count(chartDataList.get(i).getSell_count() + chartDataList.get(i+1).getSell_count());
					chartDataList.remove(i+1);
					i--;
				}
			}
			
			//날짜 사이 빈날짜 채우기
			for(int i=0; i<chartDataList.size()-1; i++) {
				
				String date1 = chartDataList.get(i).getSell_date();
				String date2 = chartDataList.get(i+1).getSell_date();
				
				try {
					Date formatDate1 = new SimpleDateFormat("yyyy/MM/dd").parse(date1);
					Date formatDate2 = new SimpleDateFormat("yyyy/MM/dd").parse(date2);
					long dateGap = (formatDate2.getTime()-formatDate1.getTime())/1000 / (24*60*60);
					
					if(dateGap != 1) {
						Calendar cal = Calendar.getInstance();
						cal.setTime(formatDate1);
						cal.add(Calendar.DATE, 1);
						String strformat = new SimpleDateFormat("yyyy/MM/dd").format(cal.getTime());
						ChartDTO chart = new ChartDTO();
						chart.setSell_date(strformat);
						chart.setSell_count(0);
						chartDataList.add(i+1,chart);	
					}
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
			
			//그래프 출력시 날짜 간소화
			for(ChartDTO chartData : chartDataList) {
				String date = chartData.getSell_date();
				date = date.substring(date.length()-5,date.length());
				chartData.setSell_date(date);
			}
			return chartDataList;
		}
		
		
	}
}

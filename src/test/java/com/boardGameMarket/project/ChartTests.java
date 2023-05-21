package com.boardGameMarket.project;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.boardGameMarket.project.domain.ChartDTO;
import com.boardGameMarket.project.mapper.ProductMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ChartTests {
	
	@Setter(onMethod_=@Autowired)
	private ProductMapper mapper;
	
	
		@Test
		public void addCartTest() {
			
			
			List<ChartDTO> chartDataList = mapper.getChartData(106, "2023/05/16", "2023/05/20");
			
			
			for(int i=0; i<chartDataList.size()-1; i++) {
				if(chartDataList.get(i).getSell_Date().equals(chartDataList.get(i+1).getSell_Date())) {
					System.out.println("이안에 들어오나");
					chartDataList.get(i).setSell_count(chartDataList.get(i).getSell_count() + chartDataList.get(i+1).getSell_count());
					chartDataList.remove(i+1);
					i--;
				}
				
				
			}
			
			for(int i=0; i<chartDataList.size()-1; i++) {
				String dateText1 = chartDataList.get(i).getSell_Date().replace("/", "");
				String dateText2 = chartDataList.get(i+1).getSell_Date().replace("/", "");
				int dateInt1 = Integer.parseInt(dateText1);
				int dateInt2 = Integer.parseInt(dateText2);
				
				int dateGap = dateInt1 - dateInt2;
				
				if(dateGap != 1) {
					for(int j=1; j<dateGap; j++) {
						dateInt2 += 1;
						StringBuffer sb = new StringBuffer();
						sb.append(Integer.toString(dateInt1));
						sb.insert(4, "/");
						sb.insert(7, "/");
						System.out.println("없느넉 들어가냐" + sb);
					}
				}
				
				
				
				
				
				log.info("리플레이스 체크" + dateText1);
			}
			
			
			log.info("과연 결과는?" + chartDataList);
		}
}

package com.boardGameMarket.project;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
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
			
			
			List<ChartDTO> chartDataList = mapper.getChartData(106, "2023/04/23", "2023/05/23");
			
			
			//검색 시작날짜에 해당하는 db데이터가 없을시
			if(chartDataList.get(0).getSell_date() != "2023/04/23") {
				ChartDTO chart = new ChartDTO();
				chart.setSell_date("2023/04/23");
				chart.setSell_count(0);
				chartDataList.add(0,chart);
			}
			
			for(int i=0; i<chartDataList.size()-1; i++) {
				if(chartDataList.get(i).getSell_date().equals(chartDataList.get(i+1).getSell_date())) {
					chartDataList.get(i).setSell_count(chartDataList.get(i).getSell_count() + chartDataList.get(i+1).getSell_count());
					chartDataList.remove(i+1);
					i--;
				}
			}
		
			for(int i=0; i<chartDataList.size()-1; i++) {
				
				String date1 = chartDataList.get(i).getSell_date();
				String date2 = chartDataList.get(i+1).getSell_date();
				
				try {
					Date formatDate1 = new SimpleDateFormat("yyyy/MM/dd").parse(date1);
					Date formatDate2 = new SimpleDateFormat("yyyy/MM/dd").parse(date2);
					long dateGap = (formatDate2.getTime()-formatDate1.getTime())/1000 / (24*60*60);
					
					System.out.println("데이트갭 검사" + dateGap);
					
					if(dateGap != 1) {
						Calendar cal = Calendar.getInstance();
						cal.setTime(formatDate1);
						cal.add(Calendar.DATE, 1);
						String strformat = new SimpleDateFormat("yyyy/MM/dd").format(cal.getTime());
						ChartDTO chart = new ChartDTO();
						System.out.println("캘린더로 바꾼건 어떨까" + strformat);
						chart.setSell_date(strformat);
						chart.setSell_count(0);
						chartDataList.add(i+1,chart);	
					}
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
			log.info("과연 결과는?" + chartDataList);
		}
}

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../includes/header.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="../../resources/js/datepicker-ko.js"></script> <!-- 파일 직접 생성함 -->

<script type="text/javascript">

$(document).ready(function(){
	
	//이미지 정보 호출
	let product_id = '<c:out value="${product.product_id}"/>';
	let uploadResult = $("#uploadResult");
	
	$.getJSON("/pages/getAttachFile",{product_id:product_id}).done(function(one){

		let str = "";
		let obj = one;
		
		let fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
		str += "<div id='result_card'";
		str += "data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "'";
		str += ">";
		str += "<img src='/pages/display?fileName=" + fileCallPath +"'>";
		str += "</div>";
		
		uploadResult.html(str);
	
	}).fail(function(){
		
		let str = "";
		str += "<div id='result_card'>";
		str += "<img src='/resources/img/noimg.jpg'>";
		str += "</div>";
		
		uploadResult.html(str);
	});
	
	$("#list_button").click(function(e){
		e.preventDefault();
		$("#moveForm").attr("action","/pages/admin/productListPage");
		$("#moveForm").submit();
	});
	
	$("#modify_button").click(function(e){
		e.preventDefault();
		$("#moveForm").attr("action","/pages/admin/productModifyPage");
		$("#moveForm").submit();
	});
	
	$("#remove_button").click(function(e){
		e.preventDefault();
		$("#moveForm").attr("action","/pages/admin/productRemove");
		$("#moveForm").attr("method","POST");
		$("#moveForm").submit();
	});
	
	$('.datepicker').datepicker({
		format: "yyyy/MM/dd",
		language: "kr",
		todayHighlight: true
	});
	
	
	//로딩시 전해줄 데이터
	const firstChart = {product_id : $("input[name='product_id']").val(),startDay : $(".startDay_input").val(),endDay : $(".endDay_input").val()}
	
	//최초 로딩시 오늘날짜~7일전 데이터 출력
	$.getJSON("/pages/admin/chart",firstChart,function(result){
		
		if(result.length === 0){
			$(".chart_canvas").html("<h3 style='text-align : center'>조회된 데이터가없습니다.</h3>");
		}else{
			var label_list = [];
			var count_list = [];
			
			result.forEach(i=>{
				label_list.push(i["sell_date"]);
				count_list.push(i["sell_count"]);
			});
			
			chartMake(label_list,count_list);	
		}
		
		
	});
	
	$("#click-btn").click(function(){
		
		const date1 = new Date($(".startDay_input").val());
		
		const date2 = new Date($(".endDay_input").val());
		
		
	
		const changeChart = {product_id : $("input[name='product_id']").val(),startDay : $(".startDay_input").val(),endDay : $(".endDay_input").val()}
		
		$.getJSON("/pages/admin/chart",changeChart,function(result){
			
			if(result.length === 0){
				$(".chart_canvas").html("<h3 style='text-align : center'>조회된 데이터가없습니다.</h3>");
			}else{

				var label_list = [];
				var count_list = [];
				
				result.forEach(i=>{
					label_list.push(i["sell_date"]);
					count_list.push(i["sell_count"]);
				});

				$(".chart_canvas").html("<canvas id='myChart'></canvas>");
				chartMake(label_list,count_list);
			}
		});	
		
	});
	
	
	
	
	
	
});

function chartMake(label_list, count_list) {
	var ctx = document.getElementById('myChart').getContext('2d');
	var myChart = new Chart(ctx, {
		type: 'bar',
		data: {
			labels: label_list,
			datasets: [{
				label: '일일 판매량',
				data: count_list,
				backgroundColor: [
					'rgba(255, 99, 132, 0.2)',
					'rgba(54, 162, 235, 0.2)',
					'rgba(255, 206, 86, 0.2)',
					'rgba(75, 192, 192, 0.2)',
					'rgba(153, 102, 255, 0.2)',
					'rgba(255, 159, 64, 0.2)'
				],
				borderColor: [
					'rgba(255, 99, 132, 1)',
					'rgba(54, 162, 235, 1)',
					'rgba(255, 206, 86, 1)',
					'rgba(75, 192, 192, 1)',
					'rgba(153, 102, 255, 1)',
					'rgba(255, 159, 64, 1)'
				],
				borderWidth: 2
			}]
		},
		options: {
			scales: {
				y: {
					beginAtZero: true
				}
			}
		}
	});
}
</script>
<style type="text/css">
.admin_page{
	color : black;
}
#result_card img {
	width : 100%;
}
#uploadResult{
	width : 250px;
}
.category_select{
	width : 30%;
	height : 35px;
	font-size : 18px;
	text-align : center;
}
.name_wrap,.price_wrap,.info_wrap,.stock_wrap,.sell_wrap,.category_wrap,.img_wrap,.updateDate_wrap,.regDate_wrap{
	margin-bottom : 21px;
}
.category_select_wrap{
	margin-top : 2px
}
#modify_button{
	background : #3366ff; 
	border : 1px solid #3366ff;
}
#remove_button{
	background : #ff3333;
	border : 1px solid #ff3333;
}
#startDay,#endDay{
	width : 200px;
	height: auto;
	padding: 5px;
	background-color: #fff;
}
#click-btn{
	padding : 5px 10px;
	background-color: #3366ff;
	color : #fff;
	border : 1px solid #3366ff;
}
.input-daterange{
	margin-left: 40px;
}
.chart_wrap{
	margin-bottom: 21px;
}
</style>
	<div class="admin_nav_list">
		<ul>
			<li><a href="/pages/admin/productListPage" class="admin_nav_1">상품 관리</a></li>
			<li><a href="/pages/admin/registerPage" class="admin_nav_2">상품 등록</a></li>
			<li><a href="/pages/admin/memberListPage" class="admin_nav_3">회원 관리</a></li>
		</ul>
	</div>
		<!-- #masthead -->
		<div id="content" class="site-content">						
			<div id="secondary" class="column third">
				<div class="widget-area">
					<aside class="widget">
						<h4 class="widget-title">상품 조회</h4>
							<div class="wpcf7">
							<div class="form">
								<div class="img_wrap">
									<div class="form_section_title">
										<label>상품 이미지</label>
									</div>
									<div class="form_section_content">
										<div id="uploadResult">
										</div>
									</div>
								</div>
								<div class="chart_wrap">
									<label>상품 판매량 그래프</label>
										<div class="input-group input-daterange">
										<c:set var='ymd' value="<%=new java.util.Date()%>"/>
										<c:set var='zmd' value="<%=new java.util.Date(new java.util.Date().getTime() - 60*60*24*1000*7)%>"/>
											<input type="text" id="startDay" class="startDay_input datepicker" name="startDay" value="<fmt:formatDate value='${zmd}' pattern='yyyy/MM/dd'/>" readonly>
											<input type="text" id="endDay" class="endDay_input datepicker" name="endDay" value="<fmt:formatDate value='${ymd}' pattern='yyyy/MM/dd'/>"  readonly>
											<button type="button" id="click-btn">조회</button>
										</div>
										<div class="chart_canvas" style="position: relative; height:250px; width:100%">
												<canvas id="myChart"></canvas>
										</div>
								</div>
								<div class="name_wrap">
									<label>상품이름</label>
									<input type="text" name="product_name" value="${product.product_name}" readonly>
								</div>
								<div class="price_wrap">
									<label>상품가격</label>
									<input type="text" name="product_price" value="${product.product_price}" readonly>
								</div>
								<div class="info_wrap">
									<label>상품정보</label>
									<textarea name="product_info" rows="5" readonly>${product.product_info}</textarea>
								</div>
								<div class="category_wrap">
									<label>상품 카테고리</label>
									<div class="category_select_wrap">
									<select class="category_select" name="product_category_code">
										<option selected value ="${product.product_category_code}">
											<c:forEach items="${categoryList}" var="category">
												<c:if test="${product.product_category_code == category.category_code}">
													${category.category_name}
												</c:if>
											</c:forEach>
										</option>
									</select>
									</div>
								</div>
								<div class="stock_wrap">
									<label>상품재고</label>
									<input type="text" name="product_stock" value="${product.product_stock}" readonly>
								</div>
								<div class="sell_wrap">
									<label>판매수량</label>
									<input type="text" name="product_sell" value="${product.product_sell}" readonly>
								</div>
								<div class="updateDate_wrap">
									<label>최근 수정 날짜</label>
									<input type="text" name="product_updateDate" value="<fmt:formatDate value="${product.product_updateDate}" pattern="yyyy-MM-dd"/>" readonly/>
								</div>
								<div class="regDate_wrap">
									<label>최초 등록 날짜</label>
									<input type="text" name="product_regDate" value="<fmt:formatDate value="${product.product_regDate}" pattern="yyyy-MM-dd"/>" readonly/>
								</div>
								<div class="button_section">
									<input type="button" id="modify_button" value="수정">
									<input type="button" id="remove_button" value="삭제">
									<input type="button" id="list_button" value="목록">
								</div>
							</div>
							</div>
							
							<form id="moveForm" action="" method="get">  <!-- action 생략시 현재페이지에 요청함! -->
								<input type="hidden" name="pageNum" value="${cri.pageNum}">
								<input type="hidden" name="amount" value="${cri.amount}">
								<input type="hidden" name="keyword" value="${cri.keyword}">
								<input type="hidden" name="product_id" value="${product.product_id}">				
							</form>	
						<div class="done">								
							Your message has been sent. Thank you!
						</div>
					</aside>
				</div>
			</div>
		</div>
		<!-- #content -->
	</div>
	<!-- .container -->
<%@ include file="../includes/footer.jsp" %>
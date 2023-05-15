<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="includes/header.jsp" %>

<!-- 결제 api 포트원 -->
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>

<!-- 다음주소 api -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>

	
	$(document).ready(function(){
	
			
		$(".products_table_tr").each(function(idx,data){
			
			//이미지 정보 호출
			let product_id = "" + $(this).find(".product_id_input").val();
			let uploadResult = $(this).find("#uploadResult");
			
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
		});
		
	});
	
	
	

	
	
	
		
</script>

<style>
 .content_main{
    min-height: 700px;
    position: relative;
 }
.orderproducts_div{
	margin-top:30px;
}
.products_kind_div{
	font-size: 25px;
    line-height: 35px;
    font-weight: bold;
}
.products_subject_table{
	font-size: 14px;
    line-height: 20px;
    width: 100%;
    text-align: center; 
}
.products_subject_table th{
	text-align: center;
    color: #333;
    border-bottom: 1px solid #e7e7e7;
    border-top: 2px solid #3084d9;
    background: #f4f9fd;
    padding: 2px 0;	 
}
.products_table_tr{
	font-size: 14px;
	line-height: 20px;
	border-bottom: 1px solid #e7e7e7;
}
.products_table_tr{
height: 110px;
}
.products_table_tr td{
	text-align: center;
	vertical-align: middle;
	padding : 10px 0px 10px 0px;
}
.total_info_btn_div{
	border-top: 1px solid #ddd;
    text-align: center;
    padding: 15px 20px;
}
.order_btn{
    display: inline-block;
    font-size: 21px;
    line-height: 50px;
    width: 200px;
    height: 50px;
    background-color: #365fdd;
    color: #fff;
    font-weight: bold;
}
#result_card img{
	margin : 0 auto;
}
 
</style>

	<div class="content_subject"><h4>주문조회</h4></div>
	
	<div class="content_main">
		<!-- 상품 관련 -->
		<div class="orderproducts_div">
		<!-- 상품 종류 -->
		<div class="products_kind_div">
			주문내역 <span class="products_kind_div_kind">${fn:length(orderList)}</span>건
		</div>
		<!-- 상품 테이블 -->
		<table class="products_subject_table">
			<thead>
				<tr>
					<th>대표 이미지</th>
					<th>구매 정보</th>
					<th>결제 금액</th>
				</tr>
			</thead>
			<tbody>
			<colgroup>
				<col width="25%">
				<col width="25%">
			</colgroup>
				<c:forEach items="${orderList}" var="ol">
					<tr class="products_table_tr">
						<td class ="product_image">
							<div id="uploadResult">
							</div>
						</td>
						<td>${ol.orders[0].product_name} 외 ${fn:length(ol.orders) -1} 종</td>
						<td class="products_table_price_td">
							<fmt:formatNumber value="${ol.order_price_total_final}" pattern="#,### 원" />
							<input type="hidden" class="product_price_input" value="${ol.orders[0].product_price}">
							<input type="hidden" class="product_count_input" value="${ol.orders[0].product_count}">
							<input type="hidden" class="product_priceTotal_input" value="${ol.orders[0].product_price * ol.orders[0].product_count}">
							<input type="hidden" class="product_id_input" value="${ol.orders[0].product_id}">
						</td>
					</tr>							
				</c:forEach>
			</tbody>
		</table>
	</div>
	</div>
			
<%@ include file="includes/footer.jsp" %>
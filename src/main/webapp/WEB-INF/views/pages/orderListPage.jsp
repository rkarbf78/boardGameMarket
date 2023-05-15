<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="includes/header.jsp" %>

<!-- 결제 api 포트원 -->
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>

<!-- 다음주소 api -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>

	
	$(document).ready(function(){
	
		setTotalInfo();
			
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
	
	
	
	function setTotalInfo(){
		
		let priceTotal = 0; //총 가격
		let countTotal = 0; //총 갯수
		let kindTotal = 0; //총 종류
		let deliveryPrice = 0; //배송비
		let priceTotalFinal = 0; //최종가격
		
		/* 태그에서 값 꺼내서 저장 */
		$(".products_table_price_td").each(function(idx,data){
			priceTotal += parseInt($(data).find(".product_priceTotal_input").val());
			countTotal += parseInt($(data).find(".product_count_input").val());
			kindTotal += 1;
		});
		
		/* 배송비 결정 */
		if(priceTotal >= 30000){
			deliveryPrice = 0;
		}else if(priceTotal == 0){
			deliveryPrice = 0;
		}else{
			deliveryPrice = 3000;
		}
		
		priceTotalFinal = priceTotal + deliveryPrice;
		
		/* 값 삽입 */
		$(".priceTotal_span").text(priceTotal);
		$(".products_kind_div_count").text(countTotal);
		$(".products_kind_div_kind").text(kindTotal);
		$(".deliveryPrice_span").text(deliveryPrice);
		$(".priceTotalFinal_span").text(priceTotalFinal);
	}
	
	
	
		
</script>

<style>
 .content_main{
    min-height: 700px;
    padding-right: 350px;
    position: relative;
 }
 
 /* 사용자 정보  */
 .member_info_table{
    width: 100%;
    border-spacing: 0;
    border-top: 2px solid #363636;
    border-bottom: 1px solid #b6b6b6; 
 }
 .member_info_div td{
 	padding : 12px;
 	text-align: left;
 }
 /* 사용자 주소 정보 */
 .address_info_div{
 	margin-top: 30px;
 }
 .address_info_input_div_wrap{
 	border-bottom: 1px solid #f3f3f3;
 	height: 225px;
 }
.address_btn {
    background-color: #555;
    color: white;
    float: left;
    border: none;
    outline: none;
    cursor: pointer;
    padding: 14px 16px;
    font-size: 17px;
    width: 50%;
}
.address_btn:hover{
	background-color: #777;
}
.address_info_button_div::after{
	content:'';
	display:block;
	clear:both;
}
.address_info_input_div{
	padding:12px;
	text-align: left;
	display: none;
	line-height: 40px;
}
.address_info_input_div th{
	border-color: transparent;
    background-color: transparent;		
}
.address_info_input_div th{
	padding : 12px 5px 12px 20px;
	vertical-align: top;
}
.address_info_input_div td{
	padding : 8px 12px;
}		
.address_info_input_div_2 input{
	padding: 6px 5px;
}
.address_search_btn{
    vertical-align: middle;
    display: inline-block;
    border: 1px solid #aaa;
    width: 90px;
    text-align: center;
    height: 30px;
    line-height: 30px;
    color: #555;
    cursor: pointer;
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
/* 주문 종합 정보 */
.total_info_div{
	position:absolute;
	top: 0;
	right : 0;
	width : 300px;
	border : 1px solid #333;
	border-top-width:2px;	
	
}
.total_info_price_div{
	width: 90%;
    margin: auto;
	position: relative;
}
.total_info_div ul{
	list-style: none;
}
.total_info_div li{
	text-align: right;
	margin-top:10px;
}
.price_span_label{
	float: left;
}
.price_total_li{
	border-top: 1px solid #ddd;
	padding-top: 20px;
}
.strong_red{
	color: red;
}
.total_price_red{
	font-size: 25px;
}
.total_price_label{
	margin-top: 5px;
}
.point_li{
    padding: 15px;
    border-top: 1px solid #ddd;
    margin: 10px -15px 0;
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
 
</style>

	<div class="content_subject"><h4>주문조회</h4></div>
	
	<div class="content_main">
		<!-- 상품 관련 -->
		<div class="orderproducts_div">
		<!-- 상품 종류 -->
		<div class="products_kind_div">
			주문상품 <span class="products_kind_div_kind"></span>종 <span class="products_kind_div_count"></span>개
		</div>
		<!-- 상품 테이블 -->
		<table class="products_subject_table">
			<thead>
				<tr>
					<th>이미지</th>
					<th>상품 정보</th>
					<th>판매가</th>
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
						<td>${ol.orders[0].product_name}</td>
						<td class="products_table_price_td">
							<fmt:formatNumber value="${ol.orders[0].product_price}" pattern="#,### 원" /> | 수량 ${ol.orders[0].product_count}개
							<br>
							<fmt:formatNumber value="${ol.orders[0].product_price_total}" pattern="#,### 원" />
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
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../includes/header.jsp" %>


<script>
	$(document).ready(function(){
		
	
		/* 종합 정보 섹션 정보 삽입 */
		setTotalInfo();
		
		//ci에 담긴 이미지 꺼내기 작업
		$(".image_wrap").each(function(i,obj){
			
			//초기화
			const bobj = $(obj);
			
			//이미지 데이터 있을시
			if(bobj.data("product_id")){
				
				const uploadPath = bobj.data("path");
				
				const uuid = bobj.data("uuid");
				
				const fileName = bobj.data("filename");
				
				
				//썸네일 화질 너무 구려서 원본으로 바꿔놨음
				const fileCallPath = encodeURIComponent(uploadPath + "/" + uuid + "_" + fileName);
				
				$(this).find("img").attr('src','/pages/display?fileName=' + fileCallPath);
				
			} else {
				
				$(this).find("img").attr('src','/resources/img/noimg.jpg');
				
			}
			
			});
		
		/* 체크박스 체크 여부에따른 종합정보 변화 */
		$(".cart_checkbox_input").change(function(){
			setTotalInfo();		
		});
		
		/* 체크박스 전체선택 */
		$(".all_check_input").click(function(){
			
			if($(this).prop("checked")){
				$(".cart_checkbox_input").prop("checked",true);
			}else{
				$(".cart_checkbox_input").prop("checked",false);
			}
			
			setTotalInfo();
			
		});
		
		/* 종합 정보 섹션 함수 */
		function setTotalInfo(){

			let priceTotal = 0; //총 가격
			let countTotal = 0; //총 갯수
			let kindTotal = 0; //총 종류
			let deliveryPrice = 0; //배송비
			let priceTotalFinal = 0; //최종가격
			
			$(".cart_info_td").each(function(idx,data){
				
				if($(data).find(".cart_checkbox_input").is(":checked") === true){
					//foreach로 인해 순회하는 데이터 각각의 태그 value값을 추가시켜서 종합한다.
					priceTotal += parseInt($(data).find(".product_price_total_input").val());
					countTotal += parseInt($(data).find(".product_count_input").val());
					kindTotal += 1;	
				}
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
			$(".countTotal_span").text(countTotal);
			$(".kindTotal_span").text(kindTotal);
			$(".deliveryPrice_span").text(deliveryPrice);
			$(".priceTotalFinal_span").text(priceTotalFinal);
	
		}
				
	});
</script>
 
<style>

.content_subject h4{

	text-align : center;
	
}
.th_width_1{
	width : 20px;
}
.th_width_2{
	width : auto;
}
.th_width_3,.th_width_4,.th_width_6{
	width : 150px;
}
.th_width_7,.th_width_5{
	width : 100px;
}
.subject_table tr th,.subject_table tr td{
	text-align : center;
	vertical-align : middle;
	padding-right: 0;
}
.subject_table tr th{
	background-color: #e1e5e8;
}
.subject_table {
	width: auto;
	margin : 0 auto;
}
.content_total_section{
	margin : 30px auto;
}
.total_wrap{
	background-color: #e1e5e8;
	max-width : 770px;
	width : 100%;
	margin : 0 auto;
	font-size : 12px;
}
.total_wrap table{
	margin-bottom : 0;
}
.total_wrap td{
				width : 50%;
				padding : 5px 5px 5px 10px;
			}
			.priceTotalFinal_span{
				color: #854A72;
				font-size: 17px;
				font-weight: bold;
			}
			.total_tr1 {
				border-bottom : none;
			}
			.total_tr2 {
				border-top : none;
				border-bottom : none;
			}
			.total_tr3 {
				border-top : none;
			}
		.content_btn_section{
	 		margin-top: 20px;
	 		text-align: right;
		}
	 	.content_btn_section a{
	    	color: #fefeff;
		    background-color: #3366ff;
		    min-width: 100px;
	    	padding: 5px 10px;
		    display: inline-block;
		    font-size: 14px;
		    font-weight: bold;
		    text-align: center;
		    margin-right: 14px;
		}
.image_wrap{
	width : 100px;
	margin : 0 auto;
}
.image{
	width : auto;
	vertical-align: middle;
}


</style>

			<div class="content_subject"><h4>장바구니</h4></div>
			<!-- 장바구니 리스트 -->
			<div class="content_middle_section"></div>
			<!-- 장바구니 가격 합계 -->
			<!-- cartInfo -->
			<div class="content_totalCount_section">
				<div class="all_check">
					<input type="checkbox" class="all_check_input" checked="checked">
					<span class="all_check_span">전체선택</span>
				</div>
				<table class="subject_table">
					<thead>
						<tr>
							<th class="th_width_1"></th>
							<th class="th_width_2"></th>
							<th class="th_width_3">상품명</th>
							<th class="th_width_4">가격</th>
							<th class="th_width_5">수량</th>
							<th class="th_width_6">합계</th>
							<th class="th_width_7">삭제</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${cartInfo}" var="ci">
							<tr>
								<td class="td_width_1 cart_info_td">
									<input type="checkbox" class="cart_checkbox_input" checked="checked">
									<input type="hidden" class="product_price_input" value="${ci.product_price}">
									<input type="hidden" class="product_count_input" value="${ci.product_count}">
									<input type="hidden" class="product_price_total_input" value="${ci.product_price_total}">
								</td>
								<td class="td_width_2">
									<div class="image_wrap" data-product_id="${ci.image.product_id}" data-path="${ci.image.uploadPath}" data-uuid="${ci.image.uuid}" data-filename="${ci.image.fileName}">											
										<img class="image">
									</div>
								</td>
								<td class="td_width_3">${ci.product_name}</td>
								<td class="td_width_4 price_td">
									<fmt:formatNumber value="${ci.product_price}" pattern="#,#### 원"/>
								</td>
								<td>
									<div class="product_count">
										${ci.product_count}
									</div>
									<a class="product_count_modify_btn">변경</a>
								</td>
								<td>${ci.product_price_total}</td>
								<td><button>삭제</button></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<!-- 가격 종합 -->
			<div class="content_total_section">
				<div class="total_wrap">
								<table>
									<tr class="total_tr1">
										<td>총 상품 가격</td>
										<td>
											<span class="priceTotal_span"></span> 원
										</td>
									</tr>
									<tr class="total_tr2">
										<td>배송비</td>
										<td>
											<span class="deliveryPrice_span"></span>원
										</td>
									</tr>									
									<tr class="total_tr3">
										<td>총 주문 상품수</td>
										<td>
											<span class="kindTotal_span"></span>종
											<span class="countTotal_span"></span>개
										</td>
									</tr>
									<tr class="total_tr4">
										<td>
											<strong>총 결제 예상 금액</strong>
										</td>
										<td>
											<span class="priceTotalFinal_span"></span> 원
										</td>
									</tr>
								</table>
				</div>
			</div>
			<!-- 구매 버튼 영역 -->
			<div class="content_btn_section">
				<a>주문하기</a>
			</div>
<%@ include file="../includes/footer.jsp" %>
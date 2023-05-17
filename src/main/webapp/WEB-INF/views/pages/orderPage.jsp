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
		
		var o_id = "${member_info.member_id}" + new Date().getTime();
		
		$(".order_btn").click(function(){
			
			/* 주소정보 & 받는이 */
			$(".address_info_input_div").each(function(i,obj){
				
				if($(obj).find(".address_select").val() === 'T'){
					$("input[name='receiver']").val($(obj).find(".receiver_input").val());
					$("input[name='member_address1']").val($(obj).find(".address_input_1").val());
					$("input[name='member_address2']").val($(obj).find(".address_input_2").val());
					$("input[name='member_address3']").val($(obj).find(".address_input_3").val());
					
				}				
			});
			
			
			
			var o_amount = parseInt($(".priceTotalFinal_span").text());
			var m_email = "${member_info.member_email}";
			var m_name = "${member_info.member_name}";
			var m_tel = "${member_info.member_phone}";
			var m_addr = $("input[name='member_address2']").val() + $("input[name='member_address3']").val();
			var m_postcode = $("input[name='member_address1']").val();
			
			requestPay(o_id,o_amount,m_email,m_name,m_tel,m_addr,m_postcode);
	
		});
		

		
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
		
		//결제창 스크롤 따라 움직이기
		 var currentPosition = parseInt($(".total_info_div").css("top"));
		  $(window).scroll(function() {
		    var position = $(window).scrollTop(); 
		    $(".total_info_div").stop().animate({"top":position+currentPosition+"px"},800);
		  });
		
	});
	
	
	/* 주소 입력만 버튼 동작(숨김, 등장) */
	function showAddress(className){
		/* 컨텐츠 동작 */
			/* 모두 숨기기 */
			$(".address_info_input_div").css('display','none');
		
			/* 컨테츠 보이기 */
			$(".address_info_input_div_" + className).css('display' , 'block');
		/* 버튼 색상 변경 */
			/* 모든 색상 동일 */
				$(".address_btn").css('backgroundColor','#555');
			/* 지정 색상 변경 */
				$(".address_btn"+className).css('backgroundColor','#3c3838');
		/* 주소 정보 선택 T/F */
			/* 모든 주소 정보 F만들기 */
				$(".address_info_input_div").each(function(i, obj){
					$(obj).find(".address_select").val("F");
				});
			/* 선택한 주소 정보 T만들기 */
				$(".address_info_input_div_"+className).find(".address_select").val("T");
	}
	
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
	
	//다음 주소 api 연동
	function daum_address_api(){
		new daum.Postcode({
			oncomplete: function(data){
				   // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    // 주소변수 문자열과 참고항목 문자열 합치기
                    addr += extraAddr;
                
                } else {
                    addr += ' ';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                $(".address_input_1").val(data.zonecode);
                $(".address_input_2").val(addr);
                // 상세주소 입력한 disabled 속성 변경 및 커서를 상세주소 필드로 이동한다.
                $(".address_input_3").attr("readonly",false);
                $(".address_input_3").focus();
			}
		}).open();
	}
	
	/* 결제 api 연동 portone */
	var IMP = window.IMP; 
	IMP.init("imp53218561"); // 예: imp00000000a

	function requestPay(o_id,o_amount,m_email,m_name,m_tel,m_addr,m_postcode) {
	    IMP.request_pay({
	      pg: "INIpayTest",
	      pay_method: "card",
	      merchant_uid: o_id,   // 주문번호
	      name: "상품 결제",
	      amount: o_amount,     // 숫자 타입
	      buyer_email: m_email,
	      buyer_name: m_name,
	      buyer_tel: m_tel,
	      buyer_addr: m_addr,
		  buyer_postcode: m_postcode
	    }, function (rsp) { // callback
	      //rsp.imp_uid 값으로 결제 단건조회 API를 호출하여 결제결과를 판단합니다.
	    	if(rsp.success){
	   		  console.log(rsp);
	  		/* 상품정보 */
				let form_contents = '';
				$(".products_table_price_td").each(function(idx,data){
					
					let product_id = $(data).find(".product_id_input").val();
					let product_count = $(data).find(".product_count_input").val();
					let product_price = $(data).find(".product_price_input").val();
					let product_name = $(data).find(".product_name_input").val();
					
					
					let product_id_input = "<input name='orders["+idx+"].product_id' type='hidden' value='" + product_id + "'>";
					form_contents += product_id_input;
					
					let product_count_input = "<input name='orders["+idx+"].product_count' type='hidden' value='" + product_count + "'>";
					form_contents += product_count_input;
					
					let product_price_input = "<input name='orders["+idx+"].product_price' type='hidden' value='" + product_price + "'>";
					form_contents += product_price_input;

					let product_name_input = "<input name='orders["+idx+"].product_name' type='hidden' value='" + product_name + "'>";
					form_contents += product_name_input;
					
				});
				
				
				//오더 아이디값 설정
				let order_id = "<input name='order_id' type='hidden' value='"+ rsp.merchant_uid +"'>";
				form_contents += order_id;
				
				$(".order_form").append(form_contents);
				
				/* 서버 전송 */
				$(".order_form").submit();
	   		  }else {
	   		  console.log(rsp);
	   		  alert("결제 실패");
	   		  
	   	  }
	    });
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
	vertical-align: middle;
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
	margin : 0 auto;
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
	padding: 10px 0;
}
.strong_red{
	color: red;
}
.total_price_red{
	font-size: 25px;
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
.address_info_input_div_2 .address_input_1,.address_input_2,.address_input_3{
	width: 75%;
}
.address_info_input_div th{
	vertical-align: middle;
}

 
</style>

	<div class="content_subject"><h4>상품주문</h4></div>
	
	<div class="content_main">
		<!-- 회원정보 -->
		<div class="member_info_div">
			<table class="member_info_table">
				<tbody>
					<tr>
						<th style="width: 25%;">주문자</th>								
						<td style="width: 75%">${member_info.member_name} | ${member_info.member_email}</td>						
					</tr>
				</tbody>
			</table>
		</div>
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
						<td>${ol.product_name}</td>
						<td class="products_table_price_td">
							<fmt:formatNumber value="${ol.product_price}" pattern="#,### 원" /> | 수량 ${ol.product_count}개
							<br>
							<fmt:formatNumber value="${ol.product_price_total}" pattern="#,### 원" />
							<input type="hidden" class="product_price_input" value="${ol.product_price}">
							<input type="hidden" class="product_count_input" value="${ol.product_count}">
							<input type="hidden" class="product_priceTotal_input" value="${ol.product_price * ol.product_count}">
							<input type="hidden" class="product_id_input" value="${ol.product_id}">
							<input type="hidden" class="product_name_input" value="${ol.product_name}">
						</td>
					</tr>							
				</c:forEach>
			</tbody>
		</table>
	</div>
		<!-- 배송지 -->
		<div class="address_info_div">				
			<div class="address_info_button_div">
				<button class="address_btn address_btn_1" onclick="showAddress('1')" style="background-color: #3c3838;">사용자 정보 주소록</button>
				<button class="address_btn address_btn_2" onclick="showAddress('2')">직접 입력</button>
			</div>
			<div class="address_info_input_div_wrap">
				<div class="address_info_input_div address_info_input_div_1" style="display: block">
						<table>
			<colgroup>
				<col width="25%">
				<col width="*">
			</colgroup>
			<tbody>
				<tr>
					<th>이름</th>
					<td>
						${member_info.member_name}
					</td>
				</tr>
				<tr>
					<th>주소</th>
					<td>
						${member_info.member_address.member_address1} ${member_info.member_address.member_address2}<br>${member_info.member_address.member_address3}
						<input class="address_select" value="T" type="hidden">
						<input class="receiver_input" value="${member_info.member_name}" type="hidden">
						<input class="address_input_1" type="hidden" value="${member_info.member_address.member_address1}"> 
						<input class="address_input_2" type="hidden" value="${member_info.member_address.member_address2}">
						<input class="address_input_3" type="hidden" value="${member_info.member_address.member_address3}">										
					</td>
				</tr>
			</tbody>
		</table>
				</div>
				<div class="address_info_input_div address_info_input_div_2">
					<table>
						<colgroup>
							<col width="25%">
							<col width="*">
						</colgroup>
						<tbody>
							<tr>
								<th>이름</th>
								<td>
									<input class="addressee_input">
								</td>
							</tr>
							<tr>
								<th>주소</th>
								<td>
									<input class="address_select" value="F" type="hidden">	
									<input class="address_input_1" readonly="readonly"> <a class="address_search_btn" onclick="daum_address_api()">주소 찾기</a><br>
									<input class="address_input_2" readonly="readonly"><br>
									<input class="address_input_3" readonly="readonly">
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
				<div class="total_info_div">
					<!-- 가격 종합 정보 -->
					<div class="total_info_price_div">
						<ul>
							<li>
								<span class="price_span_label">상품 금액</span>
								<span class="priceTotal_span"></span>원
							</li>
							<li>
								<span class="price_span_label">배송비</span>
								<span class="deliveryPrice_span"></span>원
								
							</li>
							<li class="price_total_li">
								<strong class="price_span_label total_price_label" >최종 결제 금액</strong>
								<strong class="strong_red">
									<span class="priceTotalFinal_span"></span>원
								</strong>
							</li>
						</ul>
					</div>
					<!-- 버튼 영역 -->
					<div class="total_info_btn_div">
						<a class="order_btn">결제하기</a>
					</div>
				</div>
		<!-- 주문 요청 form -->
		<form class="order_form" action="/pages/order" method="post">
			<!-- 주문자 회원번호 -->
			<input name="member_id" value="${member_info.member_id}" type="hidden">
			<!-- 주소록 & 받는이 -->
			<input name="receiver" type="hidden">
			<input name="member_address1" type="hidden">
			<input name="member_address2" type="hidden">
			<input name="member_address3" type="hidden">
			<!-- 상품 정보는 동적으로 추가해준다 ! -->
		</form>	
	</div>
			
<%@ include file="includes/footer.jsp" %>
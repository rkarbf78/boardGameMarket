<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<!-- 다음주소 api -->
<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>

<script>

var IMP = window.IMP; 
IMP.init("imp53218561"); // 예: imp00000000a
function requestPay() {
	IMP.request_pay({
	  pg: "INIpayTest",
	  pay_method: "card",
	  merchant_uid: "50505050-0000011",   // 주문번호
	  name: "노르웨이 회전 의자",
	  amount: 2000,                         // 숫자 타입
	  buyer_email: "gildong@gmail.com",
	  buyer_name: "홍길동",
	  buyer_tel: "010-4242-4242",
	  buyer_addr: "서울특별시 강남구 신사동",
	  buyer_postcode: "01181"
	}, function (rsp) { // callback
	  //rsp.imp_uid 값으로 결제 단건조회 API를 호출하여 결제결과를 판단합니다.
	  if(rsp.success){
		  console.log(rsp);
	  }else {
		  console.log(rsp);
	  }
	});
	}
	  
</script>
<body>
<button onclick="requestPay()">결제 테스트</button>
</body>
</html>
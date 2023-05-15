<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>BOARD GAME MARKET(BGM)</title>
<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
<link rel='stylesheet' href='/resources/css/woocommerce-layout.css' type='text/css' media='all'/>
<link rel='stylesheet' href='/resources/css/woocommerce-smallscreen.css' type='text/css' media='only screen and (max-width: 768px)'/>
<link rel='stylesheet' href='/resources/css/woocommerce.css' type='text/css' media='all'/>
<link rel='stylesheet' href='/resources/css/font-awesome.min.css' type='text/css' media='all'/>
<link rel='stylesheet' href='/resources/style.css' type='text/css' media='all'/>
<link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Oswald:400,500,700%7CRoboto:400,500,700%7CHerr+Von+Muellerhoff:400,500,700%7CQuattrocento+Sans:400,500,700' type='text/css' media='all'/>
<link rel='stylesheet' href='/resources/css/easy-responsive-shortcodes.css' type='text/css' media='all'/>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Satisfy&display=swap">

</head>

<script>
	$(document).ready(function(){
		
		
		$("#logout_button").click(function(){
			$.ajax({
				type : "POST",
				url : "/pages/logout",
				success : function(data){
					alert("로그아웃 성공");
					document.location.reload();
				}
			});
		});
		
		
		let searchForm = $('#searchForm');
		
		//상품 검색 버튼 동작
		$("#searchForm img").click(function(e){
			
			console.log(${page_category_code});
		
			e.preventDefault();
			
			//검색 키워드 유효성 검사
			if(!searchForm.find("input[name='keyword']").val()){
				alert("키워드를 입력해주세요");
				return false;
			}
			
			searchForm.find("input[name='pageNum']").val("1");
			
			searchForm.submit();
			
		});
	});
</script>

<body class="home page page-template page-template-template-portfolio page-template-template-portfolio-php">

<!-- 로그인 안했을시에만 나타나게함 -->
<c:if test="${member == null}">
<div class="userButton">
	<a href="/pages/loginPage" class="button-login">로그인</a>
	<a href="/pages/joinPage" class="button-signup">회원가입</a>
</div>
</c:if>
<c:if test="${member != null}">
	<div class="user_info">
		<span>회원 : ${member.member_name}</span>
		<a id="logout_button">로그아웃</a>
		<a href="/pages/cartPage/${member.member_id}" id="cart_button">장바구니</a>
		<a href="/pages/orderListPage/${member.member_id}" id="orderList_button">주문조회</a>
	</div>
</c:if>

<div id="page">
	<div class="container">
		<header id="masthead" class="site-header">
		<div class="site-branding">
			<h1 class="site-title"><a href="/pages/mainPage" rel="home">BGM</a></h1>
			<h2 class="site-description">BOARD GAME MARKET</h2>
		</div>
		<div class="site-header-content">
			<nav id="site-navigation" class="main-navigation">
			<button class="menu-toggle">메뉴</button>
			<div class="menu-menu-1-container">
				<ul id="menu-menu-1" class="menu">
					<li><a href="/pages/mainPage">전체상품</a></li>
					<c:forEach items="${categoryList}" var="category">
					<li class="cate_li">
						<a href="/pages/mainPage?page_category_code=${category.category_code}">${category.category_name}</a>	
					</li>
					</c:forEach>
					<c:if test="${member.member_role == 1}">
						<li><a href="/pages/admin/adminPage">관리자 페이지</a>
							<ul class="sub-menu">
								<li><a href="/pages/admin/productListPage">상품관리</a></li>
								<li><a href="/pages/admin/registerPage">상품등록</a></li>
								<li><a href="/pages/admin/memberListPage">회원관리</a></li>
							</ul>
						</li>
					</c:if>
				</ul>
			</div>
			</nav>
			<form id="searchForm" action="" method="get"> <!-- action 생략시 현재페이지에 요청함! -->
				<div class="search_input">
					<input type="text" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"></c:out>'  placeholder="검색어 입력">
					<input type="hidden" name="pageNum" value='<c:out value="${pageMaker.cri.pageNum}"></c:out>'>
					<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
					<img class="btn search_btn_icon" src="https://s3.ap-northeast-2.amazonaws.com/cdn.wecode.co.kr/icon/search.png">
				</div>
			</form>
		</div>
		</header>
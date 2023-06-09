<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../includes/header.jsp" %>

<script>
	$(document).ready(function(){
		
		if(${modify_result == 1}){
			alert("수정이 완료되었습니다.");
		}
		if(${register_result == 1}){
			alert("등록이 완료되었습니다.");
		}
		if(${remove_result == 1}){
			alert("삭제가 완료되었습니다.");
		}
		
		//list에 담긴 이미지 꺼내기 작업
		$(".list_image_wrap").each(function(i,obj){
			
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
		
		
		//페이지 이동
		let moveForm = $('#moveForm');
		
		$(".page-numbers a").click(function(e){
			
			e.preventDefault();
			
			moveForm.find("input[name='pageNum']").val($(this).attr("href"));
			
			moveForm.submit();
		});
		
		//상품 디테일 페이지 이동 , 페이지넘버,어마운트,키워드,아이디 같이 보냄
		$('.products_table tbody tr').click(function(e) {
			
			e.preventDefault();
			
			let addInput = '<input type="hidden" name="product_id" value="'+$(this).find('.find_id').attr("value")+'">';
			
			moveForm.append(addInput);
			
			moveForm.attr("action","/pages/admin/productDetailPage");
			
			moveForm.submit();

		});
		
		
		//재고 기준 이하일시 CSS
		$(".list_data").each(function(idx,data){
			var stockVal = $(this).find(".stock_data").val();
			if(stockVal <= 20){
				$(this).find("td").eq(4).css("color" , "red");
			}
		});
		
		//재고 많은순 조회시 화살표 CSS
		if(${pageMaker.cri.order_by == 'stock_high'}){
			$(".fa-sort-down").css("display" , "block");
			$(".fa-sort-up").css("display" , "none");
		}
		
		//재고 많은순 조회
		$(".fa-sort-up").click(function(){
			
			moveForm.find("input[name='order_by']").val("stock_high");
			
			moveForm.attr("action","/pages/admin/productListPage");
			
			moveForm.submit();
			
		});
		
		//재고 적은순 조회
		$(".fa-sort-down").click(function(){
				
			moveForm.find("input[name='order_by']").val("stock_row");
			
			moveForm.attr("action","/pages/admin/productListPage");
			
			moveForm.submit();
			
		});
		
	}); //다큐멘트레디 끝
</script>
<style>
.pageMaker{
	list-style: none;
	display: inline-block;
	margin : 0 auto;
	position : relative;
}
.pageMaker li{
	display : inline;
}
#searchForm{
	display : block;
}
.list_image_wrap{
	width : 100px;
	margin : 0 auto;
	height: 100%;
}
.list_image{
	width : 100%;
	vertical-align: middle;
	height: 100px;
}
.products_table tr td{
	text-align : center;
	vertical-align : middle;
	padding-right: 0;
	border-left : 1px solid #ccc;
	border-right : 1px solid #ccc; 
}
.th_column_1,.th_column_5{
	width : 70px;
}
.th_column_2,.th_column_3{
	width : 150px;
}
.th_column_6,.th_column_7{
	width : 100px;
}
.th_column_4{
	width : 120px;
}
.th_column_8{
	width : 130px;
}
.products_table tbody tr{
	height : 100%;
	max-height : 120px;
	cursor: pointer;
}
.products_table tbody tr:hover{
	background:#ffff99;
}
.products_table {
	width: auto;
	margin : 0 auto;
}
.admin_page_name{
	text-align : center;
}
.products_table thead td{
	background-color : #e1e5e8;
	font-weight: bold;
}
.products_table thead tr{
	height: 50px;
}
.fa-sort-up,.fa-sort-down{
	color: #888888;
	position: absolute;
}
.fa-sort-up{
	display: block;
	right: 5px;
	bottom: 12px;
	cursor: pointer;
}
.fa-sort-down{
	display: none;
	bottom: 19px;
	right: 5px;
	cursor: pointer;
}
.th_column_5 i{
	font-size: 20px;
}
.th_column_5 {
	position: relative;
}
.admin_nav_1,.admin_page{
	color : black;
}
</style>
	   <!-- </header> -->
			<div class="admin_nav_list">
				<ul>
					<li><a href="/pages/admin/productListPage" class="admin_nav_1">상품 관리</a></li>
					<li><a href="/pages/admin/registerPage" class="admin_nav_2">상품 등록</a></li>
					<li><a href="/pages/admin/memberListPage" class="admin_nav_3">회원 관리</a></li>
				</ul>
			</div>
			<div id="content" class="site-content">
				<div id="primary" class="content-area column full">
					<h4 class="admin_page_name">상품 관리 페이지</h4>
					<c:if test="${productListCheck != 'empty'}">
						<div class="products_table_wrap">
	                    	<table class="products_table">
	                    		<thead>
	                    			<tr>
										<td class="th_column_1">번호</td>
										<td class="th_column_2">이미지</td>
	                    				<td class="th_column_3">상품 이름</td>
	                    				<td class="th_column_4">가격</td>
	                    				<td class="th_column_5">재고<i class="fa fa-sort-up"></i><i class="fa fa-sort-down"></i></td>
	                    				<td class="th_column_6">총 판매량</td>
	                    				<td class="th_column_7">카테고리</td>
	                    				<td class="th_column_8">등록 날짜</td>
	                    			</tr>
	                    		</thead>	
	                    		<c:forEach items="${productList}" var="list">
	                    				<tr class="list_data">
	                    					<td>
	                    						<input class="find_id" type="hidden" value='<c:out value="${list.product_id}"/>'>
	                    						<c:out value="${list.product_id}"></c:out>
	                    					</td>
	                    					<td>
	                    						<div class="list_image_wrap" data-product_id="${list.image.product_id}" data-path="${list.image.uploadPath}" data-uuid="${list.image.uuid}" data-filename="${list.image.fileName}">											
													<img class="list_image">
												</div>
											</td>
			                    			<td><c:out value="${list.product_name}"></c:out></td>
			                    			<td><c:out value="￦ ${list.product_price}"></c:out></td>
			                    			<td><c:out value="${list.product_stock}"></c:out><input type="hidden" class="stock_data" value="${list.product_stock}"></td>
			                    			<td><c:out value="${list.product_sell}"></c:out></td>
			                    			<c:forEach items="${categoryList}" var="category">
			                    				<c:if test="${list.product_category_code == category.category_code}">
			                    					<td><c:out value="${category.category_name}"></c:out></td>
			                    				</c:if>
			                    			</c:forEach>
			                    			<td><fmt:formatDate value="${list.product_regDate}" pattern="yyyy-MM-dd"/></td>
			                    		</tr>
	                    		</c:forEach>
	                    	</table>
						</div>
						<nav class="pagination">
							<div class="pageMaker_wrap">
								<ul class="pageMaker">
									<c:if test="${pageMaker.prev}">
										<li class="prev page-numbers">
											<a href="${pageMaker.pageStart - 1}">이전</a>
										</li>
									</c:if>	
									<c:forEach begin="${pageMaker.pageStart}" end="${pageMaker.pageEnd}" var="num">
										<li class="page-numbers ${pageMaker.cri.pageNum == num ? "current" : ""}">
											<a href="${num}">${num}</a>
									</c:forEach>		
									<c:if test="${pageMaker.next}">
										<li class="next page-numbers">
											<a href="${pageMaker.pageEnd + 1}">다음</a>
										</li>
									</c:if>
								</ul>
							</div>
						</nav>
						<form id="moveForm" action="" method="get">  <!-- action 생략시 현재페이지에 요청함! -->
							<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
							<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
							<input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">
							<input type="hidden" name="order_by" value="${pageMaker.cri.order_by}">										
						</form>	
					</c:if>
					<c:if test="${productListCheck == 'empty'}">
						<div class="data_empty">
							등록된 상품이 없습니다.
						</div>
					</c:if>
				</div>
			</div>
		</div><!-- header.jsp container 끝 -->
<%@ include file="../includes/footer.jsp" %>
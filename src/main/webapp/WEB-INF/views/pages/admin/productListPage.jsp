<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../includes/header.jsp" %>

<script>
	$(document).ready(function(){
		
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
		
	});
</script>

<style>
.image_wrap {
	width : 100%;
	height : 100%;
}
.image_wrap img {
	max-width : 85%;
	height : auto;
	display : block;
	margin : 0 auto;	
}
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
}
.list_image{
	width : auto;
	height: auto;
}
.products_table tr td{
	text-align : center;
	vertical-align : middle;
	width : auto;
}
.products_table tbody tr{
	height: 140px;
}

</style>
	<div class="admin_nav_list">
		<ul>
			<li><a href="/pages/admin/productListPage" class="admin_nav_1">상품 관리</a></li>
			<li><a href="/pages/admin/registerPage" class="admin_nav_2">상품 등록</a></li>
			<li><a href="" class="admin_nav_3">유저 관리</a></li>
		</ul>
	</div>
		<!-- #masthead -->
		<div id="content" class="site-content">
			<div id="primary" class="content-area column full">
					<c:if test="${productListCheck != 'empty'}">
						<div class="products_table_wrap">
	                    	<table class="products_table">
	                    		<thead>
	                    			<tr>
										<td class="th_column_1">상품 번호</td>
										<td class="th_column_2">상품 이미지</td>
	                    				<td class="th_column_3">상품 이름</td>
	                    				<td class="th_column_4">상품 가격</td>
	                    				<td class="th_column_5">상품 재고</td>
	                    				<td class="th_column_6">상품 판매량</td>
	                    				<td class="th_column_7">카테고리</td>
	                    				<td class="th_column_8">등록 날짜</td>
	                    			</tr>
	                    		</thead>	
	                    		<c:forEach items="${productList}" var="list">
	                    		<tr>
	                    			<td><c:out value="${list.product_id}"></c:out></td>
	                    			<td>
	                    				<div class="list_image_wrap" data-product_id="${list.image.product_id}" data-path="${list.image.uploadPath}" data-uuid="${list.image.uuid}" data-filename="${list.image.fileName}">											
											<img class="list_image">
										</div>
									</td>
	                    			<td><c:out value="${list.product_name}"></c:out></td>
	                    			<td><c:out value="￦ ${list.product_price}"></c:out></td>
	                    			<td><c:out value="${list.product_stock}"></c:out></td>
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
					<form id="moveForm" action="/pages/admin/productListPage" method="get">
						<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
						<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
						<input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">					
					</form>	
					</c:if>
					<c:if test="${productListCheck == 'empty'}">
						<div class="data_empty">
							등록된 상품이 없습니다.
						</div>
					</c:if>			

			
			</div>
				<!-- #primary -->
		</div>
			<!-- #content -->
	</div>
		<!-- .container -->
<%@ include file="../includes/footer.jsp" %>
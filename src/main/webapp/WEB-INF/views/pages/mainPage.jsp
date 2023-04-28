<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="includes/header.jsp" %>

<script>
	$(document).ready(function(){
		
		//list에 담긴 이미지 꺼내기 작업
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
</style>

		<!-- #masthead -->
		<div id="content" class="site-content">
			<div id="primary" class="content-area column full">
				<main id="main" class="site-main">
					<c:if test="${productListCheck != 'empty'}">
						<div class="grid portfoliogrid">
						<c:forEach var="list" items="${productList}">
							<article class="hentry">
								<header class="entry-header">
									<div class="image_wrap" data-product_id="${list.image.product_id}" data-path="${list.image.uploadPath}" data-uuid="${list.image.uuid}" data-filename="${list.image.fileName}">
										<div class="entry-thumbnail">	
											<a href="detailPage?product_id=${list.product_id}" class="moveDetail"><img></a>
										</div>
									</div>
									<div class="entry-info">
										<h2 class="entry-title">${list.product_name}</h2>
										<p>${list.product_price} 원</p>
									</div>				
								</header>	
							</article>	
					</c:forEach>
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
					<form id="moveForm" action="/pages/mainPage" method="get">
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
				</main>
					<!-- #main -->
			</div>
				<!-- #primary -->
		</div>
			<!-- #content -->
	</div>
		<!-- .container -->
<%@ include file="includes/footer.jsp" %>
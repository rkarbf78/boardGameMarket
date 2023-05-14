<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="includes/header.jsp" %>

<script>
	$(document).ready(function(){
		
		/* 카테고리 선택한 메인페이지에서 검색시 
		header.jsp에 있는 검색 이벤트 발생시 카테고리값 유지하기위해 메인에 작성
		header.jsp에 작성하면 다른 페이지에서 값이없다고 오류발생하기 떄문 */
		let searchForm = $('#searchForm');
		
		if(${page_category_code != null}){
			searchForm.append("<input type='hidden' name='page_category_code' value="+${page_category_code}+">");	
		}
		
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
		
		
		//페이지 이동
		let moveForm = $('#moveForm');
		
		$(".page-numbers a").click(function(e){
			
			e.preventDefault();
			
			moveForm.find("input[name='pageNum']").val($(this).attr("href"));
			
			moveForm.submit();
		});
		
		//상품 디테일 페이지 이동
		$('.entry-thumbnail').click(function(e) {
			
			e.preventDefault();
			
			let testid = $(".find_id").val();
			
			console.log(testid);
			
			let addInput = '<input type="hidden" name="product_id" value="'+$(this).find('.find_id').attr("value")+'">';
			
			moveForm.append(addInput);
			
			moveForm.attr("action","/pages/detailPage");
			
			moveForm.submit();

		});
		
		$(".product_order_by a").click(function(e){
			e.preventDefault();
			
			let addInput = '<input type="hidden" name="order_by" value="'+$(this).attr("href")+'">';
			
			moveForm.append(addInput);
						
			moveForm.submit();

		});
		
		$(".entry-header").each(function(idx,data){
			
			const product_id_for_reply = $(this).find(".find_id").val();
			const starDiv = $(this).find(".entry-star");
			
			//전체 리뷰 별점 평균값 부여하기 (상품이름 쪽)
			$.getJSON("/pages/reply/rating" , {product_id : product_id_for_reply} , function(obj){
				
				var starTotal = 0;
				var starAvg = 0.0;
			//레이팅 총합 구하기
			for(let i = 0; i<obj.length; i++){
				starTotal += obj[i];
			}
			//레이팅 평균 구하기 (소수점 둘째자리 버리기)
			starAvg = starTotal / obj.length;
			starAvg = starAvg * 10;
			starAvg = Math.round(starAvg);
			starAvg = starAvg / 10;
			
			var starAvgTag = '';
			for(var i=0; i<5; i++){
				if(i<Math.floor(starAvg)){
					starAvgTag += "<i class='fa fa-star'></i>";
				}else if(i === Math.floor(starAvg)){
					switch((starAvg*10)-(Math.floor(starAvg)*10)){ //2진법 미세오류로 인해 조금 복잡한 계산식으로 적용함
						case 0: case 1: case 2: case 3:
							starAvgTag += "<i class='fa fa-star-o'></i>";	
							break;
						case 4: case 5: case 6: case 7:
							starAvgTag += "<i class='fa fa-star-half-full'></i>";
							break;
						case 8: case 9:
							starAvgTag += "<i class='fa fa-star'></i>";
							break;
					}
				}else{
					starAvgTag += "<i class='fa fa-star-o'></i>";	
				}
			}
			starAvgTag += "(" + obj.length + ")";
			starDiv.html(starAvgTag);
			});
			
		});	
	});
</script>

<style>
.image_wrap {
	width : 100%;
	height : 100%;
	cursor: pointer;
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

<div class="product_order_by">
		<ul>
			<li><a href="new" class="order_nav_1">신상품순</a></li>
			<li><a href="best" class="order_nav_2">인기상품순</a></li>
			<li><a href="high" class="order_nav_3">높은가격순</a></li>
			<li><a href="row" class="order_nav_4">낮은가격순</a></li>
		</ul>
	</div>
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
											<input class="find_id" type="hidden" value='<c:out value="${list.product_id}"/>'>	
											<img class="product_image">
										</div>
									</div>
									<div class="entry-info">
										<div class="entry-title">
											<h4>${list.product_name}</h4>
										</div>
										<div class="entry-star">r</div>
										<div class="entry-category">
											<c:forEach items="${categoryList}" var="category">
												<c:if test="${list.product_category_code == category.category_code}">
													<p>${category.category_name}</p>
												</c:if>
											</c:forEach>
										</div>
										<div class="entry-price">
											<p>${list.product_price} 원</p>
										</div>
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
									<li class="page-numbers ${pageMaker.cri.pageNum == num ? 'current' : ''}">
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
						<input type="hidden" name="page_category_code" value="${page_category_code}">											
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
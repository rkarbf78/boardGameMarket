<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../includes/header.jsp" %>

<script type="text/javascript">

$(document).ready(function(){
	
	//이미지 정보 호출
	let product_id = '<c:out value="${product.product_id}"/>';
	let uploadResult = $("#uploadResult");
	
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
	
	$("#list_button").click(function(e){
		e.preventDefault();
		$("#moveForm").attr("action","/pages/admin/productListPage");
		$("#moveForm").submit();
	});
	
	$("#modify_button").click(function(e){
		e.preventDefault();
		$("#moveForm").attr("action","/pages/admin/productModifyPage");
		$("#moveForm").submit();
	})
	
	
	
});
</script>
<style type="text/css">
#result_card img {
	width : 100%;
}
#uploadResult{
	width : 250px;
}
.category_select{
	width : 30%;
	height : 35px;
	font-size : 18px;
	text-align : center;
}
.name_wrap,.price_wrap,.info_wrap,.stock_wrap,.sell_wrap,.category_wrap,.img_wrap,.updateDate_wrap,.regDate_wrap{
	margin-bottom : 21px;
}
.category_select_wrap{
	margin-top : 2px
}
#modify_button{
	background : #3366ff; 
	border : 1px solid #3366ff;
}
#remove_button{
	background : #ff3333;
	border : 1px solid #ff3333;
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
			<div id="secondary" class="column third">
				<div class="widget-area">
					<aside class="widget">
						<h4 class="widget-title">상품 조회</h4>
							<div class="wpcf7">
							<div class="form">
								<div class="img_wrap">
									<div class="form_section_title">
										<label>상품 이미지</label>
									</div>
									<div class="form_section_content">
										<div id="uploadResult">
										</div>
									</div>
								</div>
								<div class="name_wrap">
									<label>상품이름</label>
									<input type="text" name="product_name" value="${product.product_name}" readonly>
									<span class="check_warn product_name_warn">상품이름을 입력해주세요.</span>
								</div>
								<div class="price_wrap">
									<label>상품가격</label>
									<input type="text" name="product_price" value="${product.product_price}" readonly>
									<span class="check_warn product_price_warn">상품가격을 입력해주세요.</span>
								</div>
								<div class="info_wrap">
									<label>상품정보</label>
									<textarea name="product_info" rows="5" readonly>${product.product_info}</textarea>
									<span class="check_warn product_info_warn">상품정보를 입력해주세요.</span>
								</div>
								<div class="category_wrap">
									<label>상품 카테고리</label>
									<div class="category_select_wrap">
									<select class="category_select" name="product_category_code">
										<option selected value ="${product.product_category_code}">
											<c:forEach items="${categoryList}" var="category">
												<c:if test="${product.product_category_code == category.category_code}">
													${category.category_name}
												</c:if>
											</c:forEach>
											
										</option>
									</select>
									</div>
									<span class="check_warn product_category_warn" id="product_category_warn">상품 카테고리를 선택해주세요.</span>
								</div>
								<div class="stock_wrap">
									<label>상품재고</label>
									<input type="text" name="product_stock" value="${product.product_stock}" readonly>
									<span class="check_warn product_stock_warn">상품재고를 입력해주세요.</span>
								</div>
								<div class="sell_wrap">
									<label>판매수량</label>
									<input type="text" name="product_sell" value="${product.product_sell}" readonly>
									<span class="check_warn product_sell_warn">상품 판매수량을 입력해주세요.</span>
								</div>
								<div class="updateDate_wrap">
									<label>최근 수정 날짜</label>
									<input type="text" name="product_updateDate" value="<fmt:formatDate value="${product.product_updateDate}" pattern="yyyy-MM-dd"/>" readonly/>
								</div>
								<div class="regDate_wrap">
									<label>최초 등록 날짜</label>
									<input type="text" name="product_regDate" value="<fmt:formatDate value="${product.product_regDate}" pattern="yyyy-MM-dd"/>" readonly/>
								</div>
								<div class="button_section">
									<input type="button" id="modify_button" value="수정">
									<input type="button" id="remove_button" value="삭제">
									<input type="button" id="list_button" value="목록">
								</div>
							</div>
							</div>
							
							<form id="moveForm" action="" method="get">  <!-- action 생략시 현재페이지에 요청함! -->
								<input type="hidden" name="pageNum" value="${cri.pageNum}">
								<input type="hidden" name="amount" value="${cri.amount}">
								<input type="hidden" name="keyword" value="${cri.keyword}">
								<input type="hidden" name="product_id" value="${product.product_id}">				
							</form>	
						<div class="done">								
							Your message has been sent. Thank you!
						</div>
					</aside>
				</div>
			</div>
		</div>
		<!-- #content -->
	</div>
	<!-- .container -->
<%@ include file="../includes/footer.jsp" %>
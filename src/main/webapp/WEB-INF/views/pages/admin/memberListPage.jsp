<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../includes/header.jsp" %>

<script>
	$(document).ready(function(){
		
		if(${remove_result == 1}){
			alert("삭제가 완료되었습니다.");
		}
		
		//페이지 이동
		let moveForm = $('#moveForm');
		
		$(".page-numbers a").click(function(e){
			
			e.preventDefault();
			
			moveForm.find("input[name='pageNum']").val($(this).attr("href"));
			
			moveForm.submit();
		});
		
		//상품 디테일 페이지 이동 , 페이지넘버,어마운트,키워드,아이디 같이 보냄
		$('.members_table tbody tr').click(function(e) {
			
			e.preventDefault();
			
			let addInput = '<input type="hidden" name="member_id" value="'+$(this).find('.find_id').attr("value")+'">';
			
			moveForm.append(addInput);
			
			moveForm.attr("action","/pages/admin/memberDetailPage");
			
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
	vertical-align: middle;
}
.members_table tr td{
	text-align : center;
	vertical-align : middle;
	padding-right: 0;
	border-left : 1px solid #ccc;
	border-right : 1px solid #ccc; 
}
.th_column_1{
	width : 150px;
}
.th_column_2{
	width : 100px;
}
.th_column_3{
	width : 150px;
}
.th_column_4{
	width : 300px;
}
.th_column_5{
	width : 100px;
}
.th_column_6{
	width : 100px;
}
.members_table tbody tr{
	height: auto;
	cursor: pointer;
}
.members_table tbody tr:hover{
	background:#ffff99;
}
.members_table {
	width: auto;
	margin : 0 auto;
}
.admin_page_name{
	text-align : center;
}
.members_table thead td{
	background-color : #e1e5e8;
	font-weight: bold;
}



</style>
	<div class="admin_nav_list">
		<ul>
			<li><a href="/pages/admin/productListPage" class="admin_nav_1">상품 관리</a></li>
			<li><a href="/pages/admin/registerPage" class="admin_nav_2">상품 등록</a></li>
			<li><a href="/pages/admin/memberListPage" class="admin_nav_3">회원 관리</a></li>
		</ul>
	</div>
		<!-- #masthead -->
		<div id="content" class="site-content">
			<div id="primary" class="content-area column full">
				<h4 class="admin_page_name">회원 관리 페이지</h4>
					<c:if test="${memberListCheck != 'empty'}">
						<div class="members_table_wrap">
	                    	<table class="members_table">
	                    		<thead>
	                    			<tr>
										<td class="th_column_1">아이디</td>
										<td class="th_column_2">이름</td>
	                    				<td class="th_column_3">전화번호</td>
	                    				<td class="th_column_4">주소</td>
	                    				<td class="th_column_5">권한</td>
	                    				<td class="th_column_6">가입일</td>
	                    			</tr>
	                    		</thead>	
	                    		<c:forEach items="${memberList}" var="list">
	                    				<tr>
	                    					<td>
	                    						<input class="find_id" type="hidden" value='<c:out value="${list.member_id}"/>'>
	                    						<c:out value="${list.member_id}"></c:out>
	                    					</td>
			                    			<td><c:out value="${list.member_name}"></c:out></td>
			                    			<td><c:out value="${list.member_phone}"></c:out></td>
			                    			<td><c:out value="${list.member_address.member_address1}"></c:out></td>
			                    			<c:choose>
			                    				<c:when test="${list.member_role == 1}">
			                    					<td><c:out value="관리자"></c:out></td>
			                    				</c:when>
			                    				<c:otherwise>
			                    					<td><c:out value="일반회원"></c:out></td>
			                    				</c:otherwise>
			                    			</c:choose>
			    	               			<td><fmt:formatDate value="${list.member_regDate}" pattern="yyyy-MM-dd"/></td>
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
					</form>	
					</c:if>
					<c:if test="${membeListCheck == 'empty'}">
						<div class="data_empty">
							등록된 회원이 없습니다.
						</div>
					</c:if>			

			
			</div>
				<!-- #primary -->
		</div>
			<!-- #content -->
	</div>
		<!-- .container -->
<%@ include file="../includes/footer.jsp" %>
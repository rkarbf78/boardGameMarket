<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../includes/header.jsp" %>

<script type="text/javascript">

$(document).ready(function(){
	
	
	$("#list_button").click(function(e){
		e.preventDefault();
		$("#moveForm").attr("action","/pages/admin/memberListPage");
		$("#moveForm").submit();
	});
	
	$("#remove_button").click(function(e){
		e.preventDefault();
		$("#moveForm").attr("action","/pages/admin/memberRemove");
		$("#moveForm").attr("method","POST");
		$("#moveForm").submit();
	});
	
	
	
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
.id_wrap,.name_wrap,.email_wrap,.phone_wrap,.address_wrap,.role_wrap,.updateDate_wrap,.regDate_wrap{
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
.address_input_2_wrap,.address_input_1_wrap,.mail_input_box {
	margin : 0 0 0.5em 0;
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
			<div id="secondary" class="column third">
				<div class="widget-area">
					<aside class="widget">
						<h4 class="widget-title">회원 조회</h4>
							<div class="wpcf7">
							<div class="form">
								<div class="id_wrap">
									<label>아이디</label>
									<input type="text" name="member_id" value="${member.member_id}" readonly>
								</div>
								<div class="name_wrap">
									<label>이름</label>
									<input type="text" name="member_name" value="${member.member_name}" readonly>
								</div>
								<div class="email_wrap">
									<label>이메일</label>
									<input type="text" name="member_email" value="${member.member_email}" readonly>
								</div>
								<div class="phone_wrap">
									<label>전화번호</label>
									<input type="text" name="member_phone" value="${member.member_phone}" readonly>
								</div>
								<div class="address_wrap">
									<div class="address_name">주소</div>
									<div class="address_input_1_wrap">
										<div class="address_input_1_box">
											<input type="text" name="address.member_address1" value="${member.member_address.member_address1}" readonly>
										</div>		
										<div class="clearfix"></div>
									</div>
									<div class ="address_input_2_wrap">
										<div class="address_input_2_box">
											<input type="text" name="address.member_address2" value="${member.member_address.member_address2}" readonly>
										</div>
									</div>
									<div class ="address_input_3_wrap">
										<div class="address_input_3_box">
											<input type="text" name="address.member_address3" value="${member.member_address.member_address3}" readonly>										
										</div>
									</div>
								</div>
								<div class="role_wrap">
									<label>권한</label>
									<div class="role_select_wrap">
			                   			<select class="category_select" name="member_role">
										<c:choose>
			                    			<c:when test="${member.member_role == 1}">
			  									<option selected>관리자
											</c:when>
		                    				<c:otherwise>
		                    					<option selected>일반회원
		                    				</c:otherwise>
			                   			</c:choose>											
									</select>
									</div>
								</div>
								<div class="updateDate_wrap">
									<label>최근 수정 날짜</label>
									<input type="text" name="member_updateDate" value="<fmt:formatDate value="${member.member_updateDate}" pattern="yyyy-MM-dd"/>" readonly/>
								</div>
								<div class="regDate_wrap">
									<label>최초 등록 날짜</label>
									<input type="text" name="member_regDate" value="<fmt:formatDate value="${member.member_regDate}" pattern="yyyy-MM-dd"/>" readonly/>
								</div>
								<div class="button_section">
									<input type="button" id="remove_button" value="삭제">
									<input type="button" id="list_button" value="목록">
								</div>
							</div>
							</div>
							<form id="moveForm" action="" method="get">  <!-- action 생략시 현재페이지에 요청함! -->
								<input type="hidden" name="pageNum" value="${cri.pageNum}">
								<input type="hidden" name="amount" value="${cri.amount}">
								<input type="hidden" name="keyword" value="${cri.keyword}">
								<input type="hidden" name="member_id" value="${member.member_id}">				
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
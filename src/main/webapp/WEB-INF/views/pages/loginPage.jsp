<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="includes/header.jsp" %>

<script>
	$(document).ready(function(){
		$(".login_button").click(function(){
			alert("로그인 버튼 작동");
			$("#login_form").attr("action","/pages/login");
			$("#login_form").submit();
		});
	});
</script>

<style>
.login {
	border:0;
	margin:8em 0 25em 0;
	padding:0;
	word-wrap:break-word;
}

.column.login {
	width : 45%;
	margin : 0 auto;
}
.id_wrap,.password_wrap {
	margin-bottom : 21px;
}
.login_warn{
	margin-top : 30px;
	text-align : center;
	color : red; 
}
</style>

		<!-- #masthead -->
		<div id="content" class="site-content">						
			<div id="secondary" class="column login">
				<div class="login-area">
					<aside class="login">
						<h4 class="login-title">로그인 페이지</h4>
						<form class="wpcf7" method="post" action="" id="login_form">
							<div class="login_wrap">
								<div class="id_wrap">
									<div class="id_name">아이디</div>
									<input type="text" name="member_id">
								</div>
								<div class="password_wrap">
									<div class="password_name">비밀번호</div>
									<input type="password" name="member_password">
								</div>
								<c:if test="${loginResult == 0}">
								<div class="login_warn">사용자 ID 또는 비밀번호를 잘못 입력하셨습니다.</div>
								</c:if>
								<div class="login_button_wrap">
									<input type="button" class="login_button" id="login_button" value="로그인">
								</div>
							</div>
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
<%@ include file="includes/footer.jsp" %>
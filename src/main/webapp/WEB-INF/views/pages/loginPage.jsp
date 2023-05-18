<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="includes/header.jsp" %>

<script>
	$(document).ready(function(){
		
		console.log($(".find_idpw_2").css("display") == "block");
		
		
		
		$(".login_button").click(function(){
			$("#login_form").attr("action","/pages/login");
			$("#login_form").submit();
		});
		//모달 보이기
		$(".find_idpw_modal_btn").click(function(){
			$("#myModal").show();
		});
		//모달 내리기
		$(".modal_close").click(function(){
			$("#myModal").hide();
		});
	
		var emailCode = ""; //이메일전송 인증번호 저장위한 변수
		
		//유효성 검사 통과유무 변수
		var id_check = false;
		var name_check = false;
		var phone_check = false;
		var mail_check = false;
		var mail_code_check = false;
		
		//회원가입 버튼 동작
		$(".modal_search").click(function(){
			
			if($(".find_idpw_1").css("display") == "block"){
				var name = $(".name_input").val();
				var phone = $(".phone_input").val();
			
				//이름 유효성 검사
				if(name == ""){
					$(".final_name_ck").css("display","block");
					name_check = false;
				}else{
					$(".final_name_ck").css("display","none");
					name_check = true;
				}
				//전화번호 유효성 검사
				if(phone == ""){
					$(".final_phone_ck").css("display","block");
					phone_check = false;
				}else{
					$(".final_phone_ck").css("display","none");
					phone_check = true;
				}
				//최종 유효성 검사
				if(name_check && phone_check){
					alert("아디찾기 테스트 완료");
					searchData = {member_name:name ,member_phone:phone}
					$.ajax({
						url : "/pages/idSearch",
						data : searchData,
						type : "GET",
						success : function(result){
							console.log(result);
							var searchResult = '';
							if(result != ''){
								searchResult += "<div class='modal_close'>";
								searchResult += "<i class='fa fa-times'></i></div>"
								searchResult += "<p>검색된 아이디는 "+result+" 입니다.</p>";
								$(".modal-content").html(searchResult);
							}else{
								searchResult += "<div class='modal_close'>";
								searchResult += "<i class='fa fa-times'></i></div>"
								searchResult += "<p>검색된 아이디가 없습니다.</p>";
								$(".modal-content").html(searchResult);
							}
						}
					});
				}
				return false;
			}else if ($(".find_idpw_2").css("display") == "block") {
				//입력값 변수화
				var id = $(".id_input").val();
				var mail = $(".mail_input").val();
				
				//아이디 유효성 검사
				if(id == ""){
					$(".final_id_ck").css("display","block");
					id_check = false;
				}else{
					$(".final_id_ck").css("display","none");
					id_check = true;
				}
				//이메일 유효성 검사
				if(mail == ""){
					$(".final_mail_ck").css("display","block");
					mail_check = false;
				}else{
					$(".final_mail_ck").css("display","none");
					mail_check = true;
				}
				//최종 유효성 검사
				if(id_check && mail_check && mail_code_check){
					alert("비번찾기 테스트 완료");
					searchData = {member_id : id , member_email : mail}
					$.ajax({
						url : "/pages/pwSearch",
						data : searchData,
						type : "GET",
						success : function(result){
							console.log(result);
							var searchResult = '';
							if(result == '1'){
								searchResult += "<div class='modal_close'>";
								searchResult += "<i class='fa fa-times'></i></div>"
								searchResult += "<p>입력하신 이메일로 임시비밀번호를 송신했습니다. 확인후 로그인해주세요.</p>";
								$(".modal-content").html(searchResult);
							}else{
								searchResult += "<div class='modal_close'>";
								searchResult += "<i class='fa fa-times'></i></div>";
								searchResult += "<p>조회된 정보가 없습니다.</p>";
								$(".modal-content").html(searchResult);
							}
						}
					});
				}
				return false;
			}else{
				alert("오류발생");
			}	
		});
		
		//인증번호 이메일 전송
		$(".mail_check_button").click(function(){
			
			var email = $(".mail_input").val(); //입력한 이메일
			var checkBox = $(".mail_check_input"); //인증번호 입력란
			var boxWrap = $(".mail_check_input_box"); //인증번호 입력란 박스
			var warnMsg = $(".mail_input_box_warn"); //이메일 형식 입력 경고
			
			//이메일 형식 확인 로직
			if(mailFormCheck(email)){
				warnMsg.html("이메일이 전송 되었습니다. 이메일을 확인해주세요.");
				warnMsg.css("color","green");
				warnMsg.css("display","inline-block");
			}else{
				warnMsg.html("올바르지 못한 이메일 형식입니다.");
				warnMsg.css("color","red");
				warnMsg.css("display","inline-block");
				return false;
			}
			
			$.ajax({
				type:"GET",
				url:"/pages/mailCheck",
				data:{"email" : email},
				success:function(data){
					checkBox.attr("disabled",false);
					boxWrap.attr("id","mail_check_input_box_true");
					emailCode = data;
				}
			});
		});
		
		
		//인증번호 비교
		$(".mail_check_input").blur(function(){
			
			var inputCode = $(".mail_check_input").val(); //입력코드
			var checkResult = $("#mail_check_input_box_warn"); //비교결과
			
			if(inputCode == emailCode){
				checkResult.html("인증번호가 일치합니다.");
				checkResult.attr("class","correct");
				mail_code_check = true;
			}else {
				checkResult.html("인증번호를 다시 확인해주세요.");
				checkResult.attr("class","incorrect");
				mail_code_check = false;
			}
		});

		function mailFormCheck(email){
			var form = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
			return form.test(email);
		}

		
		
	}); //다큐멘트 끝@@@@@@@@@@@@@@@@@@@@@@@
	
	
	/* 아이디 또는 비번찾기 동작(숨김, 등장) */
	function showFindIdpw(className){
		/* 컨텐츠 동작 */
			/* 모두 숨기기 */
			$(".find_idpw").css('display','none');
		
			/* 컨테츠 보이기 */
			$(".find_idpw_" + className).css('display' , 'block');
		/* 버튼 색상 변경 */
			/* 모든 색상 동일 */
				$(".find_idpw_btn").css('backgroundColor','#999');
			/* 지정 색상 변경 */
				$(".find_idpw_btn_"+className).css('backgroundColor','#3c3838');
		/* 주소 정보 선택 T/F */
			}
	

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
.join_btn{
	float : left;
	margin-left: 5px;
	margin-top : 10px;
}
.find_idpw_modal_btn{
	float : right;
	margin-right: 5px;
	margin-top : 10px;
	cursor: pointer;
}
.find_idpw_btn{
	background-color: #999;
    color: white;
}
.find_idpw_btn_1{
	width : 50%;
	float : left;
	padding: 5px 0;
	margin-top: 10px;

}
.find_idpw_btn_2{
	width : 50%;
	float : left;
	padding: 5px 0;
	margin-top: 10px;

}

   /* The Modal (background) */
.modal {
            display: none; /* Hidden by default */
            position: fixed; /* Stay in place */
            z-index: 1; /* Sit on top */
            left: 0;
            top: 0;
            width: 100%; /* Full width */
            height: 100%; /* Full height */
            overflow: auto; /* Enable scroll if needed */
            background-color: rgb(0,0,0); /* Fallback color */
            background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
        }
    
        /* Modal Content/Box */
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto; /* 15% from the top and centered */
            padding: 20px;
            border: 1px solid #888;
            width: 30%; /* Could be more or less, depending on screen size */                       
        }
.find_idpw{
	display: none;
}
.find_idpw_1,.find_idpw_2{
	width: 80%;
	margin-top : 58px;
	margin-left: auto;
	margin-right: auto;
}
.find_idpw_1 input,.find_idpw_2 input{
	width: 100%;
}
.findId_name_input,.findPw_id_input{
	margin-bottom: 10px;
}
.find_idpw_select_div{
	position: relative;
}
.modal_close{
	cursor:pointer;
	text-align: right;
	margin-top: -20px;
	position: absolute;
	right: -18px;
}
.modal_close .fa{
	color: black;
}
.modal_close i{
	font-size: 25px;
}
.modal_search{
	margin-top : 30px;
	margin-left : auto;
	margin-right : auto;
	cursor:pointer;
	color : #fff;
	background-color:#3366ff;
	text-align: center;
	padding : 5px 0;
	width: 80%;
}
/* 인증번호 일치여부 색상 top*/
.correct{
	color : green;
}
.incorrect{
	color : red;
}
.mail_check_button{
    border: 1px solid #4d4d4d;
    border-color:#4d4d4d;
    background:#4d4d4d;
    color:#fff;
    width: auto;
    float: right;
    text-align: center;
    cursor: pointer;
    margin-top: 10px;
    height: 39.19px;
    vertical-align: middle;
}
#mail_check_input{
	width: 58%;
	margin-top: 10px;
}
.final_mail_ck,.final_id_ck,.final_name_ck,.final_phone_ck{
	display : none;
	color: red;
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
						<div class="join_btn"><a href="/pages/joinPage">회원가입</a></div>
						<div class="find_idpw_modal_btn">아이디/비밀번호 찾기</div>
					</aside>
				</div>
			</div>
		</div>
		 <div id="myModal" class="modal">
		      <!-- Modal content -->
		      <div class="modal-content">    
			    <div class="find_idpw_select_div">
			     <div class="modal_close">
			     	<i class="fa fa-times"></i>
			     </div>
					<button class="find_idpw_btn find_idpw_btn_1" onclick="showFindIdpw('1')" style="background-color: #3c3838;">아이디 찾기</button>
					<button class="find_idpw_btn find_idpw_btn_2" onclick="showFindIdpw('2')">비밀번호 찾기</button>
				</div>  
		      	<div class="find_idpw_div_wrap">
					<div class="find_idpw find_idpw_1" style="display: block">
						<div class="findId_name">
							이름
						</div>
						<div class="findId_name_input">
							<input type="text" name="member_name" class="name_input"/>
						</div>
						<span class="final_name_ck">이름을 입력해주세요.</span>
						<div class="findId_phone">
							전화번호
						</div>
						<div class="findId_phone_input">
							<input type="text" name="member_phone" class="phone_input" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" placeholder="- 빼고 입력해 주세요"/>
						</div>
						<span class="final_phone_ck">전화번호를 입력해주세요.</span>
					</div>
					<div class="find_idpw find_idpw_2">
						<div class="findPw_id">
							아이디
						</div>
						<div class="findPw_id_input">
							<input type="text" name="member_id" class="id_input"/>
						</div>
						<span class="final_id_ck">아이디를 입력해주세요.</span>
							<div class="mail_wrap">
									<div class="mail_name">이메일</div> 
									<div class="mail_input_box">
										<input type="text" name="member_email" class="mail_input">
									</div>
									<span class="final_mail_ck">이메일을 입력해주세요.</span>
									<span class="mail_input_box_warn"></span>
									<div class="mail_check_wrap">
										<button class="mail_check_button">
											인증번호 전송
										</button>
										<div class="mail_check_input_box"  id="mail_check_input_box_false">
											<input type="text" class="mail_check_input" id="mail_check_input" disabled="disabled" placeholder="인증번호 입력칸">
										</div>
										<div class="clearfix"></div>
										<span id="mail_check_input_box_warn"></span>
									</div>
								</div>
					</div>
				</div>
				 <div class="modal_search">
			     	<span>조회</span>
			     </div>
		      </div>	 
	    </div>
        <!--End Modal-->
		<!-- #content -->
	</div>
	<!-- .container -->
<%@ include file="includes/footer.jsp" %>
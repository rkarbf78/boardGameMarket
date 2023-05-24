<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="includes/header.jsp" %>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>


<script type="text/javascript">

var password_check = true;
var password_same_check = true;
var password_same_exact_check = true;
var phone_check = false;
var mail_check = false;
var mail_code_check = true;
var address_check = false;

$(document).ready(function(){
	
	$(".email_change_button").click(function(){
		$(".mail_input").removeAttr("readonly");
		$(".mail_input").focus();
		$(".mail_check_wrap").css("display","block");
		$(this).css("display" , "none");
		$(".email_change_button2").css("display","block");
		mail_code_check = false;
	});
	$(".email_change_button2").click(function(){
		$(".mail_input").attr("readonly");
		$(".mail_input").blur();
		$(".mail_check_wrap").css("display","none");
		$(this).css("display" , "none");
		$(".email_change_button").css("display","block");
		mail_code_check = true;
	});
	$(".password_change_button").click(function(){
		password_check = false;
		password_same_check = false;
		password_same_exact_check = false;
		$(this).css("display" , "none");
		$(".password_change_button2").css("display","block");
		$(".password_wrap").css("display","block");
		$(".origin_password").removeAttr("name");
		$(".new_password").attr("name","member_password");
		$(".new_password").focus();
	});
	$(".password_change_button2").click(function(){
		$(this).css("display" , "none");
		$(".password_change_button").css("display","block");
		$(".password_wrap").css("display","none");
		$(".new_password").removeAttr("name");
		$(".origin_password").attr("name","member_password");
	});
	
	
	$("#modify_button").click(function(){
		 
		//입력값 변수화
		var pw = $(".new_password").val();
		var pw_check = $(".new_password_check").val();
		var phone = $(".phone_input").val();
		var mail = $(".mail_input").val();
		var addr = $(".address_input_3").val();
	
		if($(".password_wrap").css("display") == "block"){
			//비밀번호 유효성 검사
			if(pw == ""){
				$(".final_pw_ck").css("display","block");
				password_check = false;
			}else{
				$(".final_pw_ck").css("display","none");
				password_check = true;
			}
			//비밀번호 확인 유효성 검사
			if(pw_check == ""){
				$(".final_pwck_ck").css("display","block");
				password_same_check = false;
			}else{
				$(".final_pwck_ck").css("display","none");
				password_same_check = true;
			}	
		}
		
		//전화번호 유효성 검사
		if(phone == ""){
			$(".final_phone_ck").css("display","block");
			phone_check = false;
		}else{
			$(".final_phone_ck").css("display","none");
			phone_check = true;
		}
		//이메일 유효성 검사
		if(mail == ""){
			$(".final_mail_ck").css("display","block");
			mail_check = false;
		}else{
			$(".final_mail_ck").css("display","none");
			mail_check = true;
		}
		//주소 유효성 검사
		if(addr == ""){
			$(".final_addr_ck").css("display","block");
			address_check = false;
		}else{
			$(".final_addr_ck").css("display","none");
			address_check = true;	
		}
		
		console.log(password_check);
		console.log(password_same_check);
		console.log(password_same_exact_check);
		console.log(mail_check);
		console.log(mail_code_check);
		console.log(address_check);

		//최종 유효성 검사
		if(password_check && password_same_check && password_same_exact_check && phone_check && mail_check && mail_code_check && address_check){
			$("#modify_form").attr("action","/pages/memberModify");
			$("#modify_form").submit();
		}
		
		return false;
		
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
	/* 비밀번호 확인 일치 유효성 검사 */
	$(".new_password_check").on("propertychange change keyup paste input",function(){
		var pw = $(".new_password").val();
		var pwck = $(".new_password_check").val();
		$(".final_pwck_ck").css("display","none");
		
		if(pw==pwck){
			$(".pwck_input_re_1").css("display","block");
			$(".pwck_input_re_2").css("display","none");
			password_same_exact_check = true;
		}else{
			$(".pwck_input_re_1").css("display","none");
			$(".pwck_input_re_2").css("display","block");
			password_same_exact_check = false;
		}
	});
	
	
	
	
	
}); // 다큐멘트 끝

function mailFormCheck(email){
	var form = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
	return form.test(email);
}

//다음 주소 api 연동
function daum_address_api(){
	new daum.Postcode({
		oncomplete: function(data){
			   // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ''; // 주소 변수
            var extraAddr = ''; // 참고항목 변수

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if(data.userSelectedType === 'R'){
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                }
                // 주소변수 문자열과 참고항목 문자열 합치기
                addr += extraAddr;
            
            } else {
                addr += ' ';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            $(".address_input_1").val(data.zonecode);
            $(".address_input_2").val(addr);
            // 상세주소 입력한 disabled 속성 변경 및 커서를 상세주소 필드로 이동한다.
            $(".address_input_3").attr("readonly",false);
            $(".address_input_3").focus();
		}
	}).open();
}


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
.id_wrap,.name_wrap,.mail_wrap,.phone_wrap,.address_wrap,.password_wrap{
	margin-bottom : 21px;
}
.mail_check_input_box,.address_input_1_box,.mail_input_box{
	width : 68%;
}
.final_id_ck,.final_pw_ck,.final_pwck_ck,.final_phone_ck,.final_mail_ck,.final_addr_ck{
	display : none;
	color: red;
}
.pwck_input_re_1{
	color : green;
	display : none;
}
.pwck_input_re_2{
	color : red;
	display : none;
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
.mail_check_button,.address_button,.email_change_button{
    border: 1px solid #4d4d4d;
    border-color:#4d4d4d;
    background:#4d4d4d;
    color:#fff;
    height: 47.19px;
    width: 30%;
    float: right;
    line-height: 50px;
    text-align: center;
    font-size: 12px;
    font-weight: 900;
    cursor: pointer;
    margin : 0;
}
.email_change_button2{
  border: 1px solid #4d4d4d;
    border-color:#4d4d4d;
    background:#fff;
    color:#4d4d4d;
    height: 47.19px;
    width: 30%;
    float: right;
    line-height: 50px;
    text-align: center;
    font-size: 12px;
    font-weight: 900;
    cursor: pointer;
    margin : 0;
}
.password_change_button{
	border: 1px solid #4d4d4d;
    border-color:#4d4d4d;
    background:#4d4d4d;
    color:#fff;
    height: 47.19px;
    width: 30%;
    line-height: 50px;
    text-align: center;
    font-size: 12px;
    font-weight: 900;
    cursor: pointer;
    margin-bottom: 21px;
}
.password_change_button2{
	border: 1px solid #4d4d4d;
    border-color:#4d4d4d;
    background:#fff;
    color:#4d4d4d;
    height: 47.19px;
    width: 30%;
    line-height: 50px;
    text-align: center;
    font-size: 12px;
    font-weight: 900;
    cursor: pointer;
    margin-bottom: 21px;
}
.mail_check_wrap,.email_change_button2,.password_wrap,.password_change_button2{
	display: none;
}
.correct{
	color : green;
}
.incorrect{
	color : red;
}
</style>
		<!-- #masthead -->
		<div id="content" class="site-content">						
			<div id="secondary" class="column third">
				<div class="widget-area">
					<aside class="widget">
						<h4 class="widget-title">회원 정보변경</h4>
							<div class="wpcf7">
								<form class="wpcf7" method="post" action="" id="modify_form">
							<div class="form">
								<div class="id_wrap">
									<label>아이디</label>
									<input type="text" name="member_id" value="${member.member_id}" readonly>
								</div>
								<div class="password_change_button">
									<span>비밀번호 변경하기</span>
								</div>
									<div class="password_change_button2">
									<span>변경 취소하기</span>
								</div>
								<div class="password_wrap">
									<input class="origin_password" type="hidden" value="${member.member_password}" name="member_password">
									<label>신규 비밀번호 입력</label>
									<input class="new_password" type="text" value="">
									<span class="final_pw_ck">비밀번호를 입력해주세요.</span>
									<label>신규 비밀번호 확인</label>
									<input class="new_password_check" type="text" value="">
									<span class="final_pwck_ck">비밀번호 확인을 입력해주세요.</span>
									<span class="pwck_input_re_1">비밀번호가 일치합니다.</span>
									<span class="pwck_input_re_2">비밀번호가 일치하지 않습니다.</span>
								</div>
								<div class="name_wrap">
									<label>이름</label>
									<input type="text" name="member_name" value="${member.member_name}" readonly>
								</div>
								<div class="mail_wrap">
									<div class="mail_name">이메일</div> 
									<div class="email_change_button">
											<span>이메일 변경하기</span>
										</div>
										<div class="email_change_button2">
											<span>변경 취소하기</span>
										</div>
									<div class="mail_input_box">
										<input type="text" name="member_email" class="mail_input" value="${member.member_email}" readonly>
									</div>			
									<span class="final_mail_ck">이메일을 입력해주세요.</span>
									<span class="mail_input_box_warn"></span>
									<div class="mail_check_wrap">
										<div class="mail_check_button">
											<span>인증번호 전송</span>
										</div>
										<div class="mail_check_input_box"  id="mail_check_input_box_false">
											<input type="text" class="mail_check_input" disabled="disabled" placeholder="인증번호 입력란">
										</div>
										<div class="clearfix"></div>
										<span id="mail_check_input_box_warn"></span>
									</div>
								</div>
								<div class="phone_wrap">
									<label>전화번호</label>
									<input type="text" class="phone_input" name="member_phone" value="${member.member_phone}" >
								</div>
								<span class="final_phone_ck">전화번호를 입력해주세요.</span>
								<div class="address_wrap">
									<div class="address_name">주소</div>
									<div class="address_input_1_wrap">
										<div class="address_button" onclick="daum_address_api()">
											<span>주소지 변경하기</span>
										</div>
										<div class="address_input_1_box">
											<input type="text" name="member_address.member_address1" class="address_input_1" value="${member.member_address.member_address1}" readonly="readonly">
										</div>
						
										<div class="clearfix"></div>
									</div>
									<div class ="address_input_2_wrap">
										<div class="address_input_2_box">
											<input type="text" name="member_address.member_address2" class="address_input_2" value="${member.member_address.member_address2}" readonly="readonly">
										</div>
									</div>
									<div class ="address_input_3_wrap">
										<div class="address_input_3_box">
											<input type="text"name="member_address.member_address3" class="address_input_3" value="${member.member_address.member_address3}" readonly="readonly">
										</div>
									</div>
									<span class="final_addr_ck">주소를 입력해주세요.</span>
								</div>
								</div>
								</form>
								<div class="button_section">
									<input type="button" id="modify_button" value="수정적용">
									<input type="button" id="remove_button" value="회원탈퇴">
									<input type="button" id="list_button" value="취소">
								</div>
							</div>
							</div>
					</aside>
				</div>
			</div>
		</div>
		<!-- #content -->
	</div>
	<!-- .container -->
<%@ include file="includes/footer.jsp" %>
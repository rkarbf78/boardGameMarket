<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="includes/header.jsp" %>

<!-- 다음주소 api -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>

	var emailCode = ""; //이메일전송 인증번호 저장위한 변수
	
	//유효성 검사 통과유무 변수
	var id_check = false;
	var id_duplication_check = false;
	var password_check = false;
	var password_same_check = false;
	var password_same_exact_check = false;
	var name_check = false;
	var phone_check = false;
	var mail_check = false;
	var mail_code_check = false;
	var address_check = false;
	
	$(document).ready(function(){
		//회원가입 버튼 동작
		$(".join_button").click(function(){
 
			//입력값 변수화
			var id = $(".id_input").val();
			var pw = $(".password_input").val();
			var pw_check = $(".password_check_input").val();
			var name = $(".name_input").val();
			var phone = $(".phone_input").val();
			var mail = $(".mail_input").val();
			var addr = $(".address_input_3").val();
			
			//아이디 유효성 검사
			if(id == ""){
				$(".final_id_ck").css("display","block");
				id_check = false;
			}else{
				$(".final_id_ck").css("display","none");
				id_check = true;
			}
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
			//최종 유효성 검사
			if(id_check && id_duplication_check && password_check && password_same_check && password_same_exact_check && name_check && phone_check && mail_check && mail_code_check && address_check){
				$("#join_form").attr("action","/pages/join");
				$("#join_form").submit();
			}
			
			return false;
			
		});
		
		//회원가입 아이디 중복체크
		$(".id_input").on("propertychange change keyup paste input" , function(){
			
			var member_id = $(".id_input").val();
			var data = {member_id:member_id}	
			
			$.ajax({
				type : "post",
				url : "/pages/member_id_check",
				data : data,
				success : function(result){
					if(result != 'fail'){
						$('.id_input_re_1').css("display","inline-block");
						$('.id_input_re_2').css("display","none");
						id_duplication_check = true;
					} else {
						$('.id_input_re_2').css("display","inline-block");
						$('.id_input_re_1').css("display","none");
						id_duplication_check = false;
					}
				}
			});
			
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
		$(".password_check_input").on("propertychange change keyup paste input",function(){
			var pw = $(".password_input").val();
			var pwck = $(".password_check_input").val();
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
	}); //document 끝
	
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

<style>
.mail_check_button,.address_button{
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
.id_wrap,.pw_wrap,.pwck_wrap,.name_wrap,.phone_wrap,.mail_wrap,.address_wrap {
	margin-bottom : 21px;

}
.address_input_2_wrap,.address_input_1_wrap,.mail_input_box {
	margin : 0 0 0.5em 0;
}
.mail_check_input_box,.address_input_1_box{
	width : 68%;
}
#mail_check_input_box_false {
	background-color: #ebebe4;
}
#mail_check_input_box_true {
	background-color: white;
}
/* 인증번호 일치여부 색상 top*/
.correct{
	color : green;
}
.incorrect{
	color : red;
}
/* 인증번호 일치여부 색상 bottom*/
/* 아이디 중복여부 색상 top*/
.id_input_re_1 {
	color : green;
	display : none;
}
.id_input_re_2 {
	color : red;
	display : none;
}
/* 아이디 중복여부 색상 bottom*/

/* 유효성 검사 문구*/
.final_id_ck,.final_pw_ck,.final_pwck_ck,.final_name_ck,.final_phone_ck,.final_mail_ck,.final_addr_ck{
	display : none;
	color: red;
}

/* 비밀번호 확인 일치 유효성검사 top */
.pwck_input_re_1{
	color : green;
	display : none;
}
.pwck_input_re_2{
	color : red;
	display : none;
}
/* 비밀번호 확인 일치 유효성검사 bottom */
.column.third {
	width:65%;
	margin : 0 auto;
}
</style>
	<div id="content" class="site-content">						
			<div id="secondary" class="column third">
				<div class="widget-area">
					<aside class="widget">
						<h4 class="join-title">회원 가입</h4>
						<form class="wpcf7" method="post" id="join_form">
							<div class="form">
							
								<div class="id_wrap">
									<div class="id_name">아이디</div>
									<div class="id_input_box">
										<input type="text" name="member_id" class="id_input" oninput="this.value = this.value.replace(/[ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');">
									</div>
									<span class="id_input_re_1">사용 가능한 아이디입니다.</span>
									<span class="id_input_re_2">아이디가 이미 존재합니다.</span>
									<span class="final_id_ck">아이디를 입력해주세요.</span>
								</div>
								
								<div class="pw_wrap">
									<div class = "pw_name">비밀번호</div>
									<div class="pw_input_box">
										<input type="password" name="member_password" class="password_input">
									</div>
									<span class="final_pw_ck">비밀번호를 입력해주세요.</span>
								</div>
								<div class="pwck_wrap">
									<div class = "pwck_name">비밀번호 확인</div>
									<div class="pwck_input_box">
										<input type="password" name="member_password_check" class="password_check_input">
									</div>
									<span class="final_pwck_ck">비밀번호 확인을 입력해주세요.</span>
									<span class="pwck_input_re_1">비밀번호가 일치합니다.</span>
									<span class="pwck_input_re_2">비밀번호가 일치하지 않습니다.</span>
								</div>
								<div class="name_wrap">
									<div class = "name_name">이름</div>
									<div class="name_input_box">
										<input type="text" name="member_name" class="name_input">
									</div>
									<span class="final_name_ck">이름을 입력해주세요.</span>
								</div>
								<div class="phone_wrap">
									<div class = "phone_name">전화번호</div>
									<div class="phone_input_box">
										<input type="text" name="member_phone" class="phone_input" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" placeholder="- 빼고 입력해 주세요">
									</div>
									<span class="final_phone_ck">전화번호를 입력해주세요.</span>
								</div>
								<div class="mail_wrap">
									<div class="mail_name">이메일</div> 
									<div class="mail_input_box">
										<input type="text" name="member_email" class="mail_input">
									</div>
									<span class="final_mail_ck">이메일을 입력해주세요.</span>
									<span class="mail_input_box_warn"></span>
									<div class="mail_check_wrap">
										<div class="mail_check_button">
											<span>인증번호 전송</span>
										</div>
										<div class="mail_check_input_box"  id="mail_check_input_box_false">
											<input type="text" class="mail_check_input" disabled="disabled">
										</div>
										<div class="clearfix"></div>
										<span id="mail_check_input_box_warn"></span>
									</div>
								</div>
								<div class="address_wrap">
									<div class="address_name">주소</div>
									<div class="address_input_1_wrap">
										<div class="address_button" onclick="daum_address_api()">
											<span>주소 찾기</span>
										</div>
										<div class="address_input_1_box">
											<input type="text" name="member_address.member_address1" class="address_input_1" readonly="readonly">
										</div>
						
										<div class="clearfix"></div>
									</div>
									<div class ="address_input_2_wrap">
										<div class="address_input_2_box">
											<input type="text" name="member_address.member_address2" class="address_input_2" readonly="readonly">
										</div>
									</div>
									<div class ="address_input_3_wrap">
										<div class="address_input_3_box">
											<input type="text"name="member_address.member_address3" class="address_input_3" readonly="readonly">
										</div>
									</div>
									<span class="final_addr_ck">주소를 입력해주세요.</span>
								</div>
							</div>
								<input type="button" class="join_button" id="join_button" value="등록">
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
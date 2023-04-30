<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../includes/header.jsp" %>

<script type="text/javascript">

$(document).ready(function(){
	
	//서버로 부터 전달받은 JSON 데이터를 Javascript 객체로 변환해주는 코드
	let categoryList = JSON.parse('${categoryList}');

	let category_select = $(".category_select");

	for(i of categoryList) {
		category_select.append("<option value='"+i.category_code+"'>" + i.category_name + "</option>");		
	}
	
	// 상품 등록 버튼
	$("#register_button").click(function(){
		
		let product_name_check = false;
		let product_price_check = false;
		let product_info_check = false;
		let product_stock_check = false;
		let product_sell_check = false;
		let product_category_code_check = false;

		let productName = $("input[name='product_name']").val();
		let productPrice = $("input[name='product_price']").val();
		let productInfo = $("textarea[name='product_info']").val();
		let productStock = $("input[name='product_stock']").val();
		let productSell = $("input[name='product_sell']").val();
		let productCategory = $("select[name='product_category_code']").val();

		if(productName == ""){
			$(".product_name_warn").css('display','block');
			product_name_check = false;
		} else {
			$(".product_name_warn").css('display','none');
			product_name_check = true;
		}
		if(productPrice == ""){
			$(".product_price_warn").css('display','block');
			product_price_check = false;
		} else {
			$(".product_price_warn").css('display','none');
			product_price_check = true;
		}
		if(productInfo == ""){
			$(".product_info_warn").css('display','block');
			product_info_check = false;
		} else {
			$(".product_info_warn").css('display','none');
			product_info_check = true;
		}
		if(productStock == ""){
			$(".product_stock_warn").css('display','block');
			product_stock_check = false;
		} else {
			$(".product_stock_warn").css('display','none');
			product_stock_check = true;
		}
		if(productSell == ""){
			$(".product_sell_warn").css('display','block');
			product_sell_check = false;
		} else {
			$(".product_sell_warn").css('display','none');
			product_sell_check = true;
		}
		if(productCategory == "none"){
			$(".product_category_warn").css('display','block');
			product_category_check = false;
		} else {
			$(".product_category_warn").css('display','none');
			product_category_check = true;
		}
		if(product_name_check && product_price_check && product_info_check && product_stock_check && product_sell_check && product_category_check){
			$("#register_form").attr("action","/pages/register");
			$("#register_form").submit();
		}
		return false;
	});
	
	
	//이미지 업로드
	$("input[type='file']").on("change",function(e){
		
		// 이미지 존재시에 삭제함
		if($(".imgDeleteBtn").length > 0){
			deleteFile();
		}
		
		let formData = new FormData();
		let fileInput = $('input[name="uploadFile"]');
		let fileList = fileInput[0].files;
		let fileObj = fileList[0];
		
		let regex = new RegExp("(.*?)\.(jpg|png)$");
		let maxSize = 1048576;
		
		//파일 종류 사이즈 체크 메서드
		function fileCheck(fileName, fileSize){
			if(fileSize >= maxSize){
				alert("파일 사이즈 초과");
				return false;
			}
			if(!regex.test(fileName)){
				alert("해당 종류의 파일은 업로드할 수 없습니다.");
				return false;
			}
			return true;
		}
		
		//업로드 파일 이미지 보여주는 메서드
		function showUploadImage(oneUploadResult){
			if(!oneUploadResult == null){return}
			
			let uploadResult = $("#uploadResult");
			
			let obj = oneUploadResult;
			
			let str = "";
			
			let fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
			
			str += "<div id='result_card'>";
			str += "<img src='/pages/display?fileName=" + fileCallPath + "'>";
			str += "<div class='imgDeleteBtn' data-file='" + fileCallPath + "'>x</div>";
			str += "<input type='hidden' name='image.fileName' value='" + obj.fileName + "'>";
			str += "<input type='hidden' name='image.uuid' value='" + obj.uuid + "'>";
			str += "<input type='hidden' name='image.uploadPath' value='" + obj.uploadPath + "'>";
			str += "</div>";
			
			uploadResult.append(str);
		}
		
		//파일 삭제 메서드
		function deleteFile(){
			let targetFile = $(".imgDeleteBtn").data("file");
			let targetDiv = $("#result_card");
			$.ajax({
				url : '/pages/deleteFile',
				data : {fileName : targetFile},
				dataType : 'text',
				type : 'POST',
				success : function(result){
					console.log(result);
					
					targetDiv.remove();
					$("input[type='file']").val("");
				},
				error : function(result){
					console.log(result);
					alert("파일을 삭제하지 못했습니다.");
				}
			});
		}
		
		//이미지 삭제 버튼 동작
		$("#uploadResult").on("click",".imgDeleteBtn",function(e){
			deleteFile();
		});
		
		if(!fileCheck(fileObj.name,fileObj.size)){
			return false;
		}
		
		//view로 데이터 보내기위한 로직
		formData.append("uploadFile",fileObj);
		$.ajax({
			url:'/pages/uploadAjaxAction',
			processData : false,
			contentType : false,
			data : formData,
			type : 'POST',
			dataType : 'json',
			success : function(result){
				console.log(result);
				showUploadImage(result);
			},
			error : function(result){
				alert("이미지 파일이 아닙니다.");
			}
		});
	});
});
</script>
<style type="text/css">
#result_card img {
	max-width : 100%;
	height : auto;
	display : block;
	padding : 5px;
	margin-top : 10px;
	margin : auto;
}
#result_card {
	position : relative;
}
.imgDeleteBtn {
	position : absolute;
	top : 0;
	right : 5%;
	background-color : #ef7d7d;
	color : wheat;
	font-weight : 900;
	width : 30px;
	height : 30px;
	border-radius : 50%;
	line-height : 26px;
	text-align : center;
	border : none;
	display : block;
	cursor : pointer;
}
.category_select{
	width : 30%;
	height : 35px;
	font-size : 18px;
	text-align : center;
}
.name_wrap,.price_wrap,.info_wrap,.stock_wrap,.sell_wrap,.category_wrap,.img_warp{
	margin-bottom : 21px;
}
.category_select_wrap{
	margin-top : 2px
}

/* 유효성 검사 경고문구 top */
.check_warn{
	display : none;
	padding-top : 2px;
	text-align : center;
	color : red;
	font-weight : 300;
}
#product_category_warn{
	text-align : left;
}
/* 유효성 검사 경고문구 bottom */

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
						<h4 class="widget-title">상품 등록</h4>
						<form class="wpcf7" method="post" action="" id="register_form">
							<div class="form">
								<div class="name_wrap">
									<label>상품이름</label>
									<input type="text" name="product_name" placeholder="Name *">
									<span class="check_warn product_name_warn">상품이름을 입력해주세요.</span>
								</div>
								<div class="price_wrap">
									<label>상품가격</label>
									<input type="text" name="product_price">
									<span class="check_warn product_price_warn">상품가격을 입력해주세요.</span>
								</div>
								<div class="info_wrap">
									<label>상품정보</label>
									<textarea name="product_info" rows="5"></textarea>
									<span class="check_warn product_info_warn">상품정보를 입력해주세요.</span>
								</div>
								<div class="category_wrap">
									<label>상품 카테고리</label>
									<div class="category_select_wrap">
									<select class="category_select" name="product_category_code">
										<option selected value ="none">선택</option>
									</select>
									</div>
									<span class="check_warn product_category_warn" id="product_category_warn">상품 카테고리를 선택해주세요.</span>
								</div>
								<div class="stock_wrap">
									<label>상품재고</label>
									<input type="text" name="product_stock">
									<span class="check_warn product_stock_warn">상품재고를 입력해주세요.</span>
								</div>
								<div class="sell_wrap">
									<label>판매수량</label>
									<input type="text" name="product_sell">
									<span class="check_warn product_sell_warn">상품 판매수량을 입력해주세요.</span>
								</div>
								<div class="img_wrap">
									<div class="form_section_title">
										<label>상품 이미지</label>
									</div>
									<div class="form_section_content">
										<input type="file" id="fileItem" name="uploadFile" style="height:30px;">
										<div id="uploadResult">
										<!-- 	<div id="result_card">
												<div class="imgDeleteBtn">x</div>
												<img src="/pages/display?fileName=test.jpg">
											</div> -->
										</div>
									</div>
								</div>
								<input type="button" id="register_button" class="register_button" value="등록">
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
<%@ include file="../includes/footer.jsp" %>
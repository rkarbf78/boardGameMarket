<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../includes/header.jsp" %>

<script type="text/javascript">

$(document).ready(function(){
	
	//처음 이방식을 사용했으나 다른 페이지들은 model을 통해 데이터를 전달하여
	//header에서 카테고리 데이터를 읽지 못하는 일이 발생함. 그래서 통일시키기위해 변경 2023.05.04
	/* 서버로 부터 전달받은 JSON 데이터를 Javascript 객체로 변환해주는 코드
	let categoryList = JSON.parse('${categoryList}');*/

	// 상품 등록 버튼
	$("#modify_button").click(function(){
		
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
			$("#modify_form").append("<input type='hidden' name='product_id' value='"+${product.product_id}+"'>");
			$("#modify_form").attr("action","/pages/admin/productModify");
			$("#modify_form").submit();
		}
		return false;
	});
	
	// 이미지 불러오기
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
		str += "<div class='imgDeleteBtn' data-file='" + fileCallPath + "'>X</div>";
		str += "<input type='hidden' name='image.fileName' value='" + obj.fileName + "'>";
		str += "<input type='hidden' name='image.uuid' value='" + obj.uuid + "'>";
		str += "<input type='hidden' name='image.uploadPath' value='" + obj.uploadPath + "'>";
		str += "</div>";
		
		uploadResult.html(str);
	
	}).fail(function(){
		
		let str = "";
		str += "<div id='result_card'>";
		str += "<img src='/resources/img/noimg.jpg'>";
		str += "</div>";
		
		uploadResult.html(str);
	});
	
	
	//이미지 업로드
	$("input[type='file']").on("change",function(e){
		
		// 이미지 존재시에 삭제함
		if($("#result_card").length > 0){
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
			
			let fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
			
			str += "<div id='result_card'>";
			str += "<img src='/pages/display?fileName=" + fileCallPath + "'>";
			str += "<div class='imgDeleteBtn' data-file='" + fileCallPath + "'>X</div>";
			str += "<input type='hidden' name='image.fileName' value='" + obj.fileName + "'>";
			str += "<input type='hidden' name='image.uuid' value='" + obj.uuid + "'>";
			str += "<input type='hidden' name='image.uploadPath' value='" + obj.uploadPath + "'>";
			str += "</div>";
			
			uploadResult.append(str);
		}

		
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
	
	//파일 삭제 메서드
	function deleteFile(){
		$("#result_card").remove();
	}
	
	//이미지 삭제 버튼 동작
	$("#uploadResult").on("click",".imgDeleteBtn",function(e){
		deleteFile();
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
.imgDeleteBtn {
	position : absolute;
	top : 0;
	left : 220px;
	background-color : #ef7d7d;
	color : wheat;
	font-weight : 900;
	width : 30px;
	height : 30px;
	border-radius : 50%;
	line-height : 32px;
	letter-spacing : 0;
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
.name_wrap,.price_wrap,.info_wrap,.stock_wrap,.sell_wrap,.category_wrap,.img_wrap{
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
.admin_page{
	color : black;
}
</style>
	   <!-- </header> -->
			<div class="admin_nav_list">
				<ul>
					<li><a href="/pages/admin/productListPage" class="admin_nav_1">상품 관리</a></li>
					<li><a href="/pages/admin/registerPage" class="admin_nav_2">상품 등록</a></li>
					<li><a href="/pages/admin/memberListPage" class="admin_nav_3">회원 관리</a></li>
				</ul>
			</div>
			<div id="content" class="site-content">						
				<div id="secondary" class="column third">
					<div class="widget-area">
						<aside class="widget">
							<h4 class="widget-title">상품 수정</h4>
							<form class="wpcf7" method="post" action="" id="modify_form">
								<div class="form">
									<div class="img_wrap">
										<div class="form_section_title">
											<label>상품 이미지</label>
										</div>
										<div class="form_section_content">
											<input type="file" id="fileItem" name="uploadFile" style="height:30px;">
											<div id="uploadResult">
											</div>
										</div>
									</div>
									<div class="name_wrap">
										<label>상품이름</label>
										<input type="text" name="product_name" value="${product.product_name}">
										<span class="check_warn product_name_warn">상품이름을 입력해주세요.</span>
									</div>
									<div class="price_wrap">
										<label>상품가격</label>
										<input type="text" name="product_price" value="${product.product_price}">
										<span class="check_warn product_price_warn">상품가격을 입력해주세요.</span>
									</div>
									<div class="info_wrap">
										<label>상품정보</label>
										<textarea name="product_info" rows="5">${product.product_info}</textarea>
										<span class="check_warn product_info_warn">상품정보를 입력해주세요.</span>
									</div>
									<div class="category_wrap">
										<label>상품 카테고리</label>
										<div class="category_select_wrap">
										<select class="category_select" name="product_category_code">
											<option value ="none">선택</option>
											<c:forEach items="${categoryList}" var="category">
												<c:choose>
													<c:when test="${product.product_category_code == category.category_code}">
														<option selected value ="${category.category_code}">${category.category_name}</option>		
													</c:when>
													<c:otherwise>
														<option value ="${category.category_code}">${category.category_name}</option>
													</c:otherwise>
												</c:choose>
											</c:forEach>
										</select>
										</div>
										<span class="check_warn product_category_warn" id="product_category_warn">상품 카테고리를 선택해주세요.</span>
									</div>
									<div class="stock_wrap">
										<label>상품재고</label>
										<input type="text" name="product_stock" value="${product.product_stock}">
										<span class="check_warn product_stock_warn">상품재고를 입력해주세요.</span>
									</div>
									<div class="sell_wrap">
										<label>판매수량</label>
										<input type="text" name="product_sell" value="${product.product_sell}">
										<span class="check_warn product_sell_warn">상품 판매수량을 입력해주세요.</span>
									</div>
									<input type="button" id="modify_button" class="modify_button" value="수정 등록">
								</div>
							</form>
						</aside>
					</div>
				</div>
			</div>
		</div><!-- header.jsp container 끝 -->
<%@ include file="../includes/footer.jsp" %>
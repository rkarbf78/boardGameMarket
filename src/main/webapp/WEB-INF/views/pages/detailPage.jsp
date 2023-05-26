<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="includes/header.jsp" %>
<script>
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
		
		//카트 부분 서버로 전송할 데이터
		const cartForm = {
				member_id : '${member.member_id}',
				product_id : '${product.product_id}',
				product_count : ''
		}
		
		//결과값에 따른 창 띄우기 메서드
		function cartAlert(result){
			if(result == '0'){
				alert("장바구니에 추가하지 못했습니다.");
			}else if(result == "1"){
				alert("장바구니에 추가되었습니다.");
			}else if(result == "2"){
				alert("상품이 이미 장바구니에 있습니다.");
			}else if(result =="5"){
				alert("로그인이 필요합니다.");
			}
		}
		
		//장바구니 추가 버튼
		$(".btn_cart").click(function(e){
			cartForm.product_count = $(".quantity_input").val();
			$.ajax({
				url: '/pages/cart/add',
				type: 'POST',
				data: cartForm,
				success: function(result){
					cartAlert(result);
				}
			});
		});
		//댓글 부분 서버로 전송할 데이터
		const replyForm = {
				member_id : '${member.member_id}',
				product_id : '${product.product_id}',
				content : '',
				rating : 0
		}
		
		//댓글 등록 버튼
		$(".btn_reply").click(function(e){
		
			replyForm.content = $("#comment").val();
			replyForm.rating = $("#rating").val();
			console.log(replyForm);
			$.ajax({
				url: '/pages/reply/register',
				type: 'POST',
				data: replyForm,
				success: function(result){
					replyListInit();
					alert(result);
				}
			});
		});
		
		//댓글 불러오기
		
		/* 댓글 페이지정보 */
		const cri = {
				product_id : '${product.product_id}',
				pageNum : 1,
				amount : 10
		}

		$.getJSON("/pages/reply/list" , cri , function(obj){
		
			makeReply(obj);	
				
		});
		
		
		/* 댓글 구현 기능 함수화 */
		
		function makeReply(obj){	
			
			if(obj.reply_list.length === 0){ //등록된 리뷰 없을시
				$(".reply_not_div").html('<span>등록된 리뷰가 없습니다.</span>');
				$(".reply_content_ul").html('');
				$(".pageMaker").html('');
			}else{
				$(".reply_not_div").html('');
				
				const list = obj.reply_list;
				const pi = obj.page_info;
				const member_id = '${member.member_id}';	
			
				
		 	
			/* 댓글 리스트 만드는 부분 */
			
			let reply_list = '';
			
			$(list).each(function(idx,data){
				reply_list += '<li>';
				reply_list += '<div class="comment_wrap">';			
				reply_list += '<div class="reply_top">';
				/* 아이디 */
				reply_list += '<span class="id_span">'+ data.member_id+'</span>';
				/* 날짜 (수정된 댓글일시와 수정없을시 구분) */
				
				/* 평점 */
				for(var i = 0; i<5; i++){
					if(i<data.rating){
						reply_list += '<i class="fa fa-star"></i>';	
					}else{
						reply_list += '<i class="fa fa-star-o"></i>';
					}
				} 
				
				if(data.regDate === data.updateDate){
					reply_list += '<span class="date_span">등록일 '+ data.regDate +'</span>';
				}else{
					reply_list += '<span class="date_span">등록일 '+ data.regDate +' (수정일 '+ data.updateDate +')</span>';
				}
				
				if(data.member_id === member_id){
					reply_list += '<a class="update_reply_btn" href="'+ data.reply_id +'">수정</a><a class="delete_reply_btn" href="'+ data.reply_id +'">삭제</a>';
				}
				reply_list += '</div>'; //<div class="reply_top">
				reply_list += '<div class="reply_bottom">';
				reply_list += '<div class="reply_bottom_txt">'+ data.content +'</div>';
				reply_list += '</div>';//<div class="reply_bottom">
				reply_list += '</div>';//<div class="comment_wrap">
				reply_list += '</li>';
			});
			
			$(".reply_content_ul").html(reply_list);
			
			/* 페이지 버튼 만드는 부분 */
			
			let reply_pageMaker = '';
			
			if(pi.prev){
				let prev_num = pi.pageStart -1;
				reply_pageMaker += '<li class="prev page-numbers">';
				reply_pageMaker += '<a href="'+ prev_num +'">이전</a>';
				reply_pageMaker += '</li>';	
			}
			/* numbre btn */
			for(let i = pi.pageStart; i < pi.pageEnd+1; i++){
				reply_pageMaker += '<li class="page-numbers ';
				if(pi.cri.pageNum === i){
					reply_pageMaker += 'current';
				}
				reply_pageMaker += '">';
				reply_pageMaker += '<a href="'+i+'">'+i+'</a>';
				reply_pageMaker += '</li>';
			}
			/* next */
			if(pi.next){
				let next_num = pi.pageEnd +1;
				reply_pageMaker += '<li class="next page-numbers">';
				reply_pageMaker += '<a href="'+ next_num +'">다음</a>';
				reply_pageMaker += '</li>';	
			}
			
			$(".pageMaker").html(reply_pageMaker);
		}
		}
		

		// 댓글 데이터 서버 요청 및 댓글 동적 생성 메서드
		let replyListInit = function(){
			$.getJSON("/pages/reply/list" , cri , function(obj){
					makeReply(obj);
			});
		}
		
		//전체 리뷰 별점 평균값 부여하기 (상품이름 쪽)
		$.getJSON("/pages/reply/rating" , {product_id : cri.product_id} , function(obj){
			
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
		var starAvgTag = '<div class="starDiv">';
		
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
		starAvgTag += "</div>";
		
		
		$(".detail_section_wrap2").find(".detail_section_title").append(starAvgTag);
		});
		
		/* 댓글 페이지 버튼 document ready시점에서 .page-numbers a 태그는 
		존재하지않기때문에 클릭이벤트가 발생하지않는다. 그래서 document on 메서드를 사용*/
		$(document).on('click', '.page-numbers a', function(e){
			
			e.preventDefault();
			
			let page = $(this).attr("href");
			cri.pageNum = page;
			
			replyListInit();
			
		});
		
		const replyModifyVO = {
				reply_id : '',
				content : '',
				rating : 0
		}

		/* 댓글 수정버튼 클릭시 수정모드로 전환 */
		$(document).on('click', '.update_reply_btn', function(e){
			
			e.preventDefault();
			
			//아이디 설정
			replyModifyVO.reply_id = $(this).attr("href");
			//레이팅 설정
			replyModifyVO.rating = $(this).closest(".reply_top").find(".fa.fa-star").length;

			console.log(replyModifyVO.rating);
			
			$(this).closest(".reply_top").find(".fa").attr("style","cursor : pointer");
			
			$(this).closest(".reply_top").find(".fa").each(function(idx,data){
			$(this).click(function(){
				$(this).closest(".reply_top").find(".fa").removeClass("fa-star").addClass("fa-star-o");
				for(var i=0; i<=idx; i++){
					$(this).closest(".reply_top").find(".fa").eq(i).removeClass("fa-star-o").addClass("fa-star");
				}
				
				//변경된 레이팅 적용
				replyModifyVO.rating = idx+1;
			});
		});
			
			
			//기존 content값 부여
			let contentText = $(this).closest('.comment_wrap').find(".reply_bottom_txt").text();
			
			$(this).closest('.comment_wrap').find(".reply_bottom_txt").html('<textarea>'+contentText+'</textarea>');
			$(this).closest('.comment_wrap').append("<button class='reply_modify_btn'>수정 등록</button>");
			
			//수정 등록 클릭시 수정 진행시키기
			$(".reply_modify_btn").click(function(){
				replyModifyVO.content = $(this).closest('.comment_wrap').find(".reply_bottom_txt textarea").val();
				$.ajax({
					url: '/pages/reply/modify',
					type: 'POST',
					data: replyModifyVO,
					success: function(result){
						replyListInit();
						alert(result);
					}
				});
			});
			
		});
		
		/* 댓글 삭제 버튼 */
		$(document).on('click','.delete_reply_btn',function(e){
			
			e.preventDefault();
			
			let reply_id = $(this).attr("href");
			
			$.ajax({
				data : {reply_id : reply_id}, //ajax 데이터 전송시 객체형태로 보내는것이 가장 편리함. 그냥 보냈다가 잘 안되서 객체형으로 변경함.
				url : '/pages/reply/remove',
				type : 'POST',
				success : function(result){
					replyListInit();
					alert(result);
				}
			});	
			
		});
		
		/* 바로구매 버튼 */
		$(".btn_buy").click(function(){
			let product_count = $(".quantity_input").val();
			$(".order_form").find("input[name='orders[0].product_count']").val(product_count);
			$(".order_form").submit();
		});
		
		/* 별점 컨트롤 */
		$(".comment-form-rating .fa").each(function(idx,data){
			$(this).click(function(){
				$(".comment-form-rating .fa").removeClass("fa-star").addClass("fa-star-o");
				for(var i=0; i<=idx; i++){
					$(".comment-form-rating .fa").eq(i).removeClass("fa-star-o").addClass("fa-star");
				}
				$(".comment-form").find("input[name='rating']").val(idx+1);
			});
		});
	});
	
</script>
<style type="text/css">

.detail_section{
}
	#result_card img {
		max-width : 100%;
		height : auto;
		display : block;
		padding : 5px;
		margin-top : 10px;
		margin : auto;
	}
	.detail_section_img{
		width : auto;
		border : 1px solid #CCCCCC;
	}
.detail_section_wrap2{
	width : 50%;
	float : right;
	margin-right : 10px;
}
.detail_section_wrap1{
	width : 40%;
	float : left;
	margin-left : 10px;
}
.detail_section{
	width : 100%;
	height: 400px;
}
.comment-form-rating .fa{
	letter-spacing: -3px;
	cursor: pointer;
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
 /* 리뷰쓰기 버튼 */
  .reply_button_wrap{
  	padding : 10px;
  }
  .reply_button_wrap button{
	background-color: #365fdd;
    color: white;
    font-weight: bold;
    font-size: 15px;
    padding: 5px 12px;
    cursor: pointer;  
  }
  .reply_button_wrap button:hover{
  	background-color: #1347e7;
  }
  
  /* 리뷰 영역 */
  	.content_bottom{
  		width: 80%;
  		margin : auto;
  	}
	.reply_content_ul{
		list-style: none;
	}
	.comment_wrap{
		position: relative;
    	border-bottom: 1px dotted #d4d4d4;
    	padding: 14px 0 10px 0;	
    	font-size: 12px;
	}
		/* 리뷰 머리 부분 */
		.reply_top{
			padding-bottom: 10px;
		}
		.id_span{
			padding: 0 15px 0 3px;
		    font-weight: bold;		
		}
		.date_span{
			padding: 0 15px 0;
		}
		/* 리뷰 컨텐트 부분 */
		.reply_bottom{
			padding-bottom: 10px;
		}
		
	
	/* 리뷰 선 */
	.reply_line{
		width : 80%;
		margin : auto;
		border-top:1px solid #c6c6cf;  	
	}
	
	/* 리뷰 제목 */
	.reply_subject h2{
		padding: 15px 0 5px 5px;
	}
	.reply_not_div{
  	text-align: center;
  }
  .reply_not_div span{
	display: block;
    margin-top: 30px;
    margin-bottom: 20px; 
  }
  
  /* 리뷰 수정 삭제 버튼 */
  .update_reply_btn{
 	font-weight: bold;
    background-color: #b7b399;
    display: inline-block;
    width: 40px;
    text-align: center;
    height: 20px;
    line-height: 20px;
    margin: 0 5px 0 30px;
    border-radius: 6px;
    color: white; 
    cursor: pointer;
  }
  .delete_reply_btn{
 	font-weight: bold;
    background-color: #e7578f;
    display: inline-block;
    width: 40px;
    text-align: center;
    height: 20px;
    line-height: 20px;
    border-radius: 6px;
    color: white; 
  	cursor: pointer;
  } 
  
  .comment_wrap h3{
  	margin-bottom : 20px;
  }
  .detail_section_price{
  	font-size: 20px;
	font-weight: bold;
	color : black;
  }
  .detail_section_title h2{
  	margin-bottom: 0;
  }
  .starDiv i{
  	font-size: 20px;
  }
  .quantity{
  	margin: 10px 0;
  }
  .quantity_input{
  	width: 50px;
  }
  .btn_cart{
  	background-color: #fff;
  }
  #reviews{
  	width: 80%;
  	margin: 20px auto;
  }
  .comment-form-rating{
  	margin : 5px 5px;
  }
  .reply_content_ul{
  	margin: 0;
  }
  #comment{
  	width: 100%;
  }
 



</style>
		<!-- #masthead -->
		<div id="content" class="site-content">
			<div id="primary" class="content-area column full">
				<main id="main" class="site-main" role="main">
				<div id="container">
					<div id="content" role="main">
						<div class="detail_section">
							<div class="detail_section_wrap1">
								<div class=detail_section_title1>
									<p>상품 이미지</p>
								</div>
								<div class="detail_section_img">
									<div id="uploadResult">
									</div>
								</div>
							</div>
								<div class="detail_section_wrap2">
									<div class="detail_section_title">
										<h2>${product.product_name}  </h2>
									</div>
									<div class="detail_section_price">
										￦ <fmt:formatNumber value="${product.product_price}" pattern="#,###"/>
									</div>
									<div class="detail_section_s_info">
										<span>배송비</span>
										 ￦ <fmt:formatNumber value="3000" pattern="#,###"/> /
										 ￦ <fmt:formatNumber value="30000" pattern="#,###"/>
										 <span>이상 주문시 무료</span>
									</div>
									<div class="cart">
										<div class="quantity">
											주문수량
											<input type="number" step="1" min="1" max="" name="quantity" value="1" title="Qty" class="quantity_input" size="4"/>
										</div>
										<div class="cart_btn_set">
											<button class="btn_cart">장바구니</button>
											<button class="btn_buy">바로구매</button>
										</div>										
									</div>
								</div>	
						</div>
							<!-- .summary -->
							<div class="woocommerce-tabs wc-tabs-wrapper">
								<div class="panel entry-content wc-tab" id="tab-description">
									<h2>상품 정보</h2>
									<p>${product.product_info}</p>
								</div>
								<div class="panel entry-content wc-tab" id="tab-reviews">
									<div id="reviews">
										<c:if test="${member != null}">
										<div id="review_form_wrapper">
											<div id="review_form">
												<div id="respond" class="comment-respond">
													<h3 style="margin-bottom:10px; text-align: center;" id="reply-title" class="comment-reply-title">리뷰 등록 <small><a rel="nofollow" id="cancel-comment-reply-link" href="/demo-moschino/product/woo-logo-2/#respond" style="display:none;">Cancel reply</a></small></h3>
														<p class="comment-form-rating">
															<label>별점선택</label>
															<i class="fa fa-star"></i>
															<i class="fa fa-star"></i>
															<i class="fa fa-star"></i>
															<i class="fa fa-star"></i>
															<i class="fa fa-star"></i>
														</p>
															<input type="hidden" id="rating" name="rating" value="5">
															<p class="comment-form-comment">
																<textarea id="comment" name="comment" cols="45" rows="3" aria-required="true" placeholder="리뷰 내용을 작성해주세요!"></textarea>
															</p>
															<p class="form-submit">
																<button class="btn_reply">댓글 등록</button>
															</p>
													   
												</div>
												<!-- #respond -->
											</div>
										</div>
										</c:if>
										<div class="reply_not_div">
										
										</div>
										<h3 class="reply_title">등록된 리뷰</h3>
										<ul class="reply_content_ul">	
											<li>
												<div class="comment_wrap">
													<div class="reply_top">
														<span class="id_span">sjinjin7</span>
														<span class="date_span">2021-10-11</span>
														<span class="rating_span">평점 : <span class="rating_value_span">4</span>점</span>
														<a class="update_reply_btn">수정</a><a class="delete_reply_btn">삭제</a>
													</div>
													<div class="reply_bottom">
														<div class="reply_bottom_txt">
															사실 기대를 많이하고 읽기시작했는데 읽으면서 가가 쓴것이 맞는지 의심들게합니다 문체도그렇고 간결하지 않네요 제가 기대가 크던 작았던간에 책장이 사실 안넘겨집니다.
														</div>
													</div>
												</div>
											</li>
										</ul>
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
										<div class="button_section">
											<form id="moveForm" action="/pages/mainPage" method="get"> 
											 	<input type="hidden" name="pageNum" value="${cri.pageNum}">
												<input type="hidden" name="amount" value="${cri.amount}">
												<input type="hidden" name="keyword" value="${cri.keyword}">
												<input type="hidden" name="order_by" value="${cri.order_by}">
												<input type="hidden" name="page_category_code" value="${page_category_code}">
												<input type="submit" id="list_button" value="목록">											
											</form>	
										</div>
										<!-- 주문 form -->
										<div class="order_section">
											<form action="/pages/orderPage/${member.member_id}" method="get" class="order_form">
												<input type="hidden" name="orders[0].product_id" value="${product.product_id}">
												<input type="hidden" name="orders[0].product_count" value="">
											</form>
										</div>
										<div class="clear">
										</div>
									</div>
								</div>
							</div>
					</div>
				</div>
				</main>
				<!-- #main -->
			</div>
			<!-- #primary -->
		</div>
		<!-- #content -->
	</div>
	<!-- .container -->
<%@ include file="includes/footer.jsp" %>
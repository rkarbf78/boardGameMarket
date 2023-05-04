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
</style>
		<!-- #masthead -->
		<div id="content" class="site-content">
			<div id="primary" class="content-area column full">
				<main id="main" class="site-main" role="main">
				<div id="container">
					<div id="content" role="main">
						<div class="detail_section">
							<div class="detail_section_wrap1">
								<div class=detail_section_title>
									<p>상품 이미지</p>
								</div>
								<div class="detail_section_img">
									<div id="uploadResult">
									</div>
								</div>
							</div>
								<div class="detail_section_wrap2">
									<div class="detail_section_title">
										<h1>${product.product_name}</h1>
									</div>
									<div class="detail_section_price">
										<span>${product.product_price} 원</span>
									</div>
									<div class="detail_section_s_info">
										<span>일단 여긴 간단한 정보 1~2인용 이런거 ㅇㅋ?</span>
									</div>
									<form class="cart" method="post" enctype='multipart/form-data'>
										<div class="quantity">
											<input type="number" step="1" min="1" max="" name="quantity" value="1" title="Qty" class="input-text qty text" size="4"/>
										</div>									
										<button type="submit" class="single_add_to_cart_button button alt">Add to cart</button>
									</form>
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
										<div id="comments">
											<h2>2 Reviews for Beige Jacket</h2>
											<ol class="commentlist">
												<li itemprop="review" itemscope itemtype="http://schema.org/Review" class="comment">
												<div id="comment-3" class="comment_container">
													<img alt='' src='http://0.gravatar.com/avatar/c7cab278a651f438795c2a9ebf02b5ae?s=60&#038;d=mm&#038;r=g' srcset='http://0.gravatar.com/avatar/c7cab278a651f438795c2a9ebf02b5ae?s=120&amp;d=mm&amp;r=g 2x' class='avatar avatar-60 photo' height='60' width='60'/>
													<div class="comment-text">	
														<p class="meta">
															<strong itemprop="author">Steve</strong> &ndash; <time itemprop="datePublished" datetime="2013-06-07T15:54:25+00:00">June 7, 2013</time>:
														</p>
														<div itemprop="description" class="description">
															<p>
																I like the logo but not the color.
															</p>
														</div>
													</div>
												</div>
												</li>
											</ol>
										</div>
										<div id="review_form_wrapper">
											<div id="review_form">
												<div id="respond" class="comment-respond">
													<h3 style="margin-bottom:10px;" id="reply-title" class="comment-reply-title">Add a review <small><a rel="nofollow" id="cancel-comment-reply-link" href="/demo-moschino/product/woo-logo-2/#respond" style="display:none;">Cancel reply</a></small></h3>
													<form action="#" method="post" id="commentform" class="comment-form" novalidate>
														<p class="comment-form-rating">
															<label for="rating">Your Rating</label>
															<select name="rating" id="rating">
																<option value="">Rate&hellip;</option>
																<option value="5">Perfect</option>
																<option value="4">Good</option>
																<option value="3">Average</option>
																<option value="2">Not that bad</option>
																<option value="1">Very Poor</option>
															</select>
														</p>
														<p class="comment-form-comment">
															<label for="comment">Your Review</label><textarea id="comment" name="comment" cols="45" rows="8" aria-required="true"></textarea>
														</p>
														<p class="comment-form-author">
															<label for="author">Name <span class="required">*</span></label><input id="author" name="author" type="text" value="" size="30" aria-required="true"/>
														</p>
														<p class="comment-form-email">
															<label for="email">Email <span class="required">*</span></label><input id="email" name="email" type="text" value="" size="30" aria-required="true"/>
														</p>
														<p class="form-submit">
															<input name="submit" type="submit" id="submit" class="submit" value="Submit"/><input type='hidden' name='comment_post_ID' value='60' id='comment_post_ID'/>															
														</p>
													</form>
												</div>
												<!-- #respond -->
											</div>
										</div>
										<div class="button_section">
											<form id="moveForm" action="/pages/mainPage" method="get"> 
											 	<input type="hidden" name="pageNum" value="${cri.pageNum}">
												<input type="hidden" name="amount" value="${cri.amount}">
												<input type="hidden" name="keyword" value="${cri.keyword}">
												<input type="hidden" name="page_category_code" value="${page_category_code}">
												<input type="submit" id="list_button" value="목록">											
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
package com.boardGameMarket.project.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

import com.boardGameMarket.project.domain.MemberVO;

public class CartInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		HttpSession session = request.getSession();
		
		MemberVO mVo = (MemberVO)session.getAttribute("member");
		
		if(mVo == null) {
			response.sendRedirect("/pages/mainPage");
			return false;
		}else {
			return true;
		}
		
	}
	
}

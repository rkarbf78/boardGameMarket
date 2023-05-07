package com.boardGameMarket.project.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

import com.boardGameMarket.project.domain.MemberVO;

public class AdminInterceptor implements HandlerInterceptor {
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

		HttpSession session = request.getSession();
		
		MemberVO loginVO = (MemberVO)session.getAttribute("member");
		
		if(loginVO == null || loginVO.getMember_role() == 0) {
			response.sendRedirect("/pages/mainPage");
			return false;
		}
		
		return true;
	}
}

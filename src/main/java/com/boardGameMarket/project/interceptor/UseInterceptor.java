package com.boardGameMarket.project.interceptor;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

import com.boardGameMarket.project.domain.MemberVO;

public class UseInterceptor implements HandlerInterceptor {
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

		HttpSession session = request.getSession();
		
		MemberVO loginVO = (MemberVO)session.getAttribute("member");
		
		if(loginVO == null) {
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();

			out.write("<script language='javascript'>");
			out.write("alert('로그인이 필요한 서비스입니다.'); location.href='/pages/loginPage'");
			out.write("</script>");
			out.flush();
			out.close();
			return false;
		}
		
		return true;
	}
}

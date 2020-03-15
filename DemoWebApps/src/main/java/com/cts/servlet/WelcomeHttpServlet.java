package com.cts.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class WelcomeHttpServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		System.out.println("doGet metod of WelcomeHttpServlet start");
		PrintWriter pw=null;
		res.setContentType("text/html");
		pw=res.getWriter();
		pw.println("<h1>Welcome to HttpServlet</h1>");
		pw.println("<a href='index.jsp'>HOME</a><br>");
		
		req.setAttribute("name", "mithilesh");
		req.setAttribute("mobile", "1234567890");
		RequestDispatcher rd=null;
		rd=req.getRequestDispatcher("greeting");
		rd.forward(req, res);
		
		System.out.println("doGet method of WelcomeHttpServlet end");
	}//doGet(-,-)
}//class

package com.cts.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class GreetingHttpServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
	     System.out.println("doGet method of GreattingServlet start");
	     ServletOutputStream sos=null;
			res.setContentType("text/html");
			/*sos=res.getOutputStream();
			sos.println("<a href='index.jsp'>HOME</a><br>");
			sos.println("<h1>Fotter of HttpServlet</h1>");*/
			PrintWriter pw=null;
			res.setContentType("text/html");
			pw=res.getWriter();
			
			
			pw.println("<h1>Fotter of GreetingHttpServlet</h1>");
			pw.println("<a href='index.jsp'>HOME</a><br>");
			System.out.println("Name : "+req.getAttribute("name"));
			System.out.println("Mobile : "+req.getAttribute("mobile"));
			req.setAttribute("name", "mithilesh");
			req.setAttribute("mobile", "1234567890");
	     System.out.println("doGet method of GreattingServlet end");
	}//doGet(-,-)
	
}//class

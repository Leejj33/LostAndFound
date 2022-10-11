<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bbs.BookmarkDAO"%>
<%@ page import="bbs.Bookmark"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.util.ArrayList"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs" class="bbs.Bookmark" scope="page" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>분실물 게시판</title>
</head>
<body>
	<%
	 	String userID = null;
	 	if(session.getAttribute("userID") != null) {
	 		userID = (String) session.getAttribute("userID");
	 	}
	 	if(userID == null) {
	 		PrintWriter script = response.getWriter();
	 		script.println("<script>");
			script.println("alert('로그인을 해주세요.')");
	 		script.println("location.href = 'login.jsp'");
	 		script.println("</script>");
	 	} 
	 	else {
		 	int bbsID = 0; 
		 	if (request.getParameter("bbsID") != null) {
		 		bbsID = Integer.parseInt(request.getParameter("bbsID"));
		 	}
		 	if (bbsID == 0) {
		 		PrintWriter script = response.getWriter();
		 		script.println("<script>");
		 		script.println("alert('유효하지 않은 글입니다.')");
		 		script.println("location.href = 'login.jsp'");
		 		script.println("</script>");
		 	}
		 	
		 	BookmarkDAO bookmarkDAO = new BookmarkDAO();
			ArrayList<Bookmark> list = bookmarkDAO.getBookmark(userID, bbsID);
			
			int result = 0;
			if (list.isEmpty()) {
				result = bookmarkDAO.write(userID, bbsID);
			}
			else {
				result = bookmarkDAO.delete(userID, bbsID);
			}
	 		if (result == -1) {
		 		PrintWriter script = response.getWriter();
		 		script.println("<script>");
		 		script.println("alert('북마크를 실패했습니다.')");
		 		script.println("history.back()");
		 		script.println("</script>");
		 	}
	 		else {
		 		PrintWriter script = response.getWriter();
		 		script.println("<script>");
		 		script.println("location.href=document.referrer;");
		 		script.println("</script>");
		 	}
	 	}
	 %>
</body>
</html>
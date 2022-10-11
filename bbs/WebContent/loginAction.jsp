<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %> <!-- user 패키지의 UserDAO 불러옴(클래스 사용) -->
<%@ page import="java.io.PrintWriter" %> <!-- 자바스크립트 사용 -->
<% request.setCharacterEncoding("UTF-8"); %> <!-- 한글 깨짐 방지 -->
<jsp:useBean id="user" class="user.User" scope="page" /> <!-- User 클래스를 자바빈즈로 사용 -->
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" /> <!-- 로그인 페이지에서 넘어온 사용자 ID 저장 -->
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%  // 로그인 기능 구현
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if (userID != null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인이 되어 있습니다.')"); 
			script.println("location.href = 'main.jsp'"); 
			script.println("</script>");
		}
		
		UserDAO userDAO = new UserDAO();
		int result = userDAO.login(user.getUserID(), user.getUserPassword()); // 로그인 시도
		if (result == 1) { // 1 -> 로그인 성공
			session.setAttribute("userID", user.getUserID()); // 세션값 부여
			PrintWriter script = response.getWriter(); // 자바스크립트 문장 실행
			script.println("<script>");
			script.println("alert('로그인에 성공했습니다.')"); // 작성한 문구가 쓰여진 알림창을 띄움
			script.println("location.href = 'main.jsp'"); // 메인 페이지로 이동
			script.println("</script>");
		} else if (result == 0) { // 0 -> 비밀번호 다름
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비밀번호가 다릅니다.')");
			script.println("history.back()"); // 로그인에 실패했으므로 이전 페이지(로그인 창)로 돌려보냄
			script.println("</script>");
		} else if (result == -1) { // -1 -> 아이디 다름
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 아이디입니다.')");
			script.println("history.back()");
			script.println("</script>");
		} else if (result == -2) { // -2 -> DB 오류
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
	%>
</html>
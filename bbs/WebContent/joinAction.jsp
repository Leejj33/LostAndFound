<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<jsp:setProperty name="user" property="userName" />
<!-- 이름, 성별, 이메일 추가 -->
<jsp:setProperty name="user" property="userGender" />
<jsp:setProperty name="user" property="userEmail" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		// 회원가입 기능 구현
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

		if (user.getUserID() == null // 아이디가 빈 값
				|| user.getUserPassword() == null // or 비밀번호가 빈 값
				|| user.getUserName() == null // or 이름이 빈 값
				|| user.getUserGender() == null // or 성별이 빈 값
				|| user.getUserEmail() == null) { // or 이메일이 빈 값이면
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안 된 사항이 있습니다.')"); // (5항목 중 하나라도 빈 값이면) 이 창 띄움
			script.println("history.back()"); // 회원가입에 실패했으므로 이전 페이지(회원가입 창)로 돌려보냄
			script.println("</script>");
		} else {
			UserDAO userDAO = new UserDAO();
			int result = userDAO.join(user); // 회원가입 수행
			if (result == -1) { // -1 -> 입력사항 다 채움, 회원가입 불가(아이디 중복)
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('이미 사용중인 아이디입니다.')");
				script.println("history.back()");
				script.println("</script>");
			} else { // 나머지: 빈 값도 없고 아이디도 중복이 아닌 경우
				session.setAttribute("userID", user.getUserID()); // 세션값 부여
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('회원가입을 완료하였습니다.')");
				script.println("location.href = 'main.jsp'"); // 회원가입에 성공했으므로 메인 페이지로 이동
				script.println("</script>");
			}
		}
	%>

</html>
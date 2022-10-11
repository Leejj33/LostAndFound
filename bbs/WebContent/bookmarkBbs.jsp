<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="bbs.BookmarkDAO"%>
<%@ page import="bbs.Bookmark"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.lang.Math"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" href="css/custom.css">

<title>분실물 보관소</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		int pageNumber = 1; //기본페이지
		if (request.getParameter("pageNumber") != null) {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
		int boardID = 0;
		if (request.getParameter("boardID") != null){
			boardID = Integer.parseInt(request.getParameter("boardID"));
		}
	%>
	<!-- 내비게이션 영역 -->
	<nav class="navbar navbar-default" id="navbar-main" style="width: 100%; margin: 0 auto;">
		<!-- 헤더 -->
		<div class="navbar-header">
			<!-- 모바일 기준 우측 상단 햄버거 버튼 -->
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span>
			</button>
			<!-- 게시판 사이트 제목, 클릭하면 메인 페이지로 이동 -->
		</div>
		<!-- 하위 메뉴 -->
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1" style="width: 1200px; margin: 0 auto;">
			<ul class="nav navbar-nav">
				<!-- 내비게이션 바에 들어가는 메뉴 리스트 -->
				<li><a class="navbar-brand" href="main.jsp">분실물 보관소</a></li>
				<li><a class="navbar-menu-1" href="bbs.jsp?boardID=1&pageNumber=1">분실물 게시판</a></li>
				<li><a class="navbar-menu-2" href="bbs.jsp?boardID=2&pageNumber=1">자유 게시판</a></li>
				<li>
					<form id="search-main" action="searchBbs.jsp">
						<div class="search-bar">
							<input type="text" name="search" id="search-input" placeholder="  분실물을 검색해보세요." autocomplete='off' style="font-size: 17px;">
							<button id="search-button">
								<img class="search-image" alt="search" src="images/search-icon.png">
							</button>
						</div>
					</form>
				</li>
				<li>
					<div>
						<button type="button" id="isBtn" onclick="location.href='imageSearch.jsp'" class="btn btn-primary">이미지 검색</button>
					</div>
				</li>
			</ul>
			<%
				if (userID == null) {
			%>
			<!-- 내비게이션바 우측 드롭다운 영역 -->
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<!-- #은 링크 없는거나 마찬가지(자기자신) --> <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			<%
				} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="bookmarkBbs.jsp">북마크</a></li>
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul></li>
			</ul>
			<%
				}
			%>
		</div>
	</nav>
	<div class="container">
		<h1>
			북마크<br>
		</h1>
		<p><%= userID %>님이 북마크하신 목록입니다.<br><br></p>
		<div class="container">
			<div class="row">
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th style="background-color: #eeeee; text-align: center;">번호</th>
							<th style="background-color: #eeeee; text-align: center;">제목</th>
							<th style="background-color: #eeeee; text-align: center;">작성자</th>
							<th style="background-color: #eeeee; text-align: center;">작성일</th>
						</tr>
					</thead>
					<tbody>
						<%
							BookmarkDAO BookmarkDAO = new BookmarkDAO();
							ArrayList<Bbs> list = BookmarkDAO.getList(userID, pageNumber);
							for(int i = 0; i < list.size(); i++) {
						%>
						<tr>
							<td><%= list.get(i).getBbsID() %></td>
							<td><a href="view.jsp?boardID=<%= list.get(i).getBoardID() %>&bbsID=<%= list.get(i).getBbsID() %>"><%= list.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></a></td>
							<td><%= list.get(i).getUserID() %></td>
							<td><%= list.get(i).getBbsDate().substring(0,11) + list.get(i).getBbsDate().substring(11,13) + "시" + list.get(i).getBbsDate().substring(14,16) + "분" %></td>
						</tr>
						<%
							}
						%>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
</body>
</html>
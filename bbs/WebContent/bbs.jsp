<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 반응형 웹으로 설정 -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- CSS(부트스트랩 사용) -->
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" href="css/custom.css">
<title>분실물 보관소</title>
<!-- 하이퍼링크로 인해 제목이 밑줄 친 파란색으로 표시되는 것 방지 -->
<style type="text/css">
	a, a:hover {
		color: #000000;
		text-decoration: none;
		}
</style>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		
		int pageNumber = 1; // 1은 기본 페이지
		if (request.getParameter("pageNumber") != null) { // 현재 페이지가 몇 페이지인지 알려주기 위해
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
				<% if (boardID == 1) { %>
					<li class="active"><a href="bbs.jsp?boardID=1&pageNumber=1">분실물 게시판</a></li>
					<li><a href="bbs.jsp?boardID=2&pageNumber=1">자유 게시판</a></li>
				<% } else if(boardID == 2) { %>
					<li><a href="bbs.jsp?boardID=1&pageNumber=1">분실물 게시판</a></li>
					<li class="active"><a href="bbs.jsp?boardID=2&pageNumber=1">자유 게시판</a></li>
				<% } %>
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
					<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">접속하기<span class="caret"></span></a>
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
	<!-- 게시판(게시글 목록) 영역 -->
	<div class="container" style="margin-top: 30px;">
	<%
		if (boardID == 1) {
	%>
			<h1>분실물 게시판<br></h1>
			<p style="font-size: 17px;">분실물을 공유하는 게시판입니다.<br></p>
	<%
		} else if (boardID == 2) {
	%>
			<h1>자유 게시판<br></h1>
			<p style="font-size: 17px;">자유롭게 글을 쓰는 곳입니다.<br></p>
	<%
		}
	%>
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd; font-size: 18px;">
				<thead>
					<tr> <!-- 양식 -->
						<th style="width: 30px; background-color: #eeeeee; text-align: center;">번호</th>
						<th style="width: 100px; background-color: #eeeeee; text-align: center;">제목</th>
						<th style="width: 50px; background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="width: 60px; background-color: #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
				<tbody>
					<%
						// 게시글 가져오기
						BbsDAO bbsDAO = new BbsDAO();
						ArrayList<Bbs> list = bbsDAO.getList(boardID, pageNumber);
						for (int i = 0; i < list.size(); i++) {
					%>
					<tr> <!-- 내용 -->
						<td><%= list.get(i).getBbsID() %></td>
						<td><a href="view.jsp?boardID=<%= boardID %>&bbsID=<%= list.get(i).getBbsID() %>"><%= list.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></a></td> 
						<td><%= list.get(i).getUserID() %></td>
						<td><%= list.get(i).getBbsDate().substring(2, 11)
							  + list.get(i).getBbsDate().substring(11, 13) + ":"
							  + list.get(i).getBbsDate().substring(14, 16) %></td>
					</tr>
					<%		
						}
					%>
				</tbody>
			</table>
				<form action="searchBbs.jsp" style="display: inline-block">
					<input type="hidden" name="boardID" value=<%=boardID%>>
					<input type="text" class="form-control" autocomplete='off' style="width:250px; display: inline;" name="search">
					<input type="submit" class="btn btn-primary" style="margin-bottom: 4px;" value="검색"/>
				</form>
				<a href="write.jsp?boardID=<%= boardID %>" class="btn btn-primary pull-right">글쓰기</a>
		</div>
		<div class=container style="text-align: center">
			<%
				BbsDAO bbsDAO1 = new BbsDAO();
				int pages = (int) Math.ceil(bbsDAO1.getCount(boardID) / 10) + 1;
				for (int i = 1; i <= pages; i++) {
			%>
			<button type="button" onclick="location.href='bbs.jsp?boardID=<%=boardID%>&pageNumber=<%=i%>'"><%=i%></button>
			<%
				}
			%>
		</div>
	</div>
	<!-- CSS(부트스트랩 사용) -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>
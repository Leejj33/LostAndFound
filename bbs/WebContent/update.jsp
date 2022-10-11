<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="bbs.BbsDAO"%>
<!-- 데이터베이스 접근 위해 추가 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<!-- 도로명 주소 팝업창 -->
<script type="text/javascript">
	function goPopup(){
		var pop = window.open("jusoPopup.jsp", "pop", "width=570,height=420, scrollbars=yes, resizable=yes"); 
	}
	function jusoCallBack(roadAddrPart1){
		map.value = roadAddrPart1;
	}
</script>
<title>분실물 보관소</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if (userID == null) { // 로그아웃 상태
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다.')"); // 경고창 띄우고 
			script.println("location.href = 'login.jsp'"); // 로그인 페이지로 보냄
			script.println("</script>");
		}
		int boardID = 0;
		if (request.getParameter("boardID") != null){
			boardID = Integer.parseInt(request.getParameter("boardID"));
		}
		int bbsID = 0; // 존재하는 글
		if (request.getParameter("bbsID") != null) {
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if (bbsID == 0) { // 존재하지 않는 글
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 글입니다.')"); // 경고창 띄우고 
			script.println("location.href = 'bbs.jsp'"); // 게시판 페이지로 보냄
			script.println("</script>");
		}
		Bbs bbs = new BbsDAO().getBbs(bbsID);
		if (!userID.equals(bbs.getUserID())) { // 접속자와 작성자가 다르면 
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')"); // 글 수정 권한 없음 
			script.println("location.href = 'bbs.jsp'"); // 게시판 페이지로 보냄
			script.println("</script>");
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
			<!-- 내비게이션바 우측 드롭다운 영역 -->
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="bookmarkBbs.jsp">북마크</a></li>
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	
	<!-- 게시글 수정 영역 -->
	<div class="container" style="margin-top: 30px;">
		<div class="row">
			<form method="post" encType="multipart/form-data" action="updateAction.jsp?bbsID=<%= bbsID %>&boardID=<%= boardID %>" autocomplete='off'>
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<!-- 수정 양식 -->
							<th colspan="5" style="background-color: #eeeeee; text-align: center;">게시글 수정</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<!-- 수정 전 제목을 불러옴 -->
							<td colspan="5"><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50" value="<%= bbs.getBbsTitle() %>"></td>
						</tr>
						<%if(boardID==1) { %>
						<tr>
							<td><input type="text" id="map" name="map" class="form-control" placeholder="주소" value="<%= bbs.getMap() %>" autocomplete='off' /></td>
							<td style="width:86px; padding-top: 12px;"><input type="button" onClick="goPopup();" value="주소 검색" /></td>
						</tr>
						<% } %>
						<tr>
							<!-- 수정 전 내용을 불러옴 -->
							<td colspan="5"><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height: 350px;"><%= bbs.getBbsContent() %></textarea></td>
						</tr>
						<tr>
							<td colspan="5"><input type="file" name="fileName"></td>
						</tr>
					</tbody>
				</table>
				<input type="submit" onclick="return confirm('정말로 수정하시겠습니까?')" class="btn btn-primary pull-right" value="수정">
			</form>
		</div>
	</div>
	<!-- CSS(부트스트랩 사용) -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bookmark"%>
<%@ page import="bbs.BookmarkDAO"%>
<%@ page import="comment.Comment"%>
<%@ page import="comment.CommentDAO"%>
<%@ page import="java.io.File"%>
<%@ page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- 반응형 웹으로 설정 -->
<!-- CSS(부트스트랩 사용) -->
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" href="css/custom.css">
<title>분실물 보관소</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		// 매개변수, 기본세팅 처리
		int boardID = 0;
		if (request.getParameter("boardID") != null) {
			boardID = Integer.parseInt(request.getParameter("boardID"));
		}
		int bbsID = 0; // 존재하는 글
		if (request.getParameter("bbsID") != null) {
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if (bbsID == 0) { // 존재하지 않는 글
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 글입니다.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}
		Bbs bbs = new BbsDAO().getBbs(bbsID);
		Comment comment = new CommentDAO().getComment(bbsID);
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
								<input type="text" name="search" id="search-input" placeholder="  분실물을 검색해보세요."  autocomplete='off' style="font-size: 17px;">
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
						<!-- #은 링크 없는거나 마찬가지(자기자신) --> 
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
					<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">회원관리<span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="bookmarkBbs.jsp">북마크</a></li>
							<li><a href="logoutAction.jsp">로그아웃</a></li>
						</ul>
					</li>
				</ul>
				<%
					}
				%>
			</div>
		</nav>
	<!-- 게시글 하나 보여주는 영역 -->
	<div class="container">
		<div class="row">
			<table class="table table-haver" style="border: 1px solid #dddddd; font-size:18px; margin-top: 30px;" >
				<!-- 글 제목 -->
				<tr>
					<td colspan="5" align="left" style="background-color: lightgrey;">&nbsp;&nbsp;&nbsp;<%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></td>
					<% BookmarkDAO bookmarkDAO = new BookmarkDAO();
						ArrayList<Bookmark> bookmarklist = bookmarkDAO.getBookmark(userID, bbsID);
						if (bookmarklist.isEmpty()) { %>
					<td align="right" style="background-color: lightgrey"><button onclick="location.href='bookmarkAction.jsp?bbsID=<%= bbsID %>'"><span class="glyphicon glyphicon-heart-empty"></span></button></td>
					<% }
						else { %>
					<td align="right" style="background-color: lightgrey"><button onclick="location.href='bookmarkAction.jsp?bbsID=<%= bbsID %>'"><span class="glyphicon glyphicon-heart" style="color: red;"></span></button></td>
					<% } %>
				</tr>
				<!-- 작성자, 작성일 -->
				<tr>
					<td colspan="3" align="left">&nbsp;&nbsp;&nbsp;<%= bbs.getUserID() %></td>
					<td colspan="3" align="right"><%= bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + "시" + bbs.getBbsDate().substring(14, 16) + "분" %></td>
				</tr>
				<!-- 사진 -->
					<%
						String real = "C:\\JSP\\projects\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\BBS\\bbsUpload";
						File viewFile = new File(real + "\\" + bbsID + "사진.jpg");
						if (viewFile.exists()) {
					%>
				<!-- 내용 -->
				<tr>
					<td colspan="6"><br>
					<br> <img src="bbsUpload/<%= bbsID %>사진.jpg" border="300px" width="300px" height="300px"><br>
					<br> <%
 							} else {
 						%>
					<td colspan="6"><br>
					<br> <%
							}
						%> <%= bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %><br>
					<br></td>
				</tr>
				<%
						if(boardID==1) {
						String Map = bbs.getMap().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>");
					%>
				<tr>
					<td colspan="6" align="left">&nbsp;&nbsp;&nbsp;<a href="https://map.naver.com/v5/search/<%= Map %>" target="_blank"><%= Map %></a></td>
				</tr>
				<% } %>
				<tr>
					<td colspan="6" align="left"><a href="bbs.jsp?boardID=<%= boardID %>" class="btn btn-success" style="margin-left: 10px;">목록</a> <%
						// 글 수정/삭제기능
						if (userID != null && userID.equals(bbs.getUserID())) { // 접속한 userID가 빈 값이 아닌 로그인 상태인 동시에 작성자와 일치할 때
					%> <a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%= bbsID %>&boardID=<%= boardID %>" class="btn btn-danger pull-right">삭제</a> <a href="update.jsp?bbsID=<%= bbsID %>&boardID=<%= boardID %>" class="btn btn-primary pull-right">수정</a></td>
				</tr>
				<% } %>
			</table>
		</div>
	</div>
	<div class="container">
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<tbody>
					<tr>
						<td align="left" bgcolor="lightgray">&nbsp;&nbsp;댓글</td>
					</tr>
					<tr>
						<td>
							<%
							CommentDAO commentDAO = new CommentDAO();
							ArrayList<Comment> list = commentDAO.getList(boardID, bbsID);
							for (int i = 0; i < list.size(); i++) {
						%>
							<div class="container">
								<div class="row">
									<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd; font-size: 18px;">
										<tbody>
											<tr>
												<td align="left"><%= list.get(i).getUserID() %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= list.get(i).getCommentDate().substring(0, 11) + list.get(i).getCommentDate().substring(11, 13)
																+ "시" + list.get(i).getCommentDate().substring(14, 16) + "분" %></td>
												<td align="right">
													<%
													if (list.get(i).getUserID() != null && list.get(i).getUserID().equals(userID)) {
												%>
													<form name="p_search">
														<a type="button" onclick="nwindow(<%= boardID %>, <%= bbsID %>, <%= list.get(i).getCommentID() %>)" class="btn">수정</a> <a onclick="return confirm('정말로 삭제하시겠습니까?')" href="commentDeleteAction.jsp?bbsID=<%= bbsID %>&commentID=<%= list.get(i).getCommentID() %>" class="btn">삭제</a>
													</form> 
												<%
 													}
	 											%>
												</td>
											</tr>
											<tr>
												<td colspan="5" align="left"><%= list.get(i).getCommentText() %> <%
 												String commentReal = "C:\\Users\\j8171\\Desktop\\studyhard\\JSP\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\BBS\\commentUpload";
 												File commentFile = new File(commentReal + "\\" + bbsID + "사진" + list.get(i).getCommentID() + ".jpg");
 												if (commentFile.exists()) {
											 %> <br>
												<br> <img src="commentUpload/<%= bbsID %>사진<%= list.get(i).getCommentID() %>.jpg" border="300px" width="300px" height="300px"><br> <br></td>
												<%
												}
											%>
											</tr>
										</tbody>
									</table>
								</div>
							</div> <%
							}
						%>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<div class="container">
		<div class="form-group">
			<form method="post" encType="multipart/form-data" action="commentAction.jsp?bbsID=<%= bbsID %>&boardID=<%= boardID %>" autocomplete='off'>
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<tr>
						<td style="vertical-align: middle" valign="middle"><%= userID %></td>
						<td><input type="text" style="height: 80px;" class="form-control" placeholder="댓글 작성" name="commentText"></td>
						<td style="vertical-align: middle"><input type="submit" class="btn btn-primary pull" value="작성"></td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	<script type="text/javascript">
	function nwindow(boardID, bbsID, commentID) {
		window.name = "commentParant";
		var url= "commentUpdate.jsp?boardID="+boardID+"&bbsID="+bbsID+"&commentID="+commentID;
		window.open(url,"","width=600,height=230,left=300");
	}
	</script>
	<!-- CSS(부트스트랩 사용) -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>
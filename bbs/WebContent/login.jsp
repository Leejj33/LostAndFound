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
<title>분실물 보관소</title>
</head>
<body>
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
				<li class="dropdown">
					<!-- #은 링크 없는거나 마찬가지(자기자신) --> <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	<!-- 로그인 양식 -->
	<div class="container" id="login_container">
		<!-- 로그인창 레이아웃 설정이라고 생각하면 됨 -->
		<div class="col-lg-4"></div>
		<div class="jumbotron" id="login_jumbotron" style="padding-top: 20px;">
			<form method="post" action="loginAction.jsp" autocomplete='off'>
				<!-- 해당 페이지로 정보 전송 -->
				<h3 style="text-align: center;">로그인</h3><br>
				<!-- 아이디, 비밀번호 입력창 -->
				<div class="form-group">
					<!-- 아이디 == userID -->
					<input type="text" class="form-control" placeholder="아이디" name="userID" maxlength="20">
				</div>
				<div class="form-group">
					<!-- 비밀번호 == userPassword -->
					<input type="password" class="form-control" placeholder="비밀번호" name="userPassword" maxlength="20">
				</div>
				<!-- 로그인 버튼 -->
				<div class="login_button">
					<input type="submit" class="btn btn-primary form-control" value="로그인">
				</div>
			</form>
		</div>
	</div>
	<!-- CSS(부트스트랩 사용) -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>
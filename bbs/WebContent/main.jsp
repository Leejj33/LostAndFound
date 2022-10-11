<%@ page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- CSS -->
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
	%>
	<header>
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
								<input type="hidden" name="boardID" value="1">
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
	</header>
	<!-- 커버 페이지 -->
	<section id="home-main-1">
		<div id="home-contents-1">
			<div class="home-title-1" style="margin-left: -30px;">
				<p class="title-1">분실물 보관소 </p>				
				<p class="sub-title-1" style="font-size: 3rem;">잃어버린 물건을 찾아보세요.</p>
				<p class="sub-title-1">분실물 정보를 간편하게 제공받고 <br>손쉽고 따듯한 거래를 지금 경험해보세요.</p>
				<div class="home-buttons">
					<p class="title-button-1">
						<a class="btn btn-default btn-lg" id="home-button" href="bbs.jsp?boardID=1&pageNumber=1">게시판 보기</a> <a class="btn btn-default btn-lg" id="home-button" style="margin-left: 1.6rem;" href="imageSearch.jsp">이미지로 물건 찾기</a>
					</p>
				</div>
			</div>
			
			<!-- 캐러셀 -->
			<div id="myCarousel" class="carousel slide" data-ride="carousel">
				<ol class="carousel-indicators">
					<li data-target="#myCarousel" data-slide-to="0" class="active"></li>
					<li data-target="#myCarousel" data-slide-to="1"></li>
					<li data-target="#myCarousel" data-slide-to="2"></li>
					<li data-target="#myCarousel" data-slide-to="3"></li>
				</ol>
				<div class="carousel-inner">
					<div class="item active">
						<img src="images/main_img1.png">
					</div>
					<div class="item">
						<img src="images/main_img2.png">
					</div>
					<div class="item">
						<img src="images/main_img3.png">
					</div>
					<div class="item">
						<img src="images/main_img4.png">
					</div>
				</div>
				<a class="left carousel-control" href="#myCarousel" data-slide="prev"> 
					<span class="glyphicon glyphicon-chevron-left"></span>
				</a>
				<a class="right carousel-control" href="#myCarousel" data-slide="next">
					<span class="glyphicon glyphicon-chevron-right"></span>
				</a>
			</div>
		</div>
	</section>

	<section id="home-main-2">
		<div class="home-contents-2">
			<div class="jumbotron" id="contents-2">
				<div class="home-image-2"></div>
				<div>
					<h1 class="title-2">잃어버린 물건을<br>찾아보세요.</h1>
					<p class="sub-title-2">
						분실물 정보를 간편하게 제공받고 <br>손쉽고 따듯한 거래를 지금 경험해보세요.
					</p>
				</div>
			</div>
		</div>
	</section>

	<section id="home-main-3">
		<div class="home-contents-3">
			<div class="jumbotron" id="contents-3">
				<div class="home-image-3"></div>
				<div>
					<h1 class="title-3">
						이미지로 <br>검색해보세요.
					</h1>
					<p class="sub-title-3">
						분실물 이미지를 검색해보고 <br>비슷한 이미지 목록을 확인해보세요.
					</p>
					<ul class="home-list">
						<li class="home-list-item">
							<div class="home-list-icon-1"></div>
							<div class="text-s text-bold mt-3 mb-2">이미지 검색</div>
							<div class="text-xs">분실한 이미지를 등록하여 분실물을 검색하세요.</div>
						</li>
						<li class="home-list-item">
							<div class="home-list-icon-2"></div>
							<div class="text-s text-bold mt-3 mb-2">데이터 추출</div>
							<div class="text-xs">학습된 모델이 이미지<br>데이터를 보여줍니다.</div>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</section>
	
	<!-- Footer -->
	<section class="p-4" id="footer-section">
		<footer class="text-center text-lg-start bg-light text-muted">
			<!-- Section: Links  -->
			<div class="container text-center text-md-start mt-5" id="footer-main">
				<!-- Grid row -->
				<div class="row mt-3">
					<!-- Grid column -->
					<div class="col-md-3 col-lg-4 col-xl-3 mx-auto mb-4">
						<!-- Content -->
						<h2 class="text-uppercase fw-bold mb-4">
							<i class="fas fa-gem me-3"></i>분실물 보관소
						</h2>
					</div>
					<!-- Grid column -->

					<!-- Grid column -->
					<div class="col-md-2 col-lg-2 col-xl-2 mx-auto mb-4" id="footer-service" style="margin-right: 20px;">
						<!-- Links -->
						<h4 class="text-uppercase fw-bold mb-4" style="margin-bottom: 20px; font-weight: 400">주요 서비스</h4>
						<p style="font-size: 18px; font-weight: 700;">
							<a href="bbs.jsp?boardID=1" class="text-reset">분실물 게시판</a>
						</p>
						<p style="font-size: 18px; font-weight: 700;">
							<a href="bbs.jsp?boardID=2" class="text-reset">자유 게시판</a>
						</p>
						<p style="font-size: 18px; font-weight: 700;">
							<a href="imageSearch.jsp" class="text-reset">이미지로 분실물 찾기</a>
						</p>
					</div>
					<!-- Grid column -->

					<!-- Grid column -->
					<div class="col-md-3 col-lg-2 col-xl-2 mx-auto mb-4" style="margin-right: 10px;">
						<!-- Links -->
						<h4 class="text-uppercase fw-bold mb-4" style="margin-bottom: 20px;">팀원 정보</h4>
						<p style="font-size: 15px">
							<i class="fas fa-name me-3"></i>안양대학교<br>소프트웨어학과<br>201585017 엄덕현
						</p>
						<p style="font-size: 15px;">
							<i class="fas fa-name me-3"></i>안양대학교<br>소프트웨어학과<br>201585026 이재준
						</p>
					</div>
					<!-- Grid column -->

					<!-- Grid column -->
					<div class="col-md-4 col-lg-3 col-xl-3 mx-auto mb-md-0 mb-4">
						<!-- Links -->
						<h4 class="text-uppercase fw-bold mb-4" style="margin-bottom: 20px;">연락처</h4>
						<p>
							<i class="fas fa-phone me-3"></i> 010 4634 9692
						</p>
						<p>
							<i class="fas fa-print me-3"></i> edh9692@naver.com
						</p>
						<p style="margin-top: 24px;">
							<i class="fas fa-home me-3"></i> 010 5495 1545
						</p>
						<p>
							<i class="fas fa-envelope me-3"></i> zero_joon@naver.com
						</p>
					</div>
					<!-- Grid column -->
				</div>
				<!-- Grid row -->
			</div>
			<!-- Section: Links  -->
			<!-- Copyright -->
			<div class="text-center p-4" style="background-color: rgba(0, 0, 0, 0.05); padding: 15px 15px 15px 15px;">© Lost and Found Inc.</div>
			<!-- Copyright -->
		</footer>
	</section>
	<!-- CSS(부트스트랩 사용) -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>
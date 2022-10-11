<%@ page import="java.io.PrintWriter"%>
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
	</header>
	<!-- 이미지 입력 -->
	<div class="container">
		<div class="jumbotron" style="margin-top: 130px;">
			<div>
				<p class="upload_title" style="font-size: 37px;">분실물 이미지 검색</p>
				<p id="status" style="margin-bottom: 30px;">이미지로 분실물을 검색합니다.</p>
				<div class="spinner-border text-primary" id="loader"></div>
				<div class="card" style="text-align: center;">
					<img id="img" style="width: 300px; height: 300px;"></img>
					<div class="card-body">
						<h3 id="result"></h3>
						<label class="upload_button" for="input">업로드</label><br>
						<br> <input type="file" id="input" name="file" class="btn btn-outline-secondary" style="display: none;" />
					</div>
				</div>
				<form action="searchBbs.jsp">
					<input type="hidden" name="boardID" value="1">
					<div>
						<input type="hidden" id="search" name="search" value=""> <input type="submit" class="btn btn-primary" style="float: right; width: 84px;" value="결과보기">
					</div>
				</form>
			</div>
		</div>
	</div>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.bundle.min.js" integrity="sha384-b5kHyXgcpbZJO/tY9Ul7kGkf1S0CWuKcCD38l8YkeH8z8QjE0GmW1gYU5S9FOnJ0" crossorigin="anonymous"></script>

	<script src="https://cdn.jsdelivr.net/npm/@tensorflow/tfjs@1.3.1/dist/tf.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/@teachablemachine/image@0.8/dist/teachablemachine-image.min.js"></script>

	<script>
        const img = document.getElementById('img');
        const result = document.getElementById('result');
        let input = document.getElementById('input');
        const modelPath = "./tensorflow/my_model/";
        const modelURL = modelPath + "model.json";
        const metadataURL = modelPath + "metadata.json";
        
        tmImage.load(modelURL, metadataURL).then(model => {
       		document.getElementById('loader').style.display = 'none';
       		document.getElementById('status').innerHTML = "잃어버린 분실물 사진을 업로드하여 검색해 보세요.";

        	function run() {
        		model.predict(img).then(predictions => {
            		console.log('Predictions: ', predictions);
               		predictions.sort((a, b) => (b.probability - a.probability));
               		result.innerHTML = predictions[0].className + ' ' + parseInt(predictions[0].probability * 100) + '%';
               		console.log(predictions[0].className + ' ' + parseInt(predictions[0].probability * 100) + '%');
               		document.getElementById('search').value = predictions[0].className;
            	});
        	};

        	input.addEventListener('change', (e) => {
        		img.src = URL.createObjectURL(e.target.files[0]);
        	}, false);

        	img.onload = function () {
        		run();
        	};
    	});
    </script>
	<!-- CSS(부트스트랩 사용) -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>
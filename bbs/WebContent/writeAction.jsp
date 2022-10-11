<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="java.io.PrintWriter"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" />
<jsp:setProperty name="bbs" property="bbsTitle" />
<jsp:setProperty name="bbs" property="bbsContent" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%  // 게시글 작성 기능 구현
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		int boardID = 0;
		if (request.getParameter("boardID") != null){
			boardID = Integer.parseInt(request.getParameter("boardID"));
		}
		
		String realFolder="";
		String saveFolder = "bbsUpload";	// 사진을 저장할 경로
		String encType = "utf-8";			// 변환 형식
		String map="";	
		int maxSize=5*1024*1024;			// 사진 size
		
		ServletContext context = this.getServletContext();	// 절대경로 얻기
		realFolder = context.getRealPath(saveFolder);		// saveFolder의 절대경로 얻기
		
		MultipartRequest multi = null;
		
		// 파일 업로드 직접적으로 담당
		multi = new MultipartRequest(request,realFolder,maxSize,encType,new DefaultFileRenamePolicy());	
		
		// form으로 부터 전달받은 3가지
		String fileName = multi.getFilesystemName("fileName");
		String bbsTitle = multi.getParameter("bbsTitle");
		String bbsContent = multi.getParameter("bbsContent");
		
		bbs.setBbsTitle(bbsTitle);
		bbs.setBbsContent(bbsContent);
		
		if(boardID==1){
			map = multi.getParameter("map");
		}
		bbs.setMap(map);
		
		if (userID == null) { // 로그아웃 -> 로그인 페이지로 이동
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('게시글을 작성하려면 로그인이 필요합니다.')"); 
			script.println("location.href = 'login.jsp'"); 
			script.println("</script>");			
		} else {
			if (bbs.getBbsTitle().equals("") || bbs.getBbsContent().equals("")) { // 공란 있음
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.')"); // 경고창 띄움
				script.println("history.back()"); // 이전 페이지로 돌려보냄
				script.println("</script>");
			} else {
				BbsDAO BbsDAO = new BbsDAO();
				int result = BbsDAO.write(boardID, bbs.getBbsTitle(), userID, bbs.getBbsContent(), bbs.getMap());
		 		if (result == -1){
			 		PrintWriter script = response.getWriter();
			 		script.println("<script>");
			 		script.println("alert('글쓰기에 실패했습니다.')");
			 		script.println("history.back()");
			 		script.println("</script>");
			 	} else { // 게시글 작성 성공
					PrintWriter script = response.getWriter();
					if(fileName != null){
						File oldFile = new File(realFolder+"\\"+fileName);
						File newFile = new File(realFolder+"\\"+(result-1)+"사진.jpg");
						oldFile.renameTo(newFile);
					}
					script.println("<script>");
					script.println("alert('게시글이 등록되었습니다.')");
					script.println("location.href= \'bbs.jsp?boardID="+boardID+"\'"); // 게시글을 등록했으므로 게시판 페이지로 이동
					script.println("</script>");
				} 
			}
		}
	%>

</html>
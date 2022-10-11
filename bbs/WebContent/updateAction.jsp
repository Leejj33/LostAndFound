<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="java.io.PrintWriter"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%  // 게시글 수정 기능 구현
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		int boardID = 0;
		if (request.getParameter("boardID") != null){
			boardID = Integer.parseInt(request.getParameter("boardID"));
		}
		if (userID == null) { // 로그아웃 -> 로그인 페이지로 이동
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('게시글을 수정하려면 로그인이 필요합니다.')"); 
			script.println("location.href = 'login.jsp'"); 
			script.println("</script>");			
		} 		
		int bbsID = 0; // 존재하는 글
		if (request.getParameter("bbsID") != null) {
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if (bbsID == 0) { // 존재하지 않는 글
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 글입니다.')"); // 경고창 띄우고 
			script.println("location.href = 'bbs.jsp?boardID="+boardID+"\'"); // 게시판 페이지로 보냄
			script.println("</script>");
		}
		Bbs bbs = new BbsDAO().getBbs(bbsID);
		
		String realFolder="";
		String saveFolder = "bbsUpload";
		String encType = "utf-8";
		String map="";
		int maxSize=5*1024*1024;
		
		ServletContext context = this.getServletContext();
		realFolder = context.getRealPath(saveFolder);
		
		MultipartRequest multi = null;
		
		multi = new MultipartRequest(request,realFolder,maxSize,encType,new DefaultFileRenamePolicy());		
		String fileName = multi.getFilesystemName("fileName");
		String bbsTitle = multi.getParameter("bbsTitle");
		String bbsContent = multi.getParameter("bbsContent");
		bbs.setBbsTitle(bbsTitle);
		bbs.setBbsContent(bbsContent);
		
		if (!userID.equals(bbs.getUserID())) { // 접속자와 작성자가 다르면 
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')"); // 글 수정 권한 없음 
			script.println("location.href = 'bbs.jsp?boardID="+boardID+"\'"); // 게시판 페이지로 보냄
			script.println("</script>");
		} else {
			if (bbs.getBbsTitle().equals("") || bbs.getBbsContent().equals("")) { // 공란 있음
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.')"); // 경고창 띄움
				script.println("history.back()"); // 이전 페이지로 돌려보냄
				script.println("</script>");
			} else {
				BbsDAO bbsDAO = new BbsDAO(); // 공란 없음 -> 게시글 수정
				int result = bbsDAO.update(bbsID, bbs.getBbsTitle(), bbs.getBbsContent(), bbs.getMap());
				if (result == -1) { // 데이터베이스 오류
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('게시글 수정에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				} else { // 게시글 수정 성공
					PrintWriter script = response.getWriter();
					if(fileName != null){
						String real =  "C:\\JSP\\projects\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\BBS\\bbsUpload";
						File delFile = new File(real+"\\"+bbsID+"사진.jpg");
						if(delFile.exists()){
							delFile.delete();
						}
						File oldFile = new File(realFolder+"\\"+fileName);
						File newFile = new File(realFolder+"\\"+bbsID+"사진.jpg");
						oldFile.renameTo(newFile);
					}
					script.println("<script>");
					script.println("alert('게시글이 수정되었습니다.')");
					script.println("location.href = 'bbs.jsp?boardID="+boardID+"\'"); // 게시글을 수정했으므로 게시판 페이지로 이동
					script.println("</script>");
				} 
			}
		}
	%>

</html>
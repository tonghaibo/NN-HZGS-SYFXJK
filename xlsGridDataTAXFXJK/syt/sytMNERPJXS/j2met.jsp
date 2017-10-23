<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="java.lang.*,com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>main</title>
</head>
<body>
<p align="center"><img src="resource://pages/title.png"></p>
<%          
             response.setHeader("Pragma","No-cache"); 
             response.setHeader("Cache-Control","no-cache"); 
             response.setDateHeader("Expires", 0); 
             String y1 = EAFunc.NVL(request.getParameter("y1"),"");
             String m1 = EAFunc.NVL(request.getParameter("m1"),"");
             String d1 = EAFunc.NVL(request.getParameter("d1"),"");
             String y2 = EAFunc.NVL(request.getParameter("y2"),"");
             String m2 = EAFunc.NVL(request.getParameter("m2"),"");
             String d2 = EAFunc.NVL(request.getParameter("d2"),"");
             String bascat = EAFunc.NVL(request.getParameter("bascat"),"");//条线ID
             String date1 = y1+"-"+m1+"-"+d1;
             String date2 = y2+"-"+m2+"-"+d2;
             out.print("<br>"+y1+date1+"<br>"+date2);
%>
</body>
</html>
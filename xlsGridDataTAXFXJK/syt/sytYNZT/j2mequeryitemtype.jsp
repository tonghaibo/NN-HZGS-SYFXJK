<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>main</title>
</head>
<body>
<%
String corpid = EAFunc.NVL(request.getParameter("corpid"),"");
String kaflag = EAFunc.NVL(request.getParameter("kaflag"),"");
out.print("<img src=\"resource://pages/1.png\">　<a href=\"j2mequeryitem.jsp?itemtype=1&brand=MN&corpid="+corpid+"&pageno1=1\">蒙牛常温</a><br>");
out.print("<img src=\"resource://pages/2.png\">　<a href=\"j2mequeryitem.jsp?itemtype=2&brand=MN&corpid="+corpid+"&pageno1=1\">蒙牛低温</a><br>");
out.print("<img src=\"resource://pages/3.png\">　<a href=\"j2mequeryitem.jsp?itemtype=1&brand=DN&corpid="+corpid+"&pageno1=1\">达能常温</a><br>");
out.print("<img src=\"resource://pages/4.png\">　<a href=\"j2mequeryitem.jsp?itemtype=2&brand=DN&corpid="+corpid+"&pageno1=1\">达能低温</a><br>");

%>
<line><a href="j2mequerycorp.jsp?&amp;kaflag=<%=kaflag%>">返回上页</a>
<a href="j2memain.jsp">返回主界面</a>
</body>
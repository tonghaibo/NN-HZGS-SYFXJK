<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>商品类型</title>
</head>
<body>
<%
         String corpbascat13 = EAFunc.NVL(request.getParameter("corpbascat13"),"");
%>
<img src="resource://pages/title.png"><hr>
<p align="center">请选择商品大类</p>
<img src="resource://pages/1.png">&nbsp;
<a href="j2mejxsmngitmsum.jsp?corpbascat13=<%=corpbascat13%>&itemtype=1">常温</a><br>
<img src="resource://pages/2.png">&nbsp;
<a href="j2mejxsmngitmsum.jsp?corpbascat13=<%=corpbascat13%>&itemtype=2">低温</a><br>
<hr>
<p align="center">
<a href="j2mejxsmngquery.jsp">选择经销商</a><a href="j2memain.jsp">主菜单</a>
</p>
</body>
</html>
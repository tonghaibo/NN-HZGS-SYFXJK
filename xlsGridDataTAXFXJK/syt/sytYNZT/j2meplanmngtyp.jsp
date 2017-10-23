<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>商品大类</title>
</head>
<body>
<%         out.println( "<p align=\"center\"><img  src=\"resource://pages/title.png\" ></P><hr>" );
           String date1 = EAFunc.NVL(request.getParameter("date1"),"");//起始日期
           String date2 =  EAFunc.NVL(request.getParameter("date2"),"");//截至日期
%>
<p align="center">请选择商品大类</p>
<img src="resource://pages/1.png">&nbsp;
<a href="j2meplanmng.jsp?itemtype=1&date1=<%=date1%>&date2=<%=date2%>">常温</a><br>
<img src="resource://pages/2.png">&nbsp;
<a href="j2meplanmng.jsp?itemtype=2&date1=<%=date1%>&date2=<%=date2%>">低温</a><br>
<hr>
<p align="center">
<a href="j2memain.jsp">返回主菜单</a>
</p>
</body>
</html>
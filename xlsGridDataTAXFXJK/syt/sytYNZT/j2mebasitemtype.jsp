<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>卖场订单</title>
</head>
<body>
<%
         response.addHeader("Pragma","No-cache"); 
         response.addHeader("Cache-Control","no-cache"); 
         response.addDateHeader("Expires", 0);    
         String corpid = EAFunc.NVL(request.getParameter("corpid"),"");
         String corpsoid = EAFunc.NVL(request.getParameter("corpsoid"),"");
         String pageno = EAFunc.NVL(request.getParameter("showpage"),"1");

%>
<p align="center"><img src="resource://pages/title.png"></p>
<hr>
<p align="center">当前订单号:<%=corpsoid%></p>
<p align="left">
<img src="resource://pages/2.png">
<a href="j2meenterAll.jsp?itemtype=1&corpid=<%=corpid%>&corpsoid=<%=corpsoid%>&brand=&mobtyp=&subtyp=2&showpage=<%=pageno%>">常温</a>
<br>
<img src="resource://pages/3.png">
<a href="j2meenterAll.jsp?itemtype=2&corpid=<%=corpid%>&corpsoid=<%=corpsoid%>&brand=&mobtyp=&subtyp=2&showpage=<%=pageno%>">低温</a>
</p>
<hr>
<p align="center">
<a href="j2menewcorplist.jsp">返回网点</a> <a href="j2memain.jsp">返回主界面</a>
</p>
</p>
</body>
</html>
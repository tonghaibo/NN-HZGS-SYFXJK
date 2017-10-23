<%@ page contentType="text/html;charset=UTF8"%> 
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*"%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF8"/>
    <title>选择商品类型历史</title>
</head>
<body>
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

%>
<p align="center"> <img  src="resource://pages/title.png" ></P><hr></br>
<p align="center">请选择商品大类</p></br>
<p align="left"> 
<img  src="resource://pages/1.png" > <a href="j2mehisbyitem.jsp?flag=1&y1=<%=y1%>&m1=<%=m1%>&d1=<%=d1%>&y2=<%=y2%>&m2=<%=m2%>&d2=<%=d2%>">常温</a></br>
<img  src="resource://pages/2.png" > <a href="j2mehisbyitem.jsp?flag=2&y1=<%=y1%>&m1=<%=m1%>&d1=<%=d1%>&y2=<%=y2%>&m2=<%=m2%>&d2=<%=d2%>">低温</a></br>
</p>
<hr><br>
<p align="center"> <a href="j2mehistime.jsp">返回上一页</a></P>
</body>
</html>

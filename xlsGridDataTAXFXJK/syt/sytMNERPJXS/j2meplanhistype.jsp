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
        String date1 = EAFunc.NVL(request.getParameter("date1"),"");
        String date2 = EAFunc.NVL(request.getParameter("date2"),"");
        String flag = EAFunc.NVL(request.getParameter("flag"),"");
%>
<p align="center"> <img  src="resource://pages/title.png" ></P><hr></br>
<p align="center">请选择商品大类</p></br>
<p align="left">
<%
       if(flag.equalsIgnoreCase("1")){
%>
<img  src="resource://pages/1.png" > <a href="j2meplanhisendbyqty.jsp?itemtype=1&date1=<%=date1%>&date2=<%=date2%>&flag=<%=flag%>">常温</a></br>
<img  src="resource://pages/2.png" > <a href="j2meplanhisendbyqty.jsp?itemtype=2&date1=<%=date1%>&date2=<%=date2%>&flag=<%=flag%>">低温</a></br>
<%
         } if(flag.equalsIgnoreCase("2")){
%>
<img  src="resource://pages/1.png" > <a href="j2meplanhisendbymny.jsp?itemtype=1&date1=<%=date1%>&date2=<%=date2%>&flag=<%=flag%>">常温</a></br>
<img  src="resource://pages/2.png" > <a href="j2meplanhisendbymny.jsp?itemtype=2&date1=<%=date1%>&date2=<%=date2%>&flag=<%=flag%>">低温</a></br>
<%
        }
%>
</p>
<hr><br>
<p align="center"> <a href="j2meplanandhis.jsp?flag=<%=flag%>">返回上一页</a></P>
</body>
</html>

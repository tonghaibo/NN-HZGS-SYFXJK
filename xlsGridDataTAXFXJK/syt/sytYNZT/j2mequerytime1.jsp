<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*,java.util.*" %><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>按时间查询计划</title>
</head>
<body>
 <p align="center"><img src="resource://pages/title.png"></p><line>
<%      
        String bascat = EAFunc.NVL(request.getParameter("bascat"),"");
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE,-1);
        %>
<xlsgridform name="f1" action="j2meplanLoc.jsp?bascat=<%=bascat%>">
输入起始日期:<br>
年:<input type="text" name="y1" format="*N" size="5" value="<%=(cal.getTime().getYear()+1900)%>"/>
月:<input type="text" name="m1" format="*N" size="5" value="<%=(cal.getTime().getMonth()+1)%>"/>
日:<input type="text" name="d1" format="*N" size="5" value="<%=cal.getTime().getDate()%>"/><br>
输入截止日期:<br>
年:<input type="text" name="y2" format="*N" size="5" value="<%=(cal.getTime().getYear()+1900)%>"/>
月:<input type="text" name="m2" format="*N" size="5" value="<%=(cal.getTime().getMonth()+1)%>"/>
日:<input type="text" name="d2" format="*N" size="5" value="<%=cal.getTime().getDate()%>"/><br>
<p align="center">
<input type="submit" name="com1" value="查询"><br>
</p>
</xlsgridform>
<p align="center">
<a href="j2memain.jsp">返回主页</a><br>
</p>
</body>
</html>
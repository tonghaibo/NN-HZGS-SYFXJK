<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*,java.util.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>main</title>
</head>
<body>
<%      
        //String kaflag = EAFunc.NVL(request.getParameter("kaflag"),"");
        int showpage = 1;
        String sMsg = "";
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE,-1);
        
        %>
<xlsgridform name="f1" action="j2mebaschecktype.jsp">
输入起始日期:<br>
年:<input type="text" name="y1" format="*N" size="5" value="<%=(cal.getTime().getYear()+1900)%>"/>
月:<input type="text" name="m1" format="*N" size="5" value="<%=(cal.getTime().getMonth()+1)%>"/>
日:<input type="text" name="d1" format="*N" size="5" value="<%=cal.getTime().getDate()%>"/><br>
输入截止日期:<br>
年:<input type="text" name="y2" format="*N" size="5" value="<%=(cal.getTime().getYear()+1900)%>"/>
月:<input type="text" name="m2" format="*N" size="5" value="<%=(cal.getTime().getMonth()+1)%>"/>
日:<input type="text" name="d2" format="*N" size="5" value="<%=cal.getTime().getDate()%>"/>
<input type="hidden" name="showpage" value="<%=showpage%>" />
</xlsgridform></br>
<p align="center">
</br><input type="submit" name="com1" value="查询"></br>
</p>
<line>
<p align="center">
<a href="j2mebasquery.jsp">返回上页</a> &nbsp;<a href="j2memain.jsp">返回主页</a>
</p>
</body>
</html>
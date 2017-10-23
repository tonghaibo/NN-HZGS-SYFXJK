<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>main</title>
</head>
<body>
 <%     
        out.println( "<p align=\"center\"><img border=\"0\" src=\"resource://pages/title.png\" ></P><line>" );
        response.addHeader("Pragma","No-cache"); 
        response.addHeader("Cache-Control","no-cache"); 
        response.addDateHeader("Expires", 0);   
        String name = "";
        String corpid = "";
        String sUsrnam="";
        EAXmlDS ds = null;
        String curdat = EADbTool.GetSQL("SELECT TO_CHAR(SYSDATE,'HH24MIss') FROM DUAL");
        String sUID  = (String)session.getAttribute("sUID");
        String y1 = "";
        String m1 ="";
        String d1 = "";
        String y2 = "";
        String m2 ="";
        String d2 = "";
        y1 = EAFunc.NVL(request.getParameter("y1"),"");
        m1 = EAFunc.NVL(request.getParameter("m1"),"");
        d1 = EAFunc.NVL(request.getParameter("d1"),"");
        y2 = EAFunc.NVL(request.getParameter("y2"),"");
        m2 = EAFunc.NVL(request.getParameter("m2"),"");
        d2 = EAFunc.NVL(request.getParameter("d2"),"");
    %>
    

<p align="center">
选择查询方式<br/>
</p>
<p align="left">

<img src="resource://pages/1.png"/> <a href="j2mebascheckcorp.jsp?y1=<%=y1%>&m1=<%=m1%>&d1=<%=d1%>&y2=<%=y2%>&m2=<%=m2%>&d2=<%=d2%>">按门店汇总</a></br>
<img src="resource://pages/2.png"/> <a href="j2mebascheckall.jsp?y1=<%=y1%>&m1=<%=m1%>&d1=<%=d1%>&y2=<%=y2%>&m2=<%=m2%>&d2=<%=d2%>">按商品汇总</a></br>
</p>
<line>
<p align="center">
<a href="j2memain.jsp">返回主页</a></br>
</p>
</body>
</html>
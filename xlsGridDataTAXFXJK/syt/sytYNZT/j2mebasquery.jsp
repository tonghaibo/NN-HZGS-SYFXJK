<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>main</title>
</head>
<body>
<%
        response.addHeader("Pragma","No-cache"); 
        response.addHeader("Cache-Control","no-cache"); 
        response.addDateHeader("Expires", 0);   
        String sUsrnam = "";
        String curdat = "";
        out.println( "<p align=\"center\"><img border=\"0\" src=\"resource://pages/title.png\" ></P><line>" );
  try
  {
    //EAUserinfo usrinfo = MobileLogin.CheckIfLogin(request);
    // 得到登陆的USER ID
    String sUID  = (String)session.getAttribute("sUID");
   // sUsrnam= EADbTool.GetSQL("SELECT NAME FROM USR WHERE id='"+sUID+"'");
    curdat = EADbTool.GetSQL("SELECT TO_CHAR(SYSDATE,'HH24MIss') FROM DUAL");
  }
  catch(EAException e)
  {	
    out.println("发生错误："+e.toString());
    out.println("<br/><a href='j2melogin.jsp'>重新登录</a>");
  }
%>
<p align="center">订单查询</p></br>
<p align="left">
<img src="resource://pages/1.png"> <a href="j2mebasitemsum.jsp">当天订单汇总</a><br/>
<img src="resource://pages/2.png"> <a href="j2mebasquerycorp.jsp">网点订单查询</a><br/>
<img src="resource://pages/3.png"> <a href="j2mebasqueryalllist.jsp">订单汇总查询</a><br/>
<img src="resource://pages/4.png"> <a href="j2mebasquerylist.jsp">单笔订单查询</a><br/>
<img src="resource://pages/5.png"> <a href="j2mebasSeldate.jsp">历史订单查询</a><br/>
</p>
<line>
<p align="center"><a href="j2memain.jsp">返回主页</a></p></br>
</body>
</html>

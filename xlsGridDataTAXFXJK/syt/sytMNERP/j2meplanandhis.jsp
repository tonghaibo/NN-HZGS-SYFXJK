<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>选择日期</title>
</head>
<body>
<%
     out.println( "<p align=\"center\"><img  src=\"resource://pages/title.png\" ></P><hr>" );
     String sql = "";
     String dat = "";
     String flag = EAFunc.NVL(request.getParameter("flag"),"");
     EAXmlDS ds = null;
     try{
           sql = "select  to_char(sysdate,'yyyy')y1,to_char(sysdate,'mm') m1,to_char(sysdate,'dd') d1,to_char(sysdate,'YYYYMMDD') yymmdd FROM DUAL";
            ds = EADbTool.QuerySQL(sql);
            dat = ds.getStringAt(0,"yymmdd");

           }catch(EAException e){
               out.print("操作错误，请重新登录");
               out.print("<a href=\"j2melogin.jsp\"></a>");
                   throw e;
             }
  %>
<form id="form1" name="form1" method="post" action="j2meplanhistype.jsp?flag=<%=flag%>">
<p align="center">起始日期：格式YYYYMMDD
<input name="date1" type="text" id="date1" size="10" maxlength="10" value="<%=dat%>" /></p>
<p align="center">截至日期：格式YYYYMMDD
<input name="date2" type="text" id="date2" size="10" maxlength="10" value="<%=dat%>" /></p>
<input type="HIDDEN" name="flag" id="flag" value="<%=flag%>">
<p align="center">
    <input type="submit" name="button" id="button" value="确定" />
</p>
</form>
<p align="center">
<br><hr><br>
<a href="j2meplanhisflag.jsp">返回</a>
</p>
</body>
</html>

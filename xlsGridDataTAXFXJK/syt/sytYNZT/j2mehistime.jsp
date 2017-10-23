<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*,java.util.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>中心历史查询时间段</title>
</head>
<body>
<%
              String y1= "";
              String y2 = "";
              String m1 = "";
              String m2 = "";
              String d1 = "";
              String d2 = "";
              EAXmlDS ds = null;
              String sql = "";
              //String flag = EAFunc.NVL(request.getParameter("flag"),"");;
              //String bascat = EAFunc.NVL(request.getParameter("bascat"),"");//条线ID
              //String number = EAFunc.NVL(request.getParameter("number"),"");
          
      try{
              sql = "select  to_char(sysdate,'yyyy')y,to_char(sysdate,'mm') m,to_char(sysdate,'dd') d,to_char(sysdate,'YYYYMMDD') yymmdd FROM DUAL";
              ds = EADbTool.QuerySQL(sql);
              y1 = ds.getStringAt(0,"y");
              m1 = ds.getStringAt(0,"m");
              d1 = ds.getStringAt(0,"d");
              y2 = ds.getStringAt(0,"y");
              m2 = ds.getStringAt(0,"m");
              d2 = ds.getStringAt(0,"d");
         
      }catch(EAException e){
               out.print("操作错误，请重新登录");
               out.print("<a href=\"j2melogin.jsp\">");
                   throw e;
             }
%>

<form id="form1" name="form1" method="post" action="j2mehisitemtype.jsp">
  <p align="center">起始日期</p>
  年：
    <input name="y1" type="text" id="y1" size="10" maxlength="10" value="<%=y1%>" />
 月：
    <input name="m1" type="text" id="m1" size="10" maxlength="10" value="<%=m1%>"/>
 日：
    <input name="d1" type="text" id="d1" size="10" maxlength="10" value="<%=d1%>" />
<p align="center">截至日期</p>
年：
    <input name="y2" type="text" id="y2" size="10" value="<%=y2%>"/>
月：
    <input name="m2" type="text" id="m2" size="10" value="<%=m2%>" />
日：
    <input name="d2" type="text" id="d2" size="10" value="<%=d2%>" /></br>
  </p>  
<p align="center">
    <input type="submit" name="button" id="button" value="查询" />
</p>
</form>
</body>
</html>
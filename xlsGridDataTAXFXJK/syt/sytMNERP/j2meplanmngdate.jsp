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
     String itemtype = EAFunc.NVL(request.getParameter("itemtype"),"");//1.常温，2.低温
     String y1 = "";//默认时间
     String m1 = "";
     String d1 = "";
     String sql = "";
     EAXmlDS ds = null;
    String date1 = "";
    String date2 = "";
    
    try{
      sql = "select  to_char(sysdate,'yyyy')y1,to_char(sysdate,'mm') m1,to_char(sysdate,'dd') d1,to_char(sysdate,'YYYYMMDD') yymmdd FROM DUAL";
            ds = EADbTool.QuerySQL(sql);
            y1 = ds.getStringAt(0,"y1");
            m1 = ds.getStringAt(0,"m1");
            d1 = ds.getStringAt(0,"d1");
            date1 = ds.getStringAt(0,"yymmdd");
            date2 = ds.getStringAt(0,"yymmdd");
    
    }catch(EAException e){
               out.print("操作错误，请重新登录");
               out.print("<a href=\"j2melogin.jsp\"></a>");
                   throw e;
             }
  %>
<form id="form1" name="form1" method="post" action="j2meplanmngtyp.jsp">
<p align="center">起始日期：格式YYYYMMDD</p>
<input name="date1" type="text" id="date1" size="10" maxlength="10" value="<%=date1%>" />
<p align="center">截至日期：格式YYYYMMDD</p>
<input name="date2" type="text" id="date2" size="10" maxlength="10" value="<%=date2%>" />
<p align="center">
    <input type="submit" name="button" id="button" value="确定" />
</p>
</form>
<p align="center">
<br><hr><br>
<a href="j2meplanmngtyp.jsp">返回</a>
</p>
</body>
</html>

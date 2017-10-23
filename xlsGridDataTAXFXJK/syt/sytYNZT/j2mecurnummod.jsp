<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>选择修改界面</title>
</head>
<body>
<p align="center"><img border="0" src="resource://pages/title.png" ></P><hr></br>
<p align = "left">请输入新订单号：</p></br>
<%
        String katype = "";
        String pageno = "";
        String corpid = "";
        String corpsoid = "";
        String sUID  = (String)session.getAttribute("sUID");
    try{
         katype = EAFunc.NVL(request.getParameter("katype"),"");
         pageno = EAFunc.NVL(request.getParameter("showpage"),"1");
         corpid = EAFunc.NVL(request.getParameter("corpid"),"1");
         corpsoid = EAFunc.NVL(request.getParameter("corpsoid"),"1");
      } catch(Exception e){
      out.println("发生错误："+e.toString());
      out.println("<br/><a href='j2melogin.jsp'>重新登录</a>");
    }
%>
<form id="form1" name="form1" method="post" action="j2mecorpsoidmod.jsp?corpid=<%=corpid%>&corpsoid=<%=corpsoid%>&katype=<%=katype%>&showpage=<%=pageno%>&subtyp=2">
  <p align="center">
    <input name="corpsoidnew" type="text" id="corpsoidnew" value="<%=corpsoid%>" size="20" maxlength="20" />
    <br>
  </p>
  <p align="center">
    <br><input type="submit" name="button" id="button" value="修改" />
  </p>
</form>
<hr>
<p align="center">
<a href="j2mecurlistmenu.jsp?corpid=<%=corpid%>&corpsoid=<%=corpsoid%>&showpage=<%=pageno%>&katype=<%=katype%>">返回上一页</a>
</p>
</body>
</html>
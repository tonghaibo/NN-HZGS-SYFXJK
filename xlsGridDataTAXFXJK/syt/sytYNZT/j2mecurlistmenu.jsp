<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>选择修改界面</title>
</head>
<body>
<p align="center"><img border="0" src="resource://pages/title.png" ></P><hr></br>
<p align = "center">请选择修改类型</p></br>
<%       
//        out.println( "<p align=\"center\"><img border=\"0\" src=\"resource://pages/title.png\" ></P><line>" );
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
//        out.println( "<a href='j2mebasitemtype.jsp?corpid="+corpid+"&katype="+katype+"&corpsoid="+corpsoid+"&showpage="+pageno+"&subtyp=2'>");
        
%>
<p align="left">
<img  src="resource://pages/1.png" > <a href="j2mecurnummod.jsp?corpid=<%=corpid%>&corpsoid=<%=corpsoid%>&katype=<%=katype%>&showpage=<%=pageno%>&subtyp=2">修改订单号</a></br>
<img  src="resource://pages/2.png" > <a href="j2mebasitemtype.jsp?corpid=<%=corpid%>&katype=<%=katype%>&corpsoid=<%=corpsoid%>&showpage=<%=pageno%>&subtyp=2">修改订单</a></br>
<img  src="resource://pages/3.png" > 删除订单(开发中)</br>
</p>
<hr>
<p align="center">
<a href="j2mebasinputbil.jsp?corpid=<%=corpid%>&corpsoid=<%=corpsoid%>&showpage=<%=pageno%>&katype=<%=katype%>">返回上一页</a>
</p>
</body>
</html>

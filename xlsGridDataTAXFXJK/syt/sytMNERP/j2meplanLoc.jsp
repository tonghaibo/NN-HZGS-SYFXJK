<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>main</title>
</head>
<body>
<%    
   out.println( "<p align=\"center\"><img  src=\"resource://pages/title.png\" ></P><line>" );
//   String bascat = EAFunc.NVL(request.getParameter("bascat"),"");
   String number = EAFunc.NVL(request.getParameter("number"),"");
//   out.print(bascat);
//   String type = EAFunc.NVL(request.getParameter("type"),"");
   String sOut = "";
   String sOut1 = "";
   String sql = "";
   EAXmlDS ds = null;
   try
   {
      
    //EAUserinfo usrinfo = MobileLogin.CheckIfLogin(request);
    //String sUID  = usrinfo.getUsrid();
    sql = "select id,name from v_loc";
    ds = EADbTool.QuerySQL(sql);
    int c = ds.getRowCount();
    String locname = "";
    String locid = ""; 
    sOut = "选择库位<br/>";
    if ( c>0)
    {
        for ( int i=0;i<c;i++)
        {
            
            locname = ds.getStringAt(i,"name");
            locid = ds.getStringAt(i,"id");
            sOut1 += "<img src=\"resource://pages/"+(i%9+1)+".png\"> <a href=\"j2meplanitemtype.jsp?locid="+locid+"&planflag=plan&number="+number+"\">"+locname+"</a><br>";         
        }
    }
   // out.print("<a href=\"j2memain.jsp\">返回主页</a>");
    
}
catch ( Exception e )
{ 
     out.println("<br/><a href='j2melogin.jsp'>重新登录</a>");
}

%>
<p align="center">
<%=sOut%>
</p>
<p align="left">
<%=sOut1%>
</p>
<br><hr><br>
<p align="center">
<a href=\"j2memain.jsp\">返回主页</a>
</p>
</body>
</html>
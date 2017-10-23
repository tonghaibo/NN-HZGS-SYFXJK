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
        String sUsrnam="";
        EAXmlDS ds = null;
        String corpsoid = "";
        String soid = "";
        String curdat="";
        String sOut="";
        String sUID  = (String)session.getAttribute("sUID");
    
  try
  {
    //EAUserinfo usrinfo = MobileLogin.CheckIfLogin(request);
    // 得到登陆的USER ID
    //String sUID  = usrinfo.getUsrid();
	  curdat = EADbTool.GetSQL("SELECT TO_CHAR(SYSDATE,'HH24MIss') FROM DUAL");
    sUsrnam= EADbTool.GetSQL("SELECT NAME FROM USR WHERE id='"+sUID+"'");
    String sql = "select distinct corpsoid from curord where crtusr='"+sUID+"'";
    ds = EADbTool.QuerySQL(sql);
    int row = ds.getRowCount();
    //out.print("<card id=\"card1\" title=\"欢迎"+sUsrnam+"\" newcontext=\"true\">");		
    //out.print("<p align=\"center\">");	
    if ( row > 0 )
    {
        for (int i=0;i<row;i++ )
        {
          corpsoid = ds.getStringAt(i,"corpsoid");
          if ( corpsoid.length() < 1 )
          {   
             soid = "空订单号";
             // out.print("<anchor>"+"空订单号");
          }
          else
          {
             soid = corpsoid;
              //out.print("<anchor>"+corpsoid);
          }         
          sOut = "<img src=\"resource://pages/"+(i+1)+".png\">" 
                 +"<a href=\"j2mebaslist.jsp?&curdat="+curdat+"&corpsoid="+corpsoid+"\">"+soid+"</a><br>";
                 
//          out.print("<go href=\"bas_list.jsp\">");
//          out.print("<postfield name=\"corpsoid\" value=\""+corpsoid+"\"/>");
//		      out.print("<postfield name=\"curdat\" value=\""+curdat+"\"/>");
//          out.print("</go></anchor><br/>");     
        
        }
    }    
}
  catch(EAException e)
  {
    //out.print("<card><p>");		
    out.println("发生错误："+e.toString());
    out.println("<br/><a href='logon.jsp'>重新登录</a>");
  }
%>
<p align="center">
网点列表
</p>
<p align="left">
<%=sOut%>
</p>
<line>
<p align="center">
<a href="j2mebasquery.jsp">返回上页</a> &nbsp;<a href="j2memain.jsp">返回主页</a>
</p>
</body>
</html>

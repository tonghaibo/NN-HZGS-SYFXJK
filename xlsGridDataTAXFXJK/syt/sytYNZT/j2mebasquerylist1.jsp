<%@ page contentType="text/vnd.wap.wml;charset=gb2312" import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*"%> 
<?XML version="1.0" encoding="gb2312"?> 
<!DOCTYPE wml PUBLIC "-//WAPFORUM//DTD WML 1.1//EN" "http://www.wapforum.org/DTD/wml_1.1.xml">
<wml>
<%
        response.addHeader("Pragma","No-cache"); 
        response.addHeader("Cache-Control","no-cache"); 
        response.addDateHeader("Expires", 0);   
        String sUsrnam="";
        EAXmlDS ds = null;
         String corpsoid = "";
  try
  {
    EAUserinfo usrinfo = MobileLogin.CheckIfLogin(request);
    // 得到登陆的USER ID
    String sUID  = usrinfo.getUsrid();
	 String curdat = EADbTool.GetSQL("SELECT TO_CHAR(SYSDATE,'HH24MIss') FROM DUAL");
    sUsrnam= EADbTool.GetSQL("SELECT NAME FROM USR WHERE id='"+sUID+"'");
    String sql = "select distinct corpsoid from curord where crtusr='"+sUID+"'";
    ds = EADbTool.QuerySQL(sql);
    int row = ds.getRowCount();
    out.print("<card id=\"card1\" title=\"欢迎"+sUsrnam+"\" newcontext=\"true\">");		
    out.print("<p align=\"center\">");	
    if ( row > 0 )
    {
        for (int i=0;i<row;i++ )
        {
          corpsoid = ds.getStringAt(i,"corpsoid");
          if ( corpsoid.length() < 1 )
          {
              out.print("<anchor>"+"空订单号");
          }
          else
          {
              out.print("<anchor>"+corpsoid);
          }         
          out.print("<go href=\"bas_list.jsp\">");
          out.print("<postfield name=\"corpsoid\" value=\""+corpsoid+"\"/>");
		  out.print("<postfield name=\"curdat\" value=\""+curdat+"\"/>");
          out.print("</go></anchor><br/>");     
        
        }
    }
    out.print("<a href=\"bas_query.jsp\">返回上页</a><br/>");
    out.print("<a href=\"main.jsp?curdat="+curdat+"\">返回主页</a><br/>");
    
  }
  catch(EAException e)
  {
    out.print("<card><p>");		
    out.println("发生错误："+e.toString());
    out.println("<br/><a href='logon.jsp'>重新登录</a>");
  }
%>
</p>
</card>
</wml>

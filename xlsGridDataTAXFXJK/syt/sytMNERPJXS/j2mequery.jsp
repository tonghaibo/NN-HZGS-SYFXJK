<%@ page contentType="text/vnd.wap.wml;charset=UTF8" import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*"%> 
<?XML version="1.0" encoding="UTF8"?> 
<!DOCTYPE wml PUBLIC "-//WAPFORUM//DTD WML 1.1//EN" "http://www.wapforum.org/DTD/wml_1.1.xml">
<wml>
<%
        response.addHeader("Pragma","No-cache"); 
        response.addHeader("Cache-Control","no-cache"); 
        response.addDateHeader("Expires", 0);   
  String sUsrnam="";
  String kaflag = EAFunc.NVL(request.getParameter("kaflag"),"");
  try
  {
    EAUserinfo usrinfo = MobileLogin.CheckIfLogin(request);
    // 得到登陆的USER ID
    String sUID  = usrinfo.getUsrid();
    sUsrnam= EADbTool.GetSQL("SELECT NAME FROM USR WHERE id='"+sUID+"'");
     String curdat = EADbTool.GetSQL("SELECT TO_CHAR(SYSDATE,'HH24MIss') FROM DUAL");
    out.print("<card id=\"card1\" title=\"欢迎"+sUsrnam+"\" newcontext=\"true\">");		
    out.print("<p align=\"left\">");		
	out.print("当天订单<br/>");
    out.print("<a href=\"j2meitemsum.jsp?curdat="+curdat+"&amp;kaflag="+kaflag+"\">   当天订单汇总</a><br/>");
    out.print("<a href=\"j2mequerycorp.jsp?curdat="+curdat+"&amp;kaflag="+kaflag+"\">   网点汇总查询</a><br/>");
    out.print("历史订单<br/>");
	out.print("<a href=\"j2meSeldate.jsp?kaflag="+kaflag+"\">   历史订单查询</a><br/>");
    out.print("<a href=\"j2memain.jsp\">     返回主页</a><br/>");
    
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
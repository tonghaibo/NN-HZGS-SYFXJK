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
    // �õ���½��USER ID
    String sUID  = usrinfo.getUsrid();
	 String curdat = EADbTool.GetSQL("SELECT TO_CHAR(SYSDATE,'HH24MIss') FROM DUAL");
    sUsrnam= EADbTool.GetSQL("SELECT NAME FROM USR WHERE id='"+sUID+"'");
    String sql = "select distinct corpsoid from curord where crtusr='"+sUID+"'";
    ds = EADbTool.QuerySQL(sql);
    int row = ds.getRowCount();
    out.print("<card id=\"card1\" title=\"��ӭ"+sUsrnam+"\" newcontext=\"true\">");		
    out.print("<p align=\"center\">");	
    if ( row > 0 )
    {
        for (int i=0;i<row;i++ )
        {
          corpsoid = ds.getStringAt(i,"corpsoid");
          if ( corpsoid.length() < 1 )
          {
              out.print("<anchor>"+"�ն�����");
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
    out.print("<a href=\"bas_query.jsp\">������ҳ</a><br/>");
    out.print("<a href=\"main.jsp?curdat="+curdat+"\">������ҳ</a><br/>");
    
  }
  catch(EAException e)
  {
    out.print("<card><p>");		
    out.println("��������"+e.toString());
    out.println("<br/><a href='logon.jsp'>���µ�¼</a>");
  }
%>
</p>
</card>
</wml>

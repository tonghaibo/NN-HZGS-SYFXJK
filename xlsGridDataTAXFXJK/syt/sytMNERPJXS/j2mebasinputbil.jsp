<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>basinputbil</title>
</head>
<body>
<%       
        out.println( "<p align=\"center\"><img border=\"0\" src=\"resource://pages/title.png\" ></P><line>" );
        response.setHeader("Pragma","No-cache"); 
        response.setHeader("Cache-Control","no-cache"); 
        response.setDateHeader("Expires", 0);
        String pageno = "";
        String sUsrnam="";
        String corpid = "";
        String katype = "";
        String sql = "";
        EAXmlDS ds = null;
        EADatabase db = null;
        String curdat ="";
        String corpsoid = "";
        try
        {
          //db = new EADatabase();
          katype = EAFunc.NVL(request.getParameter("katype"),"");
          pageno = EAFunc.NVL(request.getParameter("showpage"),"1");
		      curdat = EADbTool.GetSQL("select to_char(sysdate,'yyyymmddhh24miss') dat from dual");
          //EAUserinfo usrinfo = MobileLogin.CheckIfLogin(request);
          corpid = EAFunc.NVL(request.getParameter("corpid"),"");
          // 得到登陆的USER ID
          String sUID  = (String)session.getAttribute("sUID");
		      String corpguid = EADbTool.GetSQL("select guid from corp where id='"+corpid+"'" );
          //sUsrnam= EADbTool.GetSQL("SELECT NAME FROM USR WHERE id='"+sUID+"'");     
          sql = "select distinct corpsoid from curord where crtusr='"+sUID+"'and subtyp='2' ";
		  if (corpguid.length()>0) sql += " and corp ='"+corpguid+"'";
          //out.print("<card id=\"card1\"  newcontext=\"true\">");		
          //out.print("<p align=\"left\">");		
          ds =  EADbTool.QuerySQL(sql);
          int cnt = ds.getRowCount();

          if ( cnt > 0 )
          {
              out.print("<img src=\"resource://pages/2.png\">　修改现有订单:<br>");
              for ( int i=0;i<cnt;i++ )
              {
                  corpsoid = ds.getStringAt(i,"corpsoid");
                  out.println( "<a href='j2mecurlistmenu.jsp?corpid="+corpid+"&katype="+katype+"&corpsoid="+corpsoid+"&showpage="+pageno+"&subtyp=2'>");
                  if ( corpsoid.length() < 1 )
                  {
                      out.print("空订单号");
                  }
                  else out.print(corpsoid);
                  out.println( "</a><br>" );        
              }
          }   
    }
    catch(EAException e)
    	{
      out.println("发生错误："+e.toString());
      out.println("<br/><a href='j2melogin.jsp'>重新登录</a>");
    }
%>
<br>
 <p align="left">
 <img src="resource://pages/3.png">　输入新订单号：</p>
<form id="form1" name="form1" method="post" action="j2mebasitemtype.jsp?corpid=<%=corpid%>&katype=<%=katype%>&showpage=<%=pageno%>">
    <p align="center">
    <input name="corpsoid" type="text" id="corpsoid"  />
    </p>
    <p align="center"><br />
    <input name="sub" type="submit" id="sub" value="确定" />
    </p>
   </form>
   <hr>
  <a href="j2memain.jsp">返回主页</a>
        
</body>
</html>

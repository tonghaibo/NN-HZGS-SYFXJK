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
        response.setHeader("Pragma","No-cache"); 
        response.setHeader("Cache-Control","no-cache"); 
        response.setDateHeader("Expires", 0);
        String sUID  = (String)session.getAttribute("sUID");
        String sUsrnam="";
//        String curdat="";
        String soid = "";
        String corpguid="";
//        String y1 = "";
//        String m1 = "";
//        String d1 = "";
//        String y2 = "";
//        String m2 = "";
//        String d2 = "";
        EAXmlDS ds = null;
        String corpid = "";
        String sOut = "";
        String sOut1 = "";
        String corpsoid = "";
        try
        {
          //EAUserinfo usrinfo = MobileLogin.CheckIfLogin(request);
          // 得到登陆的USER ID
          //String sUID  = usrinfo.getUsrid();
          sUsrnam= EADbTool.GetSQL("SELECT NAME FROM USR WHERE id='"+sUID+"'");
//		      curdat = EADbTool.GetSQL("SELECT TO_CHAR(SYSDATE,'HH24MIss') FROM DUAL");
          corpid = EAFunc.NVL(request.getParameter("corpid"),""); 
          corpguid = EADbTool.GetSQL("select guid from corp where id='"+corpid+"'");
          String sql="select  distinct corpsoid from curord  where crtusr='"+sUID+"' and subtyp='2' and corp='"+corpguid+"'";
        ds = EADbTool.QuerySQL(sql);
        int row = ds.getRowCount();
        
        if ( row > 0 )
        {
            sOut1 = "选择订单号<br/>";
            for (int i=0;i<row;i++)
            {
                corpsoid = ds.getStringAt(i,"corpsoid");
//                out.print("corpsoid"+corpsoid);
                if ( corpsoid.length()<1)
                {   
                    corpsoid = "空订单号";
                    //out.print("<anchor>空订单号");
                }
                  
                    //corpsoid = corpsoid;
                    //out.print("<anchor>"+corpsoid);
                
                    sOut += "<img src=\"resource://pages/"+(i+1)+".png\">"+ 
                           "<a href=\"j2mebasqueryitem.jsp?corpid="+corpid+"&corpsoid="+corpsoid+"\">"+corpsoid+"</a><br>";
                          
            }
        }
    }
        catch(EAException e)
        {      
          out.println("发生错误："+e.toString());
          out.println("<br/><a href='j2melogn.jsp'>重新登录</a>");
        }
%>
<p align="center">
<%=sOut1%></br>
</p>
<p align="left">
<%=sOut%></br>
</p>
<line>
<p align="center">
<a href="j2mebasquerycorp.jsp">返回上页</a> &nbsp;<a href="j2memain.jsp">返回主页</a>
</p>
</body>
</html>
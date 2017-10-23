<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>main</title>
</head>
<body>
<%      
        out.println( "<p align=\"center\"><img  src=\"resource://pages/title.png\" ></P><line>" );
        response.addHeader("Pragma","No-cache"); 
        response.addHeader("Cache-Control","no-cache"); 
        response.addDateHeader("Expires", 0);  
        EAXmlDS ds = null;
        String sMsg = "";
        String sOut = "";
        String sOut1 = "";
        String sql = "";
        int row = 0;
        String flag = "";
        String itemtype = "";
        String brand = "";         
        String bascat = "";//条线
        String bascat2 = "";//中心
        String type = "";//连锁还是卖场
        String sUID = (String)session.getAttribute("sUID");
        String bascatname = "";

       try 
       {
           // EAUserinfo usrinfo = MobileLogin.CheckIfLogin(request);
            //String sUID  = usrinfo.getUsrid();
            //sUsrnam = EADbTool.GetSQL("SELECT NAME FROM USR WHERE id='"+sUID+"'");
//            if ( type.equalsIgnoreCase("b"))
//            {
            sql = "select distinct a.id ,a.name from v_corpbascat12 a,usrcorpbascat12 b ,usr c where "
                  +"b.usr=c.guid and trim(b.corpbascat12)=a.guid and c.id='"+sUID+"'"
                  +"union all select distinct a.id ,a.name from v_corpbascat12 a,m_usrcorpbascat12 b ,usr c where "
                  +"b.usr=c.guid and trim(b.corpbascat12)=a.guid and c.id='"+sUID+"'";
                  
//            }
//            else if (type.equalsIgnoreCase("m"))
//            {
//             sql = "select distinct a.id ,a.name from v_corpbascat12 a,m_usrcorpbascat12 b ,usr c where "+
//                  "b.usr=c.guid and trim(b.corpbascat12)=a.guid and c.id='"+sUID+"'";
//            }
            ds = EADbTool.QuerySQL(sql);
            row = ds.getRowCount();
            sOut = "选择条线中心<br/>";
            for ( int i=0;i<row;i++ )
            {
                bascat = ds.getStringAt(i,"id");
                bascatname = ds.getStringAt(i,"name");
//                bascat = bascat.replaceAll("北区","BQ");//汉字会引起问题，故在此替换
//                out.print("转换后的bascat"+bascat);
                session.setAttribute("bascat1"+i,ds.getStringAt(i,"id"));//汉字在手机中会造成错误，改成用session传值
//                session.setAttribute("bascat"+i,bascat);
                sOut1 += "<img src=\"resource://pages/"+(i%9+1)+".png\"> <a href=\"j2meplanLoc.jsp?number="+i+"\">"+bascatname+"</a><br>";
            }
       }
      catch ( Exception e )
      { 
          sMsg = e.toString();
          out.println("<br/><a href='j2melogin.jsp'>重新登录</a>");
      }
%>        

<p align="center">
<%=sOut%>
</p>
<p align="left">
<%=sOut1%>
</p>
<hr>
<p align="center">
<a href="j2memain.jsp">返回主页</a>
</p>
</body>
</html>
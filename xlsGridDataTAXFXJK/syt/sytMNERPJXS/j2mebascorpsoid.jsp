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
        String sUsrnam="";
        String y1 = "";
        String m1 = "";
        String d1 = "";
        String y2 = "";
        String m2 = "";
        String d2 = "";
        String corpsoid = "";
        String soid = "";
        String sOut = "";
        String sOut1 = "";
        String corpguid ="";
        String sUID  = (String)session.getAttribute("sUID");
        EAXmlDS ds = null;
        String corpid = "";
        try
        {
          //EAUserinfo usrinfo = MobileLogin.CheckIfLogin(request);
          // 得到登陆的USER ID
          //String sUID  = usrinfo.getUsrid();
          sUsrnam= EADbTool.GetSQL("SELECT NAME FROM USR WHERE id='"+sUID+"'");
          y1 = EAFunc.NVL(request.getParameter("y1"),"");
          m1 = EAFunc.NVL(request.getParameter("m1"),"");
          d1 = EAFunc.NVL(request.getParameter("d1"),"");
          y2 = EAFunc.NVL(request.getParameter("y2"),"");
          m2 = EAFunc.NVL(request.getParameter("m2"),"");
          d2 = EAFunc.NVL(request.getParameter("d2"),""); 
          corpid = EAFunc.NVL(request.getParameter("corpid"),""); 
          corpguid = EADbTool.GetSQL("select guid from corp where id='"+corpid+"'");
          String sql="select  distinct corpsoid from hisord  where "+
               " to_date(to_char(crtdat,'yyyy-mm-dd'),'yyyy-mm-dd')>=to_date('"+y1+"-"+m1+"-"+d1+"','yyyy-mm-dd') "+
              "and to_date(to_char(crtdat,'yyyy-mm-dd'),'yyyy-mm-dd')<=to_date('"+y2+"-"+m2+"-"+d2+"','yyyy-mm-dd') "+
              "and crtusr='"+sUID+"' and subtyp='2' and corp='"+corpguid+"' ";
        ds = EADbTool.QuerySQL(sql);
        int row = ds.getRowCount();
        
        if ( row > 0 )
        {   
            sOut = "选择订单号<br/>";
            for (int i=0;i<row;i++)
            {
                corpsoid = ds.getStringAt(i,"corpsoid");
                if ( corpsoid.length()<1)
                {   
                   soid = "空订单号";
                    //out.print("<anchor>空订单号");
                }
                else
                {   soid = corpsoid;
                    //out.print("<anchor>"+corpsoid);
                }
                sOut1 = "<img src=\"resource://pages/"+(i+1)+".png\">"
                        +"<a href=\"bas_checksoid.jsp?corpid="+corpid+"&corpsoid="
                        +soid+"&y1="+y1+"&m1="+m1+"&d1="+d1+"&y2="+y2+"&m2="+m2+"&d2="+d2+"\">"+soid+"</a><br>";
//                 out.print("<go href=\"bas_checksoid.jsp\">");
//                 out.print("<postfield name=\"corpsoid\" value=\""+corpsoid+"\"/>");
//                 out.print("<postfield name=\"corpid\" value=\""+corpid+"\"/>");
//                 out.print("<postfield name=\"y1\" value=\""+y1+"\"/>");
//                 out.print("<postfield name=\"m1\" value=\""+m1+"\"/>");
//                 out.print("<postfield name=\"d1\" value=\""+d1+"\"/>");
//                 out.print("<postfield name=\"y2\" value=\""+y2+"\"/>");
//                 out.print("<postfield name=\"m2\" value=\""+m2+"\"/>");
//                 out.print("<postfield name=\"d2\" value=\""+d2+"\"/>");
//                 out.print("</go></anchor><br/>");                
            }
        }
          //out.println("<a href=\"j2memain.jsp\">返回主页</a>");
        }
        catch(EAException e)
        {
          out.println("发生错误："+e.toString());
          out.println("<br/><a href='logon.jsp'>重新登录</a>");
        }
%>
<p align="center">
<%=sOut%></br>
</p>
<p align="left">
<%=sOut1%></br>
</p>
<line>
<p align="center">
<a href="j2memain.jsp">返回主页</a></br>
</p>
</body>
</html>

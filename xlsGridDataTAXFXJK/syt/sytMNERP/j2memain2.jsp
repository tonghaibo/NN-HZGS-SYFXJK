<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>main</title>
</head>
<body>

<%
        String sUsrnam="";
        EAXmlDS ds = null;
        String sNo = EAFunc.NVL(request.getParameter("no"),"");
        String sPwd = EAFunc.NVL(request.getParameter("pwd"),"");
        String curdat = EADbTool.GetSQL("select to_char(sysdate,'hh24:mi:ss') dat from dual");
        String sMsg="";
        boolean bContinue = true;
//        if(sNo.length()>0)
//        {
//            if(sPwd.length()==0)
//              sMsg = "请输入密�? ;
//            else //if(sNo.length()!=0 &&sPwd.length()!=0)
//            {
//              try
//              {
//                 EAUserinfo userinfo = MobileLogin.DoLogin(request,sNo,sPwd);
//                 session.setAttribute("sNo",sNo);
//                 sMsg += "登录成功" ;
//              }
//              catch ( EAException e ) 
//              {
//                out.println( "没有登录成功，请重新<a href=\"../j2melogon.jsp\">登陆</a>" );
//                bContinue = false;
//              }
//            } 
//        }
        out.println( "<p align=\"center\"><img  src=\"resource://pages/title.png\" ></P><line>" );
        if (bContinue )   { 
 
            try
            {
             // out.print(request.getHeader("User-Agent"));
//             String brandtype[] = request.getHeader("User-Agent").split("/");
//             String type = brandtype[0]; //得到手机型号和品�?
             EAUserinfo usrinfo = EASession.GetLoginInfo(request);
              //EAUserinfo usrinfo = MobileLogin.CheckIfLogin(request);
              // 得到登陆的USER ID
              String sUID  = usrinfo.getUsrid();
              session.setAttribute("sUID",sUID);
              sUsrnam= EADbTool.GetSQL("SELECT NAME FROM USR WHERE id='"+sUID+"'");
              out.print("<p align=center>欢迎您，"+sUsrnam+"</p>");
              String sql = "select distinct c.extcat2 from usrcorp a,usr b,v_ka c,corp d "+
                            "where a.usr=b.guid and a.corp=d.guid "+
                             "and c.guid=d.refguid and b.id='"+sUID+"' order by c.extcat2";
              ds = EADbTool.QuerySQL(sql);
              int row = ds.getRowCount();
              String extcat2 = "";
              boolean sign1 = true;
              boolean sign2 = true;
              boolean sign3 = true;
              if ( row > 0 )
              {
                   out.print("<img src=\"resource://pages/1.png\"> <a href=\"j2mebasnewcorplist.jsp\">录入订单</a><br>");
                   out.print("<img src=\"resource://pages/2.png\"> <a href=\"j2meitemsum.jsp\">当天订单汇总</a><br>");
                   out.print("<img src=\"resource://pages/6.png\"> <a href=\"j2meSeldate.jsp\">历史订单汇总</a><br>");
              if (row==2&&ds.getStringAt(0,"extcat2").equalsIgnoreCase("1")&&ds.getStringAt(1,"extcat2").equalsIgnoreCase("3")) {
              
                           // out.print("<img src=\"resource://pages/1.png\"> <a href=\"j2mebasnewcorplist.jsp\">录入订单</a><br>");
                           // out.print("<img src=\"resource://pages/2.png\"> <a href=\"j2meitemsum.jsp\">当天订单汇总</a><br>");
                            out.print("<img src=\"resource://pages/3.png\"> <a href=\"j2mebasquerycorp.jsp\">网点订单汇总</a><br>");
                            out.print("<img src=\"resource://pages/4.png\"> <a href=\"j2mebasqueryalllist.jsp\">订单汇总查询</a><br>");
                            out.print("<img src=\"resource://pages/5.png\"> <a href=\"j2mebasquerylist.jsp\">单笔订单查询</a><br>");
                            //out.print("<img src=\"resource://pages/6.png\"> <a href=\"j2meSeldate.jsp\">历史订单汇总</a><br>");
               }else{
                  for ( int i=0;i<row;i++ )
                  {
                    extcat2 = ds.getStringAt(i,"extcat2");
                    if ( sign1)
                    {
                          if ( extcat2.equalsIgnoreCase("1") || extcat2.equalsIgnoreCase("2") )
                          //out.print((flag1||flag2)&!flag3&!flag4);
                          {     //out.print("<a href=\"test.jsp\">测试</a><br>");
                                String kaflag = EAFunc.NVL(request.getParameter("kaflag"),"");
                                //out.print("<img src=\"resource://pages/1.png\">　<a href=\"j2mecorplist.jsp\">录入查询订单</a><br>");
//                               // out.print("<img src=\"resource://pages/2.png\">当天订单<br>");
                                  out.print("<img src=\"resource://pages/3.png\">　<a href=\"j2meitemsum.jsp?kaflag="+kaflag+"\">   当天订单汇总</a><br>");
                                  out.print("<img src=\"resource://pages/4.png\">　<a href=\"j2mequerycorp.jsp?kaflag="+kaflag+"\">   网点汇总查询</a><br>");
//                                  out.print("<img src=\"resource://pages/5.png\">历史订单<br/>");
                                //out.print("<img src=\"resource://pages/6.png\">　<a href=\"j2meSeldate.jsp?kaflag="+kaflag+"\">   历史订单查询</a><br/>");

                                //out.print("<a href=\"j2mequery.jsp?curdat="+curdat+"\">查询</a><br>");
                                sign1=false;
                          
                          }
//                    }
                   if (sign2)
                    {                          
                           if ( extcat2.equalsIgnoreCase("3"))
                            {
                           
                                    out.print("<img src=\"resource://pages/1.png\"> <a href=\"j2mebascorplist.jsp\">录入卖场订单</a><br>");
                                    out.print("<img src=\"resource://pages/2.png\"> <a href=\"j2meitemsum.jsp\">当天订单汇总</a><br>");
                                    out.print("<img src=\"resource://pages/3.png\"> <a href=\"j2mebasquerycorp.jsp\">网点订单汇总</a><br>");
                                    out.print("<img src=\"resource://pages/4.png\"> <a href=\"j2mebasqueryalllist.jsp\">订单汇总查询</a><br>");
                                    out.print("<img src=\"resource://pages/5.png\"> <a href=\"j2mebasquerylist.jsp\">单笔订单查询</a><br>");
                                    out.print("<img src=\"resource://pages/6.png\"> <a href=\"j2meSeldate.jsp\">历史订单汇总</a><br>");
                                    sign2=false;
                            
                            }
                    }
//          
 if ( sign3 )
                      {
                            if ( extcat2.equalsIgnoreCase("4") || extcat2.equalsIgnoreCase("9") )
                            {
                                  out.print("<img src=\"resource://pages/5.png\"> <a href=\"j2mesqcorplist.jsp?curdat="+curdat+"\">录入社区订单</a><br>");
                                  out.print("<img src=\"resource://pages/7.png\"> <a href=\"query.jsp?curdat="+curdat+"&amp;kaflag=sq"+"\">查询社区订单</a><br>");
                        sign3=false;
                
                            }                      
                        }
      }
    }
//              String sql1 = "select * from USRCORPBASCAT12 where usr=(select guid from usr where id='"+sUID+"')";
//              ds = EADbTool.QuerySQL(sql1);
//              if ( ds.getRowCount()>0)
//              {
//                       out.print("<a href=\"planBascat.jsp?type=b\">录入计划</a><br>");
//                       out.print("<a href=\"planQuery.jsp?type=b\">查询计划</a><br>");
//          
//                }
//          
//               String sql2 = "select * from M_USRCORPBASCAT12 where usr=(select guid from usr where id='"+sUID+"')"; 
//               ds = EADbTool.QuerySQL(sql2);
//               if (ds.getRowCount()>0)
//               {
//                       out.print("<a href=\"planBascat.jsp?type=m\">录入卖场计划</a><br>");
//                       out.print("<a href=\"planQuery.jsp?type=m\">查询卖场计划</a><br>");
//               }
//          
               String sql3 = "select * from planmanger where usr=(select guid from usr where id='"+sUID+"')";
               ds = EADbTool.QuerySQL(sql3);            
               if (ds.getRowCount()>0)
               {        
                      String corpbascat12 = (String)ds.getStringAt(0,"corpbascat12");
                        out.print("<img src=\"resource://pages/1.png\"> <a href=\"j2mecuritemtype.jsp\">("+corpbascat12+")订单汇总</a><br>");
               }
//               out.print("<a href=\"pwd.jsp\">修改密码</a><br>");
               out.print("<hr><p align=center><a href=\"../j2melogin.jsp\">重 新 登 录 </a><br>");
            }
         }
     }
            catch(EAException e)
            {
              out.print("<p>");		
              out.println(e.toString());
              out.println("<hr><p align=center><a href='../j2melogin.jsp'> 重新登录 </a></p>");
            }
  }
%>

</body>

</html>
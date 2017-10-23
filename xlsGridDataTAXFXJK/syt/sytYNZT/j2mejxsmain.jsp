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
        EAXmlDS ds1 = null;
        String sNo = EAFunc.NVL(request.getParameter("no"),"");
        String sPwd = EAFunc.NVL(request.getParameter("pwd"),"");
        String curdat = EADbTool.GetSQL("select to_char(sysdate,'hh24:mi:ss') dat from dual");
        String sMsg="";
        String sql = "";
        String sql2 = "";
        String org = "";
        boolean bContinue = true;
        
        out.println( "<p align=\"center\"><img  src=\"resource://pages/title.png\" ></P><line>" );
        if (bContinue )   { 
            try
            {
              EAUserinfo usrinfo = EASession.GetLoginInfo(request);
              String sUID  = usrinfo.getUsrid();
              session.setAttribute("sUID",sUID);
              sUsrnam= EADbTool.GetSQL("SELECT NAME FROM USR WHERE id='"+sUID+"'");
              out.print("<p align=center>欢迎您，"+sUsrnam+"</p>");
              org = EADbTool.GetSQL("select org from usr where id = '"+sUID+"'");
              //out.print
              //20090404 判断ORG字段，如果是“SXMNJXS”则执行以下代码
            if(org.equalsIgnoreCase("SHMNJXS")){
              sql = "select usrcorp.guid from usrcorp , usr where usrcorp.usr = usr.guid and usr.id = '"+sUID+"'";             
              ds = EADbTool.QuerySQL(sql);
              int row = ds.getRowCount();
            if(row > 0){
                   out.print("<img src=\"resource://pages/1.png\"> <a href=\"j2mejxscorplist.jsp\">录入订单</a><br>");
                   out.print("<img src=\"resource://pages/2.png\"> <a href=\"j2mejxsitemsum.jsp\">当天订单汇总</a><br>");
                   //out.print("<img src=\"resource://pages/6.png\"> <a href=\"j2meSeldate.jsp\">历史订单汇总</a><br>");
                   //out.print("<img src=\"resource://pages/6.png\"> 当天订单汇总（开发中）</br>");
              
              }
               String sql3 = "select * from planmanger where usr=(select guid from usr where id='"+sUID+"')";
               ds = EADbTool.QuerySQL(sql3);            
               if (ds.getRowCount()>0){        
                      String corpbascat12 = (String)ds.getStringAt(0,"corpbascat12");
                      //out.print("<img src=\"resource://pages/5.png\"> <a href=\"j2meplanhisflag.jsp\">销售完成量统计</a><br>");
                      out.print("<img src=\"resource://pages/3.png\"> <a href=\"j2mejxscuritemtype.jsp\">("+corpbascat12+")当天订单汇总</a><br>");
                      //out.print("<img src=\"resource://pages/4.png\"> <a href=\"j2mehistime.jsp\">("+corpbascat12+")历史订单汇总</a><br>");
               }
               String sql4 = "select * from planmanger where usr = (select guid from usr where id = '"+sUID+"')";
               ds = EADbTool.QuerySQL(sql4);
               if(ds.getRowCount()>1){
                    out.print("<img src=\"resource://pages/4.png\"> <a href=\"j2mejxsmngquery.jsp\">区域当天订单汇总</a><br>");
               
               }
                  
                  out.println("<hr><p align=center><a href='../j2melogin.jsp'> 重新登录 </a></p>");
              }
              
            else{
            
             sql = "select distinct c.extcat2 from usrcorp a,usr b,v_ka c,corp d "+
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
                   out.print("<img src=\"resource://pages/3.png\"> <a href=\"j2meupdatepwd.jsp\">修改密码</a><br>");
                   out.print("<img src=\"resource://pages/1.png\"> <a href=\"j2menewcorplist.jsp\">录入订单</a><br>");
                   out.print("<img src=\"resource://pages/2.png\"> <a href=\"j2meitemsum.jsp\">当天订单汇总</a><br>");
                   out.print("<img src=\"resource://pages/6.png\"> <a href=\"j2meSeldate.jsp\">历史订单汇总</a><br>");
                  for ( int i=0;i<row;i++ )
                  {
                    extcat2 = ds.getStringAt(i,"extcat2");
                    if ( sign1)
                    {
                          if (!extcat2.equalsIgnoreCase("3"))
                          {    
                                  String kaflag = EAFunc.NVL(request.getParameter("kaflag"),"");
                                  out.print("<img src=\"resource://pages/3.png\">　<a href=\"j2meitemsum.jsp?kaflag="+kaflag+"\">   当天订单汇总</a><br>");
                                  out.print("<img src=\"resource://pages/4.png\">　<a href=\"j2mequerycorp.jsp?kaflag="+kaflag+"\">   网点汇总查询</a><br>");
                                  sign1=false; 
                          }
                    }
                   if (sign2)
                    {     
                           if ( extcat2.equalsIgnoreCase("3"))
                            {
                                    out.print("<img src=\"resource://pages/3.png\"> <a href=\"j2mebasquerycorp.jsp\">网点订单汇总</a><br>");
                                    out.print("<img src=\"resource://pages/4.png\"> <a href=\"j2mebasqueryalllist.jsp\">订单汇总查询</a><br>");
                                    out.print("<img src=\"resource://pages/5.png\"> <a href=\"j2mebasquerylist.jsp\">单笔订单查询</a><br>");
                                    sign2=false;
                          }
                  }
           }
      }
              String sql1 = "select * from USRCORPBASCAT12 where usr=(select guid from usr where id='"+sUID+"')"
                            +"union all select * from M_USRCORPBASCAT12 where usr=(select guid from usr where id='"+sUID+"')";
              ds = EADbTool.QuerySQL(sql1);
              if ( ds.getRowCount()>0)
              {        
                       out.print("<img src=\"resource://pages/3.png\"> <a href=\"j2meupdatepwd.jsp\">修改密码</a><br>");
                       out.print("<img src=\"resource://pages/1.png\"> <a href=\"j2meplanBascat.jsp\">录入计划</a><br>");
                       out.print("<img src=\"resource://pages/2.png\"> <a href=\"j2meplanquery.jsp\">查询计划</a><br>");          
                }          
//               String sql2 = "select * from M_USRCORPBASCAT12 where usr=(select guid from usr where id='"+sUID+"')"; 
//               ds = EADbTool.QuerySQL(sql2);
//               if (ds.getRowCount()>0)
//               {
//                       out.print("<a href=\"j2meplanBascat.jsp?type=m\">录入计划</a><br>");
//                       out.print("<a href=\"j2meplanQuery.jsp?type=m\">查询卖场计划</a><br>");
//               }
          
               String sql3 = "select * from planmanger where usr=(select guid from usr where id='"+sUID+"')";
               ds = EADbTool.QuerySQL(sql3);            
               if (ds.getRowCount()>0)
               {        
                      String corpbascat12 = (String)ds.getStringAt(0,"corpbascat12");
                      out.print("<img src=\"resource://pages/5.png\"> <a href=\"j2meplanhisflag.jsp\">销售完成量统计</a><br>");
                      out.print("<img src=\"resource://pages/3.png\"> <a href=\"j2mecurlisttype.jsp\">("+corpbascat12+")当天订单汇总</a><br>");
                      out.print("<img src=\"resource://pages/4.png\"> <a href=\"j2mehistime.jsp\">("+corpbascat12+")历史订单汇总</a><br>");
               }
//               out.print("<a href=\"pwd.jsp\">修改密码</a><br>");
               out.print("<hr><p align=center><a href=\"../j2melogin.jsp\">重 新 登 录 </a><br>");
           }//20090404 else代表非经销商系统的程序代码
        }
            catch(EAException e)
            {
              out.print("<p>");		
              out.println(e.toString());
              out.println("<hr><p align=center><a href='../j2melogin.jsp'> 重新登录 </a></p>");
            }
  }
%>
<img src="resource://pages/3.png"> <a href="j2meupdatepwd.jsp">修改密码</a><br>
</body>

</html>
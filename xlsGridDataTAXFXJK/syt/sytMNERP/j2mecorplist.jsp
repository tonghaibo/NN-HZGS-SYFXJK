<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>首页</title>
</head>
<body>
<%
         response.addHeader("Pragma","No-cache"); 
         response.addHeader("Cache-Control","no-cache"); 
         response.addDateHeader("Expires", 0);    
         out.println( "<p align=\"center\"><img  src=\"resource://pages/title.png\" ></P><line>" );
  try
  {
      String katype = "";
     String curdat = EADbTool.GetSQL("select to_char(sysdate,'yyyymmddhh24miss') dat from dual");
    //EAUserinfo usrinfo = MobileLogin.CheckIfLogin(request);
    EAUserinfo usrinfo = EASession.GetLoginInfo(request);
             
   
    String sUID  = usrinfo.getUsrid();
    String sql = "SELECT CORP.ID 网点编号,CORP.NAME 可开单的网点名称,KA.bascat3 katype ,(SELECT COUNT(distinct ITEM) FROM CURORD C WHERE C.CORP=CORP.GUID ) 已开单商品记录数 FROM USRCORP,USR,CORP,V_KA KA WHERE USRCORP.USR=USR.GUID AND KA.guid=corp.refguid and corp.useflg='1' and ka.extcat2 in ('1','2') and USRCORP.CORP=CORP.GUID AND USR.ID='"+sUID+"' order by CORP.SORTID,CORP.REFID,CORP.id ";//NVL(USRCORP.SORTID,99999999)
    int pagesize=10;//每页显示条数
    
    int pageno = Integer.parseInt(EAFunc.NVL(request.getParameter("showpage"),"1"));
      //取总记录数
    int allRowCount = (int)EADbTool.GetSQLRowCount(sql);
    int nPageCount = allRowCount%pagesize==0 ? allRowCount/pagesize : allRowCount/pagesize+1;
    EAFunc.assertsFmt(nPageCount>=pageno,"分页错误，没有第%s页的数据。",""+pageno);
    //取分页后的数据集
    String pageSql = EASqlFunc.pageSql(sql,""+pageno,""+pagesize);
    EAXmlDS ds =  EADbTool.QuerySQL(pageSql);

    //实际的记录数
    int c = ds.getRowCount();

    //out.print(""+pageno+"/"+nPageCount);
    //if(pageno==nPageCount)
    //  out.print("<a href=\"j2mecorplist.jsp?showpage="+(pageno-1)+"&amp;curdat="+curdat+"\">上页</a>");
   // if(pageno<nPageCount)
   //   out.print("<a href=\"j2mecorplist.jsp?showpage="+(pageno+1)+"&amp;curdat="+curdat+"\">下页</a>");
    out.print("<br>");

    for( int i=0;i<c;i++) 
    { 
    katype = ds.getStringAt(i,"katype");
      out.print( "<img src=\"resource://pages/"+(i%9+1)+".png\">　<a href=\"j2meitemtype.jsp?corpid="+ds.getStringAt(i,"网点编号")+"&showpage="+pageno+"&curdat="+curdat+"&katype="+katype+"\">"+ds.getStringAt(i,"可开单的网点名称")+"</a><br>" );
//      out.print( "<anchor>" );
//      out.print( ds.getStringAt(i,"可开单的网点名称") );
//      out.print( "<go href=\"j2meitemtype.jsp\">" );
//      out.print( EAFunc.format("<postfield name=\"corpid\" value=\"%s\"/>",ds.getStringAt(i,"网点编号")) );
//      out.print( EAFunc.format("<postfield name=\"showpage\" value=\"%s\"/>",""+pageno) );
//	  out.print( "<postfield name=\"curdat\" value=\""+curdat+"\"/>" );
//out.print( "<postfield name=\"katype\" value=\""+katype+"\"/>" );
//      out.print( "</go></anchor><br>" );
    }
    
    //if(pageno>1)
     // out.print("<a href=\"j2mecorplist.jsp?showpage="+(pageno-1)+"&amp;curdat="+curdat+"\">上页</a>");
    //if(pageno<nPageCount)
     // out.print("<a href=\"j2mecorplist.jsp?showpage="+(pageno+1)+"&amp;curdat="+curdat+"\">下页</a>");

  }
  catch(EAException e)
  {
    out.println("发生错误："+e.toString());
    out.println("<br><a href='../j2melogon.jsp'>重新登录</a>");
  }
%>
    <br>
    <a href="j2memain.jsp" >返回主页 </a>

</body>

</html>

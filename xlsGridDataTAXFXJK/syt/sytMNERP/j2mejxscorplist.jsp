<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>首页</title>
</head>
<body>
<p align="center"><img  src="resource://pages/title.png" ></P>
<hr>
<p align="center">网点列表</p>
<%       
        // out.println( "<p align=\"center\"><img  src=\"resource://pages/title.png\" ></P><line>" );
         response.addHeader("Pragma","No-cache"); 
         response.addHeader("Cache-Control","no-cache"); 
         response.addDateHeader("Expires", 0);    
         String katype = "";
         String extcat2 = "";
         String sUID  = (String)session.getAttribute("sUID");
         EAXmlDS ds =  null;
         String sql = "";
  try
  {
        sql = "select corp.id as corpid,corp.name as corpname"
               +" From usrcorp,usr,corp"
               +" where usr.guid = usrcorp.usr"
               +" and usr.id = '"+sUID+"'"
               +" and usrcorp.corp = corp.guid"
               +" and corp.useflg='1'"
               +" order by corp.id";
           int pagesize=5;//每页显示条数
    //out.print("SQL"+sql);
           int pageno = Integer.parseInt(EAFunc.NVL(request.getParameter("showpage"),"1"));
    //取总记录数
           int allRowCount = (int)EADbTool.GetSQLRowCount(sql);
           int nPageCount = allRowCount%pagesize==0 ? allRowCount/pagesize : allRowCount/pagesize+1;
           String pageSql = EASqlFunc.pageSql(sql,""+pageno,""+pagesize);
           ds =  EADbTool.QuerySQL(pageSql);  
           int c = ds.getRowCount();
           out.print(""+pageno+"/"+nPageCount);
    //out.print(c);
    if(c>0){
       if(pageno==nPageCount)
          out.print("<a href=\"j2mejxscorplist.jsp?showpage="+(pageno-1)+"\">上页</a>");
       if(pageno<nPageCount)
          out.print("<a href=\"j2mejxscorplist.jsp?showpage="+(pageno+1)+"\">下页</a>");
          out.print("<br/>");
      for( int i=0;i<c;i++) 
     {
          out.print( "<img src=\"resource://pages/"+(i%9+1)+".png\">　<a href=\"j2mejxsitemtyp.jsp?corpid="+ds.getStringAt(i,"corpid")+"&showpage="+pageno+"\">"+ds.getStringAt(i,"corpname")+"</a><br>") ;
     }
       if(pageno>1)
           out.print("<a href=\"j2mejxscorplist.jsp?showpage="+(pageno-1)+"\">上页</a>");
        if(pageno<nPageCount)
           out.print("<a href=\"j2mejxscorplist.jsp?showpage="+(pageno+1)+"\">下页</a>");
   }
}

  catch(EAException e)
  {
    out.println("发生错误："+e.toString());
    out.println("<br><a href='../j2melogon.jsp'>重新登录</a>");
  }
%>
<hr>
<p align="center">
    <a href="j2memain.jsp" >返回主页 </a>
</p>
</body>
</html>

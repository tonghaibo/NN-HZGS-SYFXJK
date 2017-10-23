<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>bascorplist</title>
</head>
<body>
<%      
         out.println( "<p align=\"center\"><img border=\"0\" src=\"resource://pages/title.png\" ></P><line>" );
         response.addHeader("Pragma","No-cache"); 
         response.addHeader("Cache-Control","no-cache"); 
         response.addDateHeader("Expires", 0);    
         String katype = "";
         String curdat = "";
         String sUID  = (String)session.getAttribute("sUID");
  try
  {
	       curdat = EADbTool.GetSQL("select to_char(sysdate,'yyyymmddhh24miss') dat from dual");
    //EAUserinfo usrinfo = MobileLogin.CheckIfLogin(request);
         String sql = "SELECT CORP.ID 网点编号,CORP.NAME 可开单的网点名称, v_ka.bascat3 katype,(SELECT COUNT(distinct ITEM) FROM CURORD C WHERE C.CORP=CORP.GUID ) 已开单商品记录数 "+
                  "FROM USRCORP,USR,CORP ,v_ka "+
                  "WHERE USRCORP.USR=USR.GUID AND USRCORP.CORP=CORP.GUID AND USR.ID='"+sUID+"' "+
                  " and corp.refguid=v_ka.guid and v_ka.extcat2 ='3' and corp.useflg='1' "+ 
                  "order by CORP.SORTID,CORP.REFID,CORP.id";//NVL(USRCORP.SORTID,99999999)
    int pagesize=5;//每页显示条数
    //out.print("SQL"+sql);
    int pageno = Integer.parseInt(EAFunc.NVL(request.getParameter("showpage"),"1"));
    //取总记录数
    int allRowCount = (int)EADbTool.GetSQLRowCount(sql);
    int nPageCount = allRowCount%pagesize==0 ? allRowCount/pagesize : allRowCount/pagesize+1;
    EAFunc.assertsFmt(nPageCount>=pageno,"未分配网点给业务员。",""+pageno);
    //取分页后的数据集
    String pageSql = EASqlFunc.pageSql(sql,""+pageno,""+pagesize);
    //System.out.println(pageSql);
    EAXmlDS ds =  EADbTool.QuerySQL(pageSql);

    //实际的记录数
    int c = ds.getRowCount();

    out.print(""+pageno+"/"+nPageCount);
    if(pageno==nPageCount)
      out.print("<a href=\"j2mebascorplist.jsp?showpage="+(pageno-1)+"\">上页</a>");
    if(pageno<nPageCount)
      out.print("<a href=\"j2mebascorplist.jsp?showpage="+(pageno+1)+"\">下页</a>");
    out.print("<br/>");

    for( int i=0;i<c;i++) 
    { 
       katype = ds.getStringAt(i,"katype");
       String corpid =  (String)ds.getStringAt(i,"网点编号");
       String corpname = (String)ds.getStringAt(i,"可开单的网点名称"); 
       out.print("<img src=\"resource://pages/"+(i+1)+".png\"> <a href=\"j2mebasinputbil.jsp?corpid="+corpid+"&showpage="+pageno+"&katype="+katype+"\">"+corpname+"</a><br>");
           
    }
    
    if(pageno>1)
      out.print("<a href=\"j2mebascorplist.jsp?showpage="+(pageno-1)+"\">上页</a>");
    if(pageno<nPageCount)
      out.print("<a href=\"j2mebascorplist.jsp?showpage="+(pageno+1)+"\">下页</a>");

  }
  catch(EAException e)
  {
    out.println("发生错误："+e.toString());
    //out.println("<br/><a href='main.jsp'>返回主页</a>");
  }
%>
    <br/>
    <line>
   <p align="center">
 <a href="j2memain.jsp">返回主页</a>&nbsp;<a href="j2mebasquery.jsp">重新登录</a>
</p>

</body>
</html>

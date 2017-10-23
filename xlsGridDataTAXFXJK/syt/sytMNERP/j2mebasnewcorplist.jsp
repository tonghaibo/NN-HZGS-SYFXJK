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
  try
  {
    String sql = "SELECT CORP.ID 网点编号,CORP.NAME 可开单的网点名称,KA.bascat3 katype ,ka.extcat2 extcat2, "
            +"(SELECT COUNT(distinct ITEM) FROM CURORD C WHERE C.CORP=CORP.GUID ) 已开单商品记录数 "
            +"FROM USRCORP,USR,CORP,V_KA KA WHERE USRCORP.USR=USR.GUID AND KA.guid=corp.refguid "
            +"and corp.useflg='1' and ka.extcat2 in ('1','3') and USRCORP.CORP=CORP.GUID "
            +"AND USR.ID='"+sUID+"' order by ka.extcat2,CORP.SORTID,CORP.REFID,CORP.id ";//NVL(USRCORP.SORTID,99999999)
       ds =  EADbTool.QuerySQL(sql);   
    int c = ds.getRowCount();
    //out.print(c);
    for( int i=0;i<c;i++) 
    { 
      katype = ds.getStringAt(i,"katype");
      extcat2 = ds.getStringAt(i,"extcat2");
      if(extcat2.equalsIgnoreCase("1")){
     out.print( "<img src=\"resource://pages/"+(i%9+1)+".png\">　<a href=\"j2meitemtype.jsp?corpid="+ds.getStringAt(i,"网点编号")+"&katype="+katype+"\">"+ds.getStringAt(i,"可开单的网点名称")+"</a><br>") ;
    } else if(extcat2.equalsIgnoreCase("3")){
      out.print("<img src=\"resource://pages/"+(i%9+1)+".png\"> <a href=\"j2mebasinputbil.jsp?corpid="+ds.getStringAt(i,"网点编号")+"&katype="+katype+"\">"+ds.getStringAt(i,"可开单的网点名称")+"</a><br>");
    }
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

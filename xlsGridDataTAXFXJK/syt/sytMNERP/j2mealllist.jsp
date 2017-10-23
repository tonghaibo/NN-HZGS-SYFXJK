<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="java.lang.*,com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>alllist</title>
</head>
<body>

<%   
    out.println( "<p align=\"center\"><img border=\"0\" src=\"resource://pages/title.png\" ></P><line>" );
    String name = "";
    String corpid = "";
    String sUsrnam="";
    EAXmlDS ds = null;
    EAXmlDS ds1 = null;
//    String sNo=(String)session.getAttribute("sNo");//session保存用户的手机号码
    //EAUserinfo usrinfo = new MobileLogin().GetUsrinfo(request); 
    String refid = EAFunc.NVL(request.getParameter("refid"),"");
    String  brand = EAFunc.NVL(request.getParameter("brand"),"");
    //String note = EAFunc.NVL(request.getParameter("note"),"");
    //out.print("NOTE"+note);
    String itemtypid = EAFunc.NVL(request.getParameter("itemtypid"),"");
     // 得到登陆的USER ID
    String sUID  = (String)session.getAttribute("sUID");
    
    String strsql = "";

    String sql = "select id,shtnam as 商品 "+
              "from ( "+
              "select i.id,i.shtnam ,sum(qty) qty "+
              "from item i,curord h,v_sctype c,planmanger  d ,itemtypclass e where h.sctype=c.id and h.item=i.guid  "+
              " and i.refid='"+refid+"' and i.brand='"+brand+"' ";
             
      if ( refid.equalsIgnoreCase("1")&&brand.equalsIgnoreCase("MN"))
          sql += " and e.id='"+itemtypid+"' and e.brand=i.brand and i.bascal4 = e.note";
       if( refid.equalsIgnoreCase("2")&&brand.equalsIgnoreCase("MN") )
          sql += " and e.id='"+itemtypid+"' and e.brand=i.brand and i.extcat8 =e.note "; 
              
         sql +=     " and h.corp in (select n.guid from corp n,planmanger m where m.usr=(select guid from usr where id='"+sUID+"') "+
              " and n.bascat1||'.'||n.bascat2=m.corpbascat12 )"+
              "group by i.id,i.shtnam,i.refid,i.sortid order by i.refid,i.sortid )";
              //out.print(sql);
    ds = EADbTool.QuerySQL(sql);
    String sOut1 = "";
    String sOut2 = "";
    int c = ds.getRowCount();    
    //out.print("结果集"+c);
    if ( c == 0 ) {
    sOut1 += "暂无商品记录！<br/>";
    out.print("<p align=\"center\">"+sOut1+"</p>");
    }
    else
    {  
         sOut1 +="商 品 列 表：<br/>";
         out.print("<p align=\"center\">"+sOut1+"</p>");
        for ( int i=0;i<c;i ++ ) {
            out.print("<img src=\"resource://pages/1.png\"> <a href=\"j2mecurlist.jsp?itmid="+ds.getStringAt(i,"id")+"&refid="+refid+"&brand="+brand+"&itemtypid="+itemtypid+"\">"+ds.getStringAt(i,"商品")+"</a></br>");
        }     
    }
    sOut2 += "<a href=\"j2mecuritemtype.jsp\">返回上页</a>"+"&nbsp;&nbsp;&nbsp;<a href=\"j2memain.jsp\">返回主页</a>";

%>
<p align="center">
<%=sOut2%>
</p>
</body>
</html>

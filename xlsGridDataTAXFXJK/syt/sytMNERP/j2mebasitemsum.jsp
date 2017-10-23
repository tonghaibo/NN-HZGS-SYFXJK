<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>main</title>
</head>
<body>
<%   

    String name = "";
    String corpid = "";
    String sUsrnam="";
    String sOut = "";
    String sOut1 = "查询结果";
    String sOut2 = "";
    String sOut3 = "";
    EAXmlDS ds = null;
    String sUID  = (String)session.getAttribute("sUID");
    out.println( "<p align=\"center\"><img border=\"0\" src=\"resource://pages/title.png\" ></P><line>" );
    String sql = "select shtnam as 商品,sctype 分类,ceil(qty/untnum)-decode(mod(qty,untnum),0,0,1)||unit||mod(qty,untnum)||smlunt as 数量 "+
      "from ( "+
      "select i.shtnam ,i.untnum,i.unit,i.smlunt,c.name sctype,sum(h.qty) qty "+
      "from item i,curord h,v_sctype c,corp d,corpitem e where h.sctype=c.id and h.item=i.guid and h.crtusr='"+sUID+"' and h.subtyp='2' and h.corp=d.guid and h.item=e.item and d.refguid=e.corp "+
//      "from item i,curord h,v_sctype c,corp d,corpitem e where h.sctype=c.id and h.item=i.guid and h.crtusr='"+sUID+"' and h.corp=d.guid and h.item=e.item and d.refguid=e.corp "+
      "group by i.id,i.refid,i.sortid,i.shtnam,i.untnum,i.unit,i.smlunt,c.name order by i.refid,i.sortid )";

    ds = EADbTool.QuerySQL(sql);
	//String sql1 = "select distinct item from curord where crtusr='"+sUID+"'";
   String sql1 = "select distinct curord.item from curord,corpitem,corp  where curord.subtyp='2' and curord.crtusr='"+sUID+"' and curord.corp=corp.guid and curord.item=corpitem.item and corp.refguid=corpitem.corp ";
//      String sql1 = "select distinct curord.item from curord,corpitem,corp  where and curord.crtusr='"+sUID+"' and curord.corp=corp.guid and curord.item=corpitem.item and corp.refguid=corpitem.corp ";

    int cc = EADbTool.QuerySQL(sql1).getRowCount();
    int c = ds.getRowCount();       
    sOut2 +="共"+cc+"个品种,"+EADbTool.GetSQL("SELECT COUNT(DISTINCT CORP) FROM CURORD WHERE crtusr='"+sUID+"' ") + "个网点<br/>";          
    sOut3 +="商品汇总<br/>";
    for ( int i=0;i<c;i ++ ) {
       
        sOut += ds.getStringAt(i,"商品")+":<br/>"+ds.getStringAt(i,"分类")+ds.getStringAt(i,"数量")+"<br/>";     
    }
%>
<p align="center">
<%=sOut1%></br>
</p>
<p align="center">
<%=sOut2%></br>
</p>
<p align="center">
<%=sOut3%></br>
</p>
<p align="left">
<%=sOut%></br>
</p>
<line>
<p align="center">
<a href="j2mebasquery.jsp">返回上页ҳ</a> &nbsp;<a href="j2memain.jsp">返回主页</a>
</p>
</body>
</html>


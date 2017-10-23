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
      String sOut1 = "";
      String sOut2 = "";
      EAXmlDS ds = null;
      //EAUserinfo usrinfo = new MobileLogin().GetUsrinfo(request); 
      String corpsoid = EAFunc.NVL(request.getParameter("corpsoid"),"");
     // 得到登陆的USER ID
      String sUID  = (String)session.getAttribute("sUID"); 
      out.println( "<p align=\"center\"><img border=\"0\" src=\"resource://pages/title.png\" ></P><line>" );
  //  String sql = "select shtnam as 商品,sctype 分类,ceil(qty/untnum)-decode(mod(qty,untnum),0,0,1)||unit||mod(qty,untnum)||smlunt as 数量 "+
  //    "from ( "+
  //    "select i.shtnam ,i.untnum,i.unit,i.smlunt,c.name sctype,sum(qty) qty "+
  ////    "from item i,curord h,v_sctype c where h.sctype=c.id and h.item=i.guid and h.crtusr='"+sUID+"' and h.subtyp='2'";
  //    if ( corpsoid.length() < 1 ) sql +=" and h.corpsoid is null " ;
  //    else sql+= "and h.corpsoid='"+corpsoid+"'" ;
  //    sql += " group by i.id,i.refid,i.sortid,i.shtnam,i.untnum,i.unit,i.smlunt,c.name order by i.refid,i.sortid )";

    String sql = "select shtnam as 商品,sctype 分类,ceil(qty/untnum)-decode(mod(qty,untnum),0,0,1)||unit||mod(qty,untnum)||smlunt as 数量 "+
      "from ( "+
      "select i.shtnam ,i.untnum,i.unit,i.smlunt,c.name sctype,sum(h.qty) qty "+
      "from item i,curord h,v_sctype c,corp d,corpitem e where h.sctype=c.id and h.item=i.guid and h.crtusr='"+sUID+"' and h.subtyp='2'"+
//      "from item i,curord h,v_sctype c,corp d,corpitem e where h.sctype=c.id and h.item=i.guid and h.crtusr='"+sUID+"'"+
      " and h.corp=d.guid and h.item=e.item and d.refguid=e.corp ";
      if ( corpsoid.length() < 1 ) sql +=" and h.corpsoid is null " ;
      else sql+= "and h.corpsoid='"+corpsoid+"'" ;
      sql += " group by i.id,i.refid,i.sortid,i.shtnam,i.untnum,i.unit,i.smlunt,c.name order by i.refid,i.sortid )";

    ds = EADbTool.QuerySQL(sql);
	// String sql1 = "select distinct item from curord where crtusr='"+sUID+"' and subtyp='2'  ";
   //if ( corpsoid.length() < 1 ) sql1 += " and corpsoid is null " ;
  // else sql1 += "and corpsoid='"+corpsoid+"'" ;


	 String sql1 = "select distinct curord.item from curord,corp,corpitem where curord.crtusr='"+sUID+"' and curord.subtyp='2'"+
//    String sql1 = "select distinct curord.item from curord,corp,corpitem where curord.crtusr='"+sUID+"'"+
   " and corp.guid=curord.corp and curord.item=corpitem.item and corp.refguid=corpitem.corp ";
   if ( corpsoid.length() < 1 ) sql1 += " and curord.corpsoid is null " ;
   else sql1 += "and curord.corpsoid='"+corpsoid+"'" ;


    int cc = EADbTool.QuerySQL(sql1).getRowCount();
   
    int c = ds.getRowCount();
    sOut +="共"+cc+"个品种<br/>";          
    //sOut +="<br/>共"+EADbTool.GetSQL("SELECT COUNT(DISTINCT CORP) FROM CURORD WHERE crtusr='"+sUID+"' ") + "个网点<br/>";          
    sOut1 +="商品汇总：<br/>";
    for ( int i=0;i<c;i ++ ) {
        sOut2 += ds.getStringAt(i,"商品")+":<br/>"+ds.getStringAt(i,"分类")+ds.getStringAt(i,"数量")+"<br/>";     
    }
%>
<p align="center">
<%=sOut%>
</p>
<p align="center">
<%=sOut1%>
</p>
<p align="left">
<%=sOut2%>
</p>
<line>
<p align="center">
<a href="j2mebasquerylist.jsp">返回上页</a> &nbsp;<a href="j2memain.jsp">返回主页</a>
</p>
</body>
</html>


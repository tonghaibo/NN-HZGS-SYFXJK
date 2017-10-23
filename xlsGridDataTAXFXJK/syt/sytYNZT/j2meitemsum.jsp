<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>当天订单汇总</title>
</head>
<body>

<%   
String kaflag = EAFunc.NVL(request.getParameter("kaflag"),"");
   try{
    String name = "";
    String corpid = "";
    String sUsrnam="";
    EAXmlDS ds = null;
    EAXmlDS ds1 = null;
    String sNo=(String)session.getAttribute("sNo");//session保存用户的手机号码
    EAUserinfo usrinfo = EASession.GetLoginInfo(request);
    
    if ( usrinfo ==null ) 
    {
      usrinfo = new EAUserinfo();
      usrinfo.setUsrid(sNo);
    }
     // 得到登陆的USER ID
    String sUID  = usrinfo.getUsrid();
   // String sql = "select shtnam as 商品,sctype 分类,ceil(qty/untnum)-decode(mod(qty,untnum),0,0,1)||unit||mod(qty,untnum)||smlunt as 数量 "+
    //  "from ( "+
    //  "select i.shtnam ,i.untnum,i.unit,i.smlunt,c.name sctype,sum(qty) qty "+
   //   "from item i,curord h,v_sctype c where h.sctype=c.id and h.item=i.guid and h.crtusr='"+sUID+"' ";
   //   if ( kaflag.equalsIgnoreCase("sq"))
   //   sql += "and h.subtyp='3' ";
   //   else
    //  sql +=  "and h.subtyp='1' ";
   //  sql+= "group by i.id,i.refid,i.sortid,i.shtnam,i.untnum,i.unit,i.smlunt,c.name order by i.refid,i.sortid )";




    String sql = "select shtnam as 商品,sctype 分类,ceil(qty/untnum)-decode(mod(qty,untnum),0,0,1)||unit||mod(qty,untnum)||smlunt as 数量 "+
      "from ( "+
      "select i.shtnam ,i.untnum,i.unit,i.smlunt,c.name sctype,sum(qty) qty "+
      "from item i,curord h,v_sctype c,corpitem d ,corp e where h.sctype=c.id and h.item=i.guid and h.crtusr='"+sUID+"' and d.item=h.item and h.corp=e.guid and e.refguid=d.corp  ";
//      if ( kaflag.equalsIgnoreCase("sq"))
//      sql += "and h.subtyp='3' ";
//      else
//      sql +=  "and h.subtyp='1' ";
     sql+= "group by i.id,i.refid,i.sortid,i.shtnam,i.untnum,i.unit,i.smlunt,c.name order by i.refid,i.sortid )";

   // ds = EADbTool.QuerySQL(sql);
    String sOut = "";
   // int c = ds.getRowCount();
  // String s1 = "select distinct item from curord where crtusr='"+sUID+"'";
 //  if ( kaflag.equalsIgnoreCase("sq"))
 //    s1 += " and subtyp='3'";
 //    else
 //    s1 += " and subtyp='1'";




String s1 = "select distinct curord.item from curord,corpitem,corp where curord.crtusr='"+sUID+"' and curord.item=corpitem.item and curord.corp=corp.guid and corp.refguid=corpitem.corp ";
//   if ( kaflag.equalsIgnoreCase("sq"))
//     s1 += " and curord.subtyp='3'";
//     else
//     s1 += " and curord.subtyp='1'";

    ds1 = EADbTool.QuerySQL(s1);
    int cc = ds1.getRowCount();
    sOut +="共"+cc+"个品种";          
    String s2 = "SELECT COUNT(DISTINCT CORP) FROM CURORD WHERE crtusr='"+sUID+"' ";
//    if ( kaflag.equalsIgnoreCase("sq"))
//     s2 += " and subtyp='3'";
//     else
//     s2 += " and subtyp='1'";
    sOut +="共"+EADbTool.GetSQL(s2) + "个网点，商品汇总如下：<br>";          
    
    
    int pagesize=10;//每页显示条数   
    int pageno = Integer.parseInt(EAFunc.NVL(request.getParameter("showpage"),"1"));
    int allRowCount = (int)EADbTool.GetSQLRowCount(sql);
    int nPageCount = allRowCount%pagesize==0 ? allRowCount/pagesize : allRowCount/pagesize+1;
    EAFunc.assertsFmt(nPageCount>=pageno,"目前没有数据。","");
    ds = EADbTool.pageDS(sql,pageno,pagesize); 
    ds = EADbTool.QuerySQL(EASqlFunc.pageSql(sql,""+pageno,""+pagesize));
    int c = ds.getRowCount();
    out.print(""+pageno+"/"+nPageCount+"　");
    if(pageno==nPageCount)
      out.print("<a href=\"j2meitemsum.jsp?showpage="+(pageno-1)+"&amp;kaflag="+kaflag+"\">上页</a>");
    if(pageno<nPageCount)
      out.print("<a href=\"j2meitemsum.jsp?showpage="+(pageno+1)+"&amp;kaflag="+kaflag+"\">下页</a>");
    
    
    sOut += "<SINGLETABLE name=\"data\" width=\"100%\" COLWIDTH=\"120,50,60\" FIXEDROW=\"1\" FIXEDCOL=\"1\">" ;
    sOut += "商品,分类,数量~n";
    for ( int i=0;i<c;i ++ ) {
      if ( i!= 0 ) 
          sOut+="~n";
      sOut += ds.getStringAt(i,"商品")+","+ds.getStringAt(i,"分类")+","+ds.getStringAt(i,"数量");     
    }
    sOut += "</SINGLETABLE>" ;

    out.print(sOut);
    if(pageno>1)
      out.print("<a href=\"j2meitemsum.jsp?showpage="+(pageno-1)+"&amp;kaflag="+kaflag+"\">上页</a>");
    if(pageno<nPageCount)
      out.print("<a href=\"j2meitemsum.jsp?showpage="+(pageno+1)+"&amp;kaflag="+kaflag+"\">下页</a>");
    }
    catch(EAException e)
    {
    out.println(e.toString());
    }
    out.print("<br><a href=\"j2memain.jsp?kaflag="+kaflag+"\">返回</a>");   


%>
</p>
</body>
</html>

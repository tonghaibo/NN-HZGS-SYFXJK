<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>main</title>
</head>
<body>
<%   
    String name = "";
    String corpid = "";
	    String itemtypename = "";
    String brandname = "";
	 String itemtype = EAFunc.NVL(request.getParameter("itemtype"),"");
    String brand = EAFunc.NVL(request.getParameter("brand"),"");
     String kaflag = EAFunc.NVL(request.getParameter("kaflag"),"");
    String sUsrnam="";
    EAXmlDS ds = null;
    String sNo=(String)session.getAttribute("sNo");//session保存用户的手机号码
    EAUserinfo usrinfo = EASession.GetLoginInfo(request); 
    if ( usrinfo ==null ) 
    {
      usrinfo = new EAUserinfo();
      usrinfo.setUsrid(sNo);
    }
     // 得到登陆的USER ID
    String sUID  = usrinfo.getUsrid();
    corpid = EAFunc.NVL(request.getParameter("corpid"),"");
	 if ( itemtype.length()>0 )
      itemtypename = EADbTool.GetSQL("select name from v_itemclass where id='"+itemtype+"'");
    if (brand.length()>0 )
      brandname = EADbTool.GetSQL("select name from v_brand where id='"+brand+"'");
//    String sql = "select distinct c.name,a.qty ,c.sctype from curord a,corp b,item c where "+
//                 "a.corp=b.guid and b.id='"+corpid+"' and a.item=c.guid "+
//                 "and a.crtusr='"+sUID+"'";           
//    String sql = "select shtnam as 商品,sctype 分类,ceil(qty/untnum)-decode(mod(qty,untnum),0,0,1)||unit||mod(qty,untnum)||smlunt as 数量 "+
 //     "from ( "+
 //     "select i.shtnam ,i.untnum,i.unit,i.smlunt,c.name sctype,sum(qty) qty "+
 //     "from item i,curord h,v_sctype c ,corp d where h.sctype=c.id and h.item=i.guid and h.crtusr='"+sUID+"' "+
 //     " and h.corp=d.guid and d.id='"+corpid+"' and h.qty <>'0' and i.brand like '"+brand+"%' and i.refid like '"+itemtype+"%' ";
 //     if (kaflag.equalsIgnoreCase("sq"))
 //     sql += " and h.subtyp='3' ";
 //     else
  //     sql += " and h.subtyp='1' ";
 //    sql +="group by i.id,i.sortid,i.shtnam,i.untnum,i.unit,i.smlunt,c.name order by i.sortid )";

    String sql = "select shtnam as 商品,sctype 分类,ceil(qty/untnum)-decode(mod(qty,untnum),0,0,1)||unit||mod(qty,untnum)||smlunt as 数量 "+
      "from ( "+
      "select i.shtnam ,i.untnum,i.unit,i.smlunt,c.name sctype,sum(qty) qty "+
      "from item i,curord h,v_sctype c ,corp d,corpitem e where h.sctype=c.id and h.item=i.guid and h.crtusr='"+sUID+"' "+
      " and h.corp=d.guid and d.id='"+corpid+"' and h.qty <>'0' and i.brand like '"+brand+"%' and i.refid like '"+itemtype+"%' "+
	   " and h.item=e.item and d.refguid=e.corp ";
      if (kaflag.equalsIgnoreCase("sq"))
      sql += " and h.subtyp='3' ";
      else
       sql += " and h.subtyp='1' ";
     sql +="group by i.id,i.sortid,i.shtnam,i.untnum,i.unit,i.smlunt,c.name order by i.sortid )";




    ds = EADbTool.QuerySQL(sql);
    String sOut = "";
    int c = ds.getRowCount();
    //sOut +="本网点"+brandname+itemtypename+"共"+c+"个品种"+"<br>";  
   
    String itemsql = "select count(distinct curord.item) from curord,item,corp where curord.crtusr='"+sUID+"' and "+
                     " item.brand='"+brand+"' and item.refid like '"+itemtype+"%' and "+
                     " curord.item=item.guid and curord.corp=corp.guid and corp.id='"+corpid+"' ";
    if ( kaflag.equalsIgnoreCase("sq"))
    itemsql += "and curord.subtyp='3'";
    else
    itemsql += "and curord.subtyp='1'";
    sOut +="本网点"+brandname+itemtypename+"共"+EADbTool.GetSQL(itemsql)+"个品种"+"<br>";  
    sOut += "<SINGLETABLE name=\"data\" width=\"100%\" COLWIDTH=\"120,30,80\" FIXEDROW=\"0\" FIXEDCOL=\"1\">" ;
    sOut += "商品,分类,数量~n";
    for ( int i=0;i<c;i ++ ) {
      if ( i!= 0 ) 
          sOut+="~n";
      sOut += ds.getStringAt(i,"商品")+","+ds.getStringAt(i,"分类")+","+ds.getStringAt(i,"数量");     
    }
    
    sOut += "</SINGLETABLE>" ;
    
    sOut +="<line><a href=\"j2mequerycorp.jsp?kaflag="+kaflag+"\">返回上页</a>";          
    sOut +="<br><a href=\"j2memain.jsp\">返回主页</a>";

%>

<%=sOut%>
<hr><a href="j2memain.jsp">返回主页</a>
</body></html>

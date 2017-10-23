<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>main</title>
</head>
<body>
<%   

	  String itmtyp = EAFunc.NVL(request.getParameter("itmtyp"),"");
    String sql = "";
    String sql2 = "";
    String sOut = "";
    String sumqty = "";
    EAXmlDS ds = null;
    sql2 = " select sum(sumsxx) sumqty from ("
            +" select round(sum(nvl(a.qty,0)/nvl(a.untnum,1)),2) sumsxx"
            +" from V_FI_CURHISBIL a,v_fiitem b"
            +" where to_char(dat,'YYYY-MM-DD')=to_char(sysdate+1,'yyyy-mm-dd')" 
            +" and  a.itemid(+)=b.id"
            +" and b.refid = '"+itmtyp+"'"
            +" group by b.id,b.name,b.unit)";
    sql = "select b.id||'.'||b.name idnam,SORTID,round(sum(nvl(a.qty,0)/nvl(a.untnum,1)),2) sqty "
          +" from V_FI_CURHISBIL a,v_fiitem b "
          +" where to_char(dat,'YYYY-MM-DD')=to_char(sysdate+1,'yyyy-mm-dd') "
          +" and  a.itemid(+)=b.id"
          +" and b.refid = '"+itmtyp+"'"
          +" group by b.id,b.name ,b.unit,b.SORTID"
          +" order by SORTID";
//    sql ="select i.id itmid,i.name item,round(sum(c.qty/i.untnum),0) sqty from curord c,item i"
//         +" where i.guid = c.item"
//         +" and i.refid = c.subtyp"
//         +" and c.subtyp = '"+itmtyp+"'"
//         +" group by i.name,i.untnum,i.id order by i.id";
    ds = EADbTool.QuerySQL(sql2);
    sumqty = ds.getStringAt(0,"sumqty");
    out.print("当前开单数："+sumqty+"<br>");
    ds = EADbTool.QuerySQL(sql);
    int c = ds.getRowCount();
    sOut += "<SINGLETABLE name=\"data\" width=\"100%\" COLWIDTH=\"190,60\" FIXEDROW=\"0\" FIXEDCOL=\"1\">" ;
    sOut += "商品,数量~n";
    for ( int i=0;i<c;i ++ ) {
      if ( i!= 0 ) 
          sOut+="~n";
      sOut += ds.getStringAt(i,"idnam")+","+ds.getStringAt(i,"sqty");    
    }
    
    sOut += "</SINGLETABLE>" ;
%>
<%=sOut%>
<br><a href="j2mecurtyp.jsp">返回常低温</a>
</body></html>

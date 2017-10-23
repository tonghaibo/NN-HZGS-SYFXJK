<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>main</title>
</head>
<body>
<%
          String sql = "";
          String sql2 = "";
          String cenid = "";
          String sOut = "";
          String ownloc = "";
          EADatabase db = null;
          int c = 0;
          int c2 = 0;
          int i = 0;
          EAXmlDS ds = null;
          EAXmlDS ds2 = null;
          String sUID = "";
          String sNo=(String)session.getAttribute("sNo");
          EAUserinfo usrinfo = EASession.GetLoginInfo(request);
          String itemtype = EAFunc.NVL(request.getParameter("itemtype"),"");
          String date1 = EAFunc.NVL(request.getParameter("date1"),"");//起始日期
          String date2 =  EAFunc.NVL(request.getParameter("date2"),"");//截至日期
          try{
              if ( usrinfo ==null ){
                usrinfo = new EAUserinfo();
                usrinfo.setUsrid(sNo);
             }
          sUID  = usrinfo.getUsrid();
          db = new EADatabase();
             try {
                date1 = db.GetSQL("select to_char(to_date('"+date1+"','YYYYMMDD'),'YYYY-MM-DD') from dual");
                date2 = db.GetSQL("select to_char(to_date('"+date2+"','YYYYMMDD'),'YYYY-MM-DD') from dual");
             }
             catch ( EAException e ) {
                  throw new EAException ("日期格式不符，正确的格式是YYYYMMDD，4位年，2位月，2位日！！！");
             }
           
              sql = "select id,refid,cenid from v_corpbascat12 "
                    +"where refid = (select ownloc from usr where id = '"+sUID+"') "
                    +"order by id";
              ds = EADbTool.QuerySQL(sql);
              c = ds.getRowCount(); 
              ownloc = ds.getStringAt(0,"refid");
              sql2 += "select ord,商品,单位,";
            for(int h = 0;h<c;h++){
              cenid = ds.getStringAt(h,"cenid");
              sql2 += "sum(decode(中心,'"+cenid+"',数量,0)) "+cenid+",";
          }
              sql2 +="sum(decode(中心,'其他',数量,0)) 其他 from ("
                    +" select to_char(nvl(b.sortid1,9999),'0000') ord,b.name 商品,max(b.spec)规格, max(b.unit) 单位,NVL(a.corpbascat2,'其他') 中心,round(sum(qty/b.untnum*a.mnynum),2) 数量"  
                    +" from v_FI_sxdtl a,v_fi_item b" 
                    +" where a.dat(+)>=TO_DATE(DECODE('2009-04-01','','1900-01-01','2009-04-01'),'YYYY-MM-DD')"  
                    +" AND a.dat(+)<=TO_DATE(DECODE('2009-04-01','','2900-01-01','2009-04-22'),'YYYY-MM-DD')" 
                    +" and a.corpbascat1(+)='"+ownloc+"'"  
                    +" and b.refid = '"+itemtype+"'" 
                    +" and decode(a.sctype,'','1','1','1','2') like '1%'" 
                    +" and b.id=a.itemid(+)" 
                    +" and b.brand like 'MN%'" 
                    +" group by b.refid,b.name,b.id,a.corpbascat2,b.sortid1"
                    +" order by b.refid,nvl(b.sortid1,9999),b.name )"
                    +" group by ord,商品,规格,单位"
                    +" order by ord";
          //out.print("中心"+sql2);
             ds2 = EADbTool.QuerySQL(sql2);
             c2 = ds2.getRowCount();
             
//             int pagesize=20;//每页显示条数   
//             int pageno = Integer.parseInt(EAFunc.NVL(request.getParameter("showpage"),"1"));
//             int allRowCount = (int)EADbTool.GetSQLRowCount(sql);
//             int nPageCount = allRowCount%pagesize==0 ? allRowCount/pagesize : allRowCount/pagesize+1;
//              EAFunc.assertsFmt(nPageCount>=pageno,"目前没有数据。","");
//              ds = EADbTool.pageDS(sql,pageno,pagesize); 
//              //ds = EADbTool.QuerySQL(EASqlFunc.pageSql(sql,""+pageno,""+pagesize));
//              if(pageno==nPageCount)
//                out.print("<a href=\"j2mecurlistbyitem.jsp?showpage="+(pageno-1)+"\">上页</a></br>");
//              if(pageno<nPageCount)
//                out.print("<a href=\"j2mecurlistbyitem.jsp?showpage="+(pageno+1)+"\">下页</a></br>");
              sOut += "<SINGLETABLE name=\"data\" width=\"100%\" COLWIDTH=\"120,30,90,90,90,90,90,90,90,\" FIXEDROW=\"1\" FIXEDCOL=\"1\">" ;
//              sOut += "<SINGLETABLE name=\"data\" width=\"100%\" FIXEDROW=\"1\" FIXEDCOL=\"1\">" ;             
              sOut += "商品,单位";
              for(int j=0;j<ds.getRowCount();j++){
                sOut += ","+ds.getStringAt(j,"cenid");
              }
              sOut += ",其他~n";
              for (  i=0;i<c2;i++ ) {
//                sOut += ds2.getStringAt(i,"商品")+","+ds2.getStringAt(i,"单位");
//                   for(int k=0;k<c;k++){
//                sOut += ","+ds2.getStringAt(i,ds.getStringAt(k,"cenid"));  
                for(int col=1;col<ds2.getColumnCount();col++){
                  sOut += ds2.get(i,col)+",";
                }
                sOut += "~n";
              }
              sOut += "</SINGLETABLE>" ;
              out.print(sOut);
//              if(pageno>1)
//                out.print("<a href=\"j2mecurlistbyitem.jsp?showpage="+(pageno-1)+"\">上页</a></br>");
//              if(pageno<nPageCount)
//                out.print("<a href=\"j2mecurlistbyitem.jsp?showpage="+(pageno+1)+"\">下页</a></br>");
          
}catch(EAException e){
               out.print("操作错误，请重新登录");
               out.print("<a href=\"j2melogin.jsp\"></a>");
                   throw e;
             }












%>







</body>
</html>
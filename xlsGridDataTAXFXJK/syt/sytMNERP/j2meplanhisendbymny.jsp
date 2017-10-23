<%@ page contentType="text/html;charset=UTF8"%> 
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*,java.text.*"%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF8"/>
    <title>中心计划与销售对比按金额</title>
  </head>
  <body>
  <%   
          EAXmlDS ds = null;
          EADatabase db = null;
          response.setHeader("Pragma","No-cache"); 
          response.setHeader("Cache-Control","no-cache"); 
          response.setDateHeader("Expires", 0);
          int c = 0;
          String bascat = "";
          String sql = "";
          String sql2 = "";
          String sUID = "";
          String sOut = "";
          String date11 = "";
          String date22 = "";
          String sNo=(String)session.getAttribute("sNo");//session保存用户的手机号码
          EAUserinfo usrinfo = EASession.GetLoginInfo(request);
          String flag = EAFunc.NVL(request.getParameter("flag"),"");//按数量或金额分类的标识符
          String itemtype = EAFunc.NVL(request.getParameter("itemtype"),"");//商品常低温
          String date1 = EAFunc.NVL(request.getParameter("date1"),"");//起始日期
          String date2 = EAFunc.NVL(request.getParameter("date2"),"");//截至日期
          out.print("选定时间段内销售与非销售金额：<br>");
    
  try{
          db = new EADatabase();
          if ( usrinfo ==null ) {
                usrinfo = new EAUserinfo();
                usrinfo.setUsrid(sNo);
            } // 得到登陆的USER ID
          sUID  = usrinfo.getUsrid();
             try {
                date11 = db.GetSQL("select to_char(to_date('"+date1+"','YYYYMMDD'),'YYYY-MM-DD') from dual");
                date22 = db.GetSQL("select to_char(to_date('"+date2+"','YYYYMMDD'),'YYYY-MM-DD') from dual");
             }catch ( EAException e ) {
                  throw new EAException ("日期格式不符，正确的格式是YYYYMMDD，4位年，2位月，2位日！！！");
             }
        sql = "select corpbascat12 From planmanger"
                    +" where usr = (select guid from usr where id = '"+sUID+"')";
        ds = EADbTool.QuerySQL(sql);
        bascat = ds.getStringAt(0,"corpbascat12");//取出user所在的中心
/*      20090330改为显示销售金额和非销售金额的数据，不再和计划做对比
      sql2 = "select id , max(item)as 商品,max(spec),max(unit),sum(pmny) as 计划,sum(smny) as 完成,"
              +" round(decode(sum(pmny),0,null,sum(smny)/sum(pmny)*100),1)||'%'as 百分比 from ("
              +" select b.id, max(b.name) item ,max(b.spec) spec,max(b.unit) unit,max(b.refid) refid,max(b.sortid1) sortid1,sum(a.QTY/b.untnum) s11,sum(0) s12,sum(a.QTY/b.untnum)*b.MNYNUM as pmny,sum(0) smny"
              +" from V_soplan a,v_FIitem b"
              +" where a.item=b.guid"
              +" and a.dat>=to_date('"+date1+"','YYYY-MM-DD')"
              +" and a.dat<=to_date('"+date2+"','YYYY-MM-DD')"
              +" and a.locid like '%'"
              +" and b.refid like '2%'"
              +" AND A.TXID LIKE '%'"
              +" AND A.TXID not IN (' ')"
              +" AND A.deptid LIKE '"+bascat+"%'"
              +" AND B.BRAND LIKE 'MN%'"
              +" group by b.id,b.MNYNUM"
              +" union all" 
              +" select b.id, max(b.name) item ,max(b.spec) spec,max(b.unit) unit,max(b.refid) refid,max(b.sortid1) sortid1,sum(0) s11, sum(a.QTY/b.untnum) s12,sum(0) pmny,sum(a.QTY/b.untnum)*b.MNYNUM as smny"
              +" from v_FI_sxdtl a,v_FIitem b,corp c"
              +" where a.itemid=b.id"
              +" and a.corpid=c.id"
              +" and a.dat>=to_date('"+date1+"','YYYY-MM-DD')"
              +" and a.dat<=to_date('"+date2+"','YYYY-MM-DD')"
//              +" and a.locid like '%'"
              +" and b.refid like '2%'"
//              +" and c.bascat1 like '%'"
//              +" and c.bascat1  not IN (' ')"
              +" and c.bascat1||'.'||c.bascat2 like '"+bascat+"%'"
              +" and decode(a.sctype,'','1',a.sctype) like '1%'"
              +" group by b.id,b.MNYNUM ) group by id,refid,sortid1 order by refid,to_char(sortid1,'0000'),id";
*/      
     sql2 = "select id , max(item)as 商品,max(spec),max(unit),sum(smny) as summny,sum(smny1) as nosummny from("
              +"select b.id, max(b.name) item ,max(b.spec) spec,max(b.unit) unit,max(b.refid) refid,max(b.sortid1) sortid1,sum(0) s11, sum(a.QTY/b.untnum) s12,round(sum(a.QTY/b.untnum)*b.MNYNUM,1)as smny,sum(0) smny1"
              +" from v_FI_sxdtl a,v_FIitem b,corp c"
              +" where a.itemid=b.id"
              +" and a.corpid=c.id"
              +" and a.dat>=to_date('"+date11+"','YYYY-MM-DD')"
              +" and a.dat<=to_date('"+date22+"','YYYY-MM-DD')"
              +" and b.refid = '"+itemtype+"'"
              +" and c.bascat1||'.'||c.bascat2 like '"+bascat+"%'"
              +" and a.sctype = '1'"
              +" group by b.id,b.MNYNUM"
              +" union all"
              +" select b.id, max(b.name) item ,max(b.spec) spec,max(b.unit) unit,max(b.refid) refid,max(b.sortid1) sortid1,sum(0) s11, sum(a.QTY/b.untnum) s12,sum(0) smny,round(sum(a.QTY/b.untnum)*b.MNYNUM,1) as smny1"
              +" from v_FI_sxdtl a,v_FIitem b,corp c"
              +" where a.itemid=b.id"
              +" and a.corpid=c.id"
              +" and a.dat>=to_date('"+date11+"','YYYY-MM-DD')"
              +" and a.dat<=to_date('"+date22+"','YYYY-MM-DD')"
              +" and b.refid = '"+itemtype+"'"
              +" and c.bascat1||'.'||c.bascat2 like '"+bascat+"%'"
              +" and a.sctype != '1'"
              +" group by b.id,b.MNYNUM)"
              +" group by id,refid,sortid1 order by refid,to_char(sortid1,'0000'),id";
        ds = EADbTool.QuerySQL(sql2);
        c = ds.getRowCount();
        sOut += "<SINGLETABLE name=\"data\" width=\"100%\" COLWIDTH=\"100,60,60\" FIXEDROW=\"0\" FIXEDCOL=\"1\">" ;
        sOut += "商品,销售,非销售~n";
      for ( int i=0;i<c;i ++ ) {
          if ( i!= 0 ) 
              sOut+="~n";
          sOut += ds.getStringAt(i,"商品")+","+ds.getStringAt(i,"summny")+","+ds.getStringAt(i,"nosummny");     
       }
    sOut += "</SINGLETABLE>" ;
  }  catch ( Exception e ){ 
            if ( db!= null ) db.Rollback(); 
            out.println( "运行出错："+e.toString());
            
    }finally{ 
           if (db!= null ) db.Close(); 
    } 
       out.print(sOut+"<br>");
        out.print("<br><a href=\"j2meplanhistype.jsp?flag="+flag+"&date1="+date1+"&date2="+date2+"\">返回</a><br>");      
%>
</body>
</html>
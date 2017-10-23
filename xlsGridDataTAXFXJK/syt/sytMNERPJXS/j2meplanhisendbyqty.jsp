<%@ page contentType="text/html;charset=UTF8"%> 
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*,java.text.*"%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF8"/>
    <title>中心计划与销售对比按数量</title>
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
          String flag = EAFunc.NVL(request.getParameter("flag"),"");//按销量或金额分类的标识符
          String itemtype = EAFunc.NVL(request.getParameter("itemtype"),"");//商品大类
          String date1 = EAFunc.NVL(request.getParameter("date1"),"");//起始日期
          String date2 = EAFunc.NVL(request.getParameter("date2"),"");//截至日期
          out.print("选定时间段商品总量完成比：<br>");
    
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
        sql2 = "select id , max(item)as 商品,max(spec),max(unit),sum(s11)as 计划,sum(s12)as 完成,round(decode(sum(s11),0,null,sum(s12)/sum(s11))*100,1)||'%' as 百分比 "
                     +" from (select b.id, max(b.name) item ,max(b.spec) spec,max(b.unit) unit,max(b.refid) refid,max(b.sortid1) sortid1,round(sum(a.QTY/b.untnum),1) s11,sum(0) s12"
                     +" from V_soplan a,v_FIitem b where a.item=b.guid and a.dat>=to_date('"+date11+"','YYYY-MM-DD')and a.dat<=to_date('"+date22+"','YYYY-MM-DD')and a.locid like '%'"
                     +" and b.refid = '"+itemtype+"' AND A.deptid LIKE '"+bascat+"%' AND B.BRAND LIKE 'MN%' group by b.id union all "
                     +" select b.id, max(b.name) item ,max(b.spec) spec,max(b.unit) unit,max(b.refid) refid,max(b.sortid1) sortid1,sum(0) s11, round(sum(a.QTY/a.untnum),1) s12"
                     +" from v_FI_sxdtl a,v_FIitem b,corp c where a.itemid=b.id and a.corpid=c.id and a.dat>=to_date('"+date11+"','YYYY-MM-DD')"
                     +" and a.dat<=to_date('"+date22+"','YYYY-MM-DD') and b.refid = '"+itemtype+"' and c.bascat1||'.'||c.bascat2 like '"+bascat+"%'"
//                     +" and decode(a.sctype,'','1',a.sctype) like '1%' 20090330修改为所有销售类型
                     +"group by b.id ) group by id,refid,sortid1 order by refid,to_char(sortid1,'0000'),id";
        ds = EADbTool.QuerySQL(sql2);
        c = ds.getRowCount();
        sOut += "<SINGLETABLE name=\"data\" width=\"100%\" COLWIDTH=\"100,60,60,70\" FIXEDROW=\"0\" FIXEDCOL=\"1\">" ;
        sOut += "商品,计划,完成,百分比~n";
      for ( int i=0;i<c;i ++ ) {
          if ( i!= 0 ) 
              sOut+="~n";
          sOut += ds.getStringAt(i,"商品")+","+ds.getStringAt(i,"计划")+","+ds.getStringAt(i,"完成")+","+ds.getStringAt(i,"百分比");     
       }
    sOut += "</SINGLETABLE>" ;
  }  catch ( Exception e ){ 
            if ( db!= null ) db.Rollback(); 
            out.println( "运行出错："+e.toString());//
            
    }finally{ 
           if (db!= null ) db.Close(); 
    } 
       out.print(sOut+"<br>");
        out.print("<br><a href=\"j2meplanhistype.jsp?flag="+flag+"&date1="+date1+"&date2="+date2+"\">返回</a><br>");      
%>
</body>
</html>

<%@ page contentType="text/html;charset=UTF8"%> 
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*"%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF8"/>
    <title>中心历史订单汇总</title>
  </head>
  <body>
  <%   
    EAXmlDS ds = null;
    EAXmlDS ds1 = null;
    response.setHeader("Pragma","No-cache"); 
    response.setHeader("Cache-Control","no-cache"); 
    response.setDateHeader("Expires", 0); 
    String y1 = EAFunc.NVL(request.getParameter("y1"),"");
    String m1 = EAFunc.NVL(request.getParameter("m1"),"");
    String d1 = EAFunc.NVL(request.getParameter("d1"),"");
    String y2 = EAFunc.NVL(request.getParameter("y2"),"");
    String m2 = EAFunc.NVL(request.getParameter("m2"),"");
    String d2 = EAFunc.NVL(request.getParameter("d2"),"");
    String flag = EAFunc.NVL(request.getParameter("flag"),"");
    String sNo=(String)session.getAttribute("sNo");//session保存用户的手机号码
    EAUserinfo usrinfo = EASession.GetLoginInfo(request);
    String date1 = y1+"-"+m1+"-"+d1;//起始日期
    String date2 = y2+"-"+m2+"-"+d2;//截至日期
    
  try{
  
    if ( usrinfo ==null ) 
    {
      usrinfo = new EAUserinfo();
      usrinfo.setUsrid(sNo);
    }
     // 得到登陆的USER ID
        String sUID  = usrinfo.getUsrid();
        String sql2 = "select 分类,round(sum(金额),1) as summny from (select shtnam as 商品, name as 分类,ceil(sum(qty)/untnum)-decode(mod(sum(qty),untnum),0,0,1)||unit||mod(sum(qty),untnum)||smlunt 数量,qty*itemprice/untnum as 金额 "
                     +"from  (select item.shtnam ,v_sctype.name,v_sctype.id,sum(hisord.qty) qty,item.untnum,item.unit,item.smlunt,item.mnynum as itemprice "
                     +"from hisord,corp,v_sctype,item "
                     +"where hisord.corp=corp.guid "
                     +"and  hisord.corp in (select n.guid from corp n,planmanger  m where m.usr=(select guid from usr where id='"+sUID+"') "
                     +"and n.bascat1||'.'||n.bascat2=m.corpbascat12 ) "
                     +"and hisord.item=item.guid "
                     +"and hisord.dat>=to_date('"+date1+"','YYYY-MM-DD') "
                     +"and hisord.dat<=to_date('"+date2+"','YYYY-MM-DD') "
                     +"and v_sctype.id=hisord.sctype ";
        if(flag.equalsIgnoreCase("1")){
              sql2 += "and item.refid='1'";
                     }
        if(flag.equalsIgnoreCase("2")){
              sql2 += "and item.refid='2'";
                 }
                 
              sql2 += "group by item.id,item.refid,item.sortid,item.shtnam,v_sctype.id,v_sctype.name ,item.untnum,item.unit,item.smlunt,item.mnynum "
                     +"order  by  v_sctype.id ) group by shtnam,unit,smlunt,untnum,name,qty*itemprice) group by 分类 order by 分类";
        ds1 = EADbTool.QuerySQL(sql2);//金额分类汇总
        
        String sql = "select shtnam as 商品, name as 分类,ceil(sum(qty)/untnum)-decode(mod(sum(qty),untnum),0,0,1)||unit||mod(sum(qty),untnum)||smlunt 数量,qty*itemprice/untnum as 金额 "
                     +"from  (select item.shtnam ,v_sctype.name,v_sctype.id,sum(hisord.qty) qty,item.untnum,item.unit,item.smlunt,item.mnynum as itemprice "
                     +"from hisord,corp,v_sctype,item "
                     +"where hisord.corp=corp.guid "
                     +"and  hisord.corp in (select n.guid from corp n,planmanger  m where m.usr=(select guid from usr where id='"+sUID+"') "
                     +"and n.bascat1||'.'||n.bascat2=m.corpbascat12 ) "
                     +"and hisord.item=item.guid "
                     +"and hisord.dat>=to_date('"+date1+"','YYYY-MM-DD') "
                     +"and hisord.dat<=to_date('"+date2+"','YYYY-MM-DD') "
                     +"and v_sctype.id=hisord.sctype ";
        if(flag.equalsIgnoreCase("1")){
              sql += "and item.refid='1'";
                     }
        if(flag.equalsIgnoreCase("2")){
              sql += "and item.refid='2'";
                 }
                 
              sql += "group by item.id,item.refid,item.sortid,item.shtnam,v_sctype.id,v_sctype.name ,item.untnum,item.unit,item.smlunt,item.mnynum "
                     +"order  by  v_sctype.id ) group by shtnam,unit,smlunt,untnum,name,qty*itemprice";

        String sOut = "";
        ds = EADbTool.QuerySQL(sql);
        int cc = ds.getRowCount();
        sOut +="共"+cc+"个商品</br>";
        for(int k = 0;k<ds1.getRowCount();k++){
              out.print(ds1.getStringAt(k,"分类")+":"+ds1.getStringAt(k,"summny")+"元</br>");
        } 
    
    int pagesize=20;//每页显示条数   
    int pageno = Integer.parseInt(EAFunc.NVL(request.getParameter("showpage"),"1"));
    int allRowCount = (int)EADbTool.GetSQLRowCount(sql);
    int nPageCount = allRowCount%pagesize==0 ? allRowCount/pagesize : allRowCount/pagesize+1;
    EAFunc.assertsFmt(nPageCount>=pageno,"目前没有数据。","");
    ds = EADbTool.pageDS(sql,pageno,pagesize); 
    //ds = EADbTool.QuerySQL(EASqlFunc.pageSql(sql,""+pageno,""+pagesize));
    int c = ds.getRowCount();
    out.print(""+pageno+"/"+nPageCount+"　");
    if(pageno==nPageCount)
      out.print("<a href=\"j2mehisbyitem.jsp?showpage="+(pageno-1)+"&flag="+flag+"&y1="+y1+"&m1="+m1+"&d1="+d1+"&y2="+y2+"&m2="+m2+"&d2="+d2+"\">上页</a></br>");
    if(pageno<nPageCount)
      out.print("<a href=\"j2mehisbyitem.jsp?showpage="+(pageno+1)+"&flag="+flag+"&y1="+y1+"&m1="+m1+"&d1="+d1+"&y2="+y2+"&m2="+m2+"&d2="+d2+"\">下页</a></br>");
    
    
    sOut += "<SINGLETABLE name=\"data\" width=\"100%\" COLWIDTH=\"100,50,80,120\" FIXEDROW=\"1\" FIXEDCOL=\"1\">" ;
    sOut += "商品,分类,数量,估算金额~n";
    for ( int i=0;i<c;i ++ ) {
      if ( i!= 0 ) 
          sOut+="~n";
      sOut += ds.getStringAt(i,"商品")+","+ds.getStringAt(i,"分类")+","+ds.getStringAt(i,"数量")+","+ds.getStringAt(i,"金额");     
    }
    sOut += "</SINGLETABLE>" ;
    out.print(sOut);
    if(pageno>1)
      out.print("<a href=\"j2mehisbyitem.jsp?showpage="+(pageno-1)+"&flag="+flag+"&y1="+y1+"&m1="+m1+"&d1="+d1+"&y2="+y2+"&m2="+m2+"&d2="+d2+"\">上页</a></br>");
    if(pageno<nPageCount)
      out.print("<a href=\"j2mehisbyitem.jsp?showpage="+(pageno+1)+"&flag="+flag+"&y1="+y1+"&m1="+m1+"&d1="+d1+"&y2="+y2+"&m2="+m2+"&d2="+d2+"\">下页</a></br>");
    }
    catch(EAException e)
    {
    out.println(e.toString());
    }
    out.print("<br><a href=\"j2mehisitemtype.jsp?y1="+y1+"&m1="+m1+"&d1="+d1+"&y2="+y2+"&m2="+m2+"&d2="+d2+"\">返回常低温</a>");   

%>
  </body>
</html>

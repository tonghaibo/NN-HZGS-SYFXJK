
<%@ page contentType="text/html;charset=UTF8"%> 
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*"%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF8"/>
    <title>当天订单汇总</title>
  </head>
  <body>
    <%    
   try{
    EAXmlDS ds = null;
    EAXmlDS ds1 = null;
    String sql2 = "";
    String sOut = "";
    String sNo=(String)session.getAttribute("sNo");//session保存用户的手机号码
    EAUserinfo usrinfo = EASession.GetLoginInfo(request);
    
    if ( usrinfo ==null ) 
    {
      usrinfo = new EAUserinfo();
      usrinfo.setUsrid(sNo);
    }
     // 得到登陆的USER ID
        String sUID  = usrinfo.getUsrid();
        String sql = "select itemname,crtusr,'销售' name1"
                    +",max(decode(sn,'销售',qty,'0箱0袋')) qty1,(1) id1"
                    +",'赠品' name2,max(decode(sn,'赠品',qty,'0箱0袋')) qty2,(2) id2"
                    +",'补损' name3,max(decode(sn,'补损',qty,'0箱0袋')) qty3,(3) id3"
                    +",'品尝' name4,max(decode(sn,'品尝',qty,'0箱0袋')) qty4,(4) id4"
                    +",'管理费' name5,max(decode(sn,'管理费',qty,'0箱0袋')) qty5,(5) id5" 
                    +",'调坏包' name6,max(decode(sn,'调坏包',qty,'0箱0袋')) qty6,(6) id6 "
                    +"from (select itemname,crtusr,sn,id,ceil(qty/untnum)-decode(mod(qty,untnum),0,0,1)||unit||mod(qty,untnum)||smlunt qty "
                    +"from  (select curord.crtusr,v_sctype.name as sn,v_sctype.id,sum(curord.qty) qty,item.untnum,item.unit,item.smlunt,item.name as itemname "
                    +"from curord,corp,v_sctype,item "
                    +"where curord.corp=corp.guid and  curord.corp in (select n.guid from corp n,planmanger  m where m.usr=(select guid from usr where id='"+sUID+"') "
                    +"and n.bascat1||'.'||n.bascat2=m.corpbascat12 )and curord.item=item.guid  and v_sctype.id=curord.sctype "
                    +"group by curord.crtusr,v_sctype.id,v_sctype.name ,item.untnum,item.unit,item.smlunt,item.name order  by  crtusr,v_sctype.id ))a "
                    +"group by crtusr,itemname "
                    +"order by crtusr";
        
         sql2 = "select 分类,round(sum(金额),1) as summny from (select shtnam as 商品, name as 分类,ceil(sum(qty)/untnum)-decode(mod(sum(qty),untnum),0,0,1)||unit||mod(sum(qty),untnum)||smlunt 数量,qty*itemprice/untnum as 金额 "
                     +"from  (select item.shtnam ,v_sctype.name,v_sctype.id,sum(curord.qty) qty,item.untnum,item.unit,item.smlunt,item.mnynum as itemprice "
                     +"from curord,corp,v_sctype,item "
                     +"where curord.corp=corp.guid "
                     +"and  curord.corp in (select n.guid from corp n,planmanger  m where m.usr=(select guid from usr where id='"+sUID+"') "
                     +"and n.bascat1||'.'||n.bascat2=m.corpbascat12 ) "
                     +"and curord.item=item.guid "
                     +"and v_sctype.id=curord.sctype "
                     +"group by item.id,item.refid,item.sortid,item.shtnam,v_sctype.id,v_sctype.name ,item.untnum,item.unit,item.smlunt,item.mnynum "
                     +"order  by  v_sctype.id ) group by shtnam,unit,smlunt,untnum,name,qty*itemprice) group by 分类 order by 分类";
                     //统计金额
        ds1 = EADbTool.QuerySQL(sql2);
        for(int k = 0;k<ds1.getRowCount();k++){
              out.print(ds1.getStringAt(k,"分类")+":"+ds1.getStringAt(k,"summny")+"元</br>");
        }//显示统计的金额
        
        ds = EADbTool.QuerySQL(sql);
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
          out.print("<a href=\"j2mecurlistbyusr.jsp?showpage="+(pageno-1)+"\">上页</a></br>");
        if(pageno<nPageCount)
          out.print("<a href=\"j2menewcurlist.jsp?showpage="+(pageno+1)+"\">下页</a></br>");
        
        
        sOut += "<SINGLETABLE name=\"data\" width=\"100%\" COLWIDTH=\"100,50,80,80,80,80,80,80\" FIXEDROW=\"1\" FIXEDCOL=\"1\">" ;
        sOut += "商品,业务员,销售,赠品,补损,品尝,管理费,掉坏包~n";
        for ( int i=0;i<c;i ++ ) {
          if ( i!= 0 ) 
              sOut+="~n";
          sOut += ds.getStringAt(i,"itemname")+","+ds.getStringAt(i,"crtusr")+","+ds.getStringAt(i,"qty1")+","+ds.getStringAt(i,"qty2")
                  +","+ds.getStringAt(i,"qty3")+","+ds.getStringAt(i,"qty4")+","+ds.getStringAt(i,"qty5")+","+ds.getStringAt(i,"qty6");
        }
        sOut += "</SINGLETABLE>" ;
        out.print(sOut);
        if(pageno>1)
          out.print("<a href=\"j2mecurlistbyusr.jsp?showpage="+(pageno-1)+"\">上页</a></br>");
        if(pageno<nPageCount)
          out.print("<a href=\"j2mecurlistbyusr.jsp?showpage="+(pageno+1)+"\">下页</a></br>");
        }
        catch(EAException e)
        {
        out.println(e.toString());
        }
        out.print("<br><a href=\"j2mecurlistbyusr.jsp\">返回</a>");   
    
    %>
    </body>
    </html>

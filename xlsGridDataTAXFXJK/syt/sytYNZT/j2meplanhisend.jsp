<%@ page contentType="text/html;charset=UTF8"%> 
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*,java.text.*"%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF8"/>
    <title>中心历史订单汇总</title>
  </head>
  <body>
  <p align="center"><img  src="resource://pages/title.png" ></P><hr><br>
  <%   
    EAXmlDS ds1 = null;
    EAXmlDS ds2 = null;
    response.setHeader("Pragma","No-cache"); 
    response.setHeader("Cache-Control","no-cache"); 
    response.setDateHeader("Expires", 0); 
    String y1 = EAFunc.NVL(request.getParameter("y1"),"");
    String m1 = EAFunc.NVL(request.getParameter("m1"),"");
    String d1 = EAFunc.NVL(request.getParameter("d1"),"");
    String y2 = EAFunc.NVL(request.getParameter("y2"),"");
    String m2 = EAFunc.NVL(request.getParameter("m2"),"");
    String d2 = EAFunc.NVL(request.getParameter("d2"),"");
    String hismny = "";
    String planmny = "";
    double dhismny = 0;
    double dplanmny = 0;
    //double summny = 0;
    int ihismny = 0;
    int iplanmny = 0;
    DecimalFormat df = new DecimalFormat( "##,##.00");
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
        String sql1 = "select 分类,round(sum(金额),1) as summny from (select shtnam as 商品, name as 分类,ceil(sum(qty)/untnum)-decode(mod(sum(qty),untnum),0,0,1)||unit||mod(sum(qty),untnum)||smlunt 数量,qty*itemprice/untnum as 金额 "
                     +"from  (select item.shtnam ,v_sctype.name,v_sctype.id,sum(hisord.qty) qty,item.untnum,item.unit,item.smlunt,item.mnynum as itemprice "
                     +"from hisord,corp,v_sctype,item "
                     +"where hisord.corp=corp.guid "
                     +"and  hisord.corp in (select n.guid from corp n,planmanger  m where m.usr=(select guid from usr where id='"+sUID+"') "
                     +"and n.bascat1||'.'||n.bascat2=m.corpbascat12 ) "
                     +"and hisord.item=item.guid "
                     +"and hisord.dat>=to_date('"+date1+"','YYYY-MM-DD') "
                     +"and hisord.dat<=to_date('"+date2+"','YYYY-MM-DD') "
                     +"and v_sctype.id=hisord.sctype "
                     +"and item.refid='2' "
                     +"group by item.id,item.refid,item.sortid,item.shtnam,v_sctype.id,v_sctype.name ,item.untnum,item.unit,item.smlunt,item.mnynum "
                     +"order  by  v_sctype.id ) group by shtnam,unit,smlunt,untnum,name,qty*itemprice) group by 分类 order by 分类";
        ds1 = EADbTool.QuerySQL(sql1);//金额分类汇总(历史订单)
        hismny = ds1.getStringAt(1,"summny");//取出历史订单中销售的金额
        dhismny = Double.parseDouble(hismny);
        //df.format(dhismny);//将String转换成Double
        String sql2 = "select sum(mny) planmny from ("
                     +" select i.name,SUM(qty)/untnum*i.mnynum as mny from wapplan w,item i"
                     +" where w.crtusr = '"+sUID+"'"
                     +" and dat>=to_date('"+date1+"','YYYY-MM-DD')"
                     +" and dat<=to_date('"+date2+"','YYYY-MM-DD')"
                     +" and w.item = i.guid"
                     +" and w.flag = '2'"
                     +" group by item,untnum,i.id,i.mnynum,i.name)";
        ds2 = EADbTool.QuerySQL(sql2);//计划金额汇总
        planmny = ds2.getStringAt(0,"planmny");//取出计划表中商品的金额
         if(planmny!=""){
        dplanmny = Double.parseDouble(planmny);//将String转换成Double
        iplanmny = (int)dplanmny;
        ihismny = (int)dhismny;
        out.print("销售总计:"+df.format(dhismny)+"元<br>");
        out.print("计划销量："+df.format(dplanmny)+"元<br>");
        out.print("完成百分比："+ihismny/iplanmny*100+"%<br>");
        }else{
        //summny = dhismny/dplanmny*100;      // df.format(dplanmny)
        out.print("计划表中未查询到低温数据，请返回！<br>");
       }
  }  catch(EAException e)
        {
        out.println(e.toString());
        }
        out.print("<hr><br><a href=\"j2meplanandhis.jsp.jsp\">返回</a>");      
%>
</body>
</html>
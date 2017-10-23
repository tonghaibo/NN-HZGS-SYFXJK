<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="java.lang.*,com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>curlist</title>
</head>
<body>
<%   
    out.println( "<p align=\"center\"><img border=\"0\" src=\"resource://pages/title.png\" ></P><line>" );
    String name = "";
    String corpid = "";
    String sUsrnam="";
    EAXmlDS ds = null;
    EAXmlDS ds1 = null;
    String refid = EAFunc.NVL(request.getParameter("refid"),"");
    String  brand = EAFunc.NVL(request.getParameter("brand"),"");
    String note = EAFunc.NVL(request.getParameter("note"),"");
    String itemtypid = EAFunc.NVL(request.getParameter("itemtypid"),"");
    String sUID  = (String)session.getAttribute("sUID");
    String strsql = "";
    String itmid = EAFunc.NVL(request.getParameter("itmid"),"");
    String sql = "";
    String sql1 = "";
    String sOut = "";
    String sOut1 = "";
    String sOut2 = "";
    String sOut3 = "";
    String sOut4 = "";
    sql  =  "select  name,ceil(sum(qty)/untnum)-decode(mod(sum(qty),untnum),0,0,1)||unit||mod(sum(qty),untnum)||smlunt qty "+
          " from  (select v_sctype.name,v_sctype.id,sum(curord.qty) qty,item.untnum,item.unit,item.smlunt  "+
          "from curord,corp,v_sctype,"+
         " item where curord.corp=corp.guid and  curord.corp in (select n.guid from corp n,planmanger  m where m.usr=(select guid from usr where id='"+sUID+"') "+
        " and n.bascat1||'.'||n.bascat2=m.corpbascat12 )"+
        " and curord.item=item.guid and item.id='"+itmid+"' and v_sctype.id=curord.sctype "+
        " group by v_sctype.id,v_sctype.name ,item.untnum,item.unit,item.smlunt "+
        " order  by  v_sctype.id ) group by name,unit,smlunt,untnum" ; 
    ds = EADbTool.QuerySQL(sql);
    sOut1 += "<br/>按商品汇总："+"<br/>";
  
    for ( int i=0;i<ds.getRowCount();i++ )
    {
       sOut3 += ds.getStringAt(i,"name")+":"+ds.getStringAt(i,"qty")+"<br/>";  
    }  
    /*sql1 = "select  crtusr,name,id,ceil(qty/untnum)-decode(mod(qty,untnum),0,0,1)||unit||mod(qty,untnum)||smlunt qty "+
          " from  (select curord.crtusr,v_sctype.name,v_sctype.id,sum(curord.qty) qty,item.untnum,item.unit,item.smlunt  "+
          "from curord@MN110,corp@MN110,v_sctype@MN110,"+
         " item@MN110 where curord.corp=corp.guid and  curord.corp in (select n.guid from corp@MN110 n,planmanger@MN110  m where m.usr=(select guid from usr@MN110 where id='"+sUID+"') "+
        " and n.bascat1||'.'||n.bascat2=m.corpbascat12 )"+
        " and curord.item=item.guid and item.id='"+itmid+"' and v_sctype.id=curord.sctype "+
        " group by curord.crtusr,v_sctype.id,v_sctype.name ,item.untnum,item.unit,item.smlunt "+
        " order  by  crtusr,v_sctype.id ) " ;*/
        
       
       sql1 = "select crtusr,'销售' name1,max(decode(name,'销售',qty,'0箱0袋')) qty1,(1) id1 "+
       ",'赠品' name2,max(decode(name,'赠品',qty,'0箱0袋')) qty2,(2) id2 "+
       ",'补损' name3,max(decode(name,'补损',qty,'0箱0袋')) qty3,(3) id3 "+
       ",'品尝' name4,max(decode(name,'品尝',qty,'0箱0袋')) qty4,(4) id4 "+
       ",'管理费' name5,max(decode(name,'管理费',qty,'0箱0袋')) qty5,(5) id5 "+
       ",'调坏包' name6,max(decode(name,'调坏包',qty,'0箱0袋')) qty6,(6) id6 "+
       " from (select  crtusr,name,id,ceil(qty/untnum)-decode(mod(qty,untnum),0,0,1)||unit||mod(qty,untnum)||smlunt qty "+
       " from  (select curord.crtusr,v_sctype.name,v_sctype.id,sum(curord.qty) qty,item.untnum,item.unit,item.smlunt "+
       " from curord,corp,v_sctype,item "+
       " where curord.corp=corp.guid and  curord.corp in (select n.guid from corp n,planmanger  m where m.usr=(select guid from usr where id='"+sUID+"') "+
       " and n.bascat1||'.'||n.bascat2=m.corpbascat12 )and curord.item=item.guid and item.id='"+itmid+"' and v_sctype.id=curord.sctype "+
       " group by curord.crtusr,v_sctype.id,v_sctype.name ,item.untnum,item.unit,item.smlunt order  by  crtusr,v_sctype.id ))a group by crtusr ";
       
    ds = EADbTool.QuerySQL(sql1);
    int c = ds.getRowCount();
   
    if ( c == 0 ) sOut += "暂无商品记录！<br/>";
    else
    {    
        sOut2 +="按业务员汇总：</br></br>";
        
        for ( int i=0;i<c;i++) {
           // sOut += "业务员"+ds.getStringAt(i,"crtusr")+":&nbsp;&nbsp;"+ds.getStringAt(i,"name")+ds.getStringAt(i,"qty")+"<br/><br/>";
           sOut += "业务员"+ds.getStringAt(i,"crtusr")+":<br/>&nbsp;"+ds.getStringAt(i,"name1")+"："+ds.getStringAt(i,"qty1")+
           "<br/>&nbsp;"+ds.getStringAt(i,"name2")+"："+ds.getStringAt(i,"qty2")+
           "<br/>&nbsp;"+ds.getStringAt(i,"name3")+"："+ds.getStringAt(i,"qty3")+
           "<br/>&nbsp;"+ds.getStringAt(i,"name4")+"："+ds.getStringAt(i,"qty4")+
           "<br/>&nbsp;"+ds.getStringAt(i,"name5")+"："+ds.getStringAt(i,"qty5")+
           "<br/>&nbsp;"+ds.getStringAt(i,"name6")+"："+ds.getStringAt(i,"qty6")+
           "<br/><br/>";   
           }     
    }
    sOut4 +="<br/><a href=\"j2mealllist.jsp?refid="+refid+"&amp;brand="+brand+"&amp;itemtypid="+itemtypid+"\">返回上页</a>"+"&nbsp;&nbsp;<a href=\"j2memain.jsp\">返回主页</a>";    
       
%>
  <p align="center">
     <%=sOut1%>
</p>
<p align="left">
<%=sOut3%>
</p>
<p align="center">
<%=sOut2%>
</p>
<p align="left">
<%=sOut%>
</p>
<p align="center">
<%=sOut4%>
</p>
</body>
</html>

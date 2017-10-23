<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>main</title>
</head>
<body>
<%   

        response.addHeader("Pragma","No-cache"); 
        response.addHeader("Cache-Control","no-cache"); 
        response.addDateHeader("Expires", 0); 
        out.println( "<p align=\"center\"><img border=\"0\" src=\"resource://pages/title.png\" ></P><line>" );
    String name = "";
    String corpid = "";
    String sUsrnam="";
    String sOut = "";
    String sOut1 = "";
    String sOut2 = "";
    EAXmlDS ds = null;
   // String sNo=(String)session.getAttribute("sNo");//session保存用户的手机号码
   // EAUserinfo usrinfo = new MobileLogin().GetUsrinfo(request); 
    String corpsoid = EAFunc.NVL(request.getParameter("corpsoid"),"");
    //out.print(corpsoid);
  //  if ( usrinfo ==null ) 
  //  {
   //   usrinfo = new EAUserinfo();
   //   usrinfo.setUsrid(sNo);
  //  }
     // 得到登陆的USER ID
    String sUID  = (String)session.getAttribute("sUID");
    corpid = EAFunc.NVL(request.getParameter("corpid"),"");
     //out.print(corpid);
//    String sql = "select distinct c.name,a.qty ,c.sctype from curord a,corp b,item c where "+
//                 "a.corp=b.guid and b.id='"+corpid+"' and a.item=c.guid "+
//                 "and a.crtusr='"+sUID+"'";           
 //   String sql = "select shtnam as 商品,sctype 分类,ceil(qty/untnum)-decode(mod(qty,untnum),0,0,1)||unit||mod(qty,untnum)||smlunt as 数量 "+
  //    "from ( "+
  //    "select i.shtnam ,i.untnum,i.unit,i.smlunt,c.name sctype,sum(qty) qty "+
  //    "from item i,curord h,v_sctype c ,corp d where h.sctype=c.id and h.item=i.guid and h.crtusr='"+sUID+"' "+
  //    " and h.corp=d.guid and d.id='"+corpid+"'  and h.subtyp='2' ";
  //    if ( corpsoid.length()<1)
  ////     sql += " and h.corpsoid is null ";
  //     else
   //    sql += " and h.corpsoid='"+corpsoid+"'";
   //   sql += "group by i.id,i.sortid,i.shtnam,i.untnum,i.unit,i.smlunt,c.name order by i.sortid )";



    String sql = "select shtnam as 商品,sctype 分类,ceil(qty/untnum)-decode(mod(qty,untnum),0,0,1)||unit||mod(qty,untnum)||smlunt as 数量 "+
      "from ( "+
      "select i.shtnam ,i.untnum,i.unit,i.smlunt,c.name sctype,sum(qty) qty "+
      "from item i,curord h,v_sctype c ,corp d,corpitem e where h.sctype=c.id and h.item=i.guid and h.crtusr='"+sUID+"' "+
      " and h.corp=d.guid and d.id='"+corpid+"'  and h.subtyp='2' and d.refguid=e.corp and h.item=e.item ";
//       " and h.corp=d.guid and d.id='"+corpid+"' and d.refguid=e.corp and h.item=e.item ";
      if ( corpsoid.length()<1)
       sql += " and h.corpsoid is null ";
       else
       sql += " and h.corpsoid='"+corpsoid+"'";
      sql += "group by i.id,i.sortid,i.shtnam,i.untnum,i.unit,i.smlunt,c.name order by i.sortid )";

    ds = EADbTool.QuerySQL(sql);
    int c = ds.getRowCount();
    sOut +="本网点共"+c+"个品种"+"<br/>";              
    for ( int i=0;i<c;i ++ ) {
        sOut1 += ds.getStringAt(i,"商品")+":<br/>"+ds.getStringAt(i,"分类")+ds.getStringAt(i,"数量")+"<br/>";     
    }
    sOut2 +="<br/><a href=\"j2mebasquerycorpsoid.jsp?corpsoid="+corpsoid+"&corpid="+corpid+"\">返回上页</a>"
    +"<a href=\"j2memain.jsp\">返回主页</a>";          
    //sOut2 +="<br/><a href=\"main.jsp\">返回主页</a>";

%>
<p align="center">
<%=sOut%>
</p>
<p align="left">
<%=sOut1%></br>
</p>
<line>
<p align="center">
<%=sOut2%></br>
</p>
</body>
</html>


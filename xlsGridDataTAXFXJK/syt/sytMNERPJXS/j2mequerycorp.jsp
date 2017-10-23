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
    String sUsrnam="";
    EAXmlDS ds = null;
    String sNo=(String)session.getAttribute("sNo");//session保存用户的手机号码
    EAUserinfo usrinfo = EASession.GetLoginInfo(request); 
    String kaflag = EAFunc.NVL(request.getParameter("kaflag"),"");
    if ( usrinfo ==null ) 
    {
      usrinfo = new EAUserinfo();
      usrinfo.setUsrid(sNo);
    }
     // 得到登陆的USER ID
    String sUID  = usrinfo.getUsrid();    
//    String sql = "select shtnam as 商品,sctype 分类,ceil(qty/untnum)-decode(mod(qty,untnum),0,0,1)||unit||mod(qty,untnum)||smlunt as 数量 "+
//      "from ( "+
//      "select i.shtnam ,i.untnum,i.unit,i.smlunt,c.name sctype,sum(qty) qty "+
//      "from item i,curord h,v_sctype c where h.sctype=c.id and h.item=i.guid and h.crtusr='"+sUID+"' "+
//      "group by i.id,i.refid,i.sortid,i.shtnam,i.untnum,i.unit,i.smlunt,c.name order by i.refid,i.sortid )";
    String sql = "select  distinct b.id,b.name from curord a,corp b where a.corp=b.guid and a.crtusr='"+sUID+"' ";
    if ( kaflag.equalsIgnoreCase("sq"))
     sql+="and a.subtyp='3' ";
     else
      sql += "and a.subtyp='1' ";
    ds = EADbTool.QuerySQL(sql);
    String sOut = "";
    int c = ds.getRowCount();
    sOut +="共"+c+"个网点"+"<br>";          
    for ( int i=0;i<c;i ++ ) {
        sOut += "<a href=\"j2mequeryitemtype.jsp?corpid="+ds.getStringAt(i,"id")+"&kaflag="+kaflag+"\">"+ds.getStringAt(i,"name")+"</a><br>";
    }
    sOut +="<line><a href=\"j2memain.jsp\">返回主页</a>";

%>
<%=sOut%>
</body>
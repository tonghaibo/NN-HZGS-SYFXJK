<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>main</title>
</head>
<body>
<%   
    out.println( "<p align=\"center\"><img border=\"0\" src=\"resource://pages/title.png\" ></P><line>" );
    String name = "";
    String corpid = "";
    String sUsrnam="";
    String sUID  = (String)session.getAttribute("sUID");
    EAXmlDS ds = null;
    //String sNo=(String)session.getAttribute("sNo");//session保存用户的手机号码
    //EAUserinfo usrinfo = new MobileLogin().GetUsrinfo(request); 
//    if ( usrinfo ==null ) 
//    {
//      usrinfo = new EAUserinfo();
//      usrinfo.setUsrid(sNo);
//    }
     // 得到登陆的USER ID
        String y1 = "";
        String m1 ="";
        String d1 = "";
        String y2 = "";
        String m2 ="";
        String d2 = "";
        String sOut = "";
        String sOut1 = "";
        String sOut2 = "";
        y1 = EAFunc.NVL(request.getParameter("y1"),"");
        m1 = EAFunc.NVL(request.getParameter("m1"),"");
        d1 = EAFunc.NVL(request.getParameter("d1"),"");
        y2 = EAFunc.NVL(request.getParameter("y2"),"");
        m2 = EAFunc.NVL(request.getParameter("m2"),"");
        d2 = EAFunc.NVL(request.getParameter("d2"),"");
        String dat1 = y1+"-"+m1+"-"+d1;
        String dat2 = y2+"-"+m2+"-"+d2;
        String sql = "select shtnam as 商品,sctype 分类,ceil(qty/untnum)-decode(mod(qty,untnum),0,0,1)||unit||mod(qty,untnum)||smlunt as 数量 "+
      "from ( "+
      "select i.shtnam ,i.untnum,i.unit,i.smlunt,c.name sctype,sum(qty) qty "+
      "from item i,hisord h,v_sctype c where h.sctype=c.id and h.item=i.guid and h.crtusr='"+sUID+"' and h.subtyp='2'"+
//       "from item i,hisord h,v_sctype c where h.sctype=c.id and h.item=i.guid and h.crtusr='"+sUID+"'"+
      " and  to_char(h.crtdat,'yyyy-mm-dd')>=to_char(to_date('"+dat1+"','yyyy-mm-dd'),'yyyy-mm-dd') "+
      " and to_char(h.crtdat,'yyyy-mm-dd')<=to_char(to_date('"+dat2+"','yyyy-mm-dd'),'yyyy-mm-dd')"+
      "group by i.id,i.refid,i.sortid,i.shtnam,i.untnum,i.unit,i.smlunt,c.name order by i.refid,i.sortid )";
      ds = EADbTool.QuerySQL(sql);
	   String sql1 = "select distinct item from hisord where crtusr='"+sUID+"' and subtyp='2' "+
//     String sql1 = "select distinct item from hisord where crtusr='"+sUID+"'"+
                " and  to_char(crtdat,'yyyy-mm-dd')>=to_char(to_date('"+dat1+"','yyyy-mm-dd'),'yyyy-mm-dd') "+
             " and to_char(crtdat,'yyyy-mm-dd')<=to_char(to_date('"+dat2+"','yyyy-mm-dd'),'yyyy-mm-dd')";
    int cc = EADbTool.QuerySQL(sql1).getRowCount();

    int c = ds.getRowCount();
    sOut +="共"+cc+"个品种,";          
    sOut1 +="共"+EADbTool.GetSQL("SELECT COUNT(DISTINCT CORP) FROM hisord WHERE crtusr='"+sUID+"' and  to_char(crtdat,'yyyy-mm-dd')>=to_char(to_date('"+dat1+"','yyyy-mm-dd'),'yyyy-mm-dd') and to_char(crtdat,'yyyy-mm-dd')<=to_char(to_date('"+dat2+"','yyyy-mm-dd'),'yyyy-mm-dd') and subtyp='2'  ") + "个网点<br/>"; 
//    sOut1 +="共"+EADbTool.GetSQL("SELECT COUNT(DISTINCT CORP) FROM hisord WHERE crtusr='"+sUID+"' and  to_char(crtdat,'yyyy-mm-dd')>=to_char(to_date('"+dat1+"','yyyy-mm-dd'),'yyyy-mm-dd') and to_char(crtdat,'yyyy-mm-dd')<=to_char(to_date('"+dat2+"','yyyy-mm-dd'),'yyyy-mm-dd')") + "个网点<br/>"; 
    //sOut +="商品汇总：<br/>";
    for ( int i=0;i<c;i ++ ) {
        sOut2 += ds.getStringAt(i,"商品")+":<br/>"+ds.getStringAt(i,"分类")+ds.getStringAt(i,"数量")+"<br/>";     
    }
    //sOut +="<br/><a href=\"bas_query.jsp\">返回上页</a>";          
    //sOut +="<br/><a href=\"main.jsp\">返回主页</a>";

%>

<p align="center">
商品汇总：</br>
<%=sOut%> <%=sOut1%></br>
</p>
<p align="left">
<%=sOut2%></br>
</p>
<line>
<p align="center">
<a href="j2mebasquery.jsp">返回上页</a> <a href="j2memain.jsp">返回主页</a></br>
</p>
</body>
</html>

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
    response.addHeader("Pragma","No-cache"); 
    response.addHeader("Cache-Control","no-cache"); 
    response.addDateHeader("Expires", 0);   
    String name = "";
    String corpid = "";
    String sUsrnam="";
    String corpname="";
    String sOut = "";
    String sOut1 = "";
    EAXmlDS ds = null;
    String curdat = EADbTool.GetSQL("SELECT TO_CHAR(SYSDATE,'HH24MIss') FROM DUAL");
    //String sNo=(String)session.getAttribute("sNo");//session保存用户的手机号码
    //EAUserinfo usrinfo = new MobileLogin().GetUsrinfo(request); 
    String y1 = "";
    String m1 ="";
    String d1 = "";
    String y2 = "";
    String m2 ="";
    String d2 = "";
    String sUID  = (String)session.getAttribute("sUID");
    y1 = EAFunc.NVL(request.getParameter("y1"),"");
    m1 = EAFunc.NVL(request.getParameter("m1"),"");
    d1 = EAFunc.NVL(request.getParameter("d1"),"");
    y2 = EAFunc.NVL(request.getParameter("y2"),"");
    m2 = EAFunc.NVL(request.getParameter("m2"),"");
    d2 = EAFunc.NVL(request.getParameter("d2"),"");
    String dat1 = y1+"-"+m1+"-"+d1;
    String dat2 = y2+"-"+m2+"-"+d2;
//    if ( usrinfo ==null ) 
//    {
//      usrinfo = new EAUserinfo();
//      usrinfo.setUsrid(sNo);
//    }
     // 得到登陆的USER ID   
    String sql = "select  distinct b.id,b.name from hisord a,corp b where a.corp=b.guid and a.crtusr='"+sUID+"' and a.subtyp='2' "+
                 " and to_char(a.crtdat,'yyyy-mm-dd')>=to_char(to_date('"+dat1+"','yyyy-mm-dd'),'yyyy-mm-dd') "+
                 " and to_char(a.crtdat,'yyyy-mm-dd')<=to_char(to_date('"+dat2+"','yyyy-mm-dd'),'yyyy-mm-dd') ";
    ds = EADbTool.QuerySQL(sql);

    int c = ds.getRowCount();
    sOut +="共"+c+"个网点"+"<br/>";          
    for ( int i=0;i<c;i ++ ) {
        corpid = ds.getStringAt(i,"id");
        corpname = ds.getStringAt(i,"name");
        sOut1 += "<img src=\"resource://pages/"+(i+1)+".png\">"
                +"<a href=\"j2mebascorpsoid.jsp?corpid="+corpid+"&curdat="+curdat+"&y1="+y1+"&m1="+m1+"&d1="+d1+"&y2="+y2+"&m2="+m2+"&d2="+d2+"\">"+corpname+"</a><br>";
//        sOut += "<anchor>"+ds.getStringAt(i,"name");    
//        sOut += "<go href=\"bas_corpsoid.jsp\">";
//        sOut += "<postfield name=\"corpid\" value=\""+corpid+"\"/>";
//        sOut += "<postfield name=\"curdat\" value=\""+curdat+"\"/>";
//        sOut += "<postfield name=\"y1\" value=\""+y1+"\"/>";
//        sOut += "<postfield name=\"m1\" value=\""+m1+"\"/>";
//        sOut += "<postfield name=\"d1\" value=\""+d1+"\"/>";
//        sOut += "<postfield name=\"y2\" value=\""+y2+"\"/>";
//        sOut += "<postfield name=\"m2\" value=\""+m2+"\"/>";
//        sOut += "<postfield name=\"d2\" value=\""+d2+"\"/>";
//        sOut += "</go></anchor><br/>";
    }
    //sOut +="<br/><a href=\"bas_query.jsp\">返回上页</a>";          
    //sOut +="<br/><a href=\"main.jsp\">返回主页</a>";
%>
<p align="center">
<%=sOut%></br>
网点列表</br>
</p>
<p align="left">
<%=sOut1%></br>
</p>
<line>
<p align="center">
<a href="j2memain.jsp">返回主页</a></br>
</p>
</body>
</html>


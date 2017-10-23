<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>main</title>
</head>
<body>
<%      out.println( "<p align=\"center\"><img border=\"0\" src=\"resource://pages/title.png\" ></P><line>" );
        response.addHeader("Pragma","No-cache"); 
        response.addHeader("Cache-Control","no-cache"); 
        response.addDateHeader("Expires", 0);   
        String name = "";
        String corpid = "";
        String corpname = "";
        String sUsrnam="";
        String sOut = "";
        String sOut1 = "";
        EAXmlDS ds = null;
        String curdat = EADbTool.GetSQL("SELECT TO_CHAR(SYSDATE,'HH24MIss') FROM DUAL");
        String sUID  = (String)session.getAttribute("sUID");//session保存用户的手机号码
        //EAUserinfo usrinfo = new MobileLogin().GetUsrinfo(request); 
    //if ( usrinfo ==null ) 
    //{
     // usrinfo = new EAUserinfo();
      //usrinfo.setUsrid(sNo);
   // }
     // 得到登陆的USER ID 
    String sql = "select  distinct b.id,b.name from curord a,corp b where a.corp=b.guid and a.crtusr='"+sUID+"' and a.subtyp='2' ";
//    String sql = "select  distinct b.id,b.name from curord a,corp b where a.corp=b.guid and a.crtusr='"+sUID+"'";
    ds = EADbTool.QuerySQL(sql);
    int c = ds.getRowCount();
    sOut +="共"+c+"个网点"+"<br/>";          
    for ( int i=0;i<c;i ++ ) {
        corpid = ds.getStringAt(i,"id");
        corpname = ds.getStringAt(i,"name");
        sOut1+="<img src=\"resource://pages/"+(i+1)+".png\"> <a href=\"j2mebasquerycorpsoid.jsp?corpid="+corpid+"&curdat="+curdat+"\">"+corpname+"</a><br>";
    }
%>
<p align="center">
<%=sOut%></br>
</p>
<p align="left">
<%=sOut1%></br>
</p>
<line>
<p align="center">
<a href="j2memain.jsp">返回主页</a>
</p>
</body>
</html>


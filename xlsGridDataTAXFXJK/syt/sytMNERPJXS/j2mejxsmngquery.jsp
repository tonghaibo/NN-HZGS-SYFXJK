<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>选择经销商</title>
</head>
<body>
<%
    out.println( "<p align=\"center\"><img  src=\"resource://pages/title.png\" ></P><hr></br>" );
    out.println("<p align=\"center\">请选择经销商</p></br>");
    String name = "";
    String corpid = "";
    String sUsrnam="";
    String jxsid = "";
    String jxsname = "";
    int c = 0;
    EAXmlDS ds = null;
    String sql = "";
    String sNo=(String)session.getAttribute("sNo");//session保存用户的手机号码
    EAUserinfo usrinfo = EASession.GetLoginInfo(request);
   try{
        if ( usrinfo ==null ) 
        {
          usrinfo = new EAUserinfo();
          usrinfo.setUsrid(sNo);
        }
           // 得到登陆的USER ID
          String sUID  = usrinfo.getUsrid();
          sql = "select a.id,a.name from planmanger p,v_corpbascat13 a "
               +"where p.usr = (select guid from usr where id = '"+sUID+"')"
               +"and a.idnam = p.corpbascat12 order by id";
          ds = EADbTool.QuerySQL(sql);
          c = ds.getRowCount();
        if(c>0){
           for(int i = 0;i<c;i++){
              jxsid = ds.getStringAt(i,"id");
              jxsname = ds.getStringAt(i,"name");
              out.print("<img src=\"resource://pages/1.png\"> <a href=\"j2mejxsmngtype.jsp?corpbascat13='"+jxsid+"'\">"+jxsname+"</a><br>");
           }
        }
    } catch(EAException e)
    {
    out.println(e.toString());
    }
    out.print("<br><a href=\"j2memain.jsp?kaflag=\">返回</a>");  
%>
</body>
</html>
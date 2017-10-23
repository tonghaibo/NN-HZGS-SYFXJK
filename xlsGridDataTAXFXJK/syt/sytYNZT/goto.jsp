<%@ page contentType="text/html;charset=GBK" import="com.xlsgrid.net.pub.*,com.xlsgrid.net.web.*"%>
<html>
<head>
<title>企业门户-登录</title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
<script>
function f_go(flag)
{
    f1.submit();  
}
</script>
</head>
<body onload="javascript:f_go(0);">

<%
try{
  // 进入其他的系统
  //  rooturl是目的网站的根目录 如：http://xx/mnerp/ 用于检查用户名是否合法
  //  loginurl 登陆后的目的的URL 如：http://xx/mnerp/ROOT_MNSH/SERP/fir.jsp
  EAUserinfo usrinfo = EASession.GetLoginInfo(request);
  String userid= EAFunc.NVL(request.getParameter("userid"),usrinfo.getUsrid());
  String userpwd= EAFunc.NVL(request.getParameter("userpwd"),usrinfo.getUsrpwd());
  String rooturl= EAFunc.NVL(request.getParameter("url"),"");
//  String loginurl= EAFunc.NVL(request.getParameter("loginurl"),"");
  
  out.println( "<form action='"+rooturl+"' name='f1' method='POST'>" );
  out.println( "<input type='hidden' name='usrid' value='"+userid+"'>" );
  out.println( "<input type='hidden' name='userid' value='"+userid+"'>" );
  out.println( "<input type='hidden' name='userpwd' value='"+userpwd+"'>" );
//  out.println( "<input type='hidden' name='loginurl' value='"+loginurl+"'>" );
  out.println( "</form>" );
      
}
catch ( EAException e ) {
  out.println( e.toString() );
}
%>
<font size="2">
正在进入，请您稍候...<P><a href='#' onclick='f_go(1)'>点击直接进入</a>
</font>
</body>
</html>
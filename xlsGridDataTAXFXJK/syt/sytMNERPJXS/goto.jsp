<%@ page contentType="text/html;charset=GBK" import="com.xlsgrid.net.pub.*,com.xlsgrid.net.web.*"%>
<html>
<head>
<title>��ҵ�Ż�-��¼</title>
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
  // ����������ϵͳ
  //  rooturl��Ŀ����վ�ĸ�Ŀ¼ �磺http://xx/mnerp/ ���ڼ���û����Ƿ�Ϸ�
  //  loginurl ��½���Ŀ�ĵ�URL �磺http://xx/mnerp/ROOT_MNSH/SERP/fir.jsp
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
���ڽ��룬�����Ժ�...<P><a href='#' onclick='f_go(1)'>���ֱ�ӽ���</a>
</font>
</body>
</html>
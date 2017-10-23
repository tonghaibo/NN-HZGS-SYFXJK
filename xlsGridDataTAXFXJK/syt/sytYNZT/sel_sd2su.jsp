<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.web.*,com.xlsgrid.net.tag.*,com.xlsgrid.net.xmldb.*" %>

<%  
  EAUserinfo usrinfo = null;
  String usrnam = "";
  String logtime = "";
  try {
    usrinfo = com.xlsgrid.net.web.EASession.GetLoginInfo(request)  ;
    if (usrinfo!=null ) {
      usrnam = usrinfo.getUsrnam();
      logtime = usrinfo.getLogdat();
    }
  }
  catch ( EAException e ){
    out.println( e.toString() );
  }
  String sWhere = "";
  if ( usrinfo.getLocid().length() > 0 ) sWhere ="&where=and locid="+usrinfo.getLocid();
%>

<html>
<head>
  <LINK rel=stylesheet type=text/css HREF="../xlsgrid/css/main.css">
  <meta http-equiv="Content-Language" content="zh-cn">
  <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
  
  <title>欢迎使用xlsGrid</title>
</head>

<body topmargin="0" leftmargin="0">

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
  <tr>
    <td align="left" height="30" bgcolor="#7DB1FF">
		<p align="left">
        <font color="#FFFFFF">　请选择：</font><a href="../ShowXlsGrid.sp?grdid=SelFlw&sytid=MNERP&datflw=SD2SU&action=&where= and b.subtyp='1'" target="mainwnd"><font color="#FFFFFF">常温</font></a><font color="#FFFFFF">&nbsp;</font><a href="../ShowXlsGrid.sp?grdid=SelFlw&sytid=MNERP&datflw=SD2SU&action=&where= and b.subtyp='2'" target="mainwnd"><font color="#FFFFFF">低温</font></a><font color="#FFFFFF">
		</font></p>
    </td>
  </tr>
	<tr>
    <td align="left" valign="top"><iframe name="mainwnd" id="mainwnd" src="" width="100%" height="100%"></iframe></td>
  </tr>
</table>

</body>

</html>
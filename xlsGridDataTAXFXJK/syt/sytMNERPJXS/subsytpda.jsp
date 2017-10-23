<%@ page contentType="text/html;charset=gb2312" %>
<%@ page import="java.io.*,com.xlsgrid.net.chart.*,com.xlsgrid.net.pub.*,com.xlsgrid.net.web.*,com.xlsgrid.net.tag.*,com.xlsgrid.net.xmldb.*" %>
<%
  EAUserinfo usrinfo = com.xlsgrid.net.web.EASession.GetLoginInfo(request)  ;
  
  String usrnam = usrinfo.getUsrnam();
  String logtime = usrinfo.getLogdat();
  String sytid = EAFunc.NVL(request.getParameter("sytid") ,"" );
  String subsytid = EAFunc.NVL(request.getParameter("subsytid") ,"" );
  String subsytnam = "";
  EAXmlDS ds = null;
  String sql = "";
  EADatabase db = null;
  String GraphPath ="";
 
  String sToolbar = "";//<a href="?action=待批">待批</a> <a href="?action=销售">销售</a> <a href="?action=采购">采购</a> <a href="?action=库存">库存</a> <a href="?action=财务指标">财务</a> <a href="?action=更多">更多</a>
  String menulist = "<TABLE border=0 cellspacing=8 >";
  try{
    EADS ds0 = EAXmlDB.getSubSytDB(sytid);
    ds0 = ds0.filterDS("subid",subsytid);
    for (int  i = 0 ; i<ds0.getRowCount() ; i++ )//>
    {
      String order = ds0.getStringAt(i,"order");
      if( order.equals("0") ) { // 找出子系统信息
        subsytnam = ds0.getStringAt(i,"NAME");
      }
      else {
        String icon = ds0.getStringDef(i,"ICON","") ;
        String sName = ds0.getStringDef(i,"NAME","");
        String url = ds0.getStringDef(i,"URL","")+"&clienttype=html";
        if(EAFunc.isEmptyStr(sName))
          break;
        //◆□■◇
        menulist+="<TR><TD WIDTH='100%' ALIGN='LEFT'>";
        if ( icon.length() > 0 )
          sName = "<IMG border=0 SRC='"+icon+ "'/>"+sName;
        menulist+="<font color=#CC3300>◇</font>&nbsp;<a href="+url+">"+sName+"</a></TD></TR>";  
      }      
    }
    menulist+="</TABLE>";
  }
  catch ( EAException e ){
    out.println( e.toString() );
  }
  
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Language" content="zh-cn">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>查询和分析</title>
<LINK href="css/smalllogin.css" type="text/css" rel="stylesheet">


</head>
<body bgcolor="#FFFFFF">


<table border="0" width="100%" cellpadding="3" id="table1" height="26">
	<tr>
		<td background="images/title-bar-bk.jpg" >
		<p align="left">&nbsp;<%=subsytnam%>&nbsp;|<a href="../../mydesktoppda.jsp">首页</a></td>
 </td>
	</tr>
</table>
  <%=menulist%>
</body>


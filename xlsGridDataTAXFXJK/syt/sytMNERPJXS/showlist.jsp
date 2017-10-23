<%@ page contentType="text/html;charset=gb2312" %>
<%@ page import="java.io.*,com.xlsgrid.net.pub.*,com.xlsgrid.net.web.*,com.xlsgrid.net.tag.*,com.xlsgrid.net.xmldb.*" %>
<%

  // 从filename找出所有的清单
  String sFilename=EAFunc.NVL(request.getParameter("filename"),"") ;
  if ( sFilename.length()==0 ) 
    throw new Exception("必须输入filename参数");
  String sTitle=EAFunc.NVL(request.getParameter("title"),"标题") ;
%>
<style type='text/css'>

.mybutton{
	
cursor:hand;
border: 1px solid #808080;
font-family:宋体;
font-size:9pt; 
background-color:#99CCFF; 
vertical-align:baseline;
height:20;
}
</style>


<html>

<head>
<meta http-equiv="Content-Language" content="zh-cn">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title><%=sTitle%></title>
<LINK rel=stylesheet type=text/css HREF="../xlsgrid/css/main.css">
</head>
<script src="../xlsgrid/js/listobj.js" type="text/jscript" language="jscript"></script>
<script language="JavaScript">

<!--

  function f_showlist () {
<%
String sAccid = "";
try{
	  EADS ds = EADS.parseXmlFile(EAOption.getRealpath()+"sytMNERPJXS/resource/"+sFilename+".xml");
    String xml=ds.GetXml();
  // 根据XmlDSListView的要求处理ds
  for ( int i =0 ; i< ds.getRowCount(); i++ ) {
   
      String sImgPath = ""+ds.getValueDef(i,"ICON","") ;
      if ( sImgPath.length() == 0 )
          sImgPath = "../xlsgrid/images/icon/icon3.gif" ;
      String sName = ds.getStringAt(i,"NAME");
      String sUrl = ds.getStringAt(i,"URL");
      sUrl = EASession.GetSysValue(sUrl,request);
      if(sUrl.length()>0&& !(sUrl.substring(sUrl.length()-4).equalsIgnoreCase(".htm")))
        sUrl += "&title="+ java.net.URLEncoder.encode(sName,"GBK");
      
      
      ds.setValueAt(i,"NAME","<IMG border=0 SRC='"+sImgPath+ "'/><BR>" + sName);
      ds.setValueAt(i,"URL","javascript:window.location='"+sUrl+"'");
      ds.setValueAt(i,"NOTE",sName);
   
  }
  String str = new XmlDSListView().GetHtml(ds,"listDiv","ID","NAME","[%URL]","[%NOTE]",100,550);
  out.println(str );
}
catch ( EAException e ) {
    request.getSession().setAttribute("XLSGRID_EXCEPTION",new EAException(EAException.errGeneral,"定义的中间件资料不正确：<BR>"+e.toString()));
    response.sendRedirect("xlsweb?action=ShowError");
}
%>
  }


-->
</script>

<script language="javascript">
// 初始化
function winonload(){
	var bkimage = "background=\"../xlsgrid/images/my/greeting.jpg\"";
	newWin( "w_top11","项目列表",480,"","<div id='listDiv' />" );
 f_showlist ();
}

// 在指定的DIV位置创建一个窗口
function newWin( id, topic, height,bkimage , wintext ) {
	var str = "";
	str+="<table border=\"0\" width=\"100%\"cellspacing=\"0\" id=\"table5\" height=\""+height+"\">";
	str+="	<tr>";
	str+="		<td height=\"23\" style=\"border: 1px solid #3A77BA\" bgcolor=\"#FFFFFF\">";
	str+="		<table width=\"100%\"><tr><td width=\"154\">&nbsp;<img border=\"0\" src='images/tutu10.gif' width=\"9\" height=\"9\"> "+topic+"</td>";
	str+="			<td >";
	str+="			<img border=\"0\" src=\"../xlsgrid/images/my/barright.jpg\" width=\"22\" height=\"15\" align=\"right\"></td></tr></table>";
	str+="		</td>";
	str+="	</tr>";
	str+="	<tr>";
	str+="		<td style=\"border-left: 1px solid #3A77BA; border-right: 1px solid #3A77BA; border-bottom: 1px solid #3A77BA; \" bgcolor=\"#FFFFFF\" "+bkimage+" valign=\"top\">";
	str+="			<table width=\"100%\" cellspacing=\"6\"><tr><td><font color=\"#014E82\">"+wintext+"</font> </td></tr></table>";
	str+="　	</td>";
	str+="	</tr>";
	str+="</table>";
	document.all(id).innerHTML = str;
}

</script>

<body topmargin="0" leftmargin="0" onload="javascript:winonload();" bgcolor="#014E82">
<table width="100%" height="100%" bgcolor="#2547BC"><tr><td>
<table align="center" border="0" width="100%" id="table1" cellpadding="0" cellspacing="0">
	
	<tr>
		<td align="left" valign="top" colspan="2" bgcolor="#FFFFFF" height="290">
		
		<table border="0" width="100%" id="table3" height="269" cellspacing="5" cellpadding="0">
			<tr>
				
				<td height="142" bgcolor="#D1E2FE" valign="top" width="100%" colspan="2">
					<table width="100%"><tr><td width="31">
					<img border="0" src="../xlsgrid/images/my/bartop.jpg" width="30" height="14"></td>
					<td width="100%">
					<p align="center"><font color="#014E82">系统管理</font></td><td width="32">
					<p align="right">
					<img border="0" src="../xlsgrid/images/my/bartop.jpg" width="30" height="14"></td></tr></table>

					<table border="0" width="100%" id="table4" cellspacing="1">
						
						<tr>
							<td align="left" valign="top"><div id="w_top11"></div></td>
						</tr>
						</table>
				</td>
			</tr>
			<tr>
				<td bgcolor="#D1E2FE" valign="top" >
				</td>
			</tr>
		</table>

		</td>
	</tr>
</table>
</td></tr></table>

</body>
</html>
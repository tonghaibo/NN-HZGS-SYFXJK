<%@ page contentType="text/html;charset=gb2312" %>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.web.*,com.xlsgrid.net.tag.*,com.xlsgrid.net.xmldb.*" %>
<html>
<%
  //===========================================================================
  //  可以使用的输入参数
  //    grdtyp: 中间件类型，可以是R B L 等，如果为空，表示R报表
  //    subtyp: 中间的子类型，如对于报表，设计器上的"分类"就是子类型，子类型使用Like的方式，如
  //         设计器上的"分类"是 "258" 那么，输入subtyp=2 =5 =8 都可以查询到该报表
  //    items: 特定的中间件编号列表；例如 items=,SO,PO,510,
  //===========================================================================
  EAUserinfo usrinfo = com.xlsgrid.net.web.EASession.GetLoginInfo(request)  ;
  String usrnam = usrinfo.getUsrnam();
  String logtime = usrinfo.getLogdat();
  String action  = EAFunc.NVL(request.getParameter("action"),"query");
  String orgid  = EAFunc.NVL(request.getParameter("orgid"),"000001");
  String sTitle = "报表查询";
  if ( action.equalsIgnoreCase("sum") ) sTitle = "报表汇总";
%>
<head>
  <meta http-equiv="Content-Language" content="zh-cn">
  <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
  <title><%=usrnam%>的工作桌面</title>
  <LINK rel=stylesheet type=text/css HREF="../xlsgrid/css/main.css">
</head>

<script src="../xlsgrid/js/listobj.js" type="text/jscript" language="jscript"></script>
<script language="JavaScript">
<!--
  function f_showlist () {
<%
//String sAccid = "";
String orgnam="";
try{
  orgnam=EADbTool.GetSQL("SELECT ORGANIZENAME FROM ideal_com.M_ORGANIZE WHERE ORGANIZEID='"+orgid+"'");
  EADS ds = EADbTool.QuerySQL("select a.报表名称,a.报表编号,b.主表,b.明细表,a.中间件ID from "+
    "ideal_com.V_REPORG a,ideal_com.V_REPTAB b "+
    " where a.报表编号=b.报表编号 and a.中间件ID is not null and "+
    " 分配组织编号='"+orgid+"' "+
    " order by to_number(报表编号) desc");

  int nRow = ds.getRowCount();
  // 根据XmlDSListView的要求处理ds
  for ( int i =0 ; i< nRow; i ++ ) {
      String sImgPath = ""+ds.getValueDef(i,"ICON","") ;
      if ( sImgPath.length() == 0 )
          sImgPath = "images/icon/icon"+(i%15+1)+".JPG" ;
      String sName = ds.getStringAt(i,"报表名称");
      String sRepid = ds.getStringAt(i,"报表编号");
      //String orgid = ds.getStringAt(i,"组织编号");
      String mtb = ds.getStringAt(i,"主表");
      String dtb = ds.getStringAt(i,"明细表");
      String mwid = ds.getStringAt(i,"中间件ID");  
      ds.setValueAt(i,"NAME","<IMG border=0 SRC='"+sImgPath+ "'/><BR>" + sName );
      
      ds.setValueAt(i,"URL","javascript:window.location='../ShowXlsGrid.sp?grdid=SelFinidxReportInstance&action="+action+"&REPORTID="+sRepid+"&ORGID="+orgid+"&MTB="+mtb+"&DTB="+dtb+"&REPORTNAME="+sName+"&MWID="+mwid+"&key=NONE';");
  }
  //String str = new XmlDSListView().GetHtml(ds,"listDiv","ID","NAME","[%URL]","[%NOTE]",100,550);
  String str = new XmlDSListView().GetHtml(ds,"listDiv","ID","NAME","[%URL]","",100,550);
  out.println(str );
}
catch ( EAException e ) {
    request.getSession().setAttribute("XLSGRID_EXCEPTION",new EAException(EAException.errGeneral,"定义的中间件资料不正确：<BR>"+e.toString()));
    response.sendRedirect("../xlsweb?action=ShowError");
}
%>
  }


-->
</script>

<script language="javascript">
// 初始化
function winonload(){
	
	newWin( "w_top11","清单列表",480,"","<div id='listDiv' />" );
  	f_showlist ();
}

// 在指定的DIV位置创建一个窗口
function newWin( id, topic, height,bkimage , wintext ) {
	var str = "";
	str+="<table border=\"0\" width=\"100%\"cellspacing=\"0\" id=\"table5\" height=\""+height+"\">";
	str+="	<tr>";
	str+="		<td height=\"23\" style=\"border: 1px solid #3A77BA\" bgcolor=\"#FFFFFF\">";
	str+="		<table width=\"100%\"><tr><td width=\"154\">&nbsp;<img border=\"0\" src=\"../xlsgrid/images/my/collapse.gif\" width=\"9\" height=\"9\"> "+topic+"</td>";
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
		<td align="left" valign="top" bgcolor="#FFFFFF" height="350">
		
		<table border="0" width="100%" id="table3" height="269" cellspacing="5" cellpadding="0">
			<tr>
				<td height="142" bgcolor="#D1E2FE" valign="top" width="100%" colspan="2">
					<table width="100%"><tr><td width="31">
					<img border="0" src="../xlsgrid/images/my/bartop.jpg" width="30" height="14"></td>
					<td width="100%">
					<p align="center"><font color="#014E82"><%=sTitle%>第2步、选择<font color="red"><%=orgnam%></font>的可用报表，注:每年都会制定一套财务的报表的模版</font></td><td width="32">
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

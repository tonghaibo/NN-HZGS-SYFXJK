<%@ page contentType="text/html;charset=gb2312" %>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.web.*,com.xlsgrid.net.tag.*,com.xlsgrid.net.xmldb.*" %>
<html>
<%
  //===========================================================================
  //  ����ʹ�õ��������
  //    grdtyp: �м�����ͣ�������R B L �ȣ����Ϊ�գ���ʾR����
  //    subtyp: �м�������ͣ�����ڱ���������ϵ�"����"���������ͣ�������ʹ��Like�ķ�ʽ����
  //         ������ϵ�"����"�� "258" ��ô������subtyp=2 =5 =8 �����Բ�ѯ���ñ���
  //    items: �ض����м������б����� items=,SO,PO,510,
  //===========================================================================
  EAUserinfo usrinfo = com.xlsgrid.net.web.EASession.GetLoginInfo(request)  ;
  String usrnam = usrinfo.getUsrnam();
  String logtime = usrinfo.getLogdat();
  String action  = EAFunc.NVL(request.getParameter("action"),"query");
  String orgid  = EAFunc.NVL(request.getParameter("orgid"),"000001");
  String sTitle = "�����ѯ";
  if ( action.equalsIgnoreCase("sum") ) sTitle = "�������";
%>
<head>
  <meta http-equiv="Content-Language" content="zh-cn">
  <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
  <title><%=usrnam%>�Ĺ�������</title>
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
  EADS ds = EADbTool.QuerySQL("select a.��������,a.������,b.����,b.��ϸ��,a.�м��ID from "+
    "ideal_com.V_REPORG a,ideal_com.V_REPTAB b "+
    " where a.������=b.������ and a.�м��ID is not null and "+
    " ������֯���='"+orgid+"' "+
    " order by to_number(������) desc");

  int nRow = ds.getRowCount();
  // ����XmlDSListView��Ҫ����ds
  for ( int i =0 ; i< nRow; i ++ ) {
      String sImgPath = ""+ds.getValueDef(i,"ICON","") ;
      if ( sImgPath.length() == 0 )
          sImgPath = "images/icon/icon"+(i%15+1)+".JPG" ;
      String sName = ds.getStringAt(i,"��������");
      String sRepid = ds.getStringAt(i,"������");
      //String orgid = ds.getStringAt(i,"��֯���");
      String mtb = ds.getStringAt(i,"����");
      String dtb = ds.getStringAt(i,"��ϸ��");
      String mwid = ds.getStringAt(i,"�м��ID");  
      ds.setValueAt(i,"NAME","<IMG border=0 SRC='"+sImgPath+ "'/><BR>" + sName );
      
      ds.setValueAt(i,"URL","javascript:window.location='../ShowXlsGrid.sp?grdid=SelFinidxReportInstance&action="+action+"&REPORTID="+sRepid+"&ORGID="+orgid+"&MTB="+mtb+"&DTB="+dtb+"&REPORTNAME="+sName+"&MWID="+mwid+"&key=NONE';");
  }
  //String str = new XmlDSListView().GetHtml(ds,"listDiv","ID","NAME","[%URL]","[%NOTE]",100,550);
  String str = new XmlDSListView().GetHtml(ds,"listDiv","ID","NAME","[%URL]","",100,550);
  out.println(str );
}
catch ( EAException e ) {
    request.getSession().setAttribute("XLSGRID_EXCEPTION",new EAException(EAException.errGeneral,"������м�����ϲ���ȷ��<BR>"+e.toString()));
    response.sendRedirect("../xlsweb?action=ShowError");
}
%>
  }


-->
</script>

<script language="javascript">
// ��ʼ��
function winonload(){
	
	newWin( "w_top11","�嵥�б�",480,"","<div id='listDiv' />" );
  	f_showlist ();
}

// ��ָ����DIVλ�ô���һ������
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
	str+="��	</td>";
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
					<p align="center"><font color="#014E82"><%=sTitle%>��2����ѡ��<font color="red"><%=orgnam%></font>�Ŀ��ñ���ע:ÿ�궼���ƶ�һ�ײ���ı����ģ��</font></td><td width="32">
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

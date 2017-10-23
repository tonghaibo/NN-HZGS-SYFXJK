<%@ page contentType="text/html;charset=gb2312" %>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.web.*,com.xlsgrid.net.tag.*,com.xlsgrid.net.xmldb.*" %>
<html xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns="http://www.w3.org/TR/REC-html40">
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
  
%>
<head>
  <meta http-equiv="Content-Language" content="zh-cn">
  <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
  <link rel="File-List" href="FR1.files/filelist.xml">

  <title><%=usrnam%>的工作桌面</title>
  <LINK rel=stylesheet type=text/css HREF="../xlsgrid/css/main.css">
<!--[if gte mso 9]>
	<xml><o:shapedefaults v:ext="edit" spidmax="1027"/>
	</xml><![endif]-->
</head>

<script src="../xlsgrid/js/listobj.js" type="text/jscript" language="jscript"></script>
<script language="JavaScript">
<!--
  function f_showlist () {
<%
//String sAccid = "";
try{
  EADS ds = EADbTool.QuerySQL("select a.报表名称,a.报表编号,b.主表,b.明细表,a.中间件ID from "+
    "ideal_com.V_REPORG a,ideal_com.V_REPTAB b "+
    " where a.报表编号=b.报表编号 and "+
    " 分配组织编号='000001' "+
    " order by to_number(报表编号) desc");

  int nRow = ds.getRowCount();
  // 根据XmlDSListView的要求处理ds
  for ( int i =0 ; i< nRow; i ++ ) {
      String sName = ds.getStringAt(i,"报表名称");
  }
  //String str = new XmlDSListView().GetHtml(ds,"listDiv","ID","NAME","[%URL]","[%NOTE]",100,550);
  //String str = new XmlDSListView().GetHtml(ds,"listDiv","ID","NAME","[%URL]","",100,550);
  //out.println(str );
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
	
	newWin( "w_top11","清单列表",480,"","<iframe src='../ShowXlsGrid.sp?grdid=idxbydate' />" );
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
					<p align="center"><font color="#014E82">时间走势分析，统计各项指标年、月的走势</font></td><td width="32">
					<p align="right">
					<img border="0" src="../xlsgrid/images/my/bartop.jpg" width="30" height="14"></td></tr></table>

					<table border="0" width="100%" id="table4" cellspacing="1">
						<tr>
							<td align="left" valign="top">
                  <table border=0 width=100% cellspacing=0 id=table5 height=100%>
                    <tr>
                      <td height=23 style="border: 1px solid #3A77BA bgcolor=#FFFFFF">
                      <table width=100%><tr><td width=154>&nbsp;<img border=0 src=../xlsgrid/images/my/collapse.gif width=9 height=9> 标题</td>
                        <td >
                        <img border=0 src=../xlsgrid/images/my/barright.jpg width=22 height=15 align=right></td></tr></table>
                      </td>
                    </tr>
                    <tr>
                      <td style="border-left: 1px solid #3A77BA; border-right: 1px solid #3A77BA; border-bottom: 1px solid #3A77BA;  bgcolor=#FFFFFF  valign=top">
                        <table width=100% cellspacing=6><tr><td>
      <TABLE cellSpacing=0 cellPadding=0 width="80%" align=center border=0 id="table6">
        <TBODY>
        <TR vAlign=center align=middle>
          <TD vAlign=center align=middle height=60 style="font-size: 9pt"><FONT 
            class=Title>富尔网络销售统计</FONT></TD></TR>
        <TR height=25>
          <TD style="font-size: 9pt"><FONT 
            class=AllText><B>2006年9月24日</B>新增销售额共计：</FONT><FONT 
            class=Amount>￥10,000.00</FONT></TD></TR>
        <TR height=25>
          <TD style="font-size: 9pt"><FONT class=AllText><B>2006年9月</B>累计销售额：</FONT><A 
            href="#"><FONT 
            class=Amount>￥<U>10,000.00</U></FONT></A></TD></TR>
        <TR height=15>
          <TD style="font-size: 9pt">　</TD></TR>
        <TR height=25>
          <TD style="font-size: 9pt">
            <TABLE cellSpacing=0 cellPadding=0 width="100%" align=center 
            border=0 id="table7">
              <TBODY>
              <TR height=25>
                <TD width="50%" style="font-size: 9pt">
                  <TABLE cellSpacing=0 cellPadding=0 width="100%" align=center 
                  border=0 id="table8">
                    <TBODY>
                    <TR height=25>
                      <TD style="font-size: 9pt"><FONT 
                        class=Text><B>2006年9月24日</B>新增B2C销售额：</FONT><FONT 
                        class=Amount>￥10,000.00</FONT></TD></TR>
                    <TR height=25>
                      <TD style="font-size: 9pt"><FONT 
                        class=Text><B>2006年9月24日</B>新增B2B销售额：</FONT><FONT 
                        class=Amount>￥10,000.00</FONT></TD></TR>
                    <TR height=25>
                      <TD style="font-size: 9pt"><FONT 
                        class=Text><B>2006年9月24日</B>新增金枫销售额：</FONT><FONT 
                        class=Amount>￥10,000.00</FONT></TD></TR></TBODY></TABLE></TD>
                <TD width="60%" style="font-size: 9pt">
                  <TABLE cellSpacing=0 cellPadding=0 width="100%" align=center 
                  border=0 id="table9">
                    <TBODY>
                    <TR height=25>
                      <TD style="font-size: 9pt"><FONT class=Text><B>2006年9月</B>B2C累计销售额：</FONT><FONT 
                        class=Amount>￥10,000.00</FONT></TD></TR>
                    <TR height=25>
                      <TD style="font-size: 9pt"><FONT class=Text><B>2006年9月</B>B2B累计销售额：</FONT><FONT 
                        class=Amount>￥10,000.00</FONT></TD></TR>
                    <TR height=25>
                      <TD style="font-size: 9pt"><FONT class=Text><B>2006年9月</B>金枫累计销售额：</FONT><FONT 
                        class=Amount>￥10,000.00</FONT></TD></TR></TBODY></TABLE></TD></TR></TBODY></TABLE></TD></TR>
        <TR vAlign=bottom height=40>
          <TD align=left style="font-size: 9pt"><FONT 
            class=Text><B>富尔网络2006年B2C销售额统计图：</B></FONT></TD></TR>
        <TR height=250>
          <TD style="font-size: 9pt"><!--[if !mso]>
            <STYLE>v\:* {
	BEHAVIOR: url(#default#VML)
}
o\:* {
	BEHAVIOR: url(#default#VML)
}
.shape {
	BEHAVIOR: url(#default#VML)
}
</STYLE>
<![endif]-->
            <STYLE>TD {
	FONT-SIZE: 9pt
}
</STYLE>
<!--[if gte vml 1]><v:rect id="_x0000_s1025"
 alt="" style='position:absolute;left:232.5pt;top:277.5pt;width:397.5pt;
 height:150pt;z-index:-1' fillcolor="#9cf" stroked="f">
 <v:fill rotate="t" angle="-45" focus="100%" type="gradient"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:-1;left:310px;top:370px;width:530px;height:200px'><img
width=530 height=200 src="FR1.files/image001.gif" v:shapes="_x0000_s1025"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1026" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="232.5pt,427.5pt" to="630pt,427.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:309px;top:569px;
width:532px;height:2px'><img width=532 height=2 src="FR1.files/image002.gif"
v:shapes="_x0000_s1026"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1027"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="232.5pt,277.5pt" to="232.5pt,427.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:309px;top:369px;
width:2px;height:202px'><img width=2 height=202 src="FR1.files/image003.gif"
v:shapes="_x0000_s1027"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1028"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="240pt,277.5pt" to="240pt,420pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:319px;top:369px;
width:2px;height:192px'><img width=2 height=192 src="FR1.files/image004.gif"
v:shapes="_x0000_s1028"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1029"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="232.5pt,420pt" to="240pt,427.5pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:309px;top:559px;
width:12px;height:12px'><img width=12 height=12 src="FR1.files/image005.gif"
v:shapes="_x0000_s1029"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1030"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="240pt,420pt" to="630pt,420pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:319px;top:559px;
width:522px;height:2px'><img width=522 height=2 src="FR1.files/image006.gif"
v:shapes="_x0000_s1030"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1031"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="221.25pt,277.5pt" to="232.5pt,277.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:294px;top:369px;
width:17px;height:2px'><img width=17 height=2 src="FR1.files/image007.gif"
v:shapes="_x0000_s1031"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1032"
 alt="" style='position:absolute;left:180pt;top:277.5pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table10">
	<tbody>
		<tr>
			<td align="right" style="font-size: 9pt">200万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:240px;top:370px;width:74px;height:22px'><img width=74
height=22 src="FR1.files/image008.gif" v:shapes="_x0000_s1032"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1033" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="232.5pt,390pt" to="240pt,397.5pt"
 strokecolor="#69f"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:-1;left:309px;top:519px;width:12px;height:12px'><img
width=12 height=12 src="FR1.files/image005.gif" v:shapes="_x0000_s1033"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1034" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="240pt,390pt" to="630pt,390pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:319px;top:519px;
width:522px;height:2px'><img width=522 height=2 src="FR1.files/image006.gif"
v:shapes="_x0000_s1034"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1035"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="221.25pt,307.5pt" to="232.5pt,307.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:294px;top:409px;
width:17px;height:2px'><img width=17 height=2 src="FR1.files/image007.gif"
v:shapes="_x0000_s1035"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1036"
 alt="" style='position:absolute;left:180pt;top:307.5pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table11">
	<tbody>
		<tr>
			<td align="right" style="font-size: 9pt">160万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:240px;top:410px;width:74px;height:22px'><img width=74
height=22 src="FR1.files/image009.gif" v:shapes="_x0000_s1036"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1037" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="232.5pt,5in" to="240pt,367.5pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:309px;top:479px;
width:12px;height:12px'><img width=12 height=12 src="FR1.files/image005.gif"
v:shapes="_x0000_s1037"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1038"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="240pt,5in" to="630pt,5in" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:319px;top:479px;
width:522px;height:2px'><img width=522 height=2 src="FR1.files/image006.gif"
v:shapes="_x0000_s1038"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1039"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="221.25pt,337.5pt" to="232.5pt,337.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:294px;top:449px;
width:17px;height:2px'><img width=17 height=2 src="FR1.files/image007.gif"
v:shapes="_x0000_s1039"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1040"
 alt="" style='position:absolute;left:180pt;top:337.5pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table12">
	<tbody>
		<tr>
			<td align="right" style="font-size: 9pt">120万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:240px;top:450px;width:74px;height:22px'><img width=74
height=22 src="FR1.files/image010.gif" v:shapes="_x0000_s1040"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1041" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="232.5pt,330pt" to="240pt,337.5pt"
 strokecolor="#69f"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:-1;left:309px;top:439px;width:12px;height:12px'><img
width=12 height=12 src="FR1.files/image005.gif" v:shapes="_x0000_s1041"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1042" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="240pt,330pt" to="630pt,330pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:319px;top:439px;
width:522px;height:2px'><img width=522 height=2 src="FR1.files/image006.gif"
v:shapes="_x0000_s1042"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1043"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="221.25pt,367.5pt" to="232.5pt,367.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:294px;top:489px;
width:17px;height:2px'><img width=17 height=2 src="FR1.files/image007.gif"
v:shapes="_x0000_s1043"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1044"
 alt="" style='position:absolute;left:180pt;top:367.5pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table13">
	<tbody>
		<tr>
			<td align="right" style="font-size: 9pt">80万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:240px;top:490px;width:74px;height:22px'><img width=74
height=22 src="FR1.files/image011.gif" v:shapes="_x0000_s1044"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1045" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="232.5pt,300pt" to="240pt,307.5pt"
 strokecolor="#69f"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:-1;left:309px;top:399px;width:12px;height:12px'><img
width=12 height=12 src="FR1.files/image005.gif" v:shapes="_x0000_s1045"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1046" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="240pt,300pt" to="630pt,300pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:319px;top:399px;
width:522px;height:2px'><img width=522 height=2 src="FR1.files/image006.gif"
v:shapes="_x0000_s1046"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1047"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="221.25pt,397.5pt" to="232.5pt,397.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:294px;top:529px;
width:17px;height:2px'><img width=17 height=2 src="FR1.files/image007.gif"
v:shapes="_x0000_s1047"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1048"
 alt="" style='position:absolute;left:180pt;top:397.5pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table14">
	<tbody>
		<tr>
			<td align="right" style="font-size: 9pt">40万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:240px;top:530px;width:74px;height:22px'><img width=74
height=22 src="FR1.files/image012.gif" v:shapes="_x0000_s1048"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1049" title="￥1,555,797.58" style='position:absolute;left:237.75pt;
 top:310.5pt;width:22.5pt;height:116.25pt;z-index:1' fillcolor="lime">
 <v:fill color2="#d1ffd1" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="lime" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:316px;top:404px;width:41px;height:166px'><img width=41
height=166 src="FR1.files/image013.gif" v:shapes="_x0000_s1049"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1050" alt="" style='position:absolute;left:232.5pt;top:428.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table15">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">1月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:310px;top:571px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image014.gif" v:shapes="_x0000_s1050"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1051" title="￥443,482.72" style='position:absolute;left:270.75pt;
 top:393.75pt;width:22.5pt;height:33pt;z-index:1' fillcolor="red">
 <v:fill color2="#fbb" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="red" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:360px;top:515px;width:41px;height:55px'><img width=41
height=55 src="FR1.files/image015.gif" v:shapes="_x0000_s1051"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1052" alt="" style='position:absolute;left:265.5pt;top:428.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table16">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">2月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:354px;top:571px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image016.gif" v:shapes="_x0000_s1052"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1053" title="￥598,658.24" style='position:absolute;left:303.75pt;
 top:382.5pt;width:22.5pt;height:44.25pt;z-index:1' fillcolor="#f90">
 <v:fill color2="#ffe3bb" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#f90" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:404px;top:500px;width:41px;height:70px'><img width=41
height=70 src="FR1.files/image017.gif" v:shapes="_x0000_s1053"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1054" alt="" style='position:absolute;left:298.5pt;top:428.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table17">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">3月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:398px;top:571px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image018.gif" v:shapes="_x0000_s1054"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1055" title="￥594,464.79" style='position:absolute;left:336.75pt;
 top:382.5pt;width:22.5pt;height:44.25pt;z-index:1' fillcolor="#3cc">
 <v:fill color2="#cff4f3" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#3cc" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:448px;top:500px;width:41px;height:70px'><img width=41
height=70 src="FR1.files/image019.gif" v:shapes="_x0000_s1055"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1056" alt="" style='position:absolute;left:331.5pt;top:428.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table18">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">4月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:442px;top:571px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image020.gif" v:shapes="_x0000_s1056"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1057" title="￥354,117.29" style='position:absolute;left:369.75pt;
 top:400.5pt;width:22.5pt;height:26.25pt;z-index:1' fillcolor="#669">
 <v:fill color2="#d9d9e5" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#669" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:492px;top:524px;width:41px;height:46px'><img width=41
height=46 src="FR1.files/image021.gif" v:shapes="_x0000_s1057"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1058" alt="" style='position:absolute;left:364.5pt;top:428.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table19">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">5月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:486px;top:571px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image022.gif" v:shapes="_x0000_s1058"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1059" title="￥1,106,048.84" style='position:absolute;left:402.75pt;
 top:344.25pt;width:22.5pt;height:82.5pt;z-index:1' fillcolor="#930">
 <v:fill color2="#ffc7ab" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#930" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:536px;top:449px;width:41px;height:121px'><img width=41
height=121 src="FR1.files/image023.gif" v:shapes="_x0000_s1059"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1060" alt="" style='position:absolute;left:397.5pt;top:428.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table20">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">6月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:530px;top:571px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image024.gif" v:shapes="_x0000_s1060"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1061" title="￥1,222,301.50" style='position:absolute;left:436.5pt;
 top:335.25pt;width:22.5pt;height:91.5pt;z-index:1' fillcolor="#9c0">
 <v:fill color2="#ecffb7" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#9c0" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:581px;top:437px;width:41px;height:133px'><img width=41
height=133 src="FR1.files/image025.gif" v:shapes="_x0000_s1061"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1062" alt="" style='position:absolute;left:431.25pt;top:428.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table21">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">7月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:575px;top:571px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image026.gif" v:shapes="_x0000_s1062"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1063" title="￥1,111,963.67" style='position:absolute;left:469.5pt;
 top:343.5pt;width:22.5pt;height:83.25pt;z-index:1' fillcolor="blue">
 <v:fill color2="#8ea5fb" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="blue" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:625px;top:448px;width:41px;height:122px'><img width=41
height=122 src="FR1.files/image027.gif" v:shapes="_x0000_s1063"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1064" alt="" style='position:absolute;left:464.25pt;top:428.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table22">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">8月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:619px;top:571px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image028.gif" v:shapes="_x0000_s1064"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1065" title="￥1,628,326.04" style='position:absolute;left:502.5pt;
 top:305.25pt;width:22.5pt;height:121.5pt;z-index:1' fillcolor="#7ef443">
 <v:fill color2="#d1ffd1" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#7ef443" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:669px;top:397px;width:41px;height:173px'><img width=41
height=173 src="FR1.files/image029.gif" v:shapes="_x0000_s1065"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1066" alt="" style='position:absolute;left:497.25pt;top:428.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table23">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">9月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:663px;top:571px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image030.gif" v:shapes="_x0000_s1066"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1067" title="￥0.00" style='position:absolute;left:535.5pt;top:427.5pt;
 width:22.5pt;height:0;z-index:1' fillcolor="#ed74ec">
 <v:fill color2="#f5bcff" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#ed74ec" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:713px;top:560px;width:41px;height:11px'><img width=41
height=11 src="FR1.files/image031.gif" v:shapes="_x0000_s1067"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1068" alt="" style='position:absolute;left:530.25pt;top:428.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table24">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">10月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:707px;top:571px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image032.gif" v:shapes="_x0000_s1068"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1069" title="￥0.00" style='position:absolute;left:568.5pt;top:427.5pt;
 width:22.5pt;height:0;z-index:1' fillcolor="#1e6730">
 <v:fill color2="#72e18e" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#1e6730" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:757px;top:560px;width:41px;height:11px'><img width=41
height=11 src="FR1.files/image033.gif" v:shapes="_x0000_s1069"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1070" alt="" style='position:absolute;left:563.25pt;top:428.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table25">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">11月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:751px;top:571px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image034.gif" v:shapes="_x0000_s1070"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1071" title="￥0.00" style='position:absolute;left:601.5pt;top:427.5pt;
 width:22.5pt;height:0;z-index:1' fillcolor="#e6cd25">
 <v:fill color2="#f4eaa6" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#e6cd25" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:801px;top:560px;width:41px;height:11px'><img width=41
height=11 src="FR1.files/image035.gif" v:shapes="_x0000_s1071"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1072" alt="" style='position:absolute;left:596.25pt;top:428.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table26">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">12月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:795px;top:571px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image036.gif" v:shapes="_x0000_s1072"></span><![endif]></TD></TR>
        <TR vAlign=bottom height=40>
          <TD align=left style="font-size: 9pt"><FONT 
            class=Text><B>富尔网络2006年B2B销售额统计图：</B></FONT></TD></TR>
        <TR height=250>
          <TD style="font-size: 9pt"><!--[if gte vml 1]><v:rect
 id="_x0000_s1073" alt="" style='position:absolute;left:232.5pt;top:502.5pt;
 width:397.5pt;height:150pt;z-index:-1' fillcolor="#9cf" stroked="f">
 <v:fill rotate="t" angle="-45" focus="100%" type="gradient"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:-1;left:310px;top:670px;width:530px;height:200px'><img
width=530 height=200 src="FR1.files/image037.gif" v:shapes="_x0000_s1073"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1074" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="232.5pt,652.5pt" to="630pt,652.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:309px;top:869px;
width:532px;height:2px'><img width=532 height=2 src="FR1.files/image002.gif"
v:shapes="_x0000_s1074"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1075"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="232.5pt,502.5pt" to="232.5pt,652.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:309px;top:669px;
width:2px;height:202px'><img width=2 height=202 src="FR1.files/image003.gif"
v:shapes="_x0000_s1075"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1076"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="240pt,502.5pt" to="240pt,645pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:319px;top:669px;
width:2px;height:192px'><img width=2 height=192 src="FR1.files/image004.gif"
v:shapes="_x0000_s1076"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1077"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="232.5pt,645pt" to="240pt,652.5pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:309px;top:859px;
width:12px;height:12px'><img width=12 height=12 src="FR1.files/image005.gif"
v:shapes="_x0000_s1077"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1078"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="240pt,645pt" to="630pt,645pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:319px;top:859px;
width:522px;height:2px'><img width=522 height=2 src="FR1.files/image006.gif"
v:shapes="_x0000_s1078"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1079"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="221.25pt,502.5pt" to="232.5pt,502.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:294px;top:669px;
width:17px;height:2px'><img width=17 height=2 src="FR1.files/image007.gif"
v:shapes="_x0000_s1079"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1080"
 alt="" style='position:absolute;left:180pt;top:502.5pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table27">
	<tbody>
		<tr>
			<td align="right" style="font-size: 9pt">2000万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:240px;top:670px;width:74px;height:22px'><img width=74
height=22 src="FR1.files/image038.gif" v:shapes="_x0000_s1080"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1081" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="232.5pt,615pt" to="240pt,622.5pt"
 strokecolor="#69f"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:-1;left:309px;top:819px;width:12px;height:12px'><img
width=12 height=12 src="FR1.files/image005.gif" v:shapes="_x0000_s1081"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1082" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="240pt,615pt" to="630pt,615pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:319px;top:819px;
width:522px;height:2px'><img width=522 height=2 src="FR1.files/image006.gif"
v:shapes="_x0000_s1082"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1083"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="221.25pt,532.5pt" to="232.5pt,532.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:294px;top:709px;
width:17px;height:2px'><img width=17 height=2 src="FR1.files/image007.gif"
v:shapes="_x0000_s1083"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1084"
 alt="" style='position:absolute;left:180pt;top:532.5pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table28">
	<tbody>
		<tr>
			<td align="right" style="font-size: 9pt">1600万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:240px;top:710px;width:74px;height:22px'><img width=74
height=22 src="FR1.files/image039.gif" v:shapes="_x0000_s1084"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1085" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="232.5pt,585pt" to="240pt,592.5pt"
 strokecolor="#69f"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:-1;left:309px;top:779px;width:12px;height:12px'><img
width=12 height=12 src="FR1.files/image005.gif" v:shapes="_x0000_s1085"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1086" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="240pt,585pt" to="630pt,585pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:319px;top:779px;
width:522px;height:2px'><img width=522 height=2 src="FR1.files/image006.gif"
v:shapes="_x0000_s1086"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1087"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="221.25pt,562.5pt" to="232.5pt,562.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:294px;top:749px;
width:17px;height:2px'><img width=17 height=2 src="FR1.files/image007.gif"
v:shapes="_x0000_s1087"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1088"
 alt="" style='position:absolute;left:180pt;top:562.5pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table29">
	<tbody>
		<tr>
			<td align="right" style="font-size: 9pt">1200万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:240px;top:750px;width:74px;height:22px'><img width=74
height=22 src="FR1.files/image040.gif" v:shapes="_x0000_s1088"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1089" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="232.5pt,555pt" to="240pt,562.5pt"
 strokecolor="#69f"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:-1;left:309px;top:739px;width:12px;height:12px'><img
width=12 height=12 src="FR1.files/image005.gif" v:shapes="_x0000_s1089"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1090" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="240pt,555pt" to="630pt,555pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:319px;top:739px;
width:522px;height:2px'><img width=522 height=2 src="FR1.files/image006.gif"
v:shapes="_x0000_s1090"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1091"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="221.25pt,592.5pt" to="232.5pt,592.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:294px;top:789px;
width:17px;height:2px'><img width=17 height=2 src="FR1.files/image007.gif"
v:shapes="_x0000_s1091"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1092"
 alt="" style='position:absolute;left:180pt;top:592.5pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table30">
	<tbody>
		<tr>
			<td align="right" style="font-size: 9pt">800万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:240px;top:790px;width:74px;height:22px'><img width=74
height=22 src="FR1.files/image041.gif" v:shapes="_x0000_s1092"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1093" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="232.5pt,525pt" to="240pt,532.5pt"
 strokecolor="#69f"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:-1;left:309px;top:699px;width:12px;height:12px'><img
width=12 height=12 src="FR1.files/image005.gif" v:shapes="_x0000_s1093"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1094" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="240pt,525pt" to="630pt,525pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:319px;top:699px;
width:522px;height:2px'><img width=522 height=2 src="FR1.files/image006.gif"
v:shapes="_x0000_s1094"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1095"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="221.25pt,622.5pt" to="232.5pt,622.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:294px;top:829px;
width:17px;height:2px'><img width=17 height=2 src="FR1.files/image007.gif"
v:shapes="_x0000_s1095"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1096"
 alt="" style='position:absolute;left:180pt;top:622.5pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table31">
	<tbody>
		<tr>
			<td align="right" style="font-size: 9pt">400万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:240px;top:830px;width:74px;height:22px'><img width=74
height=22 src="FR1.files/image042.gif" v:shapes="_x0000_s1096"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1097" title="￥15,433,996.46" style='position:absolute;left:237.75pt;
 top:536.25pt;width:22.5pt;height:115.5pt;z-index:1' fillcolor="lime">
 <v:fill color2="#d1ffd1" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="lime" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:316px;top:705px;width:41px;height:165px'><img width=41
height=165 src="FR1.files/image043.gif" v:shapes="_x0000_s1097"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1098" alt="" style='position:absolute;left:232.5pt;top:653.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table32">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">1月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:310px;top:871px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image014.gif" v:shapes="_x0000_s1098"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1099" title="￥3,123,760.32" style='position:absolute;left:270.75pt;
 top:628.5pt;width:22.5pt;height:23.25pt;z-index:1' fillcolor="red">
 <v:fill color2="#fbb" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="red" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:360px;top:828px;width:41px;height:42px'><img width=41
height=42 src="FR1.files/image044.gif" v:shapes="_x0000_s1099"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1100" alt="" style='position:absolute;left:265.5pt;top:653.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table33">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">2月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:354px;top:871px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image016.gif" v:shapes="_x0000_s1100"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1101" title="￥6,664,125.56" style='position:absolute;left:303.75pt;
 top:602.25pt;width:22.5pt;height:49.5pt;z-index:1' fillcolor="#f90">
 <v:fill color2="#ffe3bb" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#f90" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:404px;top:793px;width:41px;height:77px'><img width=41
height=77 src="FR1.files/image045.gif" v:shapes="_x0000_s1101"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1102" alt="" style='position:absolute;left:298.5pt;top:653.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table34">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">3月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:398px;top:871px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image018.gif" v:shapes="_x0000_s1102"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1103" title="￥4,453,999.28" style='position:absolute;left:336.75pt;
 top:618.75pt;width:22.5pt;height:33pt;z-index:1' fillcolor="#3cc">
 <v:fill color2="#cff4f3" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#3cc" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:448px;top:815px;width:41px;height:55px'><img width=41
height=55 src="FR1.files/image046.gif" v:shapes="_x0000_s1103"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1104" alt="" style='position:absolute;left:331.5pt;top:653.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table35">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">4月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:442px;top:871px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image020.gif" v:shapes="_x0000_s1104"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1105" title="￥3,675,092.28" style='position:absolute;left:369.75pt;
 top:624.75pt;width:22.5pt;height:27pt;z-index:1' fillcolor="#669">
 <v:fill color2="#d9d9e5" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#669" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:492px;top:823px;width:41px;height:47px'><img width=41
height=47 src="FR1.files/image047.gif" v:shapes="_x0000_s1105"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1106" alt="" style='position:absolute;left:364.5pt;top:653.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table36">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">5月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:486px;top:871px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image022.gif" v:shapes="_x0000_s1106"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1107" title="￥2,691,497.59" style='position:absolute;left:402.75pt;
 top:632.25pt;width:22.5pt;height:19.5pt;z-index:1' fillcolor="#930">
 <v:fill color2="#ffc7ab" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#930" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:536px;top:833px;width:41px;height:37px'><img width=41
height=37 src="FR1.files/image048.gif" v:shapes="_x0000_s1107"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1108" alt="" style='position:absolute;left:397.5pt;top:653.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table37">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">6月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:530px;top:871px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image024.gif" v:shapes="_x0000_s1108"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1109" title="￥3,613,769.42" style='position:absolute;left:436.5pt;
 top:624.75pt;width:22.5pt;height:27pt;z-index:1' fillcolor="#9c0">
 <v:fill color2="#ecffb7" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#9c0" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:581px;top:823px;width:41px;height:47px'><img width=41
height=47 src="FR1.files/image049.gif" v:shapes="_x0000_s1109"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1110" alt="" style='position:absolute;left:431.25pt;top:653.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table38">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">7月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:575px;top:871px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image026.gif" v:shapes="_x0000_s1110"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1111" title="￥3,466,035.72" style='position:absolute;left:469.5pt;
 top:626.25pt;width:22.5pt;height:25.5pt;z-index:1' fillcolor="blue">
 <v:fill color2="#8ea5fb" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="blue" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:625px;top:825px;width:41px;height:45px'><img width=41
height=45 src="FR1.files/image050.gif" v:shapes="_x0000_s1111"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1112" alt="" style='position:absolute;left:464.25pt;top:653.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table39">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">8月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:619px;top:871px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image028.gif" v:shapes="_x0000_s1112"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1113" title="￥4,991,898.69" style='position:absolute;left:502.5pt;
 top:615pt;width:22.5pt;height:36.75pt;z-index:1' fillcolor="#7ef443">
 <v:fill color2="#d1ffd1" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#7ef443" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:669px;top:810px;width:41px;height:60px'><img width=41
height=60 src="FR1.files/image051.gif" v:shapes="_x0000_s1113"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1114" alt="" style='position:absolute;left:497.25pt;top:653.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table40">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">9月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:663px;top:871px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image030.gif" v:shapes="_x0000_s1114"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1115" title="￥0.00" style='position:absolute;left:535.5pt;top:652.5pt;
 width:22.5pt;height:0;z-index:1' fillcolor="#ed74ec">
 <v:fill color2="#f5bcff" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#ed74ec" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:713px;top:860px;width:41px;height:11px'><img width=41
height=11 src="FR1.files/image031.gif" v:shapes="_x0000_s1115"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1116" alt="" style='position:absolute;left:530.25pt;top:653.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table41">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">10月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:707px;top:871px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image032.gif" v:shapes="_x0000_s1116"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1117" title="￥0.00" style='position:absolute;left:568.5pt;top:652.5pt;
 width:22.5pt;height:0;z-index:1' fillcolor="#1e6730">
 <v:fill color2="#72e18e" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#1e6730" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:757px;top:860px;width:41px;height:11px'><img width=41
height=11 src="FR1.files/image033.gif" v:shapes="_x0000_s1117"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1118" alt="" style='position:absolute;left:563.25pt;top:653.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table42">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">11月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:751px;top:871px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image034.gif" v:shapes="_x0000_s1118"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1119" title="￥0.00" style='position:absolute;left:601.5pt;top:652.5pt;
 width:22.5pt;height:0;z-index:1' fillcolor="#e6cd25">
 <v:fill color2="#f4eaa6" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#e6cd25" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:801px;top:860px;width:41px;height:11px'><img width=41
height=11 src="FR1.files/image035.gif" v:shapes="_x0000_s1119"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1120" alt="" style='position:absolute;left:596.25pt;top:653.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table43">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">12月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:795px;top:871px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image036.gif" v:shapes="_x0000_s1120"></span><![endif]></TD></TR>
        <TR vAlign=bottom height=40>
          <TD align=left style="font-size: 9pt"><FONT 
            class=Text><B>富尔网络2006年金枫销售额统计图：</B></FONT></TD></TR>
        <TR height=300>
          <TD style="font-size: 9pt"><!--[if gte vml 1]><v:rect
 id="_x0000_s1121" alt="" style='position:absolute;left:232.5pt;top:727.5pt;
 width:397.5pt;height:150pt;z-index:-1' fillcolor="#9cf" stroked="f">
 <v:fill rotate="t" angle="-45" focus="100%" type="gradient"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:-1;left:310px;top:970px;width:530px;height:200px'><img
width=530 height=200 src="FR1.files/image052.gif" v:shapes="_x0000_s1121"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1122" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="232.5pt,877.5pt" to="630pt,877.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:309px;top:1169px;
width:532px;height:2px'><img width=532 height=2 src="FR1.files/image002.gif"
v:shapes="_x0000_s1122"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1123"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="232.5pt,727.5pt" to="232.5pt,877.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:309px;top:969px;
width:2px;height:202px'><img width=2 height=202 src="FR1.files/image003.gif"
v:shapes="_x0000_s1123"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1124"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="240pt,727.5pt" to="240pt,870pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:319px;top:969px;
width:2px;height:192px'><img width=2 height=192 src="FR1.files/image004.gif"
v:shapes="_x0000_s1124"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1125"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="232.5pt,870pt" to="240pt,877.5pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:309px;top:1159px;
width:12px;height:12px'><img width=12 height=12 src="FR1.files/image005.gif"
v:shapes="_x0000_s1125"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1126"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="240pt,870pt" to="630pt,870pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:319px;top:1159px;
width:522px;height:2px'><img width=522 height=2 src="FR1.files/image006.gif"
v:shapes="_x0000_s1126"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1127"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="221.25pt,727.5pt" to="232.5pt,727.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:294px;top:969px;
width:17px;height:2px'><img width=17 height=2 src="FR1.files/image007.gif"
v:shapes="_x0000_s1127"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1128"
 alt="" style='position:absolute;left:180pt;top:727.5pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table44">
	<tbody>
		<tr>
			<td align="right" style="font-size: 9pt">3500万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:240px;top:970px;width:74px;height:22px'><img width=74
height=22 src="FR1.files/image053.gif" v:shapes="_x0000_s1128"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1129" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="232.5pt,840pt" to="240pt,847.5pt"
 strokecolor="#69f"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:-1;left:309px;top:1119px;width:12px;height:12px'><img
width=12 height=12 src="FR1.files/image005.gif" v:shapes="_x0000_s1129"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1130" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="240pt,840pt" to="630pt,840pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:319px;top:1119px;
width:522px;height:2px'><img width=522 height=2 src="FR1.files/image006.gif"
v:shapes="_x0000_s1130"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1131"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="221.25pt,757.5pt" to="232.5pt,757.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:294px;top:1009px;
width:17px;height:2px'><img width=17 height=2 src="FR1.files/image007.gif"
v:shapes="_x0000_s1131"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1132"
 alt="" style='position:absolute;left:180pt;top:757.5pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table45">
	<tbody>
		<tr>
			<td align="right" style="font-size: 9pt">2800万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:240px;top:1010px;width:74px;height:22px'><img width=74
height=22 src="FR1.files/image054.gif" v:shapes="_x0000_s1132"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1133" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="232.5pt,810pt" to="240pt,817.5pt"
 strokecolor="#69f"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:-1;left:309px;top:1079px;width:12px;height:12px'><img
width=12 height=12 src="FR1.files/image005.gif" v:shapes="_x0000_s1133"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1134" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="240pt,810pt" to="630pt,810pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:319px;top:1079px;
width:522px;height:2px'><img width=522 height=2 src="FR1.files/image006.gif"
v:shapes="_x0000_s1134"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1135"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="221.25pt,787.5pt" to="232.5pt,787.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:294px;top:1049px;
width:17px;height:2px'><img width=17 height=2 src="FR1.files/image007.gif"
v:shapes="_x0000_s1135"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1136"
 alt="" style='position:absolute;left:180pt;top:787.5pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table46">
	<tbody>
		<tr>
			<td align="right" style="font-size: 9pt">2100万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:240px;top:1050px;width:74px;height:22px'><img width=74
height=22 src="FR1.files/image055.gif" v:shapes="_x0000_s1136"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1137" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="232.5pt,780pt" to="240pt,787.5pt"
 strokecolor="#69f"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:-1;left:309px;top:1039px;width:12px;height:12px'><img
width=12 height=12 src="FR1.files/image005.gif" v:shapes="_x0000_s1137"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1138" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="240pt,780pt" to="630pt,780pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:319px;top:1039px;
width:522px;height:2px'><img width=522 height=2 src="FR1.files/image006.gif"
v:shapes="_x0000_s1138"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1139"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="221.25pt,817.5pt" to="232.5pt,817.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:294px;top:1089px;
width:17px;height:2px'><img width=17 height=2 src="FR1.files/image007.gif"
v:shapes="_x0000_s1139"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1140"
 alt="" style='position:absolute;left:180pt;top:817.5pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table47">
	<tbody>
		<tr>
			<td align="right" style="font-size: 9pt">1400万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:240px;top:1090px;width:74px;height:22px'><img width=74
height=22 src="FR1.files/image056.gif" v:shapes="_x0000_s1140"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1141" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="232.5pt,750pt" to="240pt,757.5pt"
 strokecolor="#69f"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:-1;left:309px;top:999px;width:12px;height:12px'><img
width=12 height=12 src="FR1.files/image005.gif" v:shapes="_x0000_s1141"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1142" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="240pt,750pt" to="630pt,750pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:319px;top:999px;
width:522px;height:2px'><img width=522 height=2 src="FR1.files/image006.gif"
v:shapes="_x0000_s1142"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1143"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="221.25pt,847.5pt" to="232.5pt,847.5pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:294px;top:1129px;
width:17px;height:2px'><img width=17 height=2 src="FR1.files/image007.gif"
v:shapes="_x0000_s1143"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1144"
 alt="" style='position:absolute;left:180pt;top:847.5pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table48">
	<tbody>
		<tr>
			<td align="right" style="font-size: 9pt">700万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:240px;top:1130px;width:74px;height:22px'><img width=74
height=22 src="FR1.files/image057.gif" v:shapes="_x0000_s1144"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1145" title="￥34,695,230.40" style='position:absolute;left:237.75pt;
 top:728.25pt;width:22.5pt;height:148.5pt;z-index:1' fillcolor="lime">
 <v:fill color2="#d1ffd1" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="lime" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:316px;top:961px;width:41px;height:209px'><img width=41
height=209 src="FR1.files/image058.gif" v:shapes="_x0000_s1145"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1146" alt="" style='position:absolute;left:232.5pt;top:878.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table49">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">1月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:310px;top:1171px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image014.gif" v:shapes="_x0000_s1146"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1147" title="￥9,299,524.80" style='position:absolute;left:270.75pt;
 top:837pt;width:22.5pt;height:39.75pt;z-index:1' fillcolor="red">
 <v:fill color2="#fbb" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="red" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:360px;top:1106px;width:41px;height:64px'><img width=41
height=64 src="FR1.files/image059.gif" v:shapes="_x0000_s1147"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1148" alt="" style='position:absolute;left:265.5pt;top:878.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table50">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">2月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:354px;top:1171px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image016.gif" v:shapes="_x0000_s1148"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1149" title="￥6,521,144.64" style='position:absolute;left:303.75pt;
 top:849pt;width:22.5pt;height:27.75pt;z-index:1' fillcolor="#f90">
 <v:fill color2="#ffe3bb" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#f90" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:404px;top:1122px;width:41px;height:48px'><img width=41
height=48 src="FR1.files/image060.gif" v:shapes="_x0000_s1149"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1150" alt="" style='position:absolute;left:298.5pt;top:878.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table51">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">3月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:398px;top:1171px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image018.gif" v:shapes="_x0000_s1150"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1151" title="￥7,664,088.00" style='position:absolute;left:336.75pt;
 top:844.5pt;width:22.5pt;height:32.25pt;z-index:1' fillcolor="#3cc">
 <v:fill color2="#cff4f3" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#3cc" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:448px;top:1116px;width:41px;height:54px'><img width=41
height=54 src="FR1.files/image061.gif" v:shapes="_x0000_s1151"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1152" alt="" style='position:absolute;left:331.5pt;top:878.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table52">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">4月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:442px;top:1171px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image020.gif" v:shapes="_x0000_s1152"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1153" title="￥5,358,825.60" style='position:absolute;left:369.75pt;
 top:854.25pt;width:22.5pt;height:22.5pt;z-index:1' fillcolor="#669">
 <v:fill color2="#d9d9e5" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#669" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:492px;top:1129px;width:41px;height:41px'><img width=41
height=41 src="FR1.files/image062.gif" v:shapes="_x0000_s1153"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1154" alt="" style='position:absolute;left:364.5pt;top:878.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table53">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">5月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:486px;top:1171px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image022.gif" v:shapes="_x0000_s1154"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1155" title="￥4,172,130.00" style='position:absolute;left:402.75pt;
 top:859.5pt;width:22.5pt;height:17.25pt;z-index:1' fillcolor="#930">
 <v:fill color2="#ffc7ab" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#930" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:536px;top:1136px;width:41px;height:34px'><img width=41
height=34 src="FR1.files/image063.gif" v:shapes="_x0000_s1155"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1156" alt="" style='position:absolute;left:397.5pt;top:878.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table54">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">6月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:530px;top:1171px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image024.gif" v:shapes="_x0000_s1156"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1157" title="￥2,828,755.20" style='position:absolute;left:436.5pt;
 top:864.75pt;width:22.5pt;height:12pt;z-index:1' fillcolor="#9c0">
 <v:fill color2="#ecffb7" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#9c0" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:581px;top:1143px;width:41px;height:27px'><img width=41
height=27 src="FR1.files/image064.gif" v:shapes="_x0000_s1157"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1158" alt="" style='position:absolute;left:431.25pt;top:878.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table55">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">7月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:575px;top:1171px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image026.gif" v:shapes="_x0000_s1158"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1159" title="￥4,815,280.80" style='position:absolute;left:469.5pt;
 top:856.5pt;width:22.5pt;height:20.25pt;z-index:1' fillcolor="blue">
 <v:fill color2="#8ea5fb" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="blue" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:625px;top:1132px;width:41px;height:38px'><img width=41
height=38 src="FR1.files/image065.gif" v:shapes="_x0000_s1159"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1160" alt="" style='position:absolute;left:464.25pt;top:878.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table56">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">8月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:619px;top:1171px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image028.gif" v:shapes="_x0000_s1160"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1161" title="￥13,175,670.00" style='position:absolute;left:502.5pt;
 top:820.5pt;width:22.5pt;height:56.25pt;z-index:1' fillcolor="#7ef443">
 <v:fill color2="#d1ffd1" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#7ef443" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:669px;top:1084px;width:41px;height:86px'><img width=41
height=86 src="FR1.files/image066.gif" v:shapes="_x0000_s1161"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1162" alt="" style='position:absolute;left:497.25pt;top:878.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table57">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">9月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:663px;top:1171px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image030.gif" v:shapes="_x0000_s1162"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1163" title="￥0.00" style='position:absolute;left:535.5pt;top:877.5pt;
 width:22.5pt;height:0;z-index:1' fillcolor="#ed74ec">
 <v:fill color2="#f5bcff" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#ed74ec" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:713px;top:1160px;width:41px;height:11px'><img width=41
height=11 src="FR1.files/image031.gif" v:shapes="_x0000_s1163"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1164" alt="" style='position:absolute;left:530.25pt;top:878.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table58">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">10月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:707px;top:1171px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image032.gif" v:shapes="_x0000_s1164"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1165" title="￥0.00" style='position:absolute;left:568.5pt;top:877.5pt;
 width:22.5pt;height:0;z-index:1' fillcolor="#1e6730">
 <v:fill color2="#72e18e" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#1e6730" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:757px;top:1160px;width:41px;height:11px'><img width=41
height=11 src="FR1.files/image033.gif" v:shapes="_x0000_s1165"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1166" alt="" style='position:absolute;left:563.25pt;top:878.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table59">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">11月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:751px;top:1171px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image034.gif" v:shapes="_x0000_s1166"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1167" title="￥0.00" style='position:absolute;left:601.5pt;top:877.5pt;
 width:22.5pt;height:0;z-index:1' fillcolor="#e6cd25">
 <v:fill color2="#f4eaa6" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#e6cd25" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:801px;top:1160px;width:41px;height:11px'><img width=41
height=11 src="FR1.files/image035.gif" v:shapes="_x0000_s1167"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1168" alt="" style='position:absolute;left:596.25pt;top:878.25pt;
 width:33pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table60">
	<tbody>
		<tr>
			<td align="middle" style="font-size: 9pt">12月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:795px;top:1171px;width:48px;height:22px'><img width=48
height=22 src="FR1.files/image036.gif" v:shapes="_x0000_s1168"></span><![endif]></TD></TR></TBODY></TABLE>
							<p>　</p>
							<p>　</p>
							<p>　</p>
							<p>　</p>
							<p>　</td></tr></table>
                    </td>
                    </tr>
                  </table>
              
              </td>
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

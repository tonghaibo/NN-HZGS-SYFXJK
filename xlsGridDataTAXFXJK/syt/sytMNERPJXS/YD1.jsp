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
  <link rel="File-List" href="YD1.files/filelist.xml">

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
					<p align="center"><font color="#014E82">食品一店销售统计</font></td><td width="32">
					<p align="right">
					<img border="0" src="../xlsgrid/images/my/bartop.jpg" width="30" height="14"></td></tr></table>

					<table border="0" width="100%" id="table4" cellspacing="1">
						<tr>
							<td align="left" valign="top">
                  <table border=0 width=100% cellspacing=0 id=table5 height=100%>
                    <tr>
                      <td height=23 style="border: 1px solid #3A77BA bgcolor=#FFFFFF">
                      <table width=100%><tr><td width=168>&nbsp;<img border=0 src=../xlsgrid/images/my/collapse.gif width=9 height=9> 
						<FONT 
            class=Title>最新统计</FONT></td>
                        <td >
                        <img border=0 src=../xlsgrid/images/my/barright.jpg width=22 height=15 align=right></td></tr></table>
                      </td>
                    </tr>
                    <tr>
                      <td style="border-left: 1px solid #3A77BA; border-right: 1px solid #3A77BA; border-bottom: 1px solid #3A77BA;  bgcolor=#FFFFFF  valign=top">
                        <table width=100% cellspacing=6><tr><td>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" align=left border=0 id="table24">
        <TBODY>
        <TR vAlign=bottom>
          <TD width=40>　</TD>
          <TD vAlign=bottom align=left><FONT 
            class=AllText>食品一店<B>2006年9月24日</B>新增销售额：</FONT><FONT 
            class=Amount>￥1,000,000.00</FONT> <FONT 
            class=AllText>，当月累计销售额：</FONT><A 
            href="#"><FONT 
            class=Amount>￥<U>50,000,000.00</U></FONT> </A></TD></TR>
        <TR vAlign=bottom height=30>
          <TD width=40>　</TD>
          <TD vAlign=bottom align=left><FONT 
            class=Text><B>2006年9月24日</B>新增零售销售额：</FONT><FONT 
            class=Amount>￥500,000.00</FONT> <FONT 
            class=Text>，当月累计零售销售额：</FONT><A 
            href="#"><FONT 
            class=Amount>￥<U>20,000,000.00</U></FONT> </A></TD></TR>
        <TR vAlign=bottom height=20>
          <TD width=40>　</TD>
          <TD align=left><FONT 
            class=Text><B>2006年9月24日</B>新增批发销售额：</FONT><FONT 
            class=Amount>￥0.00</FONT> <FONT class=Text>，当月累计批发销售额：</FONT><FONT 
            class=Amount><A 
            href="#">￥<U>30,000,000.00</U></A></FONT> </TD></TR>
        <TR height=40>
          <TD colSpan=2>　</TD></TR>
        <TR vAlign=top height=275>
          <TD width=40>　</TD>
          <TD align=left><FONT class=Text><B>食品一店2006年销售额统计图：</B><!--[if !mso]> 
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
<![endif]--><!--[if gte vml 1]><v:rect id="_x0000_s1025"
 alt="" style='position:absolute;left:202.5pt;top:228.75pt;width:412.5pt;
 height:135pt;z-index:-1' fillcolor="#9cf" stroked="f">
 <v:fill rotate="t" angle="-45" focus="100%" type="gradient"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:-1;left:270px;top:305px;width:550px;height:180px'><img
width=550 height=180 src="YD1.files/image001.gif" v:shapes="_x0000_s1025"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1026" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="202.5pt,363.75pt" to="615pt,363.75pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:269px;top:484px;
width:552px;height:2px'><img width=552 height=2 src="YD1.files/image002.gif"
v:shapes="_x0000_s1026"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1027"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="202.5pt,228.75pt" to="202.5pt,363.75pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:269px;top:304px;
width:2px;height:182px'><img width=2 height=182 src="YD1.files/image003.gif"
v:shapes="_x0000_s1027"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1028"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="210pt,228.75pt" to="210pt,356.25pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:279px;top:304px;
width:2px;height:172px'><img width=2 height=172 src="YD1.files/image004.gif"
v:shapes="_x0000_s1028"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1029"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="202.5pt,356.25pt" to="210pt,363.75pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:269px;top:474px;
width:12px;height:12px'><img width=12 height=12 src="YD1.files/image005.gif"
v:shapes="_x0000_s1029"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1030"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="210pt,356.25pt" to="615pt,356.25pt" strokecolor="#69f"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:279px;top:474px;
width:542px;height:2px'><img width=542 height=2 src="YD1.files/image006.gif"
v:shapes="_x0000_s1030"></span><![endif]><!--[if gte vml 1]><v:line id="_x0000_s1031"
 alt="" style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1'
 from="191.25pt,228.75pt" to="202.5pt,228.75pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:254px;top:304px;
width:17px;height:2px'><img width=17 height=2 src="YD1.files/image007.gif"
v:shapes="_x0000_s1031"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1032"
 alt="" style='position:absolute;left:150pt;top:228.75pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table25">
	<tbody>
		<tr>
			<td align="right">20000万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:200px;top:305px;width:74px;height:22px'><img width=74
height=22 src="YD1.files/image008.gif" v:shapes="_x0000_s1032"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1033" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="202.5pt,329.25pt" to="210pt,336.75pt"
 strokecolor="#69f"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:-1;left:269px;top:438px;width:12px;height:12px'><img
width=12 height=12 src="YD1.files/image005.gif" v:shapes="_x0000_s1033"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1034" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="210pt,329.25pt" to="615pt,329.25pt"
 strokecolor="#69f"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:-1;left:279px;top:438px;width:542px;height:2px'><img
width=542 height=2 src="YD1.files/image006.gif" v:shapes="_x0000_s1034"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1035" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="191.25pt,255.75pt" to="202.5pt,255.75pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:254px;top:340px;
width:17px;height:2px'><img width=17 height=2 src="YD1.files/image007.gif"
v:shapes="_x0000_s1035"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1036"
 alt="" style='position:absolute;left:150pt;top:255.75pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table26">
	<tbody>
		<tr>
			<td align="right">16000万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:200px;top:341px;width:74px;height:22px'><img width=74
height=22 src="YD1.files/image009.gif" v:shapes="_x0000_s1036"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1037" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="202.5pt,302.25pt" to="210pt,309.75pt"
 strokecolor="#69f"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:-1;left:269px;top:402px;width:12px;height:12px'><img
width=12 height=12 src="YD1.files/image005.gif" v:shapes="_x0000_s1037"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1038" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="210pt,302.25pt" to="615pt,302.25pt"
 strokecolor="#69f"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:-1;left:279px;top:402px;width:542px;height:2px'><img
width=542 height=2 src="YD1.files/image006.gif" v:shapes="_x0000_s1038"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1039" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="191.25pt,282.75pt" to="202.5pt,282.75pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:254px;top:376px;
width:17px;height:2px'><img width=17 height=2 src="YD1.files/image007.gif"
v:shapes="_x0000_s1039"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1040"
 alt="" style='position:absolute;left:150pt;top:282.75pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table27">
	<tbody>
		<tr>
			<td align="right">12000万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:200px;top:377px;width:74px;height:22px'><img width=74
height=22 src="YD1.files/image010.gif" v:shapes="_x0000_s1040"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1041" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="202.5pt,275.25pt" to="210pt,282.75pt"
 strokecolor="#69f"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:-1;left:269px;top:366px;width:12px;height:12px'><img
width=12 height=12 src="YD1.files/image005.gif" v:shapes="_x0000_s1041"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1042" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="210pt,275.25pt" to="615pt,275.25pt"
 strokecolor="#69f"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:-1;left:279px;top:366px;width:542px;height:2px'><img
width=542 height=2 src="YD1.files/image006.gif" v:shapes="_x0000_s1042"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1043" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="191.25pt,309.75pt" to="202.5pt,309.75pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:254px;top:412px;
width:17px;height:2px'><img width=17 height=2 src="YD1.files/image007.gif"
v:shapes="_x0000_s1043"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1044"
 alt="" style='position:absolute;left:150pt;top:309.75pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table28">
	<tbody>
		<tr>
			<td align="right">8000万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:200px;top:413px;width:74px;height:22px'><img width=74
height=22 src="YD1.files/image011.gif" v:shapes="_x0000_s1044"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1045" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="202.5pt,248.25pt" to="210pt,255.75pt"
 strokecolor="#69f"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:-1;left:269px;top:330px;width:12px;height:12px'><img
width=12 height=12 src="YD1.files/image005.gif" v:shapes="_x0000_s1045"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1046" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="210pt,248.25pt" to="615pt,248.25pt"
 strokecolor="#69f"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:-1;left:279px;top:330px;width:542px;height:2px'><img
width=542 height=2 src="YD1.files/image006.gif" v:shapes="_x0000_s1046"></span><![endif]><!--[if gte vml 1]><v:line
 id="_x0000_s1047" alt="" style='position:absolute;left:0;text-align:left;
 top:0;flip:y;z-index:-1' from="191.25pt,336.75pt" to="202.5pt,336.75pt"/><![endif]--><![if !vml]><span
style='mso-ignore:vglayout;position:absolute;z-index:-1;left:254px;top:448px;
width:17px;height:2px'><img width=17 height=2 src="YD1.files/image007.gif"
v:shapes="_x0000_s1047"></span><![endif]><!--[if gte vml 1]><v:shape id="_x0000_s1048"
 alt="" style='position:absolute;left:150pt;top:336.75pt;width:52.5pt;height:13.5pt;
 z-index:1' coordsize="" o:spt="100" adj="0,,0" path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table29">
	<tbody>
		<tr>
			<td align="right">4000万元</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:200px;top:449px;width:74px;height:22px'><img width=74
height=22 src="YD1.files/image012.gif" v:shapes="_x0000_s1048"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1049" title="￥10,000,000.00" style='position:absolute;left:207.75pt;
 top:261pt;width:22.5pt;height:102pt;z-index:1' fillcolor="lime">
 <v:fill color2="#d1ffd1" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="lime" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:276px;top:338px;width:41px;height:147px'><img width=41
height=147 src="YD1.files/image013.gif" v:shapes="_x0000_s1049"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1050" alt="" style='position:absolute;left:202.5pt;top:364.5pt;
 width:33.75pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table30">
	<tbody>
		<tr>
			<td align="middle">1月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:270px;top:486px;width:49px;height:22px'><img width=49
height=22 src="YD1.files/image014.gif" v:shapes="_x0000_s1050"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1051" title="￥10,000,000.00" style='position:absolute;left:242.25pt;
 top:330.75pt;width:22.5pt;height:32.25pt;z-index:1' fillcolor="red">
 <v:fill color2="#fbb" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="red" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:322px;top:431px;width:41px;height:54px'><img width=41
height=54 src="YD1.files/image015.gif" v:shapes="_x0000_s1051"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1052" alt="" style='position:absolute;left:236.25pt;top:364.5pt;
 width:33.75pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table31">
	<tbody>
		<tr>
			<td align="middle">2月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:315px;top:486px;width:49px;height:22px'><img width=49
height=22 src="YD1.files/image016.gif" v:shapes="_x0000_s1052"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1053" title="￥10,000,000.00" style='position:absolute;left:276.75pt;
 top:325.5pt;width:22.5pt;height:37.5pt;z-index:1' fillcolor="#f90">
 <v:fill color2="#ffe3bb" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#f90" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:368px;top:424px;width:41px;height:61px'><img width=41
height=61 src="YD1.files/image017.gif" v:shapes="_x0000_s1053"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1054" alt="" style='position:absolute;left:270.75pt;top:364.5pt;
 width:33.75pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table32">
	<tbody>
		<tr>
			<td align="middle">3月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:361px;top:486px;width:49px;height:22px'><img width=49
height=22 src="YD1.files/image018.gif" v:shapes="_x0000_s1054"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1055" title="￥10,000,000.00" style='position:absolute;left:311.25pt;
 top:323.25pt;width:22.5pt;height:39.75pt;z-index:1' fillcolor="#3cc">
 <v:fill color2="#cff4f3" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#3cc" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:414px;top:421px;width:41px;height:64px'><img width=41
height=64 src="YD1.files/image019.gif" v:shapes="_x0000_s1055"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1056" alt="" style='position:absolute;left:305.25pt;top:364.5pt;
 width:33.75pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table33">
	<tbody>
		<tr>
			<td align="middle">4月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:407px;top:486px;width:49px;height:22px'><img width=49
height=22 src="YD1.files/image020.gif" v:shapes="_x0000_s1056"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1057" title="￥10,000,000.00" style='position:absolute;left:345.75pt;
 top:327.75pt;width:22.5pt;height:35.25pt;z-index:1' fillcolor="#669">
 <v:fill color2="#d9d9e5" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#669" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:460px;top:427px;width:41px;height:58px'><img width=41
height=58 src="YD1.files/image021.gif" v:shapes="_x0000_s1057"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1058" alt="" style='position:absolute;left:339.75pt;top:364.5pt;
 width:33.75pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table34">
	<tbody>
		<tr>
			<td align="middle">5月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:453px;top:486px;width:49px;height:22px'><img width=49
height=22 src="YD1.files/image022.gif" v:shapes="_x0000_s1058"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1059" title="￥10,000,000.00" style='position:absolute;left:380.25pt;
 top:335.25pt;width:22.5pt;height:27.75pt;z-index:1' fillcolor="#930">
 <v:fill color2="#ffc7ab" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#930" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:506px;top:437px;width:41px;height:48px'><img width=41
height=48 src="YD1.files/image023.gif" v:shapes="_x0000_s1059"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1060" alt="" style='position:absolute;left:374.25pt;top:364.5pt;
 width:33.75pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table35">
	<tbody>
		<tr>
			<td align="middle">6月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:499px;top:486px;width:49px;height:22px'><img width=49
height=22 src="YD1.files/image024.gif" v:shapes="_x0000_s1060"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1061" title="￥10,000,000.00" style='position:absolute;left:414pt;
 top:333pt;width:22.5pt;height:30pt;z-index:1' fillcolor="#9c0">
 <v:fill color2="#ecffb7" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#9c0" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:551px;top:434px;width:41px;height:51px'><img width=41
height=51 src="YD1.files/image025.gif" v:shapes="_x0000_s1061"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1062" alt="" style='position:absolute;left:408.75pt;top:364.5pt;
 width:33.75pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table36">
	<tbody>
		<tr>
			<td align="middle">7月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:545px;top:486px;width:49px;height:22px'><img width=49
height=22 src="YD1.files/image026.gif" v:shapes="_x0000_s1062"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1063" title="￥10,000,000.00" style='position:absolute;left:448.5pt;
 top:321.75pt;width:22.5pt;height:41.25pt;z-index:1' fillcolor="blue">
 <v:fill color2="#8ea5fb" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="blue" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:597px;top:419px;width:41px;height:66px'><img width=41
height=66 src="YD1.files/image027.gif" v:shapes="_x0000_s1063"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1064" alt="" style='position:absolute;left:442.5pt;top:364.5pt;
 width:33.75pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table37">
	<tbody>
		<tr>
			<td align="middle">8月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:590px;top:486px;width:49px;height:22px'><img width=49
height=22 src="YD1.files/image028.gif" v:shapes="_x0000_s1064"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1065" title="￥10,000,000.00" style='position:absolute;left:483pt;
 top:324pt;width:22.5pt;height:39pt;z-index:1' fillcolor="#7ef443">
 <v:fill color2="#d1ffd1" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#7ef443" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:643px;top:422px;width:41px;height:63px'><img width=41
height=63 src="YD1.files/image029.gif" v:shapes="_x0000_s1065"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1066" alt="" style='position:absolute;left:477pt;top:364.5pt;
 width:33.75pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table38">
	<tbody>
		<tr>
			<td align="middle">9月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:636px;top:486px;width:49px;height:22px'><img width=49
height=22 src="YD1.files/image030.gif" v:shapes="_x0000_s1066"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1067" title="￥0.00" style='position:absolute;left:517.5pt;top:363.75pt;
 width:22.5pt;height:0;z-index:1' fillcolor="#ed74ec">
 <v:fill color2="#f5bcff" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#ed74ec" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:689px;top:475px;width:41px;height:11px'><img width=41
height=11 src="YD1.files/image031.gif" v:shapes="_x0000_s1067"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1068" alt="" style='position:absolute;left:511.5pt;top:364.5pt;
 width:33.75pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table39">
	<tbody>
		<tr>
			<td align="middle">10月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:682px;top:486px;width:49px;height:22px'><img width=49
height=22 src="YD1.files/image032.gif" v:shapes="_x0000_s1068"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1069" title="￥0.00" style='position:absolute;left:552pt;top:363.75pt;
 width:22.5pt;height:0;z-index:1' fillcolor="#1e6730">
 <v:fill color2="#72e18e" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#1e6730" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:735px;top:475px;width:41px;height:11px'><img width=41
height=11 src="YD1.files/image033.gif" v:shapes="_x0000_s1069"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1070" alt="" style='position:absolute;left:546pt;top:364.5pt;
 width:33.75pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table40">
	<tbody>
		<tr>
			<td align="middle">11月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:728px;top:486px;width:49px;height:22px'><img width=49
height=22 src="YD1.files/image034.gif" v:shapes="_x0000_s1070"></span><![endif]><!--[if gte vml 1]><v:rect
 id="_x0000_s1071" title="￥0.00" style='position:absolute;left:586.5pt;top:363.75pt;
 width:22.5pt;height:0;z-index:1' fillcolor="#e6cd25">
 <v:fill color2="#f4eaa6" rotate="t" type="gradient"/>
 <o:extrusion v:ext="view" backdepth="20pt" color="#e6cd25" on="t"/>
</v:rect><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:781px;top:475px;width:41px;height:11px'><img width=41
height=11 src="YD1.files/image035.gif" v:shapes="_x0000_s1071"></span><![endif]><!--[if gte vml 1]><v:shape
 id="_x0000_s1072" alt="" style='position:absolute;left:580.5pt;top:364.5pt;
 width:33.75pt;height:13.5pt;z-index:1' coordsize="" o:spt="100" adj="0,,0"
 path="">
 <v:stroke joinstyle="round"/>
 <v:formulas/>
 <v:path o:connecttype="segments"/>
 <v:textbox inset="0,0,0,0">
<table height="100%" cellSpacing="3" cellPadding="0" width="100%" id="table41">
	<tbody>
		<tr>
			<td align="middle">12月</td>
		</tr>
	</tbody>
</table>
 </v:textbox>
</v:shape><![endif]--><![if !vml]><span style='mso-ignore:vglayout;position:
absolute;z-index:1;left:774px;top:486px;width:49px;height:22px'><img width=49
height=22 src="YD1.files/image036.gif" v:shapes="_x0000_s1072"></span><![endif]></FONT></TD></TR>
        <TR>
          <TD colSpan=2>
            <TABLE style="LINE-HEIGHT: 1.8" cellSpacing=0 cellPadding=0 
            width="100%" align=left border=0 id="table42">
              <TBODY>
              <TR>
                <TD align=left width="50%">&nbsp;&nbsp;&nbsp;&nbsp; <FONT 
                  class=Text>2006年01月&nbsp;总销售额</FONT><FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT><FONT 
                  class=Text>，其中零售销售额：<FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT>，批发销售额：<FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT> 
              </FONT></TD></TR>
              <TR>
                <TD align=left width="50%">&nbsp;&nbsp;&nbsp;&nbsp; <FONT 
                  class=Text>2006年02月&nbsp;总销售额</FONT><FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT><FONT 
                  class=Text>，其中零售销售额：<FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT>，批发销售额：<FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT> 
              </FONT></TD></TR>
              <TR>
                <TD align=left width="50%">&nbsp;&nbsp;&nbsp;&nbsp; <FONT 
                  class=Text>2006年03月&nbsp;总销售额</FONT><FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT><FONT 
                  class=Text>，其中零售销售额：<FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT>，批发销售额：<FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT> 
              </FONT></TD></TR>
              <TR>
                <TD align=left width="50%">&nbsp;&nbsp;&nbsp;&nbsp; <FONT 
                  class=Text>2006年04月&nbsp;总销售额</FONT><FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT><FONT 
                  class=Text>，其中零售销售额：<FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT>，批发销售额：<FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT> 
              </FONT></TD></TR>
              <TR>
                <TD align=left width="50%">&nbsp;&nbsp;&nbsp;&nbsp; <FONT 
                  class=Text>2006年05月&nbsp;总销售额</FONT><FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT><FONT 
                  class=Text>，其中零售销售额：<FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT>，批发销售额：<FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT> 
              </FONT></TD></TR>
              <TR>
                <TD align=left width="50%">&nbsp;&nbsp;&nbsp;&nbsp; <FONT 
                  class=Text>2006年06月&nbsp;总销售额</FONT><FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT><FONT 
                  class=Text>，其中零售销售额：<FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT>，批发销售额：<FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT> 
              </FONT></TD></TR>
              <TR>
                <TD align=left width="50%">&nbsp;&nbsp;&nbsp;&nbsp; <FONT 
                  class=Text>2006年07月&nbsp;总销售额</FONT><FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT><FONT 
                  class=Text>，其中零售销售额：<FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT>，批发销售额：<FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT> 
              </FONT></TD></TR>
              <TR>
                <TD align=left width="50%">&nbsp;&nbsp;&nbsp;&nbsp; <FONT 
                  class=Text>2006年08月&nbsp;总销售额</FONT><FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT><FONT 
                  class=Text>，其中零售销售额：<FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT>，批发销售额：<FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT> 
              </FONT></TD></TR>
              <TR>
                <TD align=left width="50%">&nbsp;&nbsp;&nbsp;&nbsp; <FONT 
                  class=Text>2006年09月&nbsp;总销售额</FONT><FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT><FONT 
                  class=Text>，其中零售销售额：<FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT>，批发销售额：<FONT 
                  class=Amount><A 
                  href="#">￥<U>10,000,000.00</U></A></FONT> 
              </FONT></TD></TR></TBODY></TABLE></TD></TR></TBODY></TABLE><p>　</p>
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

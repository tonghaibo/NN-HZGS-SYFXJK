<%@ page contentType="text/html;charset=gb2312" %>
<%@ page import="java.io.*,com.xlsgrid.net.pub.*,com.xlsgrid.net.web.*,com.xlsgrid.net.tag.*,com.xlsgrid.net.xmldb.*" %>
<%
  String sTitle=EAFunc.NVL(request.getParameter("title"),"分析面向主题!分析主题是由数据管理员预定义好的分析模型,由决策者直接使用") ;
  String sTyp = EAFunc.NVL( request.getParameter("typ"),"DF" );
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
<title>分析主题</title>
<LINK rel=stylesheet type=text/css HREF="../xlsgrid/css/main.css">
</head>

<script language="javascript">
// 初始化
function winonload(){

}



</script>

<body topmargin="0" leftmargin="0" onload="javascript:winonload();" bgcolor="#014E82">
<table width="100%" height="100%" bgcolor="#2547BC"><tr><td>
<table align="center" border="0" width="100%" id="table1" cellpadding="0" cellspacing="0">
	
	<tr>
		<td align="left" valign="top" colspan="2" bgcolor="#FFFFFF" height="100%" >
		
		<table border="0" width="100%" id="table3" height="269" cellspacing="5" cellpadding="0">
			<tr>
				
				<td height="142" bgcolor="#D1E2FE" valign="top" width="100%" colspan="2">
					<table width="100%" ><tr><td width="31" valign="top">
					<img border="0" src="../xlsgrid/images/my/bartop.jpg" width="30" height="14"></td>
					<td width="100%">
					<p align="center"><font color="#014E82">请您选择分析主题</font></td><td width="32">
					<p align="right">
					<img border="0" src="../xlsgrid/images/my/bartop.jpg" width="30" height="14"></td></tr></table>

					<table border="0" width="100%" id="table4" cellspacing="1">
						
						<tr>
							<td align="left" valign="top">
              
                <table border="0" width="100%" cellspacing="0" id="table5" height="480">
                  <tr>
                    <td height="23" style="border: 1px solid #3A77BA" bgcolor="#FFFFFF">
                    <table width="100%"><tr><td width="600">&nbsp;<img border="0" src="../xlsgrid/images/my/collapse.gif" width="9" height="9">&nbsp;<%=sTitle%></td>
                      <td >
                      <img border="0" src="../xlsgrid/images/my/barright.jpg" width="22" height="15" align="right"></td></tr></table>
                    </td>
                  </tr>
                  <tr>
                    <td style="border-left: 1px solid #3A77BA; border-right: 1px solid #3A77BA; border-bottom: 1px solid #3A77BA; " bgcolor="#FFFFFF" "+bkimage+" valign="top">
                      <table width="100%" cellspacing="6"><tr><td><font color="#014E82">
                      
                  <table  width="100%" id="table6" cellspacing="8" cellpadding="8">
 <%
try{
	  EAXmlDS ds = EADbTool.QuerySQL("SELECT * FROM DIMTOP WHERE TYP='"+sTyp+"' order by sortid");
  // 根据XmlDSListView的要求处理ds
  for ( int i =0 ; i< ds.getRowCount(); i++ ) {
   
      String sImgPath = ""+ds.getValueDef(i,"ICON","") ;
      if ( sImgPath.length() == 0 )
          sImgPath = "../xlsgrid/images/icon/icon"+(i%12+1)+".gif" ;
      String sName = ds.getStringAt(i,"ID");
      String sNote = ds.getStringAt(i,"NAME");
      String sUrl = ds.getStringAt(i,"URL");
      sUrl = EAFunc.Replace(sUrl,"[AND]","&" );	// 替代特殊字符&
      
     if (i%2==0 ) out.println( "<tr>" );
     out.println("<td width=\"50%\" ");
     out.println("  onmouseover=\"this.style.border='2px solid #3a77ba';this.style.cursor='hand';\" onmouseout=\"this.style.border='';\" onclick=\"window.open('../" + sUrl + "&title="+sName+"','','height=600,width=800,toolbar=no,location=no,status=no,resizable=yes,top=0,left=0');\" ") ;    
     out.println( ">");
     out.println("<table border=\"0\" width=\"100%\" id=\"table7\">");
     out.println("  <tr>                                           ");
     out.println("    <td width=\"7%\" rowspan=\"2\" valign=\"top\">");
     out.println("    <img border=\"0\" src=\"images/icon/icon"+(i%12+1)+".JPG\" width=\"50\" height=\"50\"></td>");
     out.println("    <td width=\"88%\" style=\"border-left-width: 1px; border-right-width: 1px; border-top-width: 1px; border-bottom: 1px solid #808080\">"+sName+"</td>");
     out.println("  </tr>");
     out.println("  <tr>");
     out.println("    <td width=\"88%\"><p style=\"text-indent: 16px\">");
     out.println("    <font color=\"#808080\">"+sNote+"</font></td>");
     out.println("  </tr>");
     out.println("</table>      ");
     out.println("</td>");
     if (i%2==1&&i!=0) out.println( "</tr>" );
      
  }
  out.println( "</tr>" );
}
catch ( EAException e ) {
    request.getSession().setAttribute("XLSGRID_EXCEPTION",new EAException(EAException.errGeneral,"定义的中间件资料不正确：<BR>"+e.toString()));
    response.sendRedirect("xlsweb?action=ShowError");
}
%>                     

                  </table>
                      

              
              
                      </font> </td></tr></table>
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
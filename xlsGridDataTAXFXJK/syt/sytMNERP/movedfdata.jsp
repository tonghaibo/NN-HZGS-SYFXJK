<%@ page contentType="text/html;charset=gb2312" %>
<%@ page import="java.io.*,com.xlsgrid.net.pub.*,com.xlsgrid.net.web.*,com.xlsgrid.net.tag.*,com.xlsgrid.net.xmldb.*" %>
<%
  //移动东方的主数据到数据中心
  // 从filename找出所有的清单
  String dat=EAFunc.NVL(request.getParameter("dat"),"") ;
  if ( dat.length()==0 ) 
    throw new Exception("必须输入dat参数");

EADatabase dbfrom =null;
EADatabase dbto = null;
String sOut= "";
try{
            dbfrom =  new EADatabase("DFXD");
            dbto = new EADatabase("DCDATA");
            dbto.GetConn().setAutoCommit(true);
            int nCount = dbto.ExcecutSQL("DELETE FROM A_SalesSum where gid='DF' and CONVERT(char(10), dat, 121) like '"+dat+"%'");
            String  ret= "删除A_SalesSum共"+nCount +"条记录.\n" ;
            String sqlfrom = "select gid,dat,itemclass,corpclass,orgclass,saleclass,sum(mny) mny,sum(taxmny) taxmny "+
                  " from (select 'DF' gid,to_char(a.dat,'YYYY-MM-DD') dat,b.refid itemclass,substr(NVL(c.refid,'0199'),3,2) corpclass,a.org orgclass,'01' saleclass,sum(mny) mny,sum(taxmny) taxmny "+
                  " from bildtl a,item b,corp c where a.itmid=b.id and a.corpid=c.id and a.stat='2' and a.biltyp='SI' and to_char(a.dat,'YYYY-MM-DD') like '"+dat+"%' and a.itmid not like 'z%' and a.itmid not like 'Z%' "+
                  " group by to_char(a.dat,'YYYY-MM-DD'),b.refid,substr(NVL(c.refid,'0199'),3,2),a.org  "+
                  " union all " + 
                  "select 'DF' gid,to_char(b.dat,'YYYY-MM-DD') dat,substr(a.itemid,1,6) itemclass,NVL(c.refid,'99') corpclass,decode(a.orgid,'3','02','4','15','01') orgclass,'01' saleclass,sum(a.mny) mny,sum(a.mnytax) taxmny "+
                  " from dfxd.bildtl a,dfxd.bilhdr b,dfxd.corp c where a.orgid=b.orgid and a.id=b.id and a.biltyp=b.biltyp and b.refid=c.id and a.stat='1' and a.biltyp='SI' and to_char(b.dat,'YYYY-MM-DD') like '"+dat+"%' and a.itemid not like 'z%' and a.itemid not like 'Z%' "+
                  " group by to_char(b.dat,'YYYY-MM-DD'),substr(a.itemid,1,6),NVL(c.refid,'99'),decode(a.orgid,'3','02','4','15','01') ) "+
                  " group by gid,dat,itemclass,corpclass,orgclass,saleclass " ;
            String sqlto = "INSERT INTO A_SalesSum(gid,dat,ITEMCLASS,CUSTCLASS,ORGCLASS,SALECLASS,SALEMONEY,SALETAX) values(?,?,?,?,?,?,?,?)" ;
            String coltyp = ",date,";
            nCount = EADbCopy.InsertData( dbto,dbfrom,sqlto,sqlfrom,coltyp );
            ret+= "导入A_SalesSum共"+nCount +"条记录.\n" ;
            dbfrom.Commit();
            dbto.Commit();
            sOut = ret;
}
catch ( EAException e ) {
    out.println(e.toString());
    //request.getSession().setAttribute("XLSGRID_EXCEPTION",new EAException(EAException.errGeneral,"定义的中间件资料不正确：<BR>"+e.toString()));
    //response.sendRedirect("xlsweb?action=ShowError");
}
finally{
  dbfrom.Close();
  dbto.Close();
}
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
<title>移动DATE</title>
<LINK rel=stylesheet type=text/css HREF="../xlsgrid/css/main.css">
</head>
<script src="../xlsgrid/js/listobj.js" type="text/jscript" language="jscript"></script>
<script language="JavaScript">

<!--

  function f_showlist () {


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
					<p align="center"><font color="#014E82">运行提示</font></td><td width="32">
					<p align="right">
					<img border="0" src="../xlsgrid/images/my/bartop.jpg" width="30" height="14"></td></tr></table>

					<table border="0" width="100%" id="table4" cellspacing="1">
						
						<tr>
							<td align="left" valign="top"><%=sOut%></td>
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
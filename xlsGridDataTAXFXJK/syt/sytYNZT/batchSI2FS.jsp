<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="java.io.*,com.xlsgrid.net.pub.*,com.xlsgrid.net.web.*,com.xlsgrid.net.tag.*,com.xlsgrid.net.xmldb.*" %>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>发票批量转成结算单</title>
<script language="javascript" src="../../js/selbill.js" ></script>
<script language="javascript" src="../../js/main.js" ></script>
    <LINK rel=stylesheet type=text/css HREF="../xlsgrid/css/main.css">
<SCRIPT LANGUAGE=javascript>
<!--
function sel_DAT(obj) {
  var ret   = window.showModalDialog( "../xlsgrid/jsp/pages/calendardlg.htm","" , "dialogwidth:150pt;dialogheight:150pt" ); 			
  if ( ret != null &&  ret != "" && ret != undefined) {
          //alert(obj);
    obj.value = ret ; 
  }
}
function sel_keyvalue(key,obj1,obj2) {
  var ret   = window.showModalDialog( "../xlsgrid/jsp/pages/selectBox.jsp?flag="+key, obj2 , "dialogwidth:650pt;dialogheight:420pt" ); 
  if ( !!ret ) {
    obj1.value = ret[0] ; 
  }
}

function batchconv()
{
  //alert('');
  if(!kemuid.value)
  {
    alert("请先选择一个财务科目。");
    return;
  }
  if(!mny.value)
  {
    alert("请输入结算总金额。");
    return;
  }
  if(!memo.value)
  {
    alert("请输入一个备注信息。");
    return;
  }
  //检查总金额
  var zje = 1.0 * mny.value;
  var zje_c = 1.0 * datflwframe._this.GetCellText(0,1,6);
  if(zje != zje_c)
  {
    alert("“结算总金额”与“勾单总金额”不相等，请检查。");
    return;
  }
  //调用SelBilFlw的batchconv进行转换
  if(datflwframe.batchconv(kemuid.value,kemuname.value,kemujsh.value,memo.value,bildat.value))
  {
    location = "../BillEntry.sp?grdid=FS&datflw=SI2FS";
  }
}

function query()
{
  datflwframe.filter();
}

function windowonload()
{
  datflwframe.location = "../ShowXlsGrid.sp?grdid=SelBilFlw&sytid=x&datflw=SI2FS&callfunc=manquery&forceMappedmode=0";
}
//-->
</SCRIPT>
  </head>
  <body onload="windowonload()">
  <br>
<center>
<table border="0" width="98%" height="95%" cellspacing="0" cellpadding="0">
<tr>
<td align="left" width="100%" valign="top" height="12" >
<strong>
<font size=3 color="#4791C5">发票批量转成结算单</center></font><hr>
</td>
</tr>
<tr>
<td height="32" >
    <table border="0" width="100%" id="table4" cellspacing="0" >
      <tr>
        <td>
<!--            客户：<input type=text id='CORPID' value="" />
						<img  src='../xlsgrid/images/forderopen.gif' onclick='javascript:sel_keyvalue( "V_CUST",document.all("CORPID"),document.all("CORPIDnam") );' onmouseover=" this.style.cursor='hand'; title='点击选择'">
						<input type=text id='CORPIDnam' value="" readonly=true />	
-->
            　科目：<input type=text id='kemuid' value="" size="10" />
						<img src='../xlsgrid/images/forderopen.gif' onclick='javascript:sel_keyvalue( "V_ACCITM",kemuid,kemuname );' onmouseover=" this.style.cursor='hand'; title='点击选择'">
						<input type=text id='kemuname' value="" readonly=true size="19" /> 借方总金额：<input type=text id='mny' value="" size="15"  /> 结算号：<input type=text id='kemujsh' value="" name="kemujsh" size="21" />如银行单据号码<br>
　日期：<input style="width:100; border: 1px solid #014E82; " type=text id=bildat size=20 value="<%=EAFunc.DateToStr(new java.util.Date())%>" />
						<img src='../xlsgrid/images/forderopen.gif' onclick='javascript:sel_DAT( bildat );' onmouseover=" this.style.cursor='hand'; title='点击选择日期'">
&nbsp;备注：<input type=text id='memo' value="" size="50" />　<input type=button onclick="query();" value="条件查询" />
            　<input type=button onclick="batchconv();" value="批量转换" />
        </td>
      </tr>
    </table>
</td>
</tr>
<tr>
<td>
<iframe id=datflwframe frameborder=0 width="100%" height="100%"></iframe>
</td>
</tr>
</table>
  </body>
</html>

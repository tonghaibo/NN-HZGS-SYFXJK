<%@ page contentType="text/html;charset=gb2312" %>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.tag.*" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<link rel="stylesheet" type="text/css" href="../xlsgrid/css/main-right.css">
<title>�ɹ��ֿ����</title>
<script>
window.returnValue="";
function returnck()
{
  var idx = ck.selectedIndex;
  window.returnValue=ck.options[idx].value;
  window.close();
}
</script>
</head>

<body background='xlsgrid/images/bk.gif'>

<table width="100%" height="100%"  border="0" align="center" bordercolor="#000000" style="border-collapse:collapse ">
  <tr class="EAGRID-TR">
    <td align="center" class="EAGRID-TD">�ɹ��ֿ����</td>
  </tr> 
  <tr class="EAGRID-TR">
    <td class="EAGRID-TD">˵�����˲�������һ��һ�������Ųɹ�����</td>
  </tr>
  <tr class="EAGRID-TR">
    <td class="EAGRID-TD">�²ֿ�ţ�
    <%
    SelectID s = new SelectID(request,"ck","V_LOC","","","","","");
    out.print(s.GetHtml());
    //<input type=text name=DATE1 size=20 value="" />
    %>
    </td>
  </tr>
  <tr class="EAGRID-TR">
    <td class="EAGRID-TD" align="center">
    <input title='ȷ��' type="button" name="searchbut" value="ȷ��" onclick="returnck();" style="cursor:hand; border: 1px solid #808080; font-family:����; font-size:9pt; background-color:#99CCFF; vertical-align:baseline; height:20" ></td>
  </tr>
</table>

</body>
</html>

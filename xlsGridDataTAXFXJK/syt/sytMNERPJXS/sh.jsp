<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.web.*,com.xlsgrid.net.tag.*,com.xlsgrid.net.xmldb.*" %>

<%  
  EAUserinfo usrinfo = null;
  String usrnam = "";
  String logtime = "";
  try {
    usrinfo = com.xlsgrid.net.web.EASession.GetLoginInfo(request)  ;
    if (usrinfo!=null ) {
      usrnam = usrinfo.getUsrnam();
      logtime = usrinfo.getLogdat();
    }
  }
  catch ( EAException e ){
    out.println( e.toString() );
  }
  String sWhere = "";
  if ( usrinfo.getLocid().length() > 0 ) sWhere ="&where=and locid="+usrinfo.getLocid();
%>

<html>
<head>
  <LINK rel=stylesheet type=text/css HREF="../xlsgrid/css/main.css">
  <meta http-equiv="Content-Language" content="zh-cn">
  <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
  
  <title>欢迎使用xlsGrid</title>
</head>

<body topmargin="0">

<table width="100%" height="100%" cellspacing="0">
  <tr>
    <td align="left">
      <p align="center">
        <map name="FPMap0">
          <area href="../BillEntry.sp?grdid=ReleaseSD" shape="rect" coords="311,200,369,224">
          <area href="../BillEntry.sp?grdid=LineSelNo1" shape="rect" coords="72,208,127,239">
          <area href="../BillEntry.sp?grdid=LineSelNo2" shape="rect" coords="73,175,128,208">
		<area href="../BillEntry.sp?grdid=SD<%=sWhere%>" shape="rect" coords="386,192,450,233">
		<area href="../BillEntry.sp?grdid=SHPADJ" shape="rect" coords="237, 150, 320, 192">
		<area href="../BillEntry.sp?grdid=SavWhship" shape="rect" coords="318,245,391,287">
		<area href="../BillEntry.sp?grdid=Bakship" shape="rect" coords="317,294,391,334">
		<area href="../BillEntry.sp?grdid=SXShip" shape="rect" coords="214, 270, 297, 312">
		<area href="../BillEntry.sp?grdid=SX" shape="rect" coords="5,197,64,240">
		<area href="../BillEntry.sp?grdid=GENERRY" shape="rect" coords="150, 148, 222, 191">
		<area href="../BillEntry.sp?grdid=GENERRY2" shape="rect" coords="125,248,199,289">
		<area href="../BillEntry.sp?grdid=SHGIS" shape="rect" coords="215, 215, 295, 257">
		<area href="../BillEntry.sp?grdid=SDSXQuery" shape="rect" coords="369, 19, 464, 61">
		<area href="../BillEntry.sp?grdid=TSPTBill" shape="rect" coords="334, 76, 416, 118">
		<area href="../BillEntry.sp?grdid=SDPrint" shape="rect" coords="422, 79, 504, 121">
		<area href="../BillEntry.sp?grdid=SDList" shape="rect" coords="96,333,180,376">
		<area href="../BillEntry.sp?grdid=GenOtherSh" shape="rect" coords="148, 79, 223, 119">
		<area href="../BillEntry.sp?grdid=SX" shape="rect" coords="238, 78, 312, 119">
		<area href="../ShowXlsGrid.sp?grdid=SelFlw&sytid=MNERP&datflw=SD2SU&action=&where= and b.subtyp='1'" shape="rect" coords="454, 252, 511, 288">
		<area href="../ShowXlsGrid.sp?grdid=SelFlw&sytid=MNERP&datflw=SD2SU&action=&where= and b.subtyp='2'" shape="rect" coords="454, 292, 511, 328">
		<area href="../BillEntry.sp?grdid=SU&where=and subtyp='1'" shape="rect" coords="526, 254, 600, 288">
		<area href="../BillEntry.sp?grdid=SU&where=and subtyp='2'" shape="rect" coords="526, 293, 600, 327">
	
		</map>
        <img border="0" src="images/sh.jpg" usemap="#FPMap0" alt="" style="border:1px solid #000000; color: #FFFFFF; background-color: #FFFFFF; padding-left:4px; padding-right:4px; padding-top:1px; padding-bottom:1px">
      </p>
    </td>
  </tr>
</table>

</body>

</html>
function x_LHTML5(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");

var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb");
var layoutpack = new JavaPackage ( "com.xlsgrid.net.layout");
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd");

var langpack = new JavaPackage ( "java.lang");

//WNDMOD �����ͣ�������չ�У�
//	_this.SetListValue(list1,"HTML","HTML");
//	_this.SetListValue(list1,"OS","OS�ű�");
//	_this.SetListValue(list1,"MW","�м������");	
//	_this.SetListValue(list1,"FRAME","�ڲ�FRAME");
//	_this.SetListValue(list1,"FRAMEGROUP","��ҳFRAME��");	
//	_this.SetListValue(list1,"SCROLLIMAGE","����ͼƬ");
//	_this.SetListValue(list1,"TOOLBAR","ϵͳĬ�Ϲ�����");		
//	_this.SetListValue(list1,"MENU","�˵���");	
//	_this.SetListValue(list1,"FLASH","��Ƶ��ʾ");	
//	_this.SetListValue(list1,"���","���(��׼)");
//	_this.SetListValue(list1,"�հױ��","�հױ��");
//
//WNDMOD ���ڷ��, DSMOD ������Դ ,WHEREBY ����, SORTBY ����,SQLTXT  SQL���, LAYCOL ������ ,LAYROW ������,MOREURL ÿҳ�м�¼��, OSMWID OS�м��, OSFUNC OS����,OSPARAM OS�����Ĳ���,IFRAMEURL IFRAME��URL,IFSCROLLBAR �Ƿ���ʾ������,HTMLGUID,MOREURL,OPENLAYID HTML
function GetBody(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	return _GetHTML(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
}
// HTML 
function _GetHTML(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	if (WNDMOD == "LOGIN3A") return  _GetOS(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
}

function _GetOS(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	var fguid = db.GetSQL("select sys_guid() from dual " );
	return "<form id=\"f_login"+fguid +"\" action=\""+IFRAMEURL+"\" method=\"post\">
		<table border=\"0\" width=\"100%\"  cellspacing=\"0\" cellpadding=\"0\" bgcolor=\"#FFFFFF\">
		    <tr height=\"50\"> <td align=\"right\" width=\"20%\" ></td><td  ></td> <td width=\"20%\" >��</td>   </tr>
		    <tr height=\"30\"> <td align=\"right\" width=\"20%\" >&nbsp;</td>
		        <td >
		        <table border=\"0\" width=\"100%\" height=100% cellspacing=\"0\" cellpadding=\"0\"  >
				<tr>
					<td width=50 style=\"border: 0px solid #CCCCCC; padding-left: 0px; padding-right: 0px; padding-top: 0px; padding-bottom: 0px\">�û���:</td>
					<td  valign=middle><input type=\"text\" name=\"usrid\"  style=\"width:98%;height:25px;font-size: 12pt \"></td>
				</tr>
			</table>
		        </td> <td width=\"20%\">��</td>
		    </tr>
		    <tr height=\"20\"> <td colspan=\"3\" >&nbsp;</td></tr>
		    <tr height=\"20\"> <td colspan=\"3\" >&nbsp;</td></tr>
		    <tr height=\"30\"> <td align=\"right\" width=\"20%\" >&nbsp;</td>
		        <td ><table border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\"  >
				<tr>
					<td width=50 style=\"border: 0px solid #CCCCCC; padding-left: 0px; padding-right: 0px; padding-top: 0px; padding-bottom: 0px\">&nbsp;��&nbsp;��:</td>
					<td  valign=middle><input type=\"password\" name=\"userpwd\"  style=\"width:98%;height:25px;font-size: 12pt \"></td>
				</tr>
			</table></td><td width=\"20%\" >��</td></tr>
		     <tr height=\"20\"> <td colspan=\"3\" >&nbsp;</td></tr>
		    <tr height=40 > <td align=\"center\" colspan=\"3\" ><p align=\"center\"><img src=\"EAFormBlob.sp?guid=96376FC7A16B432399D7F052E82F805A\" border=0 onclick=\"javascript: f_login"+fguid +".submit();\" onmouseover=\"this.style.cursor='hand';\"> </td> </tr>
		     <tr height=\"20\"> <td colspan=\"3\" >&nbsp;</td></tr>
		</table></form>";
//var html=
//	"<form id=\"f_login\" action=\""+IFRAMEURL+"\" method=\"post\">"+
//	"<table  width=\"320\"  cellspacing=\"0\" cellpadding=\"0\" border=\"0\">"+
//		"<tr height=\"16\">"+
//	    "<td colspan=\"3\"  align=\"left\"><font color=#999999>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font> </td> </tr>"+
//	"<tr height=\"40\">"+
//	    "<td colspan=\"3\"  align=\"left\"><font color=#999999 size=\"4px\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�������û�������</font> </td> </tr>"+
//	"<tr height=\"40\">"+
//	    "<td align=\"right\" width=\"100\" valign=\"top\"><img src=EAFormBlob.sp?guid=69A085C9273641A39FD790D0D47D5468></td>"+
//	    "<td  align=\"left\" valign=\"top\">"+
//	        "<input type=\"text\" name=\"usrid\"  style=\"width:200px;height:25px;border: 1px solid #C0C0C0;font-size: 12pt\" > </td>"+
//	    "<td width=\"50\">��</td> </tr>"+
//	"<tr height=\"40\">"+
//	    "<td align=\"right\" width=\"100\" valign=\"top\"><img src=EAFormBlob.sp?guid=84D43F2B042F456A94A84013D6622D52></td>"+
//	   " <td  align=\"left\" valign=\"top\">"+
//	        "<input type=\"password\" name=\"userpwd\" style=\"width:200px;height:25px;border: 1px solid #C0C0C0;font-size: 12pt\"> </td>"+
//	    "<td width=\"50\" >��</td> </tr> <tr>"+
//	    "<td align=\"right\" colspan=\"3\" height=\"40\">"+
//	        "<p align=\"center\"><img src=EAFormBlob.sp?guid=44000855226C4576924B2C0A6BEE3A63 border=0 onclick=\"javascript: f_login.submit();\" onmouseover=\"this.style.cursor='hand';\">"+
//	         "</td> </tr></table></form>";
	
}
//"<tr> <td colspan=\"3\">"+
//"<img src=EAFormBlob.sp?guid=D55C6DD2FA614B2FA2FADBA6F0865E7E width=\"400\" height=\"120\" border=0>"+    
// "</td> </tr>

}
function x_L_LOGIN(){function GetBody(){
	var fguid = db.GetSQL("select sys_guid() from dual " );
	return "<form id=\"f_login"+fguid +"\" action=\""+IFRAMEURL+"\" method=\"post\">
		<table border=\"0\" width=\"100%\"  cellspacing=\"0\" cellpadding=\"0\" bgcolor=\"#FFFFFF\">
		    <tr height=\"50\"> <td align=\"right\" width=\"20%\" ></td><td  >请输入用户名密码：</td> <td width=\"20%\" >　</td>   </tr>
		    <tr height=\"30\"> <td align=\"right\" width=\"20%\" >&nbsp;</td>
		        <td >
		        <table border=\"0\" width=\"100%\" height=100% cellspacing=\"0\" cellpadding=\"0\"  >
				<tr>
					<td width=30 height=30 bgcolor=#00A8EC style=\"border: 1px solid #CCCCCC; padding-left: 0px; padding-right: 0px; padding-top: 0px; padding-bottom: 0px\">
					<img src='xlsgrid/images/flash/icon/icon_151.png' width=35  height=35></td>
					<td style=\"border-right:1px solid #CCCCCC; border-top:1px solid #CCCCCC; border-bottom:1px solid #CCCCCC; padding:0px; \" valign=middle><input type=\"text\" name=\"usrid\"  style=\"width:98%;height:25px;border: 0px ;font-size: 12pt \"></td>
				</tr>
			</table>
		        </td> <td width=\"20%\">　</td>
		    </tr>
		    <tr height=\"20\"> <td colspan=\"3\" >&nbsp;</td></tr>
		    <tr height=\"30\"> <td align=\"right\" width=\"20%\" >&nbsp;</td>
		        <td ><table border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\"  >
				<tr>
					<td width=30 height=30 bgcolor=#FFC500 style=\"border: 1px solid #CCCCCC; padding-left: 0px; padding-right: 0px; padding-top: 0px; padding-bottom: 0px\">
					<img src='xlsgrid/images/flash/icon/icon_162.png' width=35 height=35></td>
					<td style=\"border-right:1px solid #CCCCCC; border-top:1px solid #CCCCCC; border-bottom:1px solid #CCCCCC; padding:0px; \" valign=middle><input type=\"password\" name=\"userpwd\"  style=\"width:98%;height:25px;border: 0px ;font-size: 12pt \"></td>
				</tr>
			</table></td><td width=\"20%\" >　</td></tr>
		    <tr height=40 > <td align=\"center\" colspan=\"3\" ><p align=\"center\"><img src=\"EAImgBlob.sp?guid=2DBC1121895D4FD48D9584E47E4D11C7\" border=0 onclick=\"javascript: f_login"+fguid +".submit();\" onmouseover=\"this.style.cursor='hand';\"> </td> </tr>
		</table></form>";
//var html=
//	"<form id=\"f_login\" action=\""+IFRAMEURL+"\" method=\"post\">"+
//	"<table  width=\"320\"  cellspacing=\"0\" cellpadding=\"0\" border=\"0\">"+
//		"<tr height=\"16\">"+
//	    "<td colspan=\"3\"  align=\"left\"><font color=#999999>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font> </td> </tr>"+
//	"<tr height=\"40\">"+
//	    "<td colspan=\"3\"  align=\"left\"><font color=#999999 size=\"4px\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;请输入用户名密码</font> </td> </tr>"+
//	"<tr height=\"40\">"+
//	    "<td align=\"right\" width=\"100\" valign=\"top\"><img src=EAFormBlob.sp?guid=69A085C9273641A39FD790D0D47D5468></td>"+
//	    "<td  align=\"left\" valign=\"top\">"+
//	        "<input type=\"text\" name=\"usrid\"  style=\"width:200px;height:25px;border: 1px solid #C0C0C0;font-size: 12pt\" > </td>"+
//	    "<td width=\"50\">　</td> </tr>"+
//	"<tr height=\"40\">"+
//	    "<td align=\"right\" width=\"100\" valign=\"top\"><img src=EAFormBlob.sp?guid=84D43F2B042F456A94A84013D6622D52></td>"+
//	   " <td  align=\"left\" valign=\"top\">"+
//	        "<input type=\"password\" name=\"userpwd\" style=\"width:200px;height:25px;border: 1px solid #C0C0C0;font-size: 12pt\"> </td>"+
//	    "<td width=\"50\" >　</td> </tr> <tr>"+
//	    "<td align=\"right\" colspan=\"3\" height=\"40\">"+
//	        "<p align=\"center\"><img src=EAFormBlob.sp?guid=44000855226C4576924B2C0A6BEE3A63 border=0 onclick=\"javascript: f_login.submit();\" onmouseover=\"this.style.cursor='hand';\">"+
//	         "</td> </tr></table></form>";
	return html;

}
}
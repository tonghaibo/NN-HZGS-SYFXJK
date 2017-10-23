function TAXFXJK_STFX_CX(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//在Head区引用额外脚本
function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("<table border='0' width='100%' height='100%' cellspacing='0' cellpadding='0'><tr><td width='100%' height=1 style='border:0px solid #DEDEDE;'>");
}

//添加额外html
//afterBodyHtml事件后触发，已过时，建议用afterBodyHtml事件进行处理
function addBottomHtml(mwobj,request,sb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("</td></tr><tr><td width=100% bgcolor='#FEFEFE' style='border:1px solid #DEDEDE' align=left valign=top>");
	
	sb.append("<div align='center'><table border='0' width='100%' align=center>");
	sb.append("<tr><td valign='center' align='center'><span id='tips'>正在处理,请稍候...</span></td></tr>");
	sb.append("</td></tr></table></div>");
	
	sb.append("</td></tr></table>");
	sb.append("</td></tr></table></td></tr></table>");
}

}
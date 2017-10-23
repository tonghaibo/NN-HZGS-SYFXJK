function TAXFXJK_ZDSY_SSQK(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" ); 

//在Head区引用额外脚本
function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery-1.7.2.min.js\"></script>\n"); 
	sb.append("<script type=\"text/javascript\" src=\"xlsgrid/js/highcharts-3d.js\"></script>\n"); 
	sb.append("<script type=\"text/javascript\" src=\"xlsgrid/js/highcharts.js\"></script>\n"); 
	//sb.append("<script type=\"text/javascript\" src=\"xlsgrid/js/exporting.js\"></script>\n"); 

	//窗口上下分割，左右显示图表，右边显示中间件数据
	sb.append("<table border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" height=\"100%\"><tr><td bgcolor=\"#EFEFEF\" align=center valign=middle>");
	sb.append("<table border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" ><tr><td  style=\"border: 1px solid #EEEEEE\">	");
	sb.append("<table border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" ><tr>");
	sb.append("<td width=50% height=100% style=\"border:solid 1px gray\" valign=top;>");	
	sb.append("<div id='container' style=\"overflow-y:scroll;height:100%;\"></div></td>");
	sb.append("<td width=50% height=100% style=\"border:solid 1px gray\"  valign=top;><div style=\"overflow-y:scroll;height:100%;\">");


}

//添加额外html
//afterBodyHtml事件后触发，已过时，建议用afterBodyHtml事件进行处理
function addBottomHtml(mwobj,request,sb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("</div></td></tr></table>");	
	sb.append("</td></tr></table></td></tr></table>");
}


}
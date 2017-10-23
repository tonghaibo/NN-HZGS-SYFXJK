function TAXFXJK_CHART000(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" ); 

//在Head区引用额外脚本
function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery-1.7.2.min.js\"></script>\n"); 
	sb.append("<script type=\"text/javascript\" src=\"xlsgrid/js/highcharts-3d.js\"></script>\n"); 
	sb.append("<script type=\"text/javascript\" src=\"xlsgrid/js/highcharts.js\"></script>\n"); 
	//sb.append("<script type=\"text/javascript\" src=\"xlsgrid/js/exporting.js\"></script>\n"); 

	//窗口上下分割，上面显示图表，下面显示中间件数据
	sb.append("<table border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\"><tr><td bgcolor=\"#EFEFEF\" align=center valign=middle>");
	sb.append("<table border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" ><tr><td  style=\"border: 1px solid #EEEEEE\">");
	sb.append("<table border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" ><tr>"); //上面窗口高度占的比例
//	sb.append("<td align=right><button type='button' onclick='lastYear()'>上一年</button>&nbsp;&nbsp;<button type='button' onclick=nextYear()'>下一年</button></td></tr><tr>");
	sb.append("<td width=100% height=100% style=\"border:solid 1px gray\" valign=top;>");
	sb.append("<div id='container' style=\"height=100%\"></div></td>");

}

//添加额外html
//afterBodyHtml事件后触发，已过时，建议用afterBodyHtml事件进行处理
function addBottomHtml(mwobj,request,sb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("</tr></table>");	
	sb.append("</td></tr></table></td></tr></table>");
}


}
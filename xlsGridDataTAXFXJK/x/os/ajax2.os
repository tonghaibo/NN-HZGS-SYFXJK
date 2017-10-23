function x_ajax2(){
//在Head区引用额外脚本
function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("<script type='text/javascript' src='xlsgrid/js/jquery-1.3.2.min.js'></script>\n"); //压缩版  
	//sb.append("<script src='http://maps.google.com/maps?file=api&v=2&sensor=true_or_false&key=ABQIAAAADEgO6kqjKx2W3NKoYkXzGhTepiFuMo4rdqjr65BYebADdmCbPBSZRe2SjhGp7UEHeh4Eg90T-LJuxw&sensor=true' type='text/javascript'></script>");
}

//页面BODY处理完毕后事件
//sb里面是body元素及前面的head内容
//bodysb里面是body的innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	//sb.append("<div id=\"map_canvas\" style=\"width: 1000px; height: 500px\"></div>");  
}

}
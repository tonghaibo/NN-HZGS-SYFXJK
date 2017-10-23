function x_BITopic(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//页面BODY处理完毕后事件
//sb里面是body元素及前面的head内容
//bodysb里面是body的innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	try {
		pub.EADbTool.ExcecutSQL("alter table DIM_TOPIC add VDIMSHOWCOL varchar2(255)");
	} catch ( e ) { }
}

}
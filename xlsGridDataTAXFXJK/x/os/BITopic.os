function x_BITopic(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//ҳ��BODY������Ϻ��¼�
//sb������bodyԪ�ؼ�ǰ���head����
//bodysb������body��innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	try {
		pub.EADbTool.ExcecutSQL("alter table DIM_TOPIC add VDIMSHOWCOL varchar2(255)");
	} catch ( e ) { }
}

}
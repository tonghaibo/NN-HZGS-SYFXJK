function TAXFXJK_STFX_CX(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//��Head�����ö���ű�
function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("<table border='0' width='100%' height='100%' cellspacing='0' cellpadding='0'><tr><td width='100%' height=1 style='border:0px solid #DEDEDE;'>");
}

//��Ӷ���html
//afterBodyHtml�¼��󴥷����ѹ�ʱ��������afterBodyHtml�¼����д���
function addBottomHtml(mwobj,request,sb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("</td></tr><tr><td width=100% bgcolor='#FEFEFE' style='border:1px solid #DEDEDE' align=left valign=top>");
	
	sb.append("<div align='center'><table border='0' width='100%' align=center>");
	sb.append("<tr><td valign='center' align='center'><span id='tips'>���ڴ���,���Ժ�...</span></td></tr>");
	sb.append("</td></tr></table></div>");
	
	sb.append("</td></tr></table>");
	sb.append("</td></tr></table></td></tr></table>");
}

}
function TAXFXJK_CR04(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var web = new JavaPackage ( "com.xlsgrid.net.web" );

//��ʾ��ѯ����ǰԤ����
//�����ڲ�ѯ�򱨱���ʾ��ѯ����ǰ��Ԥ����
//������sb��StringBuffer����append HTML���ݻ���⸽���ű�
//�����޸�paramDs�����ݣ�������Щ�����ɼ����޸�Ĭ��ֵ
//  ID:���;  NAME:����; KEYVAL:�ؼ���; SQLWHE:WHERE����; DEFVAL:Ĭ��ֵ
//  TIP:��ʾ; EDTFLG:�Ƿ���޸�;  VISFLG:�Ƿ����ʾ; KEYFLG:�ؼ��ֶ�(û������)
//  DISPORD:������ʾ�����(�޸���Ч); INPCTL:�ؼ�����
function beforeShowParam(request,sb,paramDs,usrinfo)
//var request=javax.servlet.http.HttpServletRequest(); var sb = new java.lang.StringBuffer();var paramDs = new EAXmlDS();var usrinfo = new web.EAUserinfo();
{
	//throw new Exception(paramDs.GetXml());
//	var usrinfo = web.EASession.GetLoginInfo(request);
//	var usrorg = usrinfo.getusrOrg();
//	var usrid = usrinfo.getUsrid();
//	var ds = pub.EADbTool.QuerySQL("select a.*,nvl(b.SCOPE,'NO') SCOPE from usr a,v_depts b where a.deptid=b.id and a.org=b.org and a.org='"+usrorg+"' and a.id='"+usrid+"'");
//	if (ds.getRowCount() > 0) {
//		var scope = ds.getStringAt(0,"SCOPE");
//		if (scope != "ALL") {
//			paramDs.setValueAt(7,11,"0");
//		}
//	}
}
//�滻SQL����
function replaceParam(mwobj,request,sql)
{

	var usrinfo = web.EASession.GetLoginInfo(request);
	var usrorg = usrinfo.getusrOrg();
	var usrid = usrinfo.getUsrid();
	var swjg_dm = request.getParameter("SWJG_DM");
	if (swjg_dm == "1451100") {
		sql = pub.EAFunc.Replace(sql,"[%SWJGSTR]"," ");
	}
	else {
		sql = pub.EAFunc.Replace(sql,"[%SWJGSTR]"," and b.swjg_dm like '"+swjg_dm+"%'");
	}

	
	return sql;
}

}
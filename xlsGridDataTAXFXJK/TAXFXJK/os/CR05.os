function TAXFXJK_CR05(){var pub = new JavaPackage("com.xlsgrid.net.pub");
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
//			paramDs.setValueAt(4,11,"0");
//		}
//	}
}

//�滻SQL����
function replaceParam(mwobj,request,sql)
{
	var taxman = request.getParameter("TAXMAN");

	if (taxman != "") {
		//sql = pub.EAFunc.Replace(sql,"[%TAXMANSTR]","and taxman like (select name from v_tax_taxman where id='"+taxman+"')");
		sql = pub.EAFunc.Replace(sql,"[%TAXMANSTR]","and taxman like '%"+taxman+"%'");

	}
	else {
		sql = pub.EAFunc.Replace(sql,"[%TAXMANSTR]","");
	}
	
	
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
	
	
	var flg = pub.EAFunc.NVL(request.getParameter("FLG"),"");
	if (flg == "1") { //��ҵ��˰��ҵ
		sql = pub.EAFunc.Replace(sql,"[%FLGSTR]"," and a.id not in (select cmid from TAX_NOTAXCOM)");
	}
	if (flg == "0") {
		sql = pub.EAFunc.Replace(sql,"[%FLGSTR]"," and a.id in (select cmid from TAX_NOTAXCOM)");
	}
	else {
		sql = pub.EAFunc.Replace(sql,"[%FLGSTR]","");
	}
	
	return sql;
}

function updateFlag()
{
	var db = null;
	var sql = "";
	var ret = 0;
	try {
		db = new pub.EADatabase();
		var ammnos = cms.split(",");
		for (var i=0;i<ammnos.length();i++) {
			sql = "insert into TAX_NOTAXCOM(cmid,crtusr) values('"+ammnos[i]+"','"+thisusrid+"')";
			ret += db.ExcecutSQL(sql);
		}
		
		db.Commit();
		return "�����ɹ�! ��־��¼��"+ret;
	}
	catch(e) {
		if (db != null) db.Rollback();
		return "����ʧ��"+e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

function updateFlag2()
{
	var db = null;
	var sql = "";
	var ret = 0;
	try {
		db = new pub.EADatabase();
		var ammnos = cms.split(",");
		for (var i=0;i<ammnos.length();i++) {
			sql = "delete from TAX_NOTAXCOM where cmid='"+ammnos[i]+"'";
			ret += db.ExcecutSQL(sql);
		}
		
		db.Commit();
		return "�����ɹ�! ��־��¼��"+ret;
	}
	catch(e) {
		if (db != null) db.Rollback();
		return "����ʧ��"+e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

}
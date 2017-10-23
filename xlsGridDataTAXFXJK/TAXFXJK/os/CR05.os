function TAXFXJK_CR05(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var web = new JavaPackage ( "com.xlsgrid.net.web" );

//显示查询参数前预处理
//用于在查询或报表显示查询参数前的预处理。
//可以往sb（StringBuffer）中append HTML内容或额外附近脚本
//可以修改paramDs的内容，决定哪些参数可见或修改默认值
//  ID:编号;  NAME:标题; KEYVAL:关键字; SQLWHE:WHERE条件; DEFVAL:默认值
//  TIP:提示; EDTFLG:是否可修改;  VISFLG:是否可显示; KEYFLG:关键字段(没有作用)
//  DISPORD:参数显示次序号(修改无效); INPCTL:控件类型
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

//替换SQL参数
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
	if (flg == "1") { //工业纳税企业
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
		return "操作成功! 标志记录数"+ret;
	}
	catch(e) {
		if (db != null) db.Rollback();
		return "操作失败"+e.toString();
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
		return "操作成功! 标志记录数"+ret;
	}
	catch(e) {
		if (db != null) db.Rollback();
		return "操作失败"+e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

}
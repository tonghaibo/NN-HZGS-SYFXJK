function TAXMON_TK_DBCZ(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//�滻SQL����
function replaceParam(mwobj,request,sql)
{
	var town = pub.EAFunc.NVL(request.getParameter("TOWNS"),"");
	var flg = pub.EAFunc.NVL(request.getParameter("FLG"),"");
	if (town != "") {
		var townids = pub.EAFunc.SQLIN(town);		
		town = " and town in (select name from v_tax_elearea where id in ("+townids+"))";
	}
	sql = pub.EAFunc.Replace(sql,"[%TOWNS]",town);
	
	if (flg == "1") {
		sql = pub.EAFunc.Replace(sql,"[%FLGSTR]"," and a.usrid not in (select ammno from tax_notinammno)");
	}
	if (flg == "0") {
		sql = pub.EAFunc.Replace(sql,"[%FLGSTR]"," and a.usrid in (select ammno from tax_notinammno)");
	}
	else {
		sql = pub.EAFunc.Replace(sql,"[%FLGSTR]","");
	}
	
	var gds = request.getParameter("GDS");
	if (gds != "") {
		sql = pub.EAFunc.Replace(sql,"[%GDSSTR]","and nvl(a.gds,'') IN (select name from v_tax_gds where ID like '"+gds+"%')");
	}
	else {
		sql = pub.EAFunc.Replace(sql,"[%GDSSTR]","");
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
			sql = "insert into tax_notinammno(ammno,crtusr) values('"+ammnos[i]+"','"+thisusrid+"')";
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
			sql = "delete from tax_notinammno where ammno='"+ammnos[i]+"'";
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
function TAXMON_TK_DBCX(){var pub = new JavaPackage("com.xlsgrid.net.pub");
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
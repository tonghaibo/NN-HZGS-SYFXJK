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
			sql = "delete from tax_notinammno where ammno='"+ammnos[i]+"'";
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
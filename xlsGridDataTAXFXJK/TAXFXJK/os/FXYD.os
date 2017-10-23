function TAXFXJK_FXYD(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function YDCL()
{
	return "1";
}

//删除任务
function DeleteHSRW()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "update tax_trkhdr set stat='0' where guid in ("+pub.EAFunc.SQLIN(guidstr)+")";
		db.ExcecutSQL(sql);
		return 1;
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}


//任务推送
function Send()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "update tax_trkhdr set stat='2',chkusr='"+usrid+"',chkusrnam='"+usrnam+"',swjg_dm='"+zgswjg+"',todept='"+gs+"',tousr='"+swgly+"' where guid in ("+pub.EAFunc.SQLIN(guidstr)+")";
		var cnt = db.ExcecutSQL(sql);
		return "任务推送成功,共"+cnt+"条.";
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

//结束任务
function JSHSRW()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "update tax_trkhdr set stat='9' where guid in ("+pub.EAFunc.SQLIN(guidstr)+")";
		db.ExcecutSQL(sql);
		return 1;
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

function SendTrk()
{
	return "1";
}

}
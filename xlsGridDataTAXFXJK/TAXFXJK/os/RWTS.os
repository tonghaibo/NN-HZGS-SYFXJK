function TAXFXJK_RWTS(){var pub = new JavaPackage("com.xlsgrid.net.pub");

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


//��������
function Send()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "update tax_trkhdr set stat='2',chkusr='"+usrid+"',chkusrnam='"+usrnam+"',swjg_dm='"+zgswjg+"',todept='"+gs+"',tousr='"+swgly+"' where guid in ("+pub.EAFunc.SQLIN(guidstr)+")";
		var cnt = db.ExcecutSQL(sql);
		return "�������ͳɹ�,��"+cnt+"��.";
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

function Send2JC2B()
{
	return "1";
}

}
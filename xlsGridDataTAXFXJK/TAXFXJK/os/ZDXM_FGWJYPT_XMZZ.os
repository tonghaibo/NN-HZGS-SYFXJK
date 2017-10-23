function TAXFXJK_ZDXM_FGWJYPT_XMZZ(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function xmppCheck()
{
	var db = null;
	var ret = 0;
	try {
		db = new pub.EADatabase();
		var sql = "update tax_zdxm_jyptxm set fgwxmdm=null where fgwxmdm='"+fgwxm+"'";
		ret = db.ExcecutSQL(sql);
		sql = "update tax_zdxm_jyptxm set fgwxmdm='"+fgwxm+"' where jyptxmuuid in ("+pub.EAFunc.SQLIN(xmguid)+")";
		ret = db.ExcecutSQL(sql);
		
		db.Commit();
		return ret;		
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}
}
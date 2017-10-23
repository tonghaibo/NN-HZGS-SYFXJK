function TAXFXJK_ZDXM_PPGD(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function xmppCheck()
{
	var db = null;
	var ret = 0;
	try {
		db = new pub.EADatabase();
		var sql = "update tax_zdxm_dr set fgwxmdm=null where fgwxmdm='"+fgwxm+"'";
		db.ExcecutSQL(sql);
		sql = "update tax_zdxm_dr set fgwxmdm='"+fgwxm+"' where guid in ("+pub.EAFunc.SQLIN(xmguid)+")";
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
function TAXFXJK_ZDXM_JYPTBY_XMZZ(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function xmppCheck()
{
	var db = null;
	var ret = 0;
	try {
		db = new pub.EADatabase();
		var sql = "delete from tax_zdxm_jyptwbbyxm_dzb where jyptxmuuid='"+jyptxmuuid+"'";
		db.ExcecutSQL(sql);

		sql = "insert into tax_zdxm_jyptwbbyxm_dzb(jyptxmuuid,djxh,bydjuuid)
			select '"+jyptxmuuid+"' jyptxmuuid,djxh,bydjuuid from dj_wbnsrjydbydj where 
			bydjuuid in ("+pub.EAFunc.SQLIN(bydjuuid)+")";
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
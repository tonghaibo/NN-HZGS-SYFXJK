function TAXFXJK_COMPCLASS(){var pub = new JavaPackage("com.xlsgrid.net.pub");
function insert()
{
	var db = null;
	var sql = "";
	var ret = "";
	try {
		db = new pub.EADatabase();
		sql = "insert into tax_compclass(id,name,hycode,tax,avgsale,envload,se_ybnsr,se_xgm,year,eff) 
		       select id,name,hycode,tax,avgsale,envload,se_ybnsr,se_xgm,year,'0' eff 
		       from tax_compclass where guid='"+guid+"'";
		ret = db.ExcecutSQL(sql);
		
		db.Commit();
		return ret;
	}
	catch(e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}
}
function TAXFXJK_JK03(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//删除表信息
function Delete()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		
		var ds = new pub.EAXmlDS(xmlstr);
		for (var i=0;i<ds.getRowCount();i++) {
			var guid = ds.getStringAt(i,"GUID");
			var sql = "delete from fxjk_item where guid='"+guid+"'";
			db.ExcecutSQL(sql);
		}
		
		db.Commit();
		return "删除成功！记录数"+ds.getRowCount();
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
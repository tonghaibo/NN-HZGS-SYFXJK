function x_usracc(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function save()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		
		var ds = new pub.EAXmlDS(xmlstr);
		var sql = "delete from accmainurl where usrorgid='"+usrorg+"' and usrid='"+userid+"'";
		db.ExcecutSQL(sql);
		for (var i=0;i<ds.getRowCount();i++) {
			var accid = ds.getStringAt(i,"ID");
			var orgid = ds.getStringAt(i,"ORGID");
			var mainurl = ds.getStringAt(i,"MAINURL");
			if (accid != "" && mainurl != "") {
				sql = "insert into accmainurl(accid,usrid,usrorgid,mainurl) values ('"+accid+"','"+userid+"','"+orgid+"','"+mainurl+"')";
				db.ExcecutSQL(sql);
			}
		}
		db.Commit();
		return "²Ù×÷³É¹¦";
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
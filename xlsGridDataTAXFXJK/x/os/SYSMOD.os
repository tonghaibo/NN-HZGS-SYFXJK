function x_SYSMOD(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function saveSysMod()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "";
		var ps = db.prepareStatement("insert into sysmod (syt,id,name,modtyp,REFID,ACTION,GRDID,note) values (?,?,?,?,?,?,?,?)");
		ps.setString(1,sytid);
		ps.setString(2,mid);
		ps.setString(3,mname);
		ps.setString(4,modtyp);
		ps.setString(5,refid);
		ps.setString(7,mwid);
		ps.setString(8,note);
		if (modtyp == "2") {
			var auths = action.split(",");
			for (var i=0;i<auths.length();i++) {
				ps.setString(6,auths[i]);
			}
		}
		else {
			ps.setString(6,action);
		}
		ps.addBatch();
		ps.executeBatch();
		db.Commit();
		
		return "添加权限成功!";
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

function deleteSysMod()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "delete from sysmod where guid='"+guid+"'";
		db.ExcecutSQL(sql);
		db.Commit();
		
		return "删除权限成功!";
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
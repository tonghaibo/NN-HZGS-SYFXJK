function TAXFXJK_selParam(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function Save()
{
	var db = null;
	
	try {
		db = new pub.EADatabase();
		
		var csds = new pub.EAXmlDS(csxml);
		var sql = "delete from tax_stone_param where hydm='"+selhydm+"'";
		db.ExcecutSQL(sql);
		for (var i=0;i<csds.getRowCount();i++) {
			var hydm = csds.getStringAt(i,"HYDM");
			var csid = csds.getStringAt(i,"CSID");
			var csmc = csds.getStringAt(i,"CSMC");
			var gmdh = csds.getStringAt(i,"GMDH");
			var dmdh = csds.getStringAt(i,"DMDH");
			var gmsj = csds.getStringAt(i,"GMSJ");
			var dmsj = csds.getStringAt(i,"DMSJ");
			var pjsj = csds.getStringAt(i,"PJSJ");
			var dwdh = csds.getStringAt(i,"DWDH");
			var dwwh = csds.getStringAt(i,"DWWH");
			var dwyh = csds.getStringAt(i,"DWYH");
			var hlsj = csds.getStringAt(i,"HLSJ");
			var bcsj = csds.getStringAt(i,"BCSJ");
			var sssj = csds.getStringAt(i,"SSSJ");
			
			if (hydm != "" && csid != "") {
				sql = "insert into tax_stone_param(hydm,csid,csmc,gmdh,dmdh,gmsj,dmsj,pjsj,dwdh,dwwh,dwyh,hlsj,bcsj,sssj)
					values('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s')"
					.format([hydm,csid,csmc,gmdh,dmdh,gmsj,dmsj,pjsj,dwdh,dwwh,dwyh,hlsj,bcsj,sssj]);
				db.ExcecutSQL(sql);  
			}

			
		}
		
		var hyds = new pub.EAXmlDS(hyxml);
		sql = "delete from tax_stone_hy where hydm='"+selhydm+"'";
		for (var i=0;i<hyds.getRowCount();i++) {
			var flag = hyds.getStringAt(i,"FLAG");
			var id = hyds.getStringAt(i,"ID");
			if (flag == "1") {
				sql = "insert into tax_stone_hy(hydm,gxhhydm)values('%s','%s')".format([selhydm,id]);
				db.ExcecutSQL(sql);
			}
		}
		
		db.Commit();
		
		return "±£´æ³É¹¦!";
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
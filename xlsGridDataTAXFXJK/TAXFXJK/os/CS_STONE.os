function TAXFXJK_CS_STONE(){var pub = new JavaPackage("com.xlsgrid.net.pub");

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
			var dj = csds.getStringAt(i,"DJ");
			var whbl = csds.getStringAt(i,"WHBL");
			var lft = csds.getStringAt(i,"LFT");
			var lfm = csds.getStringAt(i,"LFM");
			var dhy = csds.getStringAt(i,"DHY");
			var dwyh = csds.getStringAt(i,"DWYH");
			var hlsj = csds.getStringAt(i,"HLSJ");
			var bcsj = csds.getStringAt(i,"BCSJ");
			var sssj = csds.getStringAt(i,"SSSJ");
			
			if (hydm != "" && csid != "") {
				sql = "insert into tax_stone_param(hydm,csid,csmc,dj,whbl,LFT,LFM,DHY,DWYH,hlsj,bcsj,sssj)
					values('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s')"
					.format([hydm,csid,csmc,dj,whbl,lft,lfm,dhy,dwyh,hlsj,bcsj,sssj]);
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
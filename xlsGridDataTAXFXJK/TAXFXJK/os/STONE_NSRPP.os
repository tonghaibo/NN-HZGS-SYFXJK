function TAXFXJK_STONE_NSRPP(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function Save()
{
	var db = null;
	var sql = "";
	try {
		db = new pub.EADatabase();
		var ds = new pub.EAXmlDS(xmlstr);
		var cnt = 0;
		for (var i=1;i<ds.getRowCount();i++) {
			var qymc = ds.getStringAt(i,"NSRMC");
			var nsrsbh = ds.getStringAt(i,"NSRSBH");
			var djxh = ds.getStringAt(i,"DJXH");
			if (djxh != "" && nsrsbh != "") {
				sql = "insert into TAX_STONE_DZB (qymc,nsrsbh,djxh)values('%s','%s','%s')"
					.format([qymc,nsrsbh,djxh]);
				cnt += db.ExcecutSQL(sql);
			}
		}
		db.Commit();
		updateStoneData();
		return "保存成功！记录数"+cnt;
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

function updateStoneData()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "update tax_stonedata a set (nsrsbh,djxh)=(select nsrsbh,djxh from TAX_STONE_DZB b where a.nsrmc=b.qymc and rownum=1)
			where exists (select 1 from TAX_STONE_DZB dzb where a.nsrmc=dzb.qymc)";
		var cnt = db.ExcecutSQL(sql);
		
		db.Commit();
		return "更新石材数据成功！更新记录数"+cnt;
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
function TAXFXJK_FXDZITEM(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function Save()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "";

		if (guid == "") {
			//����״̬�� �ж�ͬ���ı������Ƿ���ڣ������������ͬ
			sql = "select * from FXJK_ITEM where flbh='"+fxid+"'";
			var cnt = db.GetSQLRowCount(sql);
			if (cnt > 0) {
				return "�ñ�ţ�"+flbh+"���Ѵ��ڣ������ظ���";
			}
			
			sql = "insert into FXJK_ITEM(guid,dl,flbh,flmc,yxbz,fxjb,url,typ)
				values(sys_guid(),'%s','%s','%s','%s','%s','%s','%s')"
				.format([fxlb,fxid,fxmc,yxbz,fxjb,url,"2"]);
			db.ExcecutSQL(sql);
		}
		else {
			sql = "update FXJK_ITEM set dl='%s',flbh='%s',flmc='%s',yxbz='%s',fxjb='%s',url='%s'
				where guid='%s'"
				.format([fxlb,fxid,fxmc,yxbz,fxjb,url,guid]);
			db.ExcecutSQL(sql);
		}
		
		db.Commit();
		
		return "ok";
	}
	catch(e) {
		if (db != null) db.Rollback();
		//throw new Exception(e.toString());
		return e.toString();
	}	
	finally {
		if (db != null) db.Close();
	}
}
}
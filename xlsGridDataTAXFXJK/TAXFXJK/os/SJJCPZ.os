function TAXFXJK_SJJCPZ(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function Save()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "";
		wherestr = pub.EAFunc.Replace(wherestr,"'","''");
		if (guid == "") {
			//新增状态下 判断同步的表名称是否存在，不允许表名相同
			sql = "select * from tax_jssjtbb where upper(table_name)=upper('"+table_name+"')";
			var cnt = db.GetSQLRowCount(sql);
			if (cnt > 0) {
				return "该表名（"+table_name+"）已存在，不能重复配置！";
			}
			
			sql = "insert into tax_jssjtbb(guid,owner,owner_note,table_name,table_common,tbbz,dblink,dblink_name,zlbz,wherestr)
				values(sys_guid(),'%s','%s','%s','%s','%s','%s','%s','%s','%s')"
				.format([owner,owner_note,table_name,table_note,tbbz,dblink,dblink_name,zlbz,wherestr]);
			db.ExcecutSQL(sql);
		}
		else {
			sql = "update tax_jssjtbb set owner='%s',owner_note='%s',table_name='%s',
				table_common='%s',tbbz='%s',dblink='%s',dblink_name='%s',zlbz='%s',wherestr='%s'
				where guid='%s'"
				.format([owner,owner_note,table_name,table_note,tbbz,dblink,dblink_name,zlbz,wherestr,guid]);
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
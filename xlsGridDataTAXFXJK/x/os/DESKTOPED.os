function x_DESKTOPED(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var web = new JavaPackage ( "com.xlsgrid.net.web" );

// �ͻ���param����Ĳ�������ֱ��ʹ��
function getDeforg()
{
	return web.EAWebDeforg.GetDeforg(request);
}

// �ͻ���param����Ĳ�������ֱ��ʹ��
function save()
{
	var db = null;
	var sql = "";
	var msg = "";
	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var ds = new pubpack.EAXmlDS(xmlstr);	// �ͻ��˿��Դ���һ��xml
		
		for ( var row=0;row<ds.getRowCount();row ++ ) {
			var guid = ds.getStringAt(row,"COL1");
			var typ = ds.getStringAt(row,"COL2");
			var id = ds.getStringAt(row,"COL3");
			var name = ds.getStringAt(row,"COL4");
			var note = ds.getStringAt(row,"COL5");
			var refid = ds.getStringAt(row,"COL6");
			
			if (guid != "") {
				sql = "update param set typ='%s',id='%s',name='%s',note='%s',refid='%s' where guid='%s'".format([typ,id,name,note,refid,guid]);
				db.ExcecutSQL(sql);
			} else {
				if (id != "") {
					sql = "insert into param (guid,typ,id,name,note,refid) values (sys_guid(),'%s','%s','%s','%s','%s')".format([typ,id,name,note,refid]);
					db.ExcecutSQL(sql);
				}
			}
		}
		
		db.Commit();
		msg = "����ɹ�!";
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}

// �ͻ���param����Ĳ�������ֱ��ʹ��
function delt()
{
	var db = null;
	var sql = "";
	var msg = "";
	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		
		sql = "delete param where guid='"+guid+"'";
		db.ExcecutSQL(sql);
		
		db.Commit();
		msg = "ɾ���ɹ�!";
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}

}
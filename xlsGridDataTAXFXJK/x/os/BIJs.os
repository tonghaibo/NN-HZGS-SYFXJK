function x_BIJs(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var langpack = new JavaPackage ( "java.lang" );

// �ͻ���param����Ĳ�������ֱ��ʹ��
function GetXml()
{
	var db = null;
	var ds = null;
	var sql = "";
	var ret = "";
	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		sql = "select name,jsguid from DIM_MODEL where guid='"+FORMGUID+"'";
		
		ds = db.QuerySQL(sql);
		ret = ds.getStringAt(0,"NAME");
		
		if (ds.getStringAt(0,"JSGUID") != null && ds.getStringAt(0,"JSGUID") != "") {
			var b = db.getBlob2Byte("select bdata from FORMBLOB where guid='"+ds.getStringAt(0,"JSGUID")+"' for update","bdata");
			ret = ds.getStringAt(0,"NAME")+"~~~"+new langpack.String(b,"GB2312");
		}
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return ret;
}

// �ͻ���param����Ĳ�������ֱ��ʹ��
function save()
{
	var db = null;
	var sql = "";
	var ret = 0;
	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		
		sql = "update DIM_MODEL set jsguid='"+JSGUID+"' where guid='"+FORMGUID+"'";
		ret = db.ExcecutSQL(sql);
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return ret;
}

}
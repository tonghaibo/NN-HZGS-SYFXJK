function x_BIAlg(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// �ͻ���param����Ĳ�������ֱ��ʹ��
function GetXml()
{
	var db = null;
	var ds = null;
	var sql = "";
	var ret = "";
	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		
		sql = "select name,alg from DIM_TOPIC where refmod='"+FORMGUID+"' and id='"+topic+"'";
		try {
			ds = db.QuerySQL(sql);
		} catch ( e ) {
			db.ExcecutSQL("alter table DIM_TOPIC add ALG VARCHAR2(2000)");
			db.ExcecutSQL("comment on column DIM_TOPIC.ALG is '�����㷨'");
			ds = db.QuerySQL(sql);
		}
		
		ret = ds.GetXml();
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
		
		sql = "update DIM_TOPIC set alg='"+alg+"' where refmod='"+FORMGUID+"' and id='"+topic+"'";
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
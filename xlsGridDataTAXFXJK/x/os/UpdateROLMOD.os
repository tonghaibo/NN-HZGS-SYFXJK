function x_UpdateROLMOD(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// �ͻ���param����Ĳ�������ֱ��ʹ��
function save()
{
	var db = null;
	var msg= "";
	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		try{db.ExcecutSQL("create view V_SYSMODTYP as select distinct refid id ,syt,refid name from sysmod ");}catch(e){}
		var ds = new pubpack.EAXmlDS(xmlstr);	// �ͻ��˿��Դ���һ��xml
		//db.ExcecutSQL("delete from rolmod where rol ='"+thisrolguid+"'");
		for ( var i=0;i<ds.getRowCount();i++){
			var guid = ds.getStringAt(i,"GUID");
			var checkid = ds.getStringAt(i,"CHECKID");
			db.ExcecutSQL("delete from rolmod where rol ='"+thisrolguid+"' and sysmod='"+guid+"'");
			if ( checkid=="1") {
				db.ExcecutSQL("insert into rolmod(sysmod,rol) values('"+guid+"','"+thisrolguid+"') ");
			}
		}
		db.Commit();
		
		msg="�����ɹ�";	
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
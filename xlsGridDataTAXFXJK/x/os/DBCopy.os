function x_DBCopy(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// �ͻ���param����Ĳ�������ֱ��ʹ��
function save()
{
	var dbfrom = null;
	var dbto = null;
	var msg= "";
	
	try {
		var ds = new pubpack.EAXmlDS(xmlstr);	// �ͻ��˿��Դ���һ��xml
		
		var sdbfrom = ds.getStringAt(0,"dbfrom");
		var sdbto = ds.getStringAt(0,"dbto");
		var sqlfrom = ds.getStringAt(0,"sqlfrom");
		var sqlto = ds.getStringAt(0,"sqlto");
		var coltypelist = ds.getStringAt(0,"coltypelist");
		if ( sdbfrom =="" ) dbfrom = new pubpack.EADatabase();
		else dbfrom = new pubpack.EADatabase(sdbfrom );	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		if ( sdbto  == "" ) dbto = new pubpack.EADatabase();
		else dbto = new pubpack.EADatabase(sdbto );	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		msg="�ɹ�����"+pubpack.EADbCopy.InsertData(dbto,dbfrom,sqlto,sqlfrom,coltypelist ,",")+"�ʼ�¼";
			
	}
	catch ( ee ) {
		if(dbto !=null) dbto.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (dbto!=null) dbto.Close();
		if (dbfrom!=null) dbfrom.Close();
	}
	return msg;
}
}
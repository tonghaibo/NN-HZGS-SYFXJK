function x_DBCopy(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// 客户端param传入的参数可以直接使用
function save()
{
	var dbfrom = null;
	var dbto = null;
	var msg= "";
	
	try {
		var ds = new pubpack.EAXmlDS(xmlstr);	// 客户端可以传入一个xml
		
		var sdbfrom = ds.getStringAt(0,"dbfrom");
		var sdbto = ds.getStringAt(0,"dbto");
		var sqlfrom = ds.getStringAt(0,"sqlfrom");
		var sqlto = ds.getStringAt(0,"sqlto");
		var coltypelist = ds.getStringAt(0,"coltypelist");
		if ( sdbfrom =="" ) dbfrom = new pubpack.EADatabase();
		else dbfrom = new pubpack.EADatabase(sdbfrom );	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		if ( sdbto  == "" ) dbto = new pubpack.EADatabase();
		else dbto = new pubpack.EADatabase(sdbto );	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		msg="成功操作"+pubpack.EADbCopy.InsertData(dbto,dbfrom,sqlto,sqlfrom,coltypelist ,",")+"笔记录";
			
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
function x_DELACC(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// 客户端param传入的参数可以直接使用
function Run()
{
	var db = null;
	var msg= "";
	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		db.ExcecutSQL("delete from bildtlext where billguid in ( select guid from bildtl where acc='"+thisaccid+"')");
		db.ExcecutSQL("delete from bildtl where acc='"+thisaccid+"'");
		db.ExcecutSQL("delete from bilhdrext where billguid in ( select guid from bilhdr where acc='"+thisaccid+"')");
		db.ExcecutSQL("delete from bilhdr where acc='"+thisaccid+"'");
		db.ExcecutSQL("delete from datflwsta where acc='"+thisaccid+"'");
		db.ExcecutSQL("delete from datflw where acc='"+thisaccid+"'");
			
			
		db.Commit();
		msg = "删除数据成功" ;
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
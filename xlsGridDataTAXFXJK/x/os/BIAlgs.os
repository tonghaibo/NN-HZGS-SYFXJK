function x_BIAlgs(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// 客户端param传入的参数可以直接使用
function GetAlg()
{
	var db = null;
	var ds = null;
	var sql = "";
	var msg = "";
	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		
		sql = "select rownum,a.* from (select id,name,alg from DIM_TOPIC where refmod='"+FORMGUID+"' order by id) a";
		try {
			ds = db.QuerySQL(sql);
		} catch ( e ) {
			db.ExcecutSQL("alter table DIM_TOPIC add ALG VARCHAR2(2000)");
			db.ExcecutSQL("comment on column DIM_TOPIC.ALG is '主题算法'");
			ds = db.QuerySQL(sql);
		}
		
		msg = ds.GetXml();
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
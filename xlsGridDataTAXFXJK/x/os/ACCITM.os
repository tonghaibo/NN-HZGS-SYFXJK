function x_ACCITM(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// Possion
function Run()
{
	var db = null;
	var msg= "";
	var num = 0;
	var sql = "";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		//db.ExcecutSQL("delete from Poisson" );

		for ( var ee=1;ee<=1000;ee++ ) {
			var e = (1.0*ee)/10;
			
			for ( var qty=201;qty <= 300;qty++) {
				var p = pubpack.EAMath.Poisson(qty,e );
				num++;
				//if ( p!=null ) 
				try{
				db.ExcecutSQL("insert into Poisson(E,P,QTY) values( "+e+","+p+","+qty +")" );
				}catch( eee ) {}
			}
		}


		db.Commit();	
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return "成功插入"+num+"笔记录";
}

// Possion
function Run1()
{
	var db = null;
	var msg= "";
	var num = 0;
	var sql = "";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		//db.ExcecutSQL("delete from Poisson" );

		for ( var ee=1;ee<=1000;ee++ ) {
			var e = (1.0*ee)/10;
			
			for ( var qty=201;qty <= 300;qty++) {
				var p = pubpack.EAMath.Poisson(qty,e );
				num++;
				//if ( p!=null ) 
				try{
				db.ExcecutSQL("insert into Poisson(E,P,QTY) values( "+e+","+p+","+qty +")" );
				}catch( eee ) {}
			}
		}


		db.Commit();	
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return "成功插入"+num+"笔记录";
}

}
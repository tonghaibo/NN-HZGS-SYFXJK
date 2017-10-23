function x_TestMutiClickBtn(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var lang = new JavaPackage("java.lang");

function doServer()
{
	lang.Thread.sleep(3*1000);
		
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "select to_char(sysdate,'yyyymmddhh24miss') from dual";
		var t1 = 1 * db.GetSQL(sql);		
//		var t2 = 1 * db.GetSQL(sql);
//		while (t2 - t1 < 1) {
//			t2 = db.GetSQL(sql);
//		}
		
		pub.EAFunc.Log("Test6["+t1+"] count="+count);
		
		return "doserver finish!";
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}


}
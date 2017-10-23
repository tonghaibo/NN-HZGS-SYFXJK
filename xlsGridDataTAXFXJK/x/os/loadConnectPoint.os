function x_loadConnectPoint(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
//作为.sp服务时的入口
//预定义变量：request,response
function Response()
{
	var code = request.getParameter("CODE");
	var db = null;
	var ret= "";
	if (code == "dfxd") {
		return "http://222.66.72.52/dffin/Login.sp";
	}
	else if (code == "debug") {
		return "http://demo.xlsgrid.net:8990/emweb/Login.sp";
	}
	else { 
		return "http://www.xlsgrid.net";
	}
	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		ret = ".....";
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return ret ;
}
}
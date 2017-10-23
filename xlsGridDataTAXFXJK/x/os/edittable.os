function x_edittable(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" );

//在服务端OS中引用其他中间件的服务端脚本
function Run() 
{
	
	//说明：x_SQLINPUT是指x系统SQLINPUT中间件
	var parent = new x_SQLINPUT();
	var ret = parent.Run();
	//记录表所属系统
	
	try {
		tableLog(tableid,besytid,tabletype);
		
	} 
	catch(e) {
		//return e.toString();
	}

	return ret;
}

//记录表所属系统
function tableLog(tableid,besytid,tabletype)
{
	var db = null;
	try {
		db = new pubpack.EADatabase();
		var sql = "select * from user_objects where object_name=upper('"+tableid+"') and object_type='"+tabletype+"'";
		var cnt = db.GetSQLRowCount(sql);
		if (cnt > 0) {
			sql = "update sysxdbinfo set sytid='"+besytid+"' where objid='"+tableid+"' and typ='"+tabletype+"'";
			var ret = db.ExcecutSQL(sql);
			if (ret == 0) {
				sql = "insert into sysxdbinfo(sytid,objid,typ)values('"+besytid+"','"+tableid+"','"+tabletype+"')";
				db.ExcecutSQL(sql);
			}
			db.Commit();
		}
	}
	catch(e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

//================================================================// 
// 函数：GetViewCode
// 说明：得到视图的代码
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：04/02/06 15:57:54
// 修改日志：
//================================================================// 
function GetViewCode()
{
	var db = null;
	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)  dsid
		var ds=db.QuerySQL( "select TEXT from user_views where view_name=UPPER('"+tablename+"')" );
		if ( ds.getRowCount()> 0 ) 
	              return ds.getStringAt(0,"TEXT");
	        else return " " ;

	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return " ";
}


}
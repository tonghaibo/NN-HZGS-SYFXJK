function x_WS(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// 客户端param传入的参数可以直接使用
function save()
{
	var db = null;
	var msg= "操作成功";
	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		db.ExcecutSQL("delete from wsretdtl where formguid='" + FORMGUID+"' " );
		
		var ds = new pubpack.EAXmlDS(xmlstr);	// 客户端可以传入一个xml
		for ( var row=0;row<ds.getRowCount();row ++ ) {
			if (ds.getStringAt(row,"ID")=="")break; 
			var sql = "insert into wsretdtl ( formguid,seqid,id,name,note,coltyp,collen,notnull ) " + 
				" values ('"+FORMGUID+"','"+(row+1)+"','"+ds.getStringAt(row,"ID")+"','"+ds.getStringAt(row,"NAME")+"','"+ds.getStringAt(row,"NOTE")+"','"+ds.getStringAt(row,"COLTYP")+"','"+ds.getStringAt(row,"COLLEN")+"','"+ds.getStringAt(row,"NOTNULL")+"')";
			db.ExcecutSQL(sql );
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
	return msg;
}
// 客户端param传入的参数可以直接使用
// 参数：[%G_SYTID]','[%GRDID].[%FUNCID]','[%NAME]','[%] NOTE 
function AddSYSMOD()
{
	var sql = "select * from sysmod where syt='"+G_SYTID+"' and id='"+GRDID+"."+FUNCID+"' ";
	

	var inssql = "insert into sysmod ( syt,id,name,note,action,modtyp,grdid) "+
		" values( '"+G_SYTID+"','"+GRDID+"."+FUNCID+"','"+NAME+"','"+NOTE+"','"+FUNCID+"','3','"+GRDID+"') " ;
	
	var db = null;
	var msg= "操作成功";
	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		
		var ds = db.QuerySQL(sql);
		
		if (ds.getRowCount()>0 ) throw new pubpack.EAException("该权限已经添加过了，无需添加！" );
		db.ExcecutSQL(inssql);
		
		
		db.Commit();	
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


var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
//作为.sp服务时的入口
//预定义变量：request,response
function Response()
{
      var code = request.getParameter("CODE");
      var db = null;
      var ret= "100";
      try {
            db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
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
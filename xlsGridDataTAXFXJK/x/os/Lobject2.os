function x_Lobject2(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );


// 客户端param传入的参数可以直接使用
function SaveAS()
{
	var db = null;
	var guid = "";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		guid = db.GetSQL("select sys_guid() guid from dual");
		var ds = db.QuerySQL("select COLUMN_NAME from user_tab_columns where table_name='LAYOBJ'");
		var cols="";
		for ( var i=0;i<ds.getRowCount();i++){
			var colname= ds.getStringAt(i,"COLUMN_NAME");
			if(colname!="GUID"&& colname!="ID"){
				cols+=","+colname;	
			}
		}
		var sql ="insert into LAYOBJ(guid,id"+cols+") select '"+guid+"','"+id+"'"+cols+" from LAYOBJ where id='"+oldid+"' and deforg='"+deforg+"'";
		
		var retnum=db.ExcecutSQL(sql);
		
		db.Commit();	
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return guid ;
}


}
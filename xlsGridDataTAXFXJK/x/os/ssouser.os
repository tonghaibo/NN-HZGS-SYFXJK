function x_ssouser(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// 客户端param传入的参数可以直接使用
function save()
{
	var db = null;
	var msg= "操作成功";
	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var ds = new pubpack.EAXmlDS(xmlstr);	// 客户端可以传入一个xml
		for ( var row=0;row<ds.getRowCount();row ++ ) {
			//select a.guid,b.org,b.id,b.name,c.name deptname,a.url,a.destusrid,a.DESTUSERPWD ,NVL(a.useflg,'1') useflg
			var guid = ds.getStringAt(row,"GUID");
			var srcusrid= ds.getStringAt(row,"id");

			var usrid= ds.getStringAt(row,"destusrid");
			var usrpwd = ds.getStringAt(row,"DESTUSERPWD");
			var usrflg = ds.getStringAt(row,"USEFLG");
			var url = ds.getStringAt(row,"url");
			var useflg = ds.getStringAt(row,"useflg");
			var org = ds.getStringAt(row,"org");


			if ( guid == "" ) {
				db.ExcecutSQL("insert into usrchg(URL,SRCUSRID,DESTUSRID,DESTUSERPWD,ORG,USEFLG) values( "+
					"'"+url+"','"+srcusrid+"','"+usrid+"','"+usrpwd +"','"+org+"','"+useflg+"')"
				);
			
			}
			else {
				db.ExcecutSQL("update usrchg  set DESTUSRID= '"+usrid+"', DESTUSERPWD='"+usrpwd +"',useflg='"+useflg+"' where guid='"+guid+"' ");
							
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
	return msg;
}
}
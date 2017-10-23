function x_TRKUSR(){var pub = new JavaPackage ( "com.xlsgrid.net.pub" );

// 客户端param传入的参数可以直接使用

function save()
{
	var db = null;
	var msg= "";
	var sql = "";
	var cnt =0;
	
	try {
		db = new pub.EADatabase();
		var ds = new pub.EAXmlDS(xml);
	
			for ( var row=0;row<ds.getRowCount();row ++ ) {
				var ck = ds.getStringAt(row,"CK");
				var id = ds.getStringAt(row,"ID");
				var name = ds.getStringAt(row,"NAME");
				var useflg = ds.getStringAt(row,"USEFLG");
				var deptid = ds.getStringAt(row,"DEPTID");
				var note = ds.getStringAt(row,"DEPTID");
				
				sql = "insert into msg(org,title,note,tousr,crtusr) 
				values('COMAC','NOTICE','%s','%s','%s')".format([noticeid,id ,crtusr]);
			//	 throw new pub.EAException ( sql );
				if (ck == "1") {
					db.ExcecutSQL(sql);
					cnt++;
				}
				
			}	
//		}
		db.Commit();
		return cnt;
	}
	catch ( ee ) {
		db.Rollback();
		throw new pub.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
}



}
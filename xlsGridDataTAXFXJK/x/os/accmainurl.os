function x_accmainurl(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// 客户端param传入的参数可以直接使用
function save()
{
	var db = null;
	var msg= "";
	var delnum = 0;
	var newnum = 0;
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var ds = new pubpack.EAXmlDS(xmlstr);	// 客户端可以传入一个xml
		for ( var row=0;row<ds.getRowCount();row ++ ) {
			
			var accid = ds.getStringAt(row,"ACCID");
			var orgid = ds.getStringAt(row,"ORGID");

			var mainurl = ds.getStringAt(row,"MAINURL");
			if ( accid !="" ) {
				delnum +=db.ExcecutSQL("delete from accmainurl where accid='"+accid+"' and usrid='"+usrid+"' and usrorgid='"+orgid+"'");
				if(mainurl!="")
					newnum+=db.ExcecutSQL("insert into accmainurl(accid,usrid,usrorgid,mainurl) values('"+accid+"' ,'"+usrid+"','"+orgid+"','"+mainurl +"')");

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
	return "操作成功，删除了"+delnum +"笔,新增"+newnum+"笔";
}
}
function x_funtest(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// 客户端param传入的参数可以直接使用
function save()
{
	var db = null;
	var msg= "";
	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var ds = new pubpack.EAXmlDS(xmlstr);	// 客户端可以传入一个xml
		for ( var row=0;row<ds.getRowCount();row ++ ) {
			msg+="rowvalue="+ ds.getRowValue(row)+" "+"rowname="+ ds.getRowName(row)+"\n";
			for ( var col=0;col<ds.getColumnCount();col++ ) {
				msg+=" "+col+"."+ds.getColumnName(col)+"="+ds.getStringAt(row,col);
			}
			msg+="\n";
		}
			
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
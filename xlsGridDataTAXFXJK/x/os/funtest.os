function x_funtest(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// �ͻ���param����Ĳ�������ֱ��ʹ��
function save()
{
	var db = null;
	var msg= "";
	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var ds = new pubpack.EAXmlDS(xmlstr);	// �ͻ��˿��Դ���һ��xml
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
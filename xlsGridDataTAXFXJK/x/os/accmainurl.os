function x_accmainurl(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// �ͻ���param����Ĳ�������ֱ��ʹ��
function save()
{
	var db = null;
	var msg= "";
	var delnum = 0;
	var newnum = 0;
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var ds = new pubpack.EAXmlDS(xmlstr);	// �ͻ��˿��Դ���һ��xml
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
	return "�����ɹ���ɾ����"+delnum +"��,����"+newnum+"��";
}
}
function x_edittable(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" );

//�ڷ����OS�����������м���ķ���˽ű�
function Run() 
{
	
	//˵����x_SQLINPUT��ָxϵͳSQLINPUT�м��
	var parent = new x_SQLINPUT();
	var ret = parent.Run();
	//��¼������ϵͳ
	
	try {
		tableLog(tableid,besytid,tabletype);
		
	} 
	catch(e) {
		//return e.toString();
	}

	return ret;
}

//��¼������ϵͳ
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
// ������GetViewCode
// ˵�����õ���ͼ�Ĵ���
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�04/02/06 15:57:54
// �޸���־��
//================================================================// 
function GetViewCode()
{
	var db = null;
	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)  dsid
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
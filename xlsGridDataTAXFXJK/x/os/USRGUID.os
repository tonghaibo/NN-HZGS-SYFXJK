function x_USRGUID(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// �ͻ���param����Ĳ�������ֱ��ʹ��
function GetGUID()
{
	return pubpack.EADbTool.GetSQL( "select sys_guid() from dual " );
}

var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// �ͻ���param����Ĳ�������ֱ��ʹ��
function save()
{
	var db = null;
	var msg= "����ʧ��";
	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var usrguid  =db.GetSQL("select guid from usr where id='"+usrid+"' and org='"+usrorg+"'" );
		db.ExcecutSQL("delete from usracc where usrguid='"+usrguid+"'" );
		db.ExcecutSQL("insert into usracc(GUID,USRGUID,SYTID,ACCID,ORGID,STARTDAT,ENDDAT,CRTUSRNAM,USEFLG) " + 
			"values('"+guid+"', '"+usrguid+"','"+syt+"','"+acc+"','"+org+"',to_date('"+startdat+"','yyyy-mm-dd'),to_date(nvl('"+enddat+"',to_char(sysdate+3650,'YYYY-MM-DD')),'yyyy-mm-dd'),'"+crtusrnam +"','"+useflg+"') ");
		db.Commit();
		msg= "�����ɹ�";

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
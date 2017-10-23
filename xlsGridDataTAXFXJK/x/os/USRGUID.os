function x_USRGUID(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// 客户端param传入的参数可以直接使用
function GetGUID()
{
	return pubpack.EADbTool.GetSQL( "select sys_guid() from dual " );
}

var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// 客户端param传入的参数可以直接使用
function save()
{
	var db = null;
	var msg= "操作失败";
	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var usrguid  =db.GetSQL("select guid from usr where id='"+usrid+"' and org='"+usrorg+"'" );
		db.ExcecutSQL("delete from usracc where usrguid='"+usrguid+"'" );
		db.ExcecutSQL("insert into usracc(GUID,USRGUID,SYTID,ACCID,ORGID,STARTDAT,ENDDAT,CRTUSRNAM,USEFLG) " + 
			"values('"+guid+"', '"+usrguid+"','"+syt+"','"+acc+"','"+org+"',to_date('"+startdat+"','yyyy-mm-dd'),to_date(nvl('"+enddat+"',to_char(sysdate+3650,'YYYY-MM-DD')),'yyyy-mm-dd'),'"+crtusrnam +"','"+useflg+"') ");
		db.Commit();
		msg= "操作成功";

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
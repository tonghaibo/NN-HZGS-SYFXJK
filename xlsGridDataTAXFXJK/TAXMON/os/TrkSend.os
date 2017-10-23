function TAXMON_TrkSend(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function sendTrk()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "";
		var ret = 0;
		var guid = trkguid;
		sql = "update tax_trkhdr set stat='2',tousr='"+tousr+"',enddat=to_date('"+enddat+"','yyyy-mm-dd'),chkusr='"+usrid+"',chkusrnam='"+usrnam+"',chkdat=sysdate where guid='"+guid+"'";
		ret += db.ExcecutSQL(sql);
		db.Commit();
		
		return "任务分派成功!";
	}
	catch(e) {
		if (db != null) db.Rollback();
		throw new Exception(e.toString());
	}	
	finally {
		if (db != null) db.Close();
	}
}
}
function TAXMON_TKDTL(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function cancle()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "";
		var ret = 0;
		var ds = new pub.EAXmlDS(xmlstr);
		for (var i=0;i<ds.getRowCount();i++) {
			var guid = ds.getStringAt(i,"GUID");
			sql = "update tax_trkhdr set stat='1',tousr=null,chkdat=null,chkusr=null,chkusrnam=null where guid='"+guid+"' and stat='2'";
  			ret += db.ExcecutSQL(sql);
		}
		db.Commit();
		
		return "批量取消任务分派成功，记录数"+ret;
	}
	catch(e) {
		if (db != null) db.Rollback();
		throw new Exception(e.toString());
	}	
	finally {
		if (db != null) db.Close();
	}
}

function sendTrk()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "";
		var ret = 0;
		var ds = new pub.EAXmlDS(xmlstr);
		for (var i=0;i<ds.getRowCount();i++) {
			var guid = ds.getStringAt(i,"GUID");
			sql = "update tax_trkhdr set stat='2',tousr='"+tousr+"',enddat=to_date('"+enddat+"','yyyy-mm-dd'),chkusr='"+usrid+"',chkusrnam='"+usrnam+"',chkdat=sysdate where guid='"+guid+"' and stat<>'9'";
			ret += db.ExcecutSQL(sql);
		}
		db.Commit();
		
		return "批量任务分派成功，记录数"+ret;
	}
	catch(e) {
		if (db != null) db.Rollback();
		throw new Exception(e.toString());
	}	
	finally {
		if (db != null) db.Close();
	}
}


//替换SQL参数
function replaceParam(mwobj,request,sql)
{
	var dept = pub.EAFunc.NVL(request.getParameter("DEPT"),"");
	var stat = pub.EAFunc.NVL(request.getParameter("STAT"),"");
	
	if (dept != "") {
		sql = pub.EAFunc.Replace(sql,"--MORE","");
	}
	
	//处理传入多个状态的情况
	if (stat.indexOf(",") > -1) {
		var stats = pub.EAFunc.SQLIN(stat);
		sql = pub.EAFunc.Replace(sql,"[%STATSTR]","and stat in ("+stats+")");
	}
	else {
		sql = pub.EAFunc.Replace(sql,"[%STATSTR]","and stat like '"+stat+"%'");
	}
	
	return sql;

}


function closeTrk()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "";
		var ret = 0;
		var ds = new pub.EAXmlDS(xmlstr);
		for (var i=0;i<ds.getRowCount();i++) {
			var guid = ds.getStringAt(i,"GUID");
			//sql = "update tax_trkhdr set stat='0',chkusr='"+usrid+"',chkusrnam='"+usrnam+"',chkdat=sysdate where guid='"+guid+"' and tousr is null and todept is null";
			sql = "delete from tax_trkhdr where guid='"+guid+"' and tousr is null and todept is null";
			ret += db.ExcecutSQL(sql);
		}
		db.Commit();
		
		return "删除任务成功，记录数"+ret;
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
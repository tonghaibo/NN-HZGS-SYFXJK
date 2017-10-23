function TAXMON_TrkMng(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function getGuShiMenu()
{
	var sql = "select * from V_DEPT where org='"+thisorgid+"' and id<>'HSG' order by id ";
	var menuxml = "";
	var ds = pub.EADbTool.QuerySQL(sql);
	for(var r = 0;r < ds.getRowCount();r ++) {
		var id = ds.getStringAt(r,"id");
		var name = ds.getStringAt(r,"name");
		menuxml += "<item id=\""+id+"\" name=\""+name+"\"/>";
	}
	return menuxml;
}

function save()
{
	var db = null;
	try {
		var ds = new pub.EAXmlDS(xmlstr);
		db = new pub.EADatabase();
		var sql = "";
		var ret = 0;
		for (var i=0;i<ds.getRowCount();i++) {
			var flg = ds.getStringAt(i,"SELECTFLAG");
			var guid = ds.getStringAt(i,"GUID");
			if (flg == "1") {
				sql = "update tax_trkhdr set stat='8',todept='"+deptid+"' where guid='"+guid+"'";
				ret += db.ExcecutSQL(sql);
			}
		}
		db.Commit();
		
		return "成功分派 "+ret+" 条任务到股室";

	}
	catch(e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

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
			sql = "update tax_trkhdr set stat='1',tousr=null,chkdat=null,chkusr=null,chkusrnam=null where guid='"+guid+"' and stat='8'";
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
			sql = "update tax_trkhdr set stat='2',tousr='"+tousr+"',enddat=to_date('"+enddat+"','yyyy-mm-dd'),chkusr='"+usrid+"',chkusrnam='"+usrnam+"',chkdat=sysdate where guid='"+guid+"'";
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



}
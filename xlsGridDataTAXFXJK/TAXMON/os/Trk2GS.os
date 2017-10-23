function TAXMON_Trk2GS(){var pub = new JavaPackage("com.xlsgrid.net.pub");

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
//替换SQL参数
function replaceParam(mwobj,request,sql)
{
	var town = request.getParameter("TOWN");
	var elearea = request.getParameter("ELEAREA");

	if (town != "") {
		sql = pub.EAFunc.Replace(sql,"[%TOWN]"," and nvl(c.towns,' ')=(select name from v_tax_towns where id='"+town+"')");
	}
	if (elearea != "") {
		sql = pub.EAFunc.Replace(sql,"[%ELEAREA]"," and nvl(a.town,' ')=(select name from v_tax_elearea where id='"+elearea+"')");
	}
	return sql;
}

}
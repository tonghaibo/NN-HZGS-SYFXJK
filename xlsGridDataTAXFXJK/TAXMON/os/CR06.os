function TAXMON_CR06(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//替换SQL参数
function replaceParam(mwobj,request,sql)
{
	var town = pub.EAFunc.NVL(request.getParameter("TOWNS"),"");
	var flg = pub.EAFunc.NVL(request.getParameter("FLG"),"");
	if (town != "") {
		var townids = pub.EAFunc.SQLIN(town);		
		town = " and town in (select name from v_tax_elearea where id in ("+townids+"))";
	}
	sql = pub.EAFunc.Replace(sql,"[%TOWNS]",town);
	
	if (flg == "1") {
		sql = pub.EAFunc.Replace(sql,"[%FLG]"," and a.usrid not in (select ammno from tax_notinammno)");
	}
	if (flg == "0") {
		sql = pub.EAFunc.Replace(sql,"[%FLG]"," and a.usrid in (select ammno from tax_notinammno)");
	}
	else {
		sql = pub.EAFunc.Replace(sql,"[%FLG]","");
	}
	return sql;
}


function updateFlag()
{
	var db = null;
	var sql = "";
	var ret = 0;
	try {
		db = new pub.EADatabase();
		var ammnos = cms.split(",");
		for (var i=0;i<ammnos.length();i++) {
			sql = "insert into tax_notinammno(ammno,crtusr) values('"+ammnos[i]+"','"+thisusrid+"')";
			ret += db.ExcecutSQL(sql);
		}
		
		db.Commit();
		return "操作成功! 标志记录数"+ret;
	}
	catch(e) {
		if (db != null) db.Rollback();
		return "操作失败"+e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

function updateFlag2()
{
	var db = null;
	var sql = "";
	var ret = 0;
	try {
		db = new pub.EADatabase();
		var ammnos = cms.split(",");
		for (var i=0;i<ammnos.length();i++) {
			sql = "delete from tax_notinammno where ammno='"+ammnos[i]+"'";
			ret += db.ExcecutSQL(sql);
		}
		
		db.Commit();
		return "操作成功! 标志记录数"+ret;
	}
	catch(e) {
		if (db != null) db.Rollback();
		return "操作失败"+e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}
}
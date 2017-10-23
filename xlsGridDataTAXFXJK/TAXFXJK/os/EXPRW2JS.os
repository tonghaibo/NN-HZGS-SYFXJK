function TAXFXJK_EXPRW2JS(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//Ìæ»»SQL²ÎÊý
function replaceParam(mwobj,request,sql)
{
	var rwids = request.getParameter("rwids");
	rwids  = pub.EAFunc.SQLIN(rwids);
	sql = pub.EAFunc.Replace(sql,"[%RWIDS]"," and a.bilid in ("+rwids+")");
	return sql;
}

function getRWPCH()
{
	//return "17HZSJ001_FKPT";
	
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "select nvl(max(pch),'-1') pch from tax_trkhdr where bilid in ("+pub.EAFunc.SQLIN(rwids)+")";
		var tmppch = db.GetSQL(sql);
		if (tmppch != "-1") return tmppch;
		var pch = "";	
		sql = "select to_char(sysdate,'yy')||'HZ'
			       ||decode(substr('"+swjg+"',0,7),'1451100','SJ','1451101','PG','1451102','BB','1451121','ZP','1451122','ZS','1451123','FC','')
			       ||to_char(max(substr(pch,7,3))+1,'FM000') 
			       ||'_FKPT' pch
			from tax_trkhdr 
			where to_char(crtdat,'yyyy')=to_char(sysdate,'yyyy') and swjg_dm like substr('"+swjg+"',0,7)||'%'
			  and pch is not null";
		var ds = db.QuerySQL(sql);
		if (ds.getRowCount() > 0) {
			pch = ds.getStringAt(0,"PCH");
		}
		return pch;
		
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
	
}

function setRWPCH()
{
	var db = null;
	try {
		db = new pub.EADatabase();

		var sql = "update tax_trkhdr set pch='"+rwpch+"',stat='4' where bilid in ("+pub.EAFunc.SQLIN(rwids)+")";
		db.ExcecutSQL(sql);
		
		return 1;
		
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
	
}

}
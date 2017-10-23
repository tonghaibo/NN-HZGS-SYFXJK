function TAXFXJK_FPFXHCB(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function Save()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		
		var sql = "update TAX_FPFX_HCB set GDJYCD='%s',SCSB='%s',GDJYRY='%s',FDDBR='%s',CWFZR='%s',BSY='%s',YWY='%s',
				DLY='%s',HT='%s',JJSKZZ='%s',WLXX='%s',SS='%s',FLAG='%s',NOTE='%s',SSGLY='%s',FJFZR='%s',XQJYJ='%s'
			where trkguid='%s'".format([GDJYCD,SCSB,GDJYRY,FDDBR,CWFZR,BSY,YWY,DLY,HT,JJSKZZ,WLXX,SS,FLAG,NOTE,SSGLY,FJFZR,XQJYJ,TRKGUID]);
		var cnt = db.ExcecutSQL(sql);
		
		sql = "select stat from tax_trkhdr where guid='"+TRKGUID+"'";
		var stat = db.GetSQL(sql);
			
		if (cnt > 0) {
			if (stat == "2") {
				//更新核实任务应对处理的状态
				sql = "update tax_trkhdr set stat='3',redat=sysdate where guid='"+TRKGUID+"'";
				db.ExcecutSQL(sql);
			}
		}
		db.Commit();
		return "保存成功";
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

//提交任务
function SubmitTrk(newstat,TRKGUID,msgusr)
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "select * from tax_trkhdr where guid='"+TRKGUID+"'";
		var ds = db.QuerySQL(sql);
		var swjg = ds.getStringAt(0,"SWJG_DM");	
		var tousr = ds.getStringAt(0,"TOUSR");	
		if (msgusr == "" && newstat == "32") {
			sql = "select usrid from tax_fxjk_msgtouser where typ='01' and swjg='"+swjg+"'";
			msgusr = db.GetSQL(sql);
		}
		else {
			sql = "update TAX_FPFX_HCB set FJFZR='"+msgusr+"' where trkguid='"+TRKGUID+"'";
			db.ExcecutSQL(sql);
		}
		
		sql = "update tax_trkhdr set stat='"+newstat+"',tousr='"+msgusr+"',redat=sysdate where guid='"+TRKGUID+"'";
		db.ExcecutSQL(sql);
		
		db.Commit();
		return "提交任务成功";
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

function SubmitTrk2FJ()
{
	return SubmitTrk(newstat,TRKGUID,tousr);
}

function SubmitTrk2ZGG()
{
	return SubmitTrk(newstat,TRKGUID,tousr);
}


}
function TAXFXJK_FXB1(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var servletPack = new JavaPackage("com.xlsgrid.net.servlet");

function genFxData()
{
	var db = null;
	var sql = "";
	
	try {
		db = new pub.EADatabase();
		
		var mwsql = new servletPack.MWSQL();

		var mwid = "FXB1"; //中间件的编号
		for (var i=1;i<=4;i++) {
			var dsid = "TAX_FXB1" + i; //数据源ID=表名
			var dssql = "";
			try { dssql = mwsql.GetQuerySQL(request,db,"TAXFXJK",mwid,dsid); } catch (e1) { }
			if (dssql != "" && dssql != null) {
				dssql = pub.EAFunc.Replace(dssql,"[%YM1]",YM1);
				dssql = pub.EAFunc.Replace(dssql,"[%YM2]",YM2);
				
				if (dsid == "TAX_FXB11" || dsid == "TAX_FXB12" || dsid == "TAX_FXB14") {
					sql = "delete from " + dsid + " where yymm>=replace('"+YM1+"','-','') and yymm<=replace('"+YM2+"','-','')";
					db.ExcecutSQL(sql);
				}
				else if (dsid == "TAX_FXB13") {
					sql = "delete from " + dsid + " where yyyy=substr('"+YM1+"',0,4)";
					db.ExcecutSQL(sql);
				}
				
				db.ExcecutSQL(dssql); //insert into
				
			}	
		}
		
		//记录生成日志
		sql = "insert into tax_scfxsj_log(crtusr,ym1,ym2,fxlx) values('"+usrid+"','"+YM1+"','"+YM2+"','TAX_FXB1')";
		db.ExcecutSQL(sql);
		
		db.Commit();
		return "生成分析数据成功！";
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
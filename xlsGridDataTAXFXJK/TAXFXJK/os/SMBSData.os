function TAXFXJK_SMBSData(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );

//实名办税数据导入
function importSMBS()
{
	var db = null;
	var ds = null;
	var sql = "";
	var ret = "";
	var tabname = tabnam;
	var updcount = 0;
	var inscount = 0;
	try{
		db = new pubpack.EADatabase();
		
		sql = "select * from user_tables where table_name=upper('"+tabname+"')";
		var cnt = db.GetSQLRowCount(sql);
		if(cnt <= 0) return "无数据可以导入";
		
		var mycnt = 0;
		
		sql = "delete from "+tabname+" where co0='纳税人识别号'";
		db.ExcecutSQL(sql);
		
		sql = "delete from tax_smqy_ybnsr";
		db.ExcecutSQL(sql);

		sql = "insert into tax_smqy_ybnsr(nsrsbh,nsrmc,fddbrxm,fddbrsfzhm,frcjqk,cwfzrxm,cwfzrsfzhm,cwcjqk,bsrxm,bsrsfzhm,bsrcjqk,gprxm,gprsfzhm,gprcjqk)
			select co0,co1,co2,co3,co4,co5,co6,co7,co8,co9,co10,co11,co12,co13 
			from "+tabname;
		inscount = db.ExcecutSQL(sql);
		
		ret = "导入完成！共导入"+inscount+"条记录";
		//删除临时表
		sql = "drop table "+tabname;
		db.ExcecutSQL(sql);			

		return ret;
	}
	catch(e) {
		if(db != null) db.Rollback();
		return e.toString();
	}
	
	finally {
		if(db != null)	db.Close();
	}
}



}
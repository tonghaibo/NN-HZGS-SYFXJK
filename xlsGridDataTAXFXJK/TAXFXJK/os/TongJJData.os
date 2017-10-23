function TAXFXJK_TongJJData(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );

//GDP数据导入
function importData()
{
	var db = null;
	var ds = null;
	var sql = "";
	var tabname = tabnam;
	//var typ = typ;
	var ret = "";
	var updcount = 0;
	var inscount = 0;
	try{
		db = new pubpack.EADatabase();
		
		sql = "select * from user_tables where table_name=upper('"+tabname+"')";
		var cnt = db.GetSQLRowCount(sql);
		if(cnt <= 0) return "无数据可以导入";
		
		var mycnt = 0;
		
		//修改表，增加列名，存储数据所属月份
		sql = "alter table "+tabname+" add yymm varchar2(10)";		
		db.ExcecutSQL(sql);	
		
		sql = "update "+tabname+" set co0=replace(co0,'？','')";
		db.ExcecutSQL(sql);
		
		sql = "update "+tabname+" set yymm=(
			select to_char(to_date(substr(co0,0,4) ||substr(co0,instr(co0,'-'),instr(co0,'月')-instr(co0,'-')),'yyyy-mm'),'yyyymm') yymm 
			from "+tabname+" where co0 like '%国民经济主要指标%'
			)";
		db.ExcecutSQL(sql);
		
		sql = "insert into TAX_TJJDATA(zbbh,zbmc,ljzl,Zsbl,yymm)
			select rownum zbbh,co0,replace(co1,'—','') ljzl,co2,yymm
			from "+tabname+" 
			where co0 not like '%国民经济主要指标%' 
			  and co0 not like '指标%' and co1 not like '总量（万元）'
			  and yymm not in (select yymm from TAX_TJJDATA)";
                                             
		inscount = db.ExcecutSQL(sql);	
							
		ret = "导入完成！共新增"+inscount+"条记录";
		
		//删除临时表
		sql = "drop table "+tabname;
		db.ExcecutSQL(sql);			
		
		db.Commit();
		
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
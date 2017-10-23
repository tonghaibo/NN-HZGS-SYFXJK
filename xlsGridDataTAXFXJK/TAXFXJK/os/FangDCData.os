function TAXFXJK_FangDCData(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );

//驾校数据导入
function importTree()
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
		
		//删除数据
		sql="delete from "+tabname+"  where co0 like '%开发企业%'  ";
		db.ExcecutSQL(sql);	
		
		//修改表，增加列名，存储数据所属月份
		//sql = "alter table "+tabname+" add sjssyf varchar2(60)";		
		//mycnt = db.ExcecutSQL(sql);	
		
              

		//插入数据--更新数据到：
		
	sql = " insert into TAX_FANGDCDATA (FDCKFQYMC,YSZPZSJ,XSLHMC,ZTS,ZMJ,ZZNXSJJ,KSTS,PZTS,YSMJ,YSZZMJ,YSSYMJ,YSCKMJ,YSQTMJ)
   		select co0,co1,co2,to_number(co3),to_number(co4),to_number(co5),to_number(co6),to_number(co7),to_number(co8),to_number(co9),to_number(co10),to_number(co11),to_number(co12) 
		from "+tabname+" 
		where not exists (
			select  FDCKFQYMC,YSZPZSJ,XSLHMC,ZTS,ZMJ,ZZNXSJJ,KSTS,PZTS,YSMJ,YSZZMJ,YSSYMJ,YSCKMJ,YSQTMJ,a.SJSSYF
			from TAX_FANGDCDATA  a ,"+tabname+"  t
   			where a.FDCKFQYMC=t.co0 and a.YSZPZSJ=t.co1 and a.XSLHMC=t.co2 and a.ZTS=to_number(t.co3) and 
         			a.ZMJ=to_number(t.co4) and a.ZZNXSJJ=to_number(t.co5) and a.KSTS=to_number(t.co6) and a.PZTS=to_number(co7) and
         			a.YSMJ=to_number(t.co8) and a.YSZZMJ=to_number(t.co9) and a.YSSYMJ=to_number(t.co10) and a.YSCKMJ=to_number(t.co11)
         		and a.YSQTMJ=to_number(t.co12) 
        ) ";			
		inscount = db.ExcecutSQL(sql);	
							
		ret = "导入完成！共新增"+inscount+"条记录，更新"+updcount +"条记录";
		
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
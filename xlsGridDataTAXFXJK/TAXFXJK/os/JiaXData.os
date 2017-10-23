function TAXFXJK_JiaXData(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
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
		
		//修改表，增加列名，存储数据所属月份
		sql = "alter table "+tabname+" add sjssyf varchar2(60)";		
		mycnt = db.ExcecutSQL(sql);	
		//if(mycnt == 0) {
		//	db.Rollback();
		//	return "导入失败！导入的文件格式不正确"+tabname;
		//}
		
		//增加数据导入日期	
		sql = "update "+tabname+"  set sjssyf=(select (case when yf<=9 then concat(nd,concat(0,yf)) else concat(nd,yf) end) sjssyf
                from( select substr(substr(trim(ny),instr(trim(ny),'2')),1,4)nd,substr(ny,instr(ny,'年')+1, instr(ny,'月')-instr(ny,'年')-1)yf 
                    from (select co0,substr(trim(co0),instr(trim(co0),'2')) ny from "+tabname+"  where rownum=1) ))";
		db.ExcecutSQL(sql);
		
		//删除标题行数据
               sql="delete from "+tabname+" where (co0 like '%每月受理各培训驾校驾驶人月报表%' or co0 like '%驾校名称%' or co0 like '%合计%'or co0 is null)";
               db.ExcecutSQL(sql); 
                                             

		//插入数据--更新数据到：驾校受理数据表TAX_JIAXDATA，先行转列再插入数据	
		//JIAXGUID 驾校数据UUID ; DIQLX 地区类型：本地、区内、区外 ;JIAZLX	 驾照类型：A1、A2、A3、B1、B2、C1、C2、C5	;
            //LINGQLX 领取类型：初领、增驾;SHOULRS 受理人数;SJDRRQ 数据导入日期;SJSSYF 数据所属月份;JIAXMC 驾校名称;SFCSDM 收费参数代码

		sql = " insert into TAX_JIAXDATA (JIAXMC,sfcsdm,diqlx,jiazlx,lingqlx,shoulrs,sjssyf)
with tmp_hzl_jx as(
select co0,sfcsdm,diqlx,jiazlx,lingqlx,to_number(shoulrs)shoulrs,sjssyf from 
( 
select co0,'01' sfcsdm,'本地' diqlx ,'A1'jiazlx,'初领'lingqlx, co1 as shoulrs ,sjssyf  from  "+tabname+"  union all
select co0,'02' sfcsdm,'本地' diqlx ,'A1'jiazlx,'增驾'lingqlx, co2 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'03' sfcsdm,'本地' diqlx ,'A2'jiazlx,'初领'lingqlx, co3 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'04' sfcsdm,'本地' diqlx ,'A2'jiazlx,'增驾'lingqlx, co4 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'05' sfcsdm,'本地' diqlx ,'A3'jiazlx,'初领'lingqlx, co5 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'06' sfcsdm,'本地' diqlx ,'A3'jiazlx,'增驾'lingqlx, co6 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'07' sfcsdm,'本地' diqlx ,'B1'jiazlx,'初领'lingqlx, co7 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'08' sfcsdm,'本地' diqlx ,'B1'jiazlx,'增驾'lingqlx, co8 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'09' sfcsdm,'本地' diqlx ,'B2'jiazlx,'初领'lingqlx, co9 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'10' sfcsdm,'本地' diqlx ,'B2'jiazlx,'增驾'lingqlx, co10 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'11' sfcsdm,'本地' diqlx ,'C1'jiazlx,'初领'lingqlx, co11 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'12' sfcsdm,'本地' diqlx ,'C1'jiazlx,'增驾'lingqlx, co12 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'13' sfcsdm,'本地' diqlx ,'C2'jiazlx,'初领'lingqlx, co13 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'14' sfcsdm,'本地' diqlx ,'C2'jiazlx,'增驾'lingqlx, co14 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'15' sfcsdm,'本地' diqlx ,'C5'jiazlx,'初领'lingqlx, co15 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'16' sfcsdm,'本地' diqlx ,'C5'jiazlx,'增驾'lingqlx, co16 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'17' sfcsdm,'区内' diqlx ,'C1'jiazlx,'初领'lingqlx, co17 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'18' sfcsdm,'区内' diqlx ,'C1'jiazlx,'增驾'lingqlx, co18 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'19' sfcsdm,'区外' diqlx ,'C1'jiazlx,'初领'lingqlx, co19 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'20' sfcsdm,'区外' diqlx ,'C1'jiazlx,'增驾'lingqlx, co20 as shoulrs ,sjssyf from  "+tabname+"  
)where (to_number(shoulrs)<>0 and shoulrs is not null) 
)select * from tmp_hzl_jx 
where not exists (
select a.JIAXMC,a.sfcsdm,a.diqlx,a.jiazlx,a.lingqlx,a.shoulrs,a.sjssyf
 from TAX_JIAXDATA a ,tmp_hzl_jx t
    where a.JIAXMC=t.co0 and a.sfcsdm=t.sfcsdm and a.diqlx=t.diqlx and a.jiazlx=t.jiazlx and a.lingqlx=t.lingqlx and a.shoulrs= t.shoulrs 
       and a.sjssyf=t.sjssyf ) ";	
			
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
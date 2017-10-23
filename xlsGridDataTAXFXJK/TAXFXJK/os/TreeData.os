function TAXFXJK_TreeData(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );

//林业数据导入
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
		
		//导入的中间表数据清理，删除文件中的垃圾行数据，删除标题行
		sql = "delete from "+tabname+" where  co0 like '%县别%' or co0 like '%木材运输销售清单%'";
		mycnt = db.ExcecutSQL(sql);	
		if(mycnt == 0) {
			db.Rollback();
			return "导入失败！导入的文件格式不正确"+tabname;
		}
		
		//增加数据导入日期	
		sql = "update "+tabname+" set co0=to_char(sysdate,'yyyy-mm-dd')";
		db.ExcecutSQL(sql);
		
		//补齐 采伐证年度、签证月份
               sql="update "+tabname+" set co3=(select distinct co3 from "+tabname+" where co3 is not null and rownum=1),
               co33=(select distinct co33 from "+tabname+" where co33 is not null and rownum=1)
               where co3 is null or co33 is null";
               db.ExcecutSQL(sql); 
                                             

		//插入数据--更新数据到：木材数据表TAX_TREE_MC，先行转列再插入数据	
		//0年月	1运输证编号 2发证依据 3采伐证年度 4运输证属性 5销售属性	6木材产地 8发货单位 9乡镇 林业产品种类代码，林业产品种类名称，33签证月份，数据导入日期
		sql = " insert into TAX_TREE_MC (YSZBH,FZYJ_DM,CFZND,YSZSX_DM,XSSX_DM,MCCD_DM,FHDW,XZ,LYCPZL_DM,LYCPZLMC,XSSL,QZYF,SJDRRQ,SJSSYF)
with tmp_hzl as(
select co1,co2,co3,co4,co5,co6,co8,co9,LYCPZL_DM,LYCPZLMC,XSSL,to_number(co33)yf,to_date(co0,'yyyy-mm-dd'),
(case when to_number(co33)<=9 then concat(concat(to_number(co3),0),to_number(co33)) else concat(to_number(co3),to_number(co33)) end)sjssyf 
from 
( 
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'01' lycpzl_dm,'杉原条木' lycpzlmc ,   co10 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'02' lycpzl_dm,'杉锯材' lycpzlmc ,     co11 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'03' lycpzl_dm,'松原条木' lycpzlmc ,   co12 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'04' lycpzl_dm,'松锯材' lycpzlmc ,     co13 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'05' lycpzl_dm,'松火柴合片' lycpzlmc , co14 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'06' lycpzl_dm,'杂原条木' lycpzlmc ,   co15 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'07' lycpzl_dm,'杂锯材' lycpzlmc ,     co16 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'20' lycpzl_dm,'杂木衣架件' lycpzlmc , co17 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'08' lycpzl_dm,'纤维板' lycpzlmc ,     co18 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'09' lycpzl_dm,'胶合板' lycpzlmc ,     co19 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'10' lycpzl_dm,'胶单板' lycpzlmc ,     co20 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'21' lycpzl_dm,'柴火吨' lycpzlmc ,     co21 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'11' lycpzl_dm,'木地板' lycpzlmc ,     co22 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'12' lycpzl_dm,'家具立方' lycpzlmc ,   co23 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'22' lycpzl_dm,'苗木株' lycpzlmc ,     co24 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'23' lycpzl_dm,'家具件' lycpzlmc ,     co25 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'24' lycpzl_dm,'剩余物锯材' lycpzlmc , co26 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'13' lycpzl_dm,'木片吨' lycpzlmc ,     co27 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'25' lycpzl_dm,'剩余物立方' lycpzlmc , co28 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'14' lycpzl_dm,'剩余物吨' lycpzlmc ,   co29 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'26' lycpzl_dm,'竹根' lycpzlmc ,       co30 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'27' lycpzl_dm,'竹吨' lycpzlmc ,       co31 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'28' lycpzl_dm,'竹半成品件' lycpzlmc , co32 as xssl from  "+tabname+"  
)where (to_number(xssl)<>0 and xssl is not null) 
)select * from tmp_hzl 
where not exists (
select a.YSZBH,a.FZYJ_DM,a.CFZND,a.YSZSX_DM,a.XSSX_DM,a.MCCD_DM,a.FHDW,a.XZ,a.LYCPZL_DM,a.LYCPZLMC,a.XSSL,a.QZYF,a.sjssyf
 from TAX_TREE_MC a ,tmp_hzl t
    where a.YSZBH=t.co1 and a.fzyj_dm=t.co2 and a.CFZND=t.co3 and a.yszsx_dm=t.co4 and a.XSSX_DM=t.co5 and a.MCCD_DM= t.co6 
       and a.FHDW=t.co8 and nvl(a.xz,'N')=nvl(t.co9,'N') and a.lycpzl_dm=t.lycpzl_dm and a.xssl=to_number(t.xssl) 
        and to_number(a.QZYF) = to_number(t.yf)and a.sjssyf=t.sjssyf)  ";	
			
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
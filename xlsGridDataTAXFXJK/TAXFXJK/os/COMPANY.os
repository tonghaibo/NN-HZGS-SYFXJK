function TAXFXJK_COMPANY(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");

//添加额外html
//afterBodyHtml事件后触发，已过时，建议用afterBodyHtml事件进行处理
function addBottomHtml(mwobj,request,sb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("<input type='file' id='fileInput'/>");
}

//同步纳税人信息
function runImpNSR()
{
	var db = null;
	var sql = "";
	var ret = 0;
	try
	{
		db = new pubpack.EADatabase();	
//		sql = "drop table dj_nsrxx";
//		db.ExcecutSQL(sql);
//		sql = "create table dj_nsrxx as select * from dj_nsrxx@taxdb";
//		db.ExcecutSQL(sql);
//		
//		sql = "drop table dj_nsrxx_kz";
//		db.ExcecutSQL(sql);
//		sql = "create table dj_nsrxx_kz as select * from dj_nsrxx_kz@taxdb";
//		db.ExcecutSQL(sql);
//		
//		sql = "delete from tax_company";
//		db.ExcecutSQL(sql);
//		sql = "insert into tax_company (jdxz_dm,id,name,hycode,pwdept,typ,taxman,towns,
//			lawman,addr,crtdat,typclsid,ytaxman,stat,flag,SWJG_DM,hy_dm,hymx_dm,hy_mc,hymx_mc)
//			select a.jdxz_dm,a.nsrsbh,a.nsrmc,b.qysbh hycode,'' pwdept,a.djzclx_dm typ,zg_swgy_dm,jdxz_dm,fddbrmc,scjydz,sysdate,
//			'' typclsid,'' ytaxman,nsrzt_dm,'1',a.SWJG_DM,hy_dm,hymx_dm,''hy_mc,''hymx_mc
//			from dj_nsrxx a,dj_nsrxx_kz b
//			where a.NSRSBH=b.NSRSBH 
//			and a.nsrsbh not in (select id from tax_company)";
//		var ret = db.ExcecutSQL(sql);

		sql = "update tax_company a set hy_mc=(select hymc from dm_gy_hy b where a.hy_dm=b.hy_dm)";
		db.ExcecutSQL(sql);
		
		
		sql = " update tax_company a set hymx_dm=(select hymx_dm from (
			select a.nsrsbh,hymx_dm
			from dj_nsrxx@taxdb a,dj_nsrxx_kz@taxdb b
			where a.NSRSBH=b.NSRSBH 
			) b where a.id=b.nsrsbh
			)";
		db.ExcecutSQL(sql);
		
		sql = "update tax_company a set hymx_mc=(select hymx_mc from dm_hymx@taxdb b where a.hymx_dm=b.hymx_dm)";
		db.ExcecutSQL(sql);

		sql = "update tax_company a set typclsid=(select max(id) from tax_compclass b
       			where a.hycode like '%'||b.hycode||'%')";
       		db.ExcecutSQL(sql);
       		
       		db.Commit();
       		
       		return "同步完成,导入记录"+ret;
	}
	catch ( e )
	{
		if(db != null) db.Rollback();
		throw new Exception(e);
	}
	finally
	{
		if(db != null) db.Close();
	}
}

//co0 行业代码	
//co1 纳税人识别号	
//co2 纳税人名称	
//co3 法定代表人	
//co4 供电部门	
//co5 电表号	
//co6 一般纳税人标志	
//co7 企业类型	
//co8 税管员	
//co9 纳税人状态	
//co10 所属乡镇	
//co11 生产经营地址	
function insert()
{
	var db = null;
	var sql = "";
	var ds = null;
	var table = tabnam;
	try
	{
		db = new pubpack.EADatabase();	
		sql = "select * from user_tables where table_name = upper('"+table+"')";
		ds = db.QuerySQL(sql);
		if (ds.getRowCount() > 0)
		{
			sql = "update "+table+" set co6=decode(co6,'Y','1','是','1','0')";
			db.ExcecutSQL(sql);
			
			sql = "update tax_company a set (name,hycode,pwdept,typ,taxman,towns,lawman,addr,ytaxman,stat)=
		        (select trim(co2),replace(replace(trim(co0),'--','_'),' ',''),trim(co4),trim(co7),trim(co8),trim(co10),trim(co3),trim(co11),co6,trim(co9) from "+table+" b
		          where a.id=trim(b.co1) and nvl(a.ammno,'A')=nvl(trim(b.co5),'A') and nvl(a.pwdept,'A')=nvl(trim(b.co4),'A'))
		        where (id,nvl(ammno,'A'),nvl(pwdept,'A')) in (select co1,nvl(trim(co5),'A'),nvl(co4,'A') from "+table+")";
			var count1 = db.ExcecutSQL(sql);
		
	          	sql = "insert into tax_company (ID,NAME,HYCODE,PWDEPT,AMMNO,TYP,TAXMAN,TOWNS,LAWMAN,ADDR,YTAXMAN,STAT)
			select co1,co2,hycode,co4,co5,co7,co8,co10,co3,co11,co6,co9 from (
			select co1,co2,replace(replace(trim(co0),'--','_'),' ','') hycode,co4,decode(instr(co5,'.'),0,co5,to_number(co5)) co5,co7,co8,co10,co3,co11,co6,co9 from "+table+" a 
			where co1 !='纳税人识别号') a
			where not exists (select 1 from tax_company where tax_company.ID=a.co1 and nvl(tax_company.ammno,'1')=nvl(a.co5,'1') )";
	          	var count2 = db.ExcecutSQL(sql);
	          	
	            	//修改typclsid字段
	            	sql = "update tax_company a set typclsid =nvl((select max( b.id)  from tax_compclass b 
         			where  substr(replace(a.hycode,'-','_'),instr(replace(a.hycode,'-','_'),replace(b.hycode,'nsrbm_',''),1,1),length(replace(b.hycode,'nsrbm_',''))) = replace(b.hycode,'nsrbm_','')),'')         			     
	        		where exists (select 1 from tax_company a,tax_compclass b   where  
    				substr(replace(a.hycode,'-','_'),instr(replace(a.hycode,'-','_'),replace(b.hycode,'nsrbm_',''),1,1),length(replace(b.hycode,'nsrbm_','')))= replace(b.hycode,'nsrbm_','') )
    				and to_char(crtdat,'yyyymmdd')=to_char(sysdate,'yyyymmdd')";
	            	db.ExcecutSQL(sql);
	            	
	            	db.Commit();
			return "更新记录"+count1+"笔，插入记录"+count2+"笔";
		}
		else
			return "无数据可以导入的！";
	}
	catch ( e )
	{
		if(db != null) db.Rollback();
		throw new Exception(e);
	}
	finally
	{
		sql = "select * from user_tables where table_name = upper('"+table+"')";
		ds = pub.EADbTool.QuerySQL(sql);
		if (ds.getRowCount() > 0)
		{
			sql = "drop table "+ table;
			pub.EADbTool.ExcecutSQL(sql);
		}
		if(db != null) db.Close();
	}	
}

function impNSR()
{
	var db = null;
	var sql = "";
	var ds = null;
	var table = tabnam;
	try
	{
		db = new pubpack.EADatabase();	
		sql = "select * from user_tables where table_name = upper('"+table+"')";
		ds = db.QuerySQL(sql);
		if (ds.getRowCount() > 0)
		{
			sql = "delete from "+table+" where co1 like '%NSRSBH%'";
			db.ExcecutSQL(sql);
			
			sql = "update " + table + " set co2=replace(co2,chr(0),''), co3=replace(co3,chr(0),''),co18=replace(co18,chr(0),''), co10=replace(co10,chr(0),''), co29=replace(co29,chr(0),'')";
			db.ExcecutSQL(sql);
			
			sql = "update " + table + " set co2=replace(co2,'<null>',''), co3=replace(co3,'<null>',''),co18=replace(co18,'<null>',''), co10=replace(co10,'<null>',''), co29=replace(co29,'<null>','')";
			db.ExcecutSQL(sql);
			

			sql = "update tax_company a set (name,typ,taxman,towns,lawman,addr,ytaxman,stat)=
		        (select co2 name,co13 typ,co18 taxman,co29 towns,co3 lawman,co10 addr,co15 ytaxman,co14 stat from "+table+" b where a.id=b.co11)
		        where a.id in (select co1 from "+table+")";
			var count1 = db.ExcecutSQL(sql);
		
	          	sql = "insert into tax_company(typclsid,id,name,lawman,ytaxman,typ,taxman,stat,towns,addr,nsr_zsjg_dm,hy_dm,hymx_dm,hy_mc,hymx_mc)
				select co7 typclsid,co1 id,co2 name,co3 lawman,co15 ytaxman,co13 typ,co18 taxman,co14 stat,co29 towns,co10 addr,co18 nsr_zsjg_dm,co7 HY_DM,co7 hymx_dm,'' hy_mc,'' hymx_mc
				from " + table + " where co1 not in (select id from tax_company)";

			var count2 = db.ExcecutSQL(sql);
	          	
	            	//修改typclsid字段
//	            	sql = "update tax_company a set typclsid =nvl((select max( b.id)  from tax_compclass b 
//         			where  substr(replace(a.hycode,'-','_'),instr(replace(a.hycode,'-','_'),replace(b.hycode,'nsrbm_',''),1,1),length(replace(b.hycode,'nsrbm_',''))) = replace(b.hycode,'nsrbm_','')),'')         			     
//	        		where exists (select 1 from tax_company a,tax_compclass b   where  
//    				substr(replace(a.hycode,'-','_'),instr(replace(a.hycode,'-','_'),replace(b.hycode,'nsrbm_',''),1,1),length(replace(b.hycode,'nsrbm_','')))= replace(b.hycode,'nsrbm_','') )
//    				and to_char(crtdat,'yyyymmdd')=to_char(sysdate,'yyyymmdd')";
//	            	db.ExcecutSQL(sql);
	            	
	            	db.Commit();
			return "更新记录"+count1+"笔，插入记录"+count2+"笔";
		}
		else
			return "无数据可以导入的！";
	}
	catch ( e )
	{
		if(db != null) db.Rollback();
		throw new Exception(e);
	}
	finally
	{
		sql = "select * from user_tables where table_name = upper('"+table+"')";
		ds = pub.EADbTool.QuerySQL(sql);
		if (ds.getRowCount() > 0)
		{
			sql = "drop table "+ table;
			pub.EADbTool.ExcecutSQL(sql);
		}
		if(db != null) db.Close();
	}	
}

}
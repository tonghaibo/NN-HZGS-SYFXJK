function TAXFXJK_IMP_TaxData(){var pub = new JavaPackage("com.xlsgrid.net.pub");

/***************************************************************************************
//DBLINK的创建语句
--金税三期查询机
create database link JS3Q
  connect to hzcx identified by "hzgs#1234"
  using '(DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 87.12.74.12)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = gxsthxcx)
    )
  )';
  
--ctais查询机
create database link CTAIS
  connect to hzcx identified by "hzgs#1234"
  using '(DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 87.16.16.4)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = ctais)
    )
  )';    
  
--电子抵账查询
create database link DZDZ
  connect to dzdzcx_hz identified by "dzdz#hz69"
  using '(DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 87.16.19.34)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dzdz)
    )
  )';  

--数据仓库
create database link GXDW
  connect to hzgs identified by "hzgs6286"
  using '(DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 87.16.17.161)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SID = gxdw)
    )
  )'; 
*/
///////////////////////////////////////////////////////////////////////////////////////////////////////
  

//保存标志为同步的表信息
function Save()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		
		var ds = new pub.EAXmlDS(xmlstr);
		for (var i=0;i<ds.getRowCount();i++) {
			var guid = ds.getStringAt(i,"GUID");
			var tbbz = ds.getStringAt(i,"TBBZ");
			var sql = "update tax_jssjtbb set tbbz='"+tbbz+"' where guid='"+guid+"'";
			db.ExcecutSQL(sql);
		}
		
		db.Commit();
		return "保存成功！更新记录数"+ds.getRowCount();
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

//删除表信息
function Delete()
{	
	
	var db = null;
	try {
		db = new pub.EADatabase();
		
		var ds = new pub.EAXmlDS(xmlstr);
		for (var i=0;i<ds.getRowCount();i++) {
			var guid = ds.getStringAt(i,"GUID");
			var sql = "delete from tax_jssjtbb where guid='"+guid+"'";
			db.ExcecutSQL(sql);
		}
		
		db.Commit();
		return "删除成功！记录数"+ds.getRowCount();
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}


//执行同步表的操作
function RunTB()
{
	var CJK_OWNER = "CJ_FXJK"; //风险监控平台采集数据库用户
	var db = null;					
	var tb_note = "成功"; //采集结果说明
				
	try {
		db = new pub.EADatabase();
		var sql = "";
		var ds = null;
		
		//如果不是界面传入同步的参数，那么就是后台任务执行的
		if (xmlstr == "") {
			sql = "select * from tax_jssjtbb where tbbz='1' order by tbxh,owner,table_name";
			ds = db.QuerySQL(sql);
		}
		else {
			ds = new pub.EAXmlDS(xmlstr);
		}
		for (var i=0;i<ds.getRowCount();i++) {
			tb_note = "成功"; //采集结果说明
			var guid = ds.getStringAt(i,"GUID");
			var tbbz = ds.getStringAt(i,"TBBZ");
			var dblink = ds.getStringAt(i,"DBLINK");
			var owner = ds.getStringAt(i,"OWNER");
			var table_name = ds.getStringAt(i,"TABLE_NAME");
			var sourceTable = owner + "." + table_name + "@" + dblink;
			var tabds = db.QuerySQL("select * from tax_jssjtbb where guid='"+guid+"'");
			var zlbz = tabds.getStringAt(0,"ZLBZ");
			var zlwherestr = tabds.getStringAt(0,"WHERESTR");
			
			var start_time = db.GetSQL("select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') from dual"); //同步开始时间
			var tb_jls = 0; //同步记录数
				
			if (tbbz == "1") {
				try {
					try { sql = "alter table " + CJK_OWNER + "." + table_name + " nologging";
					  db.ExcecutSQL(sql);
					} catch(e) {}
					
					//检查采集库里是否已经建有表
					var chktab = checkTableExists(db,CJK_OWNER,table_name);
					//如果表存在，则删除记录后再插入
					if (chktab == 1 && zlbz != "1") {
						sql = "drop table " + CJK_OWNER + "." + table_name;
						db.ExcecutSQL(sql);
						
						sql = "create table " + CJK_OWNER + "." + table_name + " as select * from " + sourceTable + " where 1>2";
						db.ExcecutSQL(sql);

					}				
										
					//从金税三期数据库同步数据
					if (chktab != "1") {
						sql = "create table " + CJK_OWNER + "." + table_name + " as select * from " + sourceTable + " where 1>2";
						db.ExcecutSQL(sql);
					}
					
					//抓取数据的过滤条件（只抓贺州的数据）
					var wherestr = ""; 
					var filterstr = "";
					var chktabcols = checkTableHasColumn(db,CJK_OWNER,table_name,"SJGSDQ"); //SJGSDQ数据归属地区
					if (chktabcols == 1) {
//						chktabcols = checkTableHasColumn(db,CJK_OWNER,table_name,"DJXH"); //DJXH纳税人登记序号
//						if (chktabcols == 1) {
//							if (filterstr == "") filterstr += " ( SJGSDQ like '14511%' or djxh in (select djxh from hx_dj.dj_nsrxx@js3q where zgswj_dm like '14511%') ) ";
//							else filterstr += " or ( SJGSDQ like '14511%' or djxh in (select djxh from hx_dj.dj_nsrxx@js3q where zgswj_dm like '14511%') ) ";
//						}
//						else {
							if (filterstr == "") filterstr += " SJGSDQ like '14511%'";
							else filterstr += " or SJGSDQ like '14511%'";
//						}
					}
					chktabcols = checkTableHasColumn(db,CJK_OWNER,table_name,"ZGSWSKFJ_DM"); //ZGSWSKFJ_DM主管税务所科分局
					if (chktabcols == 1) {
						if (filterstr == "") filterstr += " ZGSWSKFJ_DM like '14511%'";
						else filterstr += " or ZGSWSKFJ_DM like '14511%'";
					}
					chktabcols = checkTableHasColumn(db,CJK_OWNER,table_name,"ZGSWJ_DM"); //ZGSWJ_DM 主管税务机构
					if (chktabcols == 1) {
						if (filterstr == "") filterstr += " ZGSWJ_DM like '14511%'";
						else filterstr += " or ZGSWJ_DM like '14511%'";
					}
					
					if (filterstr != "") {
						wherestr = " and ( " + filterstr + " ) ";
					}
					////////
					
					sql = "insert into "+ CJK_OWNER + "." + table_name + " select * from " + sourceTable;
					if (wherestr != "") sql += " where 1=1 " + wherestr;
					//增量同步模式下的条件
					if (zlbz == "1") {
						if (wherestr != "") sql += " and ( " + zlwherestr + " )";
						else sql += " where ( " + zlwherestr + " )";

						//先删除再同步
						var delsql = "delete from " + CJK_OWNER + "." + table_name + " where 1=1 " + wherestr + " and ("+zlwherestr+")";
						db.ExcecutSQL(delsql);

					}
					
					//throw new Exception(sql);
					tb_jls = db.ExcecutSQL(sql);
					
				} catch (e) {
					tb_note = pub.EAFunc.Replace(e.toString(),"'","''");
					pub.EAFunc.Log("采集:table_name="+table_name+" 出错="+e.toString());						
				}
				finally {
					try {sql = "alter table " + CJK_OWNER + "." + table_name + " logging";
					db.ExcecutSQL(sql);
					} catch(e) {}
				}
				
				//写同步日志
				sql = "insert into tax_jssjtb_log(guid,dblink,owner,table_name,tb_start_time,tb_end_time,tb_jls,tb_note)
				  values(sys_guid(),'%s','%s','%s',to_date('%s','yyyy-mm-dd hh24:mi:ss'),sysdate,'%s',substr('%s',0,1000))"
				  .format([dblink,owner,table_name,start_time,""+tb_jls,tb_note]);
				pub.EADbTool.ExcecutSQL(sql);
				
				//每同步一个表进行一次事务提交
				db.Commit();
				db = new pub.EADatabase();
		
			}
		}
		
		db.Commit();
		
		//后台程序自动同步到核心库
		var hxret = "";
		if (xmlstr == "") {
			hxret = "  >>>" + RunToHXK();
		}
		if (tb_note == "成功") {
			return "数据采集成功！更新记录数"+ds.getRowCount() + hxret;
		}
		return "数据采集失败："+tb_note;
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

//检查用户数据库里表是否存在
function checkTableExists(db,owner,table_name)
{
	try {
		var sql = "select count(*) from dba_tables where owner=upper('"+owner+"') and table_name=upper('"+table_name+"')";
		var cnt = db.GetSQL(sql);
		if (cnt > 0) return 1;
	}
	catch (e) {
		return 0;
	}
	return 0;
}

//检查表中是否含有某列
function checkTableHasColumn(db,owner,table_name,col_name)
{
	try {
		var sql = "select count(*) from dba_tab_columns where owner=upper('"+owner+"') and table_name=upper('"+table_name+"') and column_name=upper('"+col_name+"')";
		var cnt = db.GetSQL(sql);
		if (cnt > 0) return 1;
	}
	catch (e) {
		return 0;
	}
	return 0;
}

//执行同步到核心库的操作
function RunToHXK()
{
	var CJK_OWNER = "CJ_FXJK"; //风险监控平台采集数据库用户
	var db = null;
	var tbxmlstr  = "";
	try { tbxmlstr = xmlstr; } catch (e) { }
	try {
		db = new pub.EADatabase();
		var sql = "";
		var ds = null;
		
		//如果不是界面传入同步的参数，那么就是后台任务执行的
		if (tbxmlstr == "") {
			sql = "select a.* from tax_jssjtbb a,tax_jssjtb_log b
				where a.tbbz='1' 
				  and a.owner=b.owner
				  and a.table_name=b.table_name
				  and a.dblink=b.dblink
				  and to_char(tb_end_time,'yyyymmdd')=to_char(sysdate,'yyyymmdd')
				  and tb_note='成功'
				order by a.tbxh,a.owner,a.table_name";
			ds = db.QuerySQL(sql);
		}
		else {
			ds = new pub.EAXmlDS(tbxmlstr);
		}
		for (var i=0;i<ds.getRowCount();i++) {
			var guid = ds.getStringAt(i,"GUID");
			var tbbz = ds.getStringAt(i,"TBBZ");
			var dblink = ds.getStringAt(i,"DBLINK");
			var owner = ds.getStringAt(i,"OWNER");
			var table_name = ds.getStringAt(i,"TABLE_NAME");
			var sourceTable = CJK_OWNER + "." + table_name;
			var tabds = db.QuerySQL("select * from tax_jssjtbb where guid='"+guid+"'");
			var zlbz = tabds.getStringAt(0,"ZLBZ");
			var zlwherestr = tabds.getStringAt(0,"WHERESTR");
			
			if (tbbz == "1") {
				//检查采集库里是否已经建有表
				var chktab = checkTableExists(db,"HX_FXJK",table_name);
				//如果表存在，则删除记录后再插入
				var tabrows = 0;				
				var tb_note2 = ""; //同步结果说明				
				if (chktab == 1) {
					sql = "select count(*) from " + sourceTable;
					tabrows = db.GetSQL(sql);	
					tb_note2 = "成功["+tabrows+"]";				
					if (tabrows > 0) {
						var start_time = db.GetSQL("select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') from dual"); //同步开始时间
						try {
							sql = "alter table " + table_name + " nologging";
							db.ExcecutSQL(sql);
							
							//从采集数据库同步数据到核心库
							if (zlbz != "1") { //全增量模式
//								sql = "drop table " + table_name;
//								db.ExcecutSQL(sql);
//								sql = "create table " + table_name + " as select * from " + sourceTable;
//								db.ExcecutSQL(sql);
								
								sql = "truncate table " + table_name;
								db.ExcecutSQL(sql);
								sql = "insert into " + table_name + " select * from " + sourceTable;
								db.ExcecutSQL(sql);

							}
							else if (zlbz == "1") { //增量模式
								//先删除再同步
								var delsql = "delete from " + table_name + " where ("+zlwherestr+")";
								db.ExcecutSQL(delsql);
								sql = "insert into " + table_name + " select * from " + sourceTable + " where ("+zlwherestr+")";
								db.ExcecutSQL(sql);	
								tabrows = db.GetSQL("select count(1) from " + table_name + " where ("+zlwherestr+")");
								tb_note2 = "成功["+tabrows+"]";								
							}
						} catch (e) {
							tb_note2 = pub.EAFunc.Replace(e.toString(),"'","''");							
							pub.EAFunc.Log("同步到核心库:table_name="+table_name+" 出错="+e.toString());							
						}	
						finally {
							sql = "alter table " + table_name + " logging";
							db.ExcecutSQL(sql);
						}					
					}					
				}
				else {
					sql = "create table " + table_name + " as select * from " + sourceTable;
					db.ExcecutSQL(sql);
				}		
				
				//写同步日志
				sql = "update tax_jssjtb_log set tb_note2='"+tb_note2+"'||' '||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') 
					where guid=(select guid from (select * from tax_jssjtb_log 
						where upper(table_name)=upper('"+table_name+"') order by tb_end_time desc) where rownum=1)";
				pub.EADbTool.ExcecutSQL(sql);		
								
			}
			
			//每同步一个表进行一次事务提交
			db.Commit();
			db = new pub.EADatabase();

		}
		
		db.Commit();
		
		if (xmlstr == "") {
			//同步到核心库后需要特殊处理的
			updateTaxCompany();
			genTaxData();
			updateGbCompclass();
		}
		
		return "同步到核心库成功！";
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

//纳税人基本信息表的处理
function updateTaxCompany()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "";
		
		//2013.11.29
		//sql = "delete from tax_company";
		//db.ExcecutSQL(sql);
		
		//更新主管税务机关所科分局、税管员
		sql = "update /*+ BYPASS_UJVC*/(
			select a.id,a.name,a.swjg_dm,b.zgswskfj_dm,a.taxman,b.SSGLY_DM
			from tax_company a,dj_nsrxx b
			where a.djxh=b.djxh
			) set swjg_dm=trim(zgswskfj_dm),taxman=trim(SSGLY_DM)";
		db.ExcecutSQL(sql);
		
		sql = "insert into tax_company (djxh,id,name,typ,taxman,lawman,addr,stat,flag,SWJG_DM,hy_dm)
			  select djxh,nsrsbh,nsrmc,typ,SSGLY_DM,FDDBRXM,scjydz,nsrzt_dm,flag,swjg_dm,hy_dm from ( 
			    select t.*,row_number() over (partition by nsrsbh order by nsrsbh) rn from (     
			    select to_char(a.djxh) djxh,a.nsrsbh,a.nsrmc,a.djzclx_dm typ,trim(SSGLY_DM) SSGLY_DM,FDDBRXM,scjydz,
			      nsrzt_dm,GDSLX_DM flag,trim(a.zgswskfj_dm) swjg_dm,hy_dm
			    from dj_nsrxx a,dj_nsrxx_kz b
			    where a.djxh=b.djxh(+) 
			    and (a.nsrsbh) not in (select id from tax_company)
			    ) t
			  ) where rn=1";
		db.ExcecutSQL(sql);

		//国标行业名称
		sql = "update tax_company a set hy_mc=(select hymc from dm_gy_hy b where a.hy_dm=b.hy_dm)";
		db.ExcecutSQL(sql);
		
		try {
			//行业 明细行业
			sql = "update tax_company a set (hycode,hymx_dm)=(select qysbh,hymx_dm from dj_nsrxx_kz@taxdb b where a.id=b.nsrsbh)
				where a.id in (select nsrsbh from dj_nsrxx_kz@taxdb)";
			//db.ExcecutSQL(sql);
			//个性化行业
			sql = "update tax_company a set typclsid=(select max(id) from tax_compclass b
			           where nvl(a.hycode,'%') like '%'||b.hycode||'%')";
			db.ExcecutSQL(sql);
		
		}
		catch(ee) { }
		
		//一般纳税人标志
		sql = "update tax_company a set ytaxman=0";
		db.ExcecutSQL(sql);
		sql = "update tax_company a set ytaxman=1 where djxh in (select djxh from v_tax_ybnsr_djxx)";
		db.ExcecutSQL(sql);			

		db.Commit();
		return "纳税人基本信息表更新成功！";
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}


//生成税务数据表 sb_sbxx -> tax_taxdata
function genTaxData()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "delete from tax_taxdata where yymm>=to_char(sysdate-1,'YYYY-MM')";
		db.ExcecutSQL(sql);
		
		sql = "insert into tax_taxdata(yymm,id,name,somny,taxmny,sdtaxmny,org,djxh)
			select yymm,id,name,somny,taxmny,sdtaxmny,org,djxh 
			from v_tax_taxdata
			where yymm>=to_char(sysdate-1,'YYYY-MM')";
		db.ExcecutSQL(sql);

		db.Commit();
		return "生成税务表数据成功！";
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

//国标行业税负表
function updateGbCompclass()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "select count(*) from tax_gbcompclass where year=to_char(sysdate,'YYYY')";
		if (1*db.GetSQL(sql) <= 0) {
			sql = "insert into tax_gbcompclass(id,name,tax,avgsale,envload,se_ybnsr,se_xgm,env,year)
				select id,name,tax,avgsale,envload,se_ybnsr,se_xgm,env,to_char(sysdate,'YYYY') year
				from tax_gbcompclass
				where year=to_char(sysdate,'YYYY')-1";
			db.ExcecutSQL(sql);
		}
		
		//只取小类的
		sql = "insert into tax_gbcompclass(id,name,year)
			select hy_dm,hymc,to_char(sysdate,'yyyy') yyyy 
			from DM_GY_HY where hy_dm not in (select id from tax_gbcompclass where year=to_char(sysdate,'yyyy'))
			and xlbz='Y'";
		db.ExcecutSQL(sql);
		
		sql = "update tax_gbcompclass a set name=(select hymc from DM_GY_HY b where a.id=b.hy_dm)
			where a.year=to_char(sysdate,'YYYY')";
		db.ExcecutSQL(sql);
		
		db.Commit();
		return "生成国标行业税负表数据成功！";
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

function New()
{
	return 1;
}



}
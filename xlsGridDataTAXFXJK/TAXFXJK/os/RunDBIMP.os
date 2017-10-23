function TAXFXJK_RunDBIMP(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var timepack = new JavaPackage( "com.xlsgrid.net.time" );

//后台同步数据库
function syncDB() 
{
	var db = null;					

	try {
		db = new pub.EADatabase();
		var sql = "select * from (select distinct owner from tax_jssjtbb where tbbz='1')";
		var userds = db.QuerySQL(sql);
		var owners = "";
		for (var i=0;i<userds.getRowCount();i++) {
			var owner = userds.getStringAt(i,"OWNER");
			var tim = new timepack.EARunOSTimer(); 
			var jobseqid = db.GetSQL("select to_char(sysdate,'yyyymmddhh24miss')||'-"+(i+1)+"' from dual");
			var jobname = owner+"."+jobseqid;
			tim.init(jobseqid,jobname,"TAXFXJK","RunDBIMP","syncUserTables","owner="+owner);
			if (owners == "") owners += owner;
			else owners += ","+owner;
		}
				
		return "数据采集中...["+owners+"]";
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}

}

//后台同步一个用户的数据表 
//参数 owner = ""
function syncUserTables()
{
	var CJK_OWNER = "CJ_FXJK"; //风险监控平台采集数据库用户
	var db = null;					
	var tb_note = "成功"; //采集结果说明
	var impUtil = new TAXFXJK_IMP_TaxData();
				
	try {
		db = new pub.EADatabase();
		var sql = "";

		sql = "select * from tax_jssjtbb where owner='"+owner+"' and tbbz='1' order by tbxh,owner,table_name";
		var ds = db.QuerySQL(sql);		
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
					try {
						sql = "alter table " + CJK_OWNER + "." + table_name + " nologging";
						db.ExcecutSQL(sql);					
					} catch(e) {}
					
					//检查采集库里是否已经建有表
					var chktab = impUtil.checkTableExists(db,CJK_OWNER,table_name);
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
					var chktabcols = impUtil.checkTableHasColumn(db,CJK_OWNER,table_name,"SJGSDQ"); //SJGSDQ数据归属地区
					if (chktabcols == 1) {
						if (filterstr == "") filterstr += " SJGSDQ like '14511%'";
						else filterstr += " or SJGSDQ like '14511%'";
					}
					chktabcols = impUtil.checkTableHasColumn(db,CJK_OWNER,table_name,"ZGSWSKFJ_DM"); //ZGSWSKFJ_DM主管税务所科分局
					if (chktabcols == 1) {
						if (filterstr == "") filterstr += " ZGSWSKFJ_DM like '14511%'";
						else filterstr += " or ZGSWSKFJ_DM like '14511%'";
					}
					chktabcols = impUtil.checkTableHasColumn(db,CJK_OWNER,table_name,"ZGSWJ_DM"); //ZGSWJ_DM 主管税务机构
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
					try {
						sql = "alter table " +  CJK_OWNER + "." + table_name + " logging";
						db.ExcecutSQL(sql);
					} catch(e) { }
				}
				
				//写同步日志
				sql = "insert into tax_jssjtb_log(guid,dblink,owner,table_name,tb_start_time,tb_end_time,tb_jls,tb_note)
				  values(sys_guid(),'%s','%s','%s',to_date('%s','yyyy-mm-dd hh24:mi:ss'),sysdate,'%s',substr('%s',0,1000))"
				  .format([dblink,owner,table_name,start_time,""+tb_jls,tb_note]);
				pub.EADbTool.ExcecutSQL(sql);
				
				
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				//同步到核心库
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				try {
					try {
						sql = "alter table " + table_name + " nologging";
						db.ExcecutSQL(sql);
					} catch(e) { }
					
					//检查采集库里是否已经建有表
					var chktab = impUtil.checkTableExists(db,"HX_FXJK",table_name);
					//如果表存在，则删除记录后再插入
					var tabrows = 0;				
					var tb_note2 = ""; //同步结果说明				
					if (chktab == 1) {
						sql = "select count(*) from " + sourceTable;
						tabrows = db.GetSQL(sql);	
						tb_note2 = "成功["+tabrows+"]";				
						if (tabrows > 0) {
							var start_time = db.GetSQL("select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') from dual"); //同步开始时间
							//从采集数据库同步数据到核心库
							if (zlbz != "1") { //全增量模式
								//sql = "drop table " + table_name;
								//db.ExcecutSQL(sql);
								//sql = "create table " + table_name + " as select * from " + sourceTable;
								//db.ExcecutSQL(sql);
								
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
				catch (e) {
					tb_note2 = pub.EAFunc.Replace(e.toString(),"'","''");							
					pub.EAFunc.Log("同步到核心库:table_name="+table_name+" 出错="+e.toString());
				}
				finally {
					try {
						sql = "alter table " + table_name + " logging";
						db.ExcecutSQL(sql);
					}
					catch(e) { }
				}
				
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				//采集完成后更新、汇总生成平台的相关数据表
				if (table_name == "tax_taxdata".toUpperCase()) {
					impUtil.genTaxData();
				}
				if (table_name == "dj_nsrxx".toUpperCase()) {
					impUtil.updateTaxCompany();
				}
				
				//每同步一个表进行一次事务提交
				db.Commit();
				db = new pub.EADatabase();
		
			}
		}
		
		db.Commit();
		
		return "数据采集成功！";
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
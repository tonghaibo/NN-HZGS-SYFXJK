function TAXFXJK_EleData(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );

function insert()
{
	var db = null;
	var ds = null;
	var sql = "";
	var tabname = tabnam;
	var typ = typ;
	var ret = "";

	try{
		db = new pubpack.EADatabase();
		
		sql = "select * from user_tables where table_name=upper('"+tabname+"')";
		var cnt = db.GetSQLRowCount(sql);
		if(cnt <= 0) return "无数据可以导入";

		//平桂电力
		if(typ == 1) {
			//sql = "delete from "+tabname+" where co0='用户号'";
//			sql = "delete from "+tabname+" where co0 like 'sz_id_user%'";
//			db.ExcecutSQL(sql);
//			//居民用电不导入
//			sql = "delete from "+tabname+" where co10 ='0.4563' or co10 ='0.6003' or co10 ='0.5283'";
//			db.ExcecutSQL(sql);
//			
//			sql = "update tax_eledata a set (ELEQTY,ELEPRICE,ELEMNY)=(select sum(co9),max(co10),sum(co11) 
//				       from "+tabname+" b where a.usrid=b.co0 and a.yymm=b.co12
//				       group by co0,co12)
//				where a.typ='1' and a.org='"+thisorgid+"' and exists (select 1 from "+tabname+" b where b.co0=a.usrid and b.co12=a.yymm)";
//			var upcnt = db.ExcecutSQL(sql);
//			
//			sql = "insert into tax_eledata(ORG,YYMM,USRID,USRNAM,ELEQTY,ELEPRICE,ELEMNY,typ,TOWN)"+
//				"select '"+thisorgid+"' org,co12,co0,max(co1) co1,sum(co9) co9,max(co10) co10,sum(co11) coll,'1','平桂' from "+tabname+" a" +
//				" where not exists (select 1 from tax_eledata b where b.usrid=a.co0 and b.YYMM=a.co12 and b.typ='1' and b.org='"+thisorgid+"') group by co0,co12";
//			var count = db.ExcecutSQL(sql);
//			db.ExcecutSQL("drop table "+tabname);
//			
//			return  "导入"+count+"笔记录，更新"+upcnt+"笔记录。";	

			//2016启用新格式
			sql = "delete from "+tabname+" where is_number(co0) !=1";
			db.ExcecutSQL(sql);
			//居民用电不导入 //倍率=1
			sql = "delete from "+tabname+" where co8=1";
			db.ExcecutSQL(sql);
			
			sql = "update tax_eledata a set (ELEQTY,ELEPRICE,ELEMNY)=(select sum(co11),max(co15),sum(co16) 
				       from "+tabname+" b where a.usrid=b.co1 and a.yymm=b.co5
				       group by co1,co5)
				where a.typ='1' and a.org='"+thisorgid+"' and exists (select 1 from "+tabname+" b where b.co1=a.usrid and b.co5=a.yymm)";
			var upcnt = db.ExcecutSQL(sql);
			
			sql = "insert into tax_eledata(ORG,YYMM,USRID,USRNAM,ELEQTY,ELEPRICE,ELEMNY,typ,TOWN)
				select '"+thisorgid+"' org,co5,co1,max(co2) co2,sum(co11) co11,max(to_number(co15)) co15,sum(co16) col6,'1','平桂' from "+tabname+" a 
				where not exists (select 1 from tax_eledata b where b.usrid=a.co1 and b.YYMM=a.co5 and b.typ='1' and b.org='"+thisorgid+"') group by co1,co5";
			var count = db.ExcecutSQL(sql);
			db.ExcecutSQL("drop table "+tabname);
			
			return  "导入"+count+"笔记录，更新"+upcnt+"笔记录。";	

		}
		//钟山电力
		else if (typ == "4") {
			sql = "delete from "+tabname+" where co0 like '%编号%'";
			db.ExcecutSQL(sql);
			
			sql = "update tax_eledata a set (ELEQTY)=(select sum(co3) 
				       from "+tabname+" b where a.usrid=b.co0 and a.yymm=b.co2 
				       group by co0,co2),(ELEMNY)=(select sum(co4) 
				       from "+tabname+" b where a.usrid=b.co0 and a.yymm=b.co2 
				       group by co0,co2)
				where a.typ='4' and a.org='"+thisorgid+"' and exists (select 1 from "+tabname+" b where b.co0=a.usrid and b.co2=a.yymm)";
			var upcnt = db.ExcecutSQL(sql);
			
			sql = "insert into tax_eledata(ORG,YYMM,USRID,USRNAM,ELEQTY,typ,TOWN,GDS,ADDR,ELEPRO,ELEMNY) "+
			      "select '"+thisorgid+"' org,to_char(to_date(to_number(co2),'yyyymm'),'yyyy-mm'),co0,max(co1) co1,sum(co3) co3,'4','钟山',max(co6) co6,max(co8) co8,max(co7) co7,sum(co4) co4 from "+tabname+" a" +
			      " where not exists (select 1 from tax_eledata b where b.usrid=a.co0 and b.YYMM=to_char(to_date(to_number(co2),'yyyymm'),'yyyy-mm') and b.typ='4' and b.org='"+thisorgid+"') group by co0,co2";
			
			var count = db.ExcecutSQL(sql);
			//return sql;
			db.ExcecutSQL("drop table "+tabname);
			
			return  "导入"+count+"笔记录，更新"+upcnt+"笔记录。";	
		}
		//桂源桂东
		else if (typ == "5") {
			//删除标题行
			sql = "delete from "+tabname+" where co1 like '%户号%' or co2 like '%户名%'";
			db.ExcecutSQL(sql);
			//格式化电费年月
			sql = "update "+tabname+" set co4=to_char(to_date(to_number(co4),'yyyymm'),'yyyy-mm'),co1=to_number(co1)";//导新数据
			//sql = "update "+tabname+" set co4=to_char(to_date(190001,'yyyymm')+to_number(co4),'yyyy-mm'),co1=to_number(co1)";//导旧数据
			db.ExcecutSQL(sql);
			
			sql = "update tax_eledata a set (ELEQTY)=(select sum(co5) 
				       from "+tabname+" b where a.usrid=b.co1 and a.yymm=b.co4 
				       group by co1,co4),(ELEMNY)=(select sum(co6) 
				       from "+tabname+" b where a.usrid=b.co1 and a.yymm=b.co4 
				       group by co1,co4)
				where a.typ='5' and a.org='"+thisorgid+"' and exists (select 1 from "+tabname+" b where b.co1=a.usrid and b.co4=a.yymm)";
			var upcnt = db.ExcecutSQL(sql);
			
			sql = "insert into tax_eledata(ORG,YYMM,USRID,USRNAM,ELEQTY,typ,TOWN,GDS,ADDR,ELEPRO,ELEMNY)
				select '"+thisorgid+"' org,co4,co1,max(co2) co2,sum(co5) co5,'5','桂源桂东' town,max(co7) co7,max(co3) co3,max(co8) co8,sum(co6) co6 from "+tabname+" a
				where not exists (select 1 from tax_eledata b where b.usrid=a.co1 and b.YYMM=co4 and b.typ='5' and b.org='"+thisorgid+"') 
				group by co1,co4";
			var count = db.ExcecutSQL(sql);
			db.ExcecutSQL("drop table "+tabname);
			
			return  "导入"+count+"笔记录，更新"+upcnt+"笔记录。";	

		}
		//富川电力
		else if (typ == "6") {
			//删除标题行
			sql = "delete from "+tabname+" where co0 like '%客户编号%' or co1 like '%客户名称%'";
			db.ExcecutSQL(sql);
			//格式化电费年月
			sql = "update "+tabname+" set co3=to_char(to_date(to_number(co3),'yyyymm'),'yyyy-mm')";
			db.ExcecutSQL(sql);
			
			sql = "update tax_eledata a set (ELEQTY)=(select sum(co7) 
				       from "+tabname+" b where a.usrid=b.co0 and a.yymm=b.co3 
				       group by co0,co3),(ELEMNY)=(select sum(co8) 
				       from "+tabname+" b where a.usrid=b.co0 and a.yymm=b.co3 
				       group by co0,co3)
				where a.typ='6' and a.org='"+thisorgid+"' and exists (select 1 from "+tabname+" b where b.co1=a.usrid and b.co3=a.yymm)";
			var upcnt = db.ExcecutSQL(sql);
			
			sql = "insert into tax_eledata(ORG,YYMM,USRID,USRNAM,ELEQTY,typ,TOWN,GDS,ADDR,ELEPRO,ELEMNY)
				select '"+thisorgid+"' org,co3,co0,max(co1) co1,sum(co7) co7,'6','富川' town,max(co9) co9,max(co2) c02,max(co4) co4,sum(co8) co8 from "+tabname+" a
				where not exists (select 1 from tax_eledata b where b.usrid=a.co0 and b.YYMM=co3 and b.typ='6' and b.org='"+thisorgid+"') group by co0,co3";
			var count = db.ExcecutSQL(sql);
			db.ExcecutSQL("drop table "+tabname);
			
			return  "导入"+count+"笔记录，更新"+upcnt+"笔记录。";	
		}
		//昭平电力
		else if (typ == "7") {
			//删除标题行
			sql = "delete from "+tabname+" where co0 like '%编号%' or co1 like '%名称%'";
			db.ExcecutSQL(sql);
			//格式化电费年月
			sql = "update "+tabname+" set co0=to_number(co0),co3=to_char(to_date(to_number(co3),'yyyymm'),'yyyy-mm')";
			db.ExcecutSQL(sql);
			
			sql = "update tax_eledata a set (ELEQTY)=(select sum(co5) 
				       from "+tabname+" b where a.usrid=b.co0 and a.yymm=b.co3 
				       group by co0,co3),(ELEMNY)=(select sum(co6) 
				       from "+tabname+" b where a.usrid=b.co0 and a.yymm=b.co3
				       group by co0,co3)
				where a.typ='7' and a.org='"+thisorgid+"' and exists (select 1 from "+tabname+" b where b.co1=a.usrid and b.co3=a.yymm)";
			var upcnt = db.ExcecutSQL(sql);
			
			sql = "insert into tax_eledata(ORG,YYMM,USRID,USRNAM,ELEQTY,typ,TOWN,GDS,ADDR,ELEPRO,ELEMNY)
				select '"+thisorgid+"' org,co3,co0,max(co1) co1,sum(co5) co5,'7','昭平' town,max(co7) co7,max(co2) co2,max(co4) co4,sum(co6) co6 from "+tabname+" a
				where not exists (select 1 from tax_eledata b where b.usrid=a.co0 and b.YYMM=co3 and b.typ='7' and b.org='"+thisorgid+"') group by co0,co3";
			var count = db.ExcecutSQL(sql);
			db.ExcecutSQL("drop table "+tabname);
			
			return  "导入"+count+"笔记录，更新"+upcnt+"笔记录。";	
		}
		//南方电网
		else if (typ == "8") {
			//删除标题行
			sql = "delete from "+tabname+" where co0 like '%户号%' or co1 like '%户名%'";
			db.ExcecutSQL(sql);
			//格式化电费年月
			sql = "update "+tabname+" set co4=to_char(to_date(to_number(co4),'yyyymm'),'yyyy-mm')";//导新数据
			//sql = "update "+tabname+" set co4=to_char(to_date(190001,'yyyymm')+to_number(co4),'yyyy-mm'),co1=to_number(co1)";//导旧数据
			db.ExcecutSQL(sql);
			
			sql = "update tax_eledata a set (ELEQTY)=(select sum(co5) 
				       from "+tabname+" b where a.usrid=b.co1 and a.yymm=b.co4 
				       group by co1,co4),(ELEMNY)=(select sum(co6) 
				       from "+tabname+" b where a.usrid=b.co1 and a.yymm=b.co4 
				       group by co1,co4)
				where a.typ='8' and a.org='"+thisorgid+"' and exists (select 1 from "+tabname+" b where b.co1=a.usrid and b.co4=a.yymm)";
			var upcnt = db.ExcecutSQL(sql);
			
			sql = "insert into tax_eledata(ORG,YYMM,USRID,USRNAM,ELEQTY,typ,TOWN,GDS,ADDR,ELEPRO,ELEMNY)
				select '"+thisorgid+"' org,co4,co1,max(co2) co2,sum(co5) co5,'8','南方电网' town,max(co7) co7,max(co3) co3,max(co8) co8,sum(co6) co6 from "+tabname+" a
				where not exists (select 1 from tax_eledata b where b.usrid=a.co1 and b.YYMM=co4 and b.typ='8' and b.org='"+thisorgid+"') 
				group by co1,co4";
			var count = db.ExcecutSQL(sql);
			db.ExcecutSQL("drop table "+tabname);
			
			return  "导入"+count+"笔记录，更新"+upcnt+"笔记录。";	

		}
		//临江电力
		else if (typ == "9") {
			//删除标题行
			sql = "delete from "+tabname+" where co1 like '%户号%' or co2 like '%户名%'";
			db.ExcecutSQL(sql);
			//格式化电费年月
			sql = "update "+tabname+" set co4=to_char(to_date(to_number(co4),'yyyymm'),'yyyy-mm')";//导新数据
			//sql = "update "+tabname+" set co4=to_char(to_date(190001,'yyyymm')+to_number(co4),'yyyy-mm'),co1=to_number(co1)";//导旧数据
			db.ExcecutSQL(sql);
			
			sql = "update tax_eledata a set (ELEQTY)=(select sum(co5) 
				       from "+tabname+" b where a.usrid=b.co1 and a.yymm=b.co4 
				       group by co1,co4),(ELEMNY)=(select sum(co6) 
				       from "+tabname+" b where a.usrid=b.co1 and a.yymm=b.co4 
				       group by co1,co4)
				where a.typ='9' and a.org='"+thisorgid+"' and exists (select 1 from "+tabname+" b where b.co1=a.usrid and b.co4=a.yymm)";
			var upcnt = db.ExcecutSQL(sql);
			
			sql = "insert into tax_eledata(ORG,YYMM,USRID,USRNAM,ELEQTY,typ,TOWN,GDS,ADDR,ELEPRO,ELEMNY)
				select '"+thisorgid+"' org,co4,co1,max(co2) co2,sum(co5) co5,'9','临江电力' town,max(co7) co7,max(co3) co3,max(co8) co8,sum(co6) co6 from "+tabname+" a
				where not exists (select 1 from tax_eledata b where b.usrid=a.co1 and b.YYMM=co4 and b.typ='9' and b.org='"+thisorgid+"') 
				group by co1,co4";
			var count = db.ExcecutSQL(sql);
			db.ExcecutSQL("drop table "+tabname);
			
			return  "导入"+count+"笔记录，更新"+upcnt+"笔记录。";	

		}
		//水管所
		else if (typ == "10") {
			//删除标题行
			sql = "delete from "+tabname+" where co1 like '%用户名%' or co2 like '%地址%'";
			db.ExcecutSQL(sql);
			//格式化电费年月
			sql = "update "+tabname+" set co3=to_char(to_date(to_number(co3),'yyyymm'),'yyyy-mm')";//导新数据
			//sql = "update "+tabname+" set co4=to_char(to_date(190001,'yyyymm')+to_number(co4),'yyyy-mm'),co1=to_number(co1)";//导旧数据
			db.ExcecutSQL(sql);
			
			sql = "update tax_eledata a set (ELEQTY)=(select sum(co4) 
				       from "+tabname+" b where a.usrid=b.co0 and a.yymm=b.co3 
				       group by co0,co3),(ELEMNY)=(select sum(co5) 
				       from "+tabname+" b where a.usrid=b.co0 and a.yymm=b.co3 
				       group by co0,co3)
				where a.typ='10' and a.org='"+thisorgid+"' and exists (select 1 from "+tabname+" b where b.co0=a.usrid and b.co3=a.yymm)";
			var upcnt = db.ExcecutSQL(sql);
			
			sql = "insert into tax_eledata(ORG,YYMM,USRID,USRNAM,ELEQTY,typ,TOWN,GDS,ADDR,ELEPRO,ELEMNY)
				select '"+thisorgid+"' org,co3,co0,max(co1) co1,sum(co4) co4,'10','水管所' town,max(co6) co6,max(co2) co2,'' co8,sum(co5) co5 from "+tabname+" a
				where not exists (select 1 from tax_eledata b where b.usrid=a.co0 and b.YYMM=co3 and b.typ='10' and b.org='"+thisorgid+"') 
				group by co0,co3";
			var count = db.ExcecutSQL(sql);
			db.ExcecutSQL("drop table "+tabname);
			
			return  "导入"+count+"笔记录，更新"+upcnt+"笔记录。";	

		}
		
		
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

//桂源电力导入
function impGuiYuan()
{
	var db = null ;
	var ds = null ;
	var ps = null;
	var sql = "";
	var ret = 0;
	var typ=typ;
	try {		
		db = new pubpack.EADatabase();
		//filename = "/u/filestore/u/filestore/u/filestoreupload/pgtmp/guiyuan.xls";
		
		//加载xmlDS
		var excelgrid = new xlsdb.excelgrid();	
		for (var sheet = 0;sheet <= 12;sheet++) {
			var xmlds = excelgrid.GetXmlDS(filename,sheet);	
			if (xmlds.getColumnCount() > 3) {
				var table =  db.GetSQL("select 'PG_'||TAX_NEXTVAL.nextval from dual");
				var params = "";
				var columns = "";

				//创建临时表		
				sql = "create table "+table+" (";
				for (var col = 0;col < xmlds.getColumnCount();col ++) {
					if (col > 0) sql += ",";
					sql += "CO"+col+" varchar2(255) \n";
					if (columns != "") columns += ",";
					columns += "CO"+col;
					if (params != "") params += ",";
					params += "?";
				}
				sql += ") ";
				db.ExcecutSQL(sql);
				
				//导入临时表
				//最后一列日期类型的 导入后变成了数字，如何转成日期？
				//to_char(to_date('19000101','yyyymmdd')+to_number(co5),'yyyy-mm') co5
				var updatesql = "insert into "+table+" ("+columns +") values ("+params+")";
//				pubpack.EAFunc.Log(updatesql);
				ps = db.GetConn().prepareStatement(updatesql);
				
				var rowcount = xmlds.getRowCount();
				for(var rows=0;rows<rowcount;rows++) {
					for(var cols=0;cols<xmlds.getColumnCount();cols++) {
						var colname=xmlds.getColumnName(cols);
						var colstr=xmlds.getStringAt(rows,colname);
//						if (rows > 0 && cols == 5) throw new Exception(colstr);
						ps.setString(cols+1,colstr);
					}
					ps.addBatch();
				}
				ps.executeBatch();
				
				if(typ==2){
					//写入正式目标表 
					sql = "delete from "+table+" where co0='用户编号'";
					db.ExcecutSQL(sql);
					
					//电价为0.5283的用电记录，属于居民用电，不予导入
					sql = "delete from "+table+" where co5='0.5283'";
					db.ExcecutSQL(sql);
			
					sql = "insert into tax_eledata(ORG,YYMM,USRID,USRNAM,ELEQTY,ELEMNY,typ,TOWN)
					select '"+thisorgid+"' org,yymm,usrid,usrnam,eleqty,elemny,typ,town from (
		  			select to_char(to_date('19000101','yyyymmdd')+to_number(co2),'yyyy-mm') yymm,
					decode(instr(co0,'.'),0,co0,to_number(co0)) usrid,max(co1) usrnam,sum(co3) eleqty,sum(co4) elemny,'2' typ,max(co6) town from "+table+" a 
					group by co2,co0
					) a where not exists (select 1 from tax_eledata b where b.usrid=a.usrid and b.YYMM=a.yymm and b.org='"+thisorgid+"')";
					ret += db.ExcecutSQL(sql);
					//drop临时表
		  			sql = "drop table " + table;
		 			db.ExcecutSQL(sql);
	 			}
	 			else if(typ==3){
					sql="delete from "+table+" where co5 is null";
					db.ExcecutSQL(sql);
					
					sql="select * from "+table+" where co2='用户号'";
					ds = db.QuerySQL(sql);
					for (var i=3;i<15;i++) {
						var colnam = ds.getColumnName(i);
						var yymm = ds.getStringAt(0,i);
						sql = "insert into tax_eledata(ORG,YYMM,USRID,USRNAM,ELEQTY,typ,TOWN)
							select '"+thisorgid+"' org,yymm,co2,co1,co3,typ,'桂东' from(select to_char(to_date('"+yymm+"','yyyy-mm'),'yyyy-mm') yymm,decode(instr(co2,'.'),0,co2,to_number(co2)) co2,max(co1) co1,nvl(sum("+colnam+"),0) co3,'3' typ from "+table+" a
							where co2 !='用户号'and "+colnam+" is not null and co2 is not null group by co2 ) a where not exists (select 1 from tax_eledata b where a.co2=b.usrid and b.yymm=a.yymm and b.org='"+thisorgid+"') ";
							ret += db.ExcecutSQL(sql);
							
					}
					//drop临时表
		  			sql = "drop table " + table;
		 			db.ExcecutSQL(sql);
	 			}
			}
		}
			
		db.Commit();
		return "导入成功，记录数"+ret;

	}
	catch(e) {
		if(db != null) db.Rollback();
		return e.toString();
		throw new Exception(e);
	}
	finally {
		if(db != null) db.Close();
		//文件导入成功后删除
		var file = new java.io.File(filename);   
         	if(file.exists()){   
         		file.delete();
         	}
	}
}

}
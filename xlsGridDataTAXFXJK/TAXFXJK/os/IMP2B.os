function TAXFXJK_IMP2B(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );


//决策二包数据导入
function import2B()
{
	var db = null ;
	var ds = null ;
	var ps = null;
	var sql = "";
	var ret = 0;
	var table = "";
	
	try {		
		db = new pub.EADatabase();

		//加载xmlDS
		var excelgrid = new xlsdb.excelgrid();	
		var xmlds = excelgrid.GetXmlDS(filename,0);	
		if (xmlds.getColumnCount() == 46) {
			table =  db.GetSQL("select 'PG_'||TAX_NEXTVAL.nextval from dual");
			var params = "";
			var columns = "";

			//创建临时表		
			sql = "create table "+table+" (";
			for (var col = 0;col < xmlds.getColumnCount();col ++) {
				if (col > 0) sql += ",";
				sql += "CO"+col+" varchar2(500) \n";
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
			ps = db.GetConn().prepareStatement(updatesql);
			
			var rowcount = xmlds.getRowCount();
			for(var rows=0;rows<rowcount;rows++) {
				for(var cols=0;cols<xmlds.getColumnCount();cols++) {
					var colname=xmlds.getColumnName(cols);
					var colstr=xmlds.getStringAt(rows,colname);
					ps.setString(cols+1,colstr);
				}
				ps.addBatch();
			}
			ps.executeBatch();

			//写入正式目标表 
			sql = "delete from "+table+" where co1 is null or co1='序号' or co0 is null"; 
			db.ExcecutSQL(sql);
			
			sql = "select * from tax_trk_js2b where pch in (select co0 from "+table+")";
			var ds = db.QuerySQL(sql);
			if (ds.getRowCount() > 0) {
				var pch = ds.getStringAt(0,"PCH");
				return "任务批次号："+pch+" 已经导入过，不能重复导入！";
			}
			 
			sql = "update "+table+" set co14=replace(co14,',',''),co15=replace(co15,',',''),co16=replace(co16,',',''),co17=replace(co17,',',''),
				       co18=replace(co18,',',''),co19=replace(co19,',',''),co20=replace(co20,',',''),co21=replace(co21,',',''),
				       co22=replace(co22,',',''),co23=replace(co23,',',''),co24=replace(co24,',',''),co25=replace(co25,',',''),
				       co26=replace(co26,',',''),co27=replace(co27,',',''),co28=replace(co28,',',''),co29=replace(co29,',',''),
				       co30=replace(co30,',',''),co31=replace(co31,',',''),co32=replace(co32,',',''),co33=replace(co33,',',''),
				       co34=replace(co34,',',''),co35=replace(co35,',',''),co36=replace(co36,',',''),co37=replace(co37,',',''),
				       co38=replace(co38,',',''),co39=replace(co39,',',''),co40=replace(co40,',',''),co41=replace(co41,',',''),  
				       co42=replace(co42,',',''),co43=replace(co43,',','')
				where co1 is not null and co1!='序号' and co0 is not null";       
			db.ExcecutSQL(sql);  
			
			sql = "insert into tax_trk_js2b(PCH,XH,NSRSBH,NSRMC,ZGSWJG,RWLY,FXDJ,YDFS,YDSWJG,YDRY,YDKSRQ,YDWCRQ,RWWCQX,SFYWT,
				  CBSK_XJ,CBSK_ZZS,CBSK_XFS,CBSK_QYSDS,CBSK_GRSDS,CBSK_FCS,CBSK_TDZZS,CBSK_TDSYS,CBSK_YHS,
				  CBSK_QS,CBSK_CLGZS,CBSK_QTSF,RKSK_XJ,RKSK_ZZS,RKSK_XFS,RKSK_QYSDS,RKSK_GRSDS,RKSK_FCS,
				  RKSK_TDZZS,RKSK_TDSYS,RKSK_YHS,RKSK_QS,RKSK_CLGZS,RKSK_QTSF,RKZNJ,RKFK,ZZSDJLDJE,
				  QYSDSTZYNSE,QYSDSTZYNSSDE,QYSDSMBKSE,BZCXWLX,YDGZQKSM,IMPBZ)     
				select co0,co1,co2,co3,co4,co5,co6,co7,co8,co9,co10,co11,co12,co13,co14,co15,co16,co17,co18,co19,co20,co21,
				       co22,co23,co24,co25,co26,co27,co28,co29,co30,co31,co32,co33,co34,co35,co36,co37,co38,co39,co40,co41,
				       co42,co43,co44,co45,'"+table+"' impbz
				from "+table+" 
				where co1 is not null and co1!='序号' and co0 is not null";
			ret += db.ExcecutSQL(sql);
			
			//更新任务状态
			sql = "update tax_trkhdr set stat='5' where (pch,cmid) in (select pch,nsrsbh from tax_trk_js2b where impbz='"+table+"')";
			db.ExcecutSQL(sql);
			
			//差异对比
			//查补税款大于核实金额百分比以上的，任务自动判断结束
			sql = "select * from TAX_CS_HSRWZDJS";
			var csds = db.QuerySQL(sql);
			if (csds.getRowCount() > 0) {
				var ce = csds.getStringAt(0,"CE");
				var bl = csds.getStringAt(0,"BL");
				
				//核实金额乘以0.17转为税额
				sql = "select * from (select b.guid,a.pch,a.nsrsbh,a.nsrmc,a.cbsk_xj,b.cyje,round(a.cbsk_xj/b.cyje*0.17,2)*100 cbbl,abs(b.cyje*0.17-a.cbsk_xj) ce
					from tax_trk_js2b a,tax_trkhdr b
					where a.pch=b.pch and a.nsrsbh=b.cmid
					  and a.impbz='"+table+"'
					  and b.cyje>0
					) where ce<'"+ce+"' and cbbl>'"+bl+"'";
				var cxds = db.QuerySQL(sql);
				for (var i=0;i<cxds.getRowCount();i++) {
					var trkguid = cxds.getStringAt(i,"GUID");
					sql = "update tax_trkhdr set stat='9' where guid='"+trkguid+"'";
					db.ExcecutSQL(sql);
				}
			}
			
			//drop临时表
  			sql = "drop table " + table;
 			db.ExcecutSQL(sql);
		}
		else {
			return "导入格式不正确！";
		}

		db.Commit();
		return table+"~导入成功，记录数"+ret;

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
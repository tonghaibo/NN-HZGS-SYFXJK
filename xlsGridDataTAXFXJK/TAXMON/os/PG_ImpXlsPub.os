function TAXMON_PG_ImpXlsPub(){var pubpack=new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );
var timepack = new JavaPackage( "com.xlsgrid.net.time" );
var rs = new JavaPackage ( "com.xlsgrid.net.servlet" );

function getTableSeq(db)
{
	var seqvalue = db.GetSQL("select tax_nextval.nextval from dual");
	return "PG_"+ seqvalue;
}

function runImpXls2DB()
{
	var db = null;
	var ps = null;
	var table ="";//临时表名
	var filename = "/u/filestore/"+fil;
	//filename = "D:/excel数据表/2012.11.19钟山电表编号采集表.xls";

	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)

		var percent = 10;

		//加载xmlDS
		var excelgrid = new xlsdb.excelgrid();
		var xmlds = excelgrid.GetXmlDS(filename,0);	

		table = getTableSeq(db);
	
		var columns = "";
		var params = "";

		
		//创建临时表		
		var sql = "create table "+table+" (";
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
		
		db.Commit();
		
		return table;
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (ps != null) ps.close();
		if (db != null) db.Close();
		//文件导入成功后删除
		var file = new java.io.File(filename);   
         	if(file.exists()){   
         		file.delete();
         	}
	}
}


function getFilePath()
{
	return 	"/"+pubpack.EAOption.get("filestore") +"/u/filestoreupload/pgtmp/";
}


}
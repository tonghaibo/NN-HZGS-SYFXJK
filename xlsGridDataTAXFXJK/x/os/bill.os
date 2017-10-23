function x_bill(){var bill = new x_WG_Currefour();
//var pubpack = new JavaPackage ( "com.xlsgrid.net.pub");
function start()
{
	return bill.getOrderStr("JQPX","2011-09-05","0005","ZXR3","111111","1","gb2312");
}


//判断一个表是否存在，如果不存在就创建
//function creattable()
//{
//	var sql="";
//	var db="";
//	var ds="";
//	try{
//		sql="select  count(*)  from test_mynls";
//		db = new pubpack.EADatabase();
//		//return 22;
//
//		ds=db.QuerySQL(sql);
//		return 000;
//	}
//	catch(e){
//		//throw (e);
//		sql="create table test_mynls ( GUID CHAR(32) default SYS_GUID() not null ,ORG VARCHAR2(20),"+
//		"NAME VARCHAR2(256),NOTE VARCHAR2(1024) )";
//		db.ExcecutSQL(sql);
//		sql="comment on column test_mynls.GUID is '内部ID'";
//		db.ExcecutSQL(sql);
//		sql="comment on column test_mynls.ORG is '组织' ";
//		db.ExcecutSQL(sql);
//		return 99;
//	}
//	return 77;
//}
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );

//获取随即表名
function getTableSeq(db)
{
	var seqvalue = db.GetSQL("select tax_nextval.nextval from dual");
	return "SYTK_"+ seqvalue;
}

//参数 文件名
//返回值 导入结果
function Run()
{
        var db = null;
        var sql="";
	var ps = null;
	var table ="";//临时表名
	var file =filename;
	try{
		
		//加载xmlDS
		var excelgrid = new xlsdb.excelgrid();
		var xmlds = excelgrid.GetXmlDS(filename,0);	
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		table =getTableSeq(db);
		
		var columns = "";
		var params = "";

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
		//预编译
		sql= "insert into "+table+" ("+columns +") values ("+params+")";
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
		//提交
		db.Commit();
		if (ps != null) ps.close();
		if (db != null) db.Close();
		//文件导入成功后删除
		var file = new java.io.File(filename);   
         	if(file.exists()){   
         		file.delete();
         	}
		return table;
	}
	catch(e){
		throw e;
	}
}

}
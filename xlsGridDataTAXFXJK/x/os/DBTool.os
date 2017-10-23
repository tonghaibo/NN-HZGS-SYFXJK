function x_DBTool(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//作为.sp服务时的入口
//预定义变量：request,response
function Response()
{
	var db = null;
	var obj_name = request.getParameter("obj_name");
	var obj_type = request.getParameter("obj_type");
	var owner = request.getParameter("owner");
	var ddl = request.getParameter("ddl");
	var store = request.getParameter("store");
	var data = request.getParameter("data");
	var where = request.getParameter("where");
	try {
	  	response.setHeader("File",obj_name+".sql");
	        response.setHeader("Content-Disposition", "attachment;filename="+obj_name+".sql");
	        
	        db = new pub.EADatabase();
	        var sb = new java.lang.StringBuffer();	
	        var sql = "select to_char(sysdate,'yyyy/mm/dd hh24:mi:ss') from dual";
	        var crttime = db.GetSQL(sql);
	        //导出文件信息
		if (log == "1") {
			sb.append("--------------------------------------------------------------\r\n");
		        sb.append(formatHearNote("--Export file for user "+owner,60)+"\r\n");
			sb.append("----------------Created on "+crttime+"----------------\r\n");
			sb.append("--------------------------------------------------------------\r\n");
	        }
	        
	        if (obj_type == "TABLE") {
	        	//导出不包含存储信息
	        	if (store != "1") {
	        		sql = "EXECUTE DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'STORAGE',false)";
	        		//db.ExcecutSQL(sql);
	        		//var proc = new java.sql.CallableStatement();
	        		createMyProc(db);
	        		var proc = db.GetConn().prepareCall("{ call comm_proc() }");
	        		proc.execute();
	        	}
	        }
	        //导出对象创建语句
	        if (ddl == "1") {
		        sql = "select dbms_metadata.get_ddl('"+obj_type+"','"+obj_name+"','"+owner+"') from dual";
		        var str = db.GetSQL(sql);
			sb.append(pub.EAFunc.Replace(str,"\n","\r\n"));
		        if (obj_type == "VIEW" || obj_type == "SEQUENCE") {
				sb.append(";\r\n");
		        }
		        
		        //导出表索引
		        if (obj_type == "TABLE") {
		        	sql = "select index_name from dba_indexes where owner='"+owner+"' and table_name='"+obj_name+"'";
		        	var idxDS = db.QuerySQL(sql);
		        	for (var i=0;i<idxDS.getRowCount();i++) {
		        		var index_name = idxDS.getStringAt(i,"INDEX_NAME");
		        		sql = "select dbms_metadata.get_ddl('INDEX','"+index_name+"','"+owner+"') from dual";
				        sb.append(db.GetSQL(sql));
		        	}
		        }
		        
		        //获取表注释
		        if (zs == "1") {
			        try {
					sql = "SELECT DBMS_LOB.substr(DBMS_METADATA.get_dependent_ddl ('COMMENT','"+obj_name+"')) STR FROM dual";
					var comds = db.QuerySQL(sql);
					for (var i=0;i<comds.getRowCount();i++) {
						if (comds.getStringAt(i,"STR").indexOf("ORA-") == -1) break;
						sb.append(comds.getStringAt(i,"STR"));
					}
					sb.append("\r\n");
				} 
				catch(e) {
				
				}
			}
		}
		
		var ddlstr = sb.toString();
		//导出不含用户名
		if (user == "1") {
			var userstr = "\"" + owner + "\".";
			ddlstr = pub.EAFunc.Replace(ddlstr,userstr,"");
		}
		
		//压缩下载
		pub.EAZip.compressStringToStream(ddlstr,response.getOutputStream());

	}
	catch(e) {
		if (db != null) db.Rollback();
		pub.EAZip.compressStringToStream(e.toString(),response.getOutputStream());
	}
	finally {
		if (db != null) db.Close();
	}
}

//在Head区引用额外脚本
function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("<script type='text/javascript' src='xlsgrid/js/jquery-1.3.2.min.js'></script>\n"); //压缩版  
}

function formatHearNote(str,length)
{
	var len = str.length();
	for (var i=0;i<length-len;i++) {
		str += " ";
	}
	str += "--";
	return str;
}

//创建去掉注释的存储过程
function createMyProc(db) 
{
	var sql = "create or replace procedure comm_proc
		  AS
		  BEGIN
		    --输出信息采用缩排或换行格式化
		    DBMS_METADATA.set_transform_param(DBMS_METADATA.session_transform, 'PRETTY', TRUE);
		    --确保每个语句都带分号
		    DBMS_METADATA.set_transform_param(DBMS_METADATA.session_transform, 'SQLTERMINATOR', TRUE);
		    --关闭存储、表空间属性
		    dbms_metadata.set_transform_param(DBMS_METADATA.SESSION_TRANSFORM,'STORAGE',false);
		    DBMS_METADATA.set_transform_param(DBMS_METADATA.session_transform, 'TABLESPACE', FALSE);
		    --关闭创建表的PCTFREE、NOCOMPRESS等属性
		    DBMS_METADATA.set_transform_param(DBMS_METADATA.session_transform, 'SEGMENT_ATTRIBUTES', FALSE);
		  END;";
	db.ExcecutSQL(sql);
}


function expData()
{
	var data = "";
	var db = null;
	try {
		db = new pub.EADatabase();
		var sb = new java.lang.StringBuffer();	
		var sql = "select * from dba_tab_columns where owner='"+user+"' and table_name='"+tableName+"' and data_type not in ('BLOB','CLOB')";
		var ds = db.QuerySQL(sql);
		var columns = "";
		var values = "";
		for (var i=0;i<ds.getRowCount();i++) {
			var column_name = ds.getStringAt(i,"COLUMN_NAME");
			var column_type = ds.getStringAt(i,"DATA_TYPE");
			var column_values = "'[%"+column_name+"]'";

			if (column_type == "DATE") {
				column_values = "to_date('[%"+column_name+"]','YYYY-MM-DD HH24:MI:SS')";
			}
			
			if (i == 0) {
				columns += column_name;
				values += column_values;
			}
			else {
				columns += ","+column_name;
				values += ","+column_values;
			}
		}
		var insql = "insert into "+tableName+"("+columns+") values("+values+");\r\n";		
		var mysql = "select " + columns + " from " + tableName + " where 1=1";
		if (where != "") mysql += " and "+where;
		var dataDS = db.QuerySQL(mysql);
		if (cmt <= 0) cmt = 99999;
		for (var r=0;r<dataDS.getRowCount();r++) {
			var tmpinsql = insql;
			for (var c=0;c<ds.getRowCount();c++) {
				var cname = ds.getStringAt(c,"COLUMN_NAME");
				var val = dataDS.getStringAt(r,cname);
				tmpinsql = pub.EAFunc.Replace(tmpinsql,"[%"+cname+"]",val);
			}
			sb.append(tmpinsql);
			if ((r+1)%cmt == 0) {
				sb.append("commit;\r\n");
			}
		}	
		sb.append("commit;\r\n");
		data = sb.toString();
	}
	catch(e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}	
	return data;
}


}
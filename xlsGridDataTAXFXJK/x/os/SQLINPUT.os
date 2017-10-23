function x_SQLINPUT(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var pub = new JavaPackage("com.xlsgrid.net.pub");

var TABLETAG = "TABLE数据查询";
var TABLEEDITTAG = "TABLE表结构编辑";
var VIEWTAG = "VIEW数据查询";
var VIEWCODETAG = "VIEW代码编辑";

function getdatabase(sqlid,dsid)
{ 
  var session = request.getSession();
  var sid = "hashmap_"+sqlid;
  var map=session.getAttribute(sid);
  if(map==null)
  {
    map = new java.util.HashMap();
    session.setAttribute(sid,map);
  }
  var keyid=dsid;
  if(dsid=="") 
    keyid="_default_";
  var db = map.get(keyid);
  if(db==null)
  {
  	
    if(dsid=="") dsid=null;
    db = new pub.EADatabase(dsid);
    map.put(keyid,db);
//    throw new Exception(sqlid+","+dsid);
  }
  return db;
}

function closealldb()
{
  var session = request.getSession();
  var sid = "hashmap_"+sqlid;
  var map=session.getAttribute(sid);
  var c=0;
  if(map!=null)
  {
    var dbs = map.values().iterator();
    while(dbs.hasNext())
    {
      var db=dbs.next();
      db.Close();
      c++;
    }
  }
  return ""+c;
}

function commit()
{
   var db = getdatabase(sqlid,dsid);
   db.GetConn().commit();
   return "提交成功。";
}

function rollback()
{
   var db = getdatabase(sqlid,dsid);
   db.GetConn().rollback();
   return "回滚成功。";
}


//================================================================// 
// 函数：Commit
// 说明：执行SQL
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：10/27/05 17:15:03
// 修改日志：
//================================================================// 
function Run()
{
  var sql = "";//new String("");
  var i = 0;
  var db = null;
  var nRun = 0;
  var retcnt = 0;
  var msg = "";
  db = getdatabase(sqlid,dsid);//new pubpack.EADatabase();
  if ( buttontype == "bat" ) 
  {
    // 执行多个SQL，使用,分割
    for(i=0;i< pubpack.EAFunc.GetListCount(runsql,";"); i++) 
    {
    	
      sql = pubpack.EAFunc.GetListValue(runsql,";",i);
      sql = sql.trim();
      if ( sql.length() > 0 ) 
      {
        try {
          retcnt += db.ExcecutSQL(sql);
          nRun ++;
        }
        catch ( e ) {
          msg += "ERROR:"+ e.toString()+"\n";
        }
      }
    }
  }
  else 
  {
    // 执行单个SQL
    retcnt += db.ExcecutSQL(runsql);
    nRun  = 1;
  }
  return msg +"执行了"+nRun +"条SQL语句,共操作了" + retcnt + "条数据库记录";
}


//================================================================// 
// 函数：GetTableTree
// 说明：得到数据的TABLE和TREE的列表
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：12/11/05 14:48:21
// 修改日志：
//================================================================// 
function GetTableTree()
{
   var db = getdatabase(sqlid,dsid);
        var xml = "";
        var sql = "";
        if( tagid==TABLETAG || tagid== TABLEEDITTAG ) 
        {
              var sql = "select a.table_name,a.typ,decode( INSTR(b.COMMENTS,'~'),0,b.COMMENTS,substr(b.COMMENTS,1,INSTR(COMMENTS,'~')-1)) note,substr(b.COMMENTS,INSTR(COMMENTS,'~')+1,length(b.comments)) comments from "+
                  "( select TABLE_NAME,'TABLE' TYP from user_tables ) "+
                  "a,user_tab_comments b "+
                  "where a.TABLE_NAME=b.table_name(+) "+
                  "order by a.TYP,a.TABLE_NAME  ";
              var ds = db.QuerySQL(sql);  
              var cnt = ds.getRowCount();
              for( var i=0;i< cnt; i ++ ) {
                    var sTableName = ds.getStringAt(i,"table_name");
                    var sNote = ds.getStringAt(i,"note");
                    var sComment = ds.getStringAt(i,"comments");
                    if ( tagid==TABLETAG )
                    	xml+="<"+sTableName +" conn=\""+dsid+"\" ID=\"+sTableName +\" name=\" "+sNote +"\" comment=\""+sComment +"\"/>";
                    else 
                    	xml+="<"+sTableName +" conn=\""+dsid+"\" ID=\"+sTableName +\" action=\"TABLEEDIT\" name=\" "+sNote +"\" comment=\""+sComment +"\"/>";

              }
        }
        else if ( tagid==VIEWTAG || tagid== VIEWCODETAG  ) {
              sql = "select a.table_name,a.typ,decode( INSTR(b.COMMENTS,'~'),0,b.COMMENTS,substr(b.COMMENTS,1,INSTR(COMMENTS,'~')-1)) note,substr(b.COMMENTS,INSTR(COMMENTS,'~')+1,length(b.comments)) comments  from "+
                  "( select VIEW_NAME TABLE_NAME,'VIEW' TYP from USER_VIEWS ) "+
                  "a,user_tab_comments b "+
                  "where a.TABLE_NAME=b.table_name(+) "+
                  "order by a.TYP,a.TABLE_NAME  ";
              var ds1 = db.QuerySQL(sql);        
              var cnt = ds1.getRowCount();
              for( var i=0;i< cnt; i ++ ) {
                    var sTableName = ds1.getStringAt(i,"table_name");
                    var sNote = ds1.getStringAt(i,"note");
                    var sComment = ds1.getStringAt(i,"comments");
                    if ( tagid==VIEWTAG )
                          xml+="<"+sTableName +" conn=\""+dsid+"\" ID=\""+sTableName +"\" name=\" "+sNote +"\" comment=\""+sComment +"\"/>";
                    else 
                          xml += "<"+sTableName +" conn=\""+dsid+"\" ID=\""+sTableName +"\" action=\"VIEWCODE\" name=\""+sNote +"\" comment=\""+sComment +"\"/>";
              }
        }    
        return xml;
}


//================================================================// 
// 函数：GetColumnList
// 说明：得到某个表格的字段列表
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：12/12/05 14:04:33
// 修改日志：
//================================================================// 
function GetColumnList()
{
   var db = getdatabase(sqlid,dsid);
        var sql = "select a.table_name,a.column_name,decode( INSTR(b.COMMENTS,'~'),0,b.COMMENTS,substr(b.COMMENTS,1,INSTR(COMMENTS,'~')-1)) note,"+
            "substr(b.COMMENTS,INSTR(COMMENTS,'~')+1,length(b.comments)) comments from "+
            "( select TABLE_NAME,COLUMN_NAME,COLUMN_ID from user_tab_columns) a,user_col_comments b "+
            "where a.TABLE_NAME=b.table_name(+) and a.COLUMN_NAME=b.COLUMN_NAME(+) and a.TABLE_NAME='"+tablename+"' order by a.COLUMN_ID";
        var ds = db.QuerySQL(sql);        
        var ret = "";
        for( var i=0;i< ds.getRowCount(); i ++ ) {
              var sTableName = ds.getStringAt(i,"table_name");
              var sColumnName = ds.getStringAt(i,"column_name");
              var sNote = ds.getStringAt(i,"note");
              var sComment = ds.getStringAt(i,"comments");
              if ( i!=0 ) ret +=",\t";
              ret+= sColumnName ;
              if ( sNote.length() >16 ) sNote = sNote.substring(0,16);
              if ( sNote.length() > 0 ) ret+= " AS \"" + sNote +"\"" ;
              ret +="\n" ;
        }
        return ret;
}
//================================================================// 
// 函数：GetViewCode
// 说明：得到视图的代码
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：04/02/06 15:57:54
// 修改日志：
//================================================================// 
function GetViewCode()
{
   var db = getdatabase(sqlid,dsid);
        var sql = "select TEXT from user_views where view_name=upper('"+tablename+"')";
        var ds = db.QuerySQL(sql);        
        if ( ds.getRowCount()> 0 ) 
              return ds.getStringAt(0,"TEXT");
        else return "";
}
//================================================================// 
// 函数：Commit
// 说明：执行SQL
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：10/27/05 17:15:03
// 修改日志：
//================================================================// 
function QuerySQL()
{
   var d1 = new java.util.Date();
   d1 = d1.getTime();
   var db = getdatabase(sqlid,dsid);
   var xml = db.pageDS(runsql,pageno,pagesize).GetXml();//.QuerySQL(runsql).GetXml();
   var d2 = new java.util.Date();
   d2 = d2.getTime();
   var t = d2 - d1;
   return ""+t+"\t"+xml;
   
   //var db = getdatabase(sqlid,dsid);
   //return db.pageDS(runsql,pageno,pagesize).GetXml();//.QuerySQL(runsql).GetXml();
}

function GetSQL()
{
   var db = getdatabase(sqlid,dsid);
   return db.GetSQL(runsql);
}

//在Head区引用额外脚本
function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
  var sql = "select ID,NAME from v_dblist";
  var ds;
  try{
    ds = pub.EADbTool.QuerySQL(sql);
  }catch(e){ ds = new pub.EAXmlDS();}
  //var ds= new pub.EAXmlDS();
  ds.AddNullRow(-1);
  ds.setValueAt(0,"id","");
  ds.setValueAt(0,"name","默认连接");
  var c=ds.getRowCount();
  sb.append("<script>\nvar treexml=\"<数据库>");
  for(var i=0;i<c;i++)
  {
    var connid=ds.getStringAt(i,"id");
    sb.append("<");sb.append(ds.getStringAt(i,"name"));sb.append(" conn=\\\""+connid+"\\\">");
    sb.append("<"+TABLETAG +" conn=\\\""+connid+"\\\" imageid=\\\"1\\\"/>");
    sb.append("<"+TABLEEDITTAG +" conn=\\\""+connid+"\\\"/>");
    sb.append("<"+VIEWTAG+" conn=\\\""+connid+"\\\"/>");
    sb.append("<"+VIEWCODETAG+" conn=\\\""+connid+"\\\"/>");
    sb.append("</");sb.append(ds.getStringAt(i,"name"));sb.append(">");
  }
  sb.append("</数据库>\";\n");
  sb.append("\nvar G_DSID=\"\";");
  sb.append("\nvar G_DSNAME=\"默认连接\";");
  var sqlid=pub.EAFunc.DateToStr(new java.util.Date(),"MMddHHmmssSSS");
  sb.append("\nvar G_SQLID=\""+sqlid+"\";");
  sb.append("</script>");
}

function GetTabCnt()
{
   	var db = getdatabase(sqlid,dsid);
  	var ds = new pubpack.EAXmlDS();
//   var sql = "select table_name from dba_all_tables  order by table_name ";
   	var sql = "select a.table_name,b.comments from "+
                  "( select TABLE_NAME,'TABLE' TYP from user_tables ) "+
                  "a,user_tab_comments b "+
                  "where a.TABLE_NAME=b.table_name(+) "+
                  "order by a.TYP,a.TABLE_NAME  ";
   	var sql2 = "";
   	try{
		ds = db.QuerySQL(sql);
		for(var i=0;i<ds.getRowCount();i++){
			var tabnam = ds.getStringAt(i,"table_name");
			 
		if(i==0){
			sql2 = "select c.表名,c.表记录数,d.comments 表说明 from ( select '"+tabnam+"' 表名 ,count(*) 表记录数 from "+tabnam;
		
		}
		if(i>0){
		sql2 += " union all select '"+tabnam+"' 表名 ,count(*) 表记录数 from "+tabnam;
		}
		if(i==(ds.getRowCount()-1)){
			sql2 +=") c,("+sql+") d	 where c.表名=d.table_name"; 
		}
	}
//  ds = db.QuerySQL(sql2).GetXml();
   }catch(e){}
//   throw new Exception(sql2);
   	return sql2;
}

function GetButSQL()
{
   	var db = getdatabase(sqlid,dsid);
  	var ds = new pubpack.EAXmlDS();
  	var sql = "";
  	if(flg==1){
//   	 	sql = "select f.tablespace_name,a.total,u.used,f.free,round((u.used/a.total)*100)\"% used\", round((f.free/a.total)*100)\"% Free\" 
//			from (select tablespace_name, sum(bytes/(1024*1024)) total 
//			from dba_data_files group by tablespace_name) a, 
//			(select tablespace_name, round(sum(bytes/(1024*1024))) used 
//			from dba_extents group by tablespace_name) u, 
//			(select tablespace_name, round(sum(bytes/(1024*1024))) free 
//			from dba_free_space group by tablespace_name) f 
//			WHERE a.tablespace_name = f.tablespace_name and a.tablespace_name = u.tablespace_name ";    
		sql = "select b.tablespace_name 表空间,
				b.file_name 物理文件名,			
				b.bytes/1024/1024 大小M,
				(b.bytes-sum(nvl(a.bytes,0)))/1024/1024  已使用M,
				sum(nvl(a.bytes,0))/1024/1024  剩余M,
				substr((b.bytes-sum(nvl(a.bytes,0)))/(b.bytes)*100,1,5)  利用率 
			from dba_free_space a,dba_data_files b 
			where a.file_id=b.file_id 
			group by b.tablespace_name,b.file_name,b.bytes 
			order by b.tablespace_name";		
	}
	else if(flg==2){
		sql = "select ss.sid,se.command,ss.value CPU ,se.username,se.program,se.serial#,'ALTER SYSTEM KILL SESSION '''||ss.sid||','||se.serial#||''';' com, 
			(select max(q.sql_text) from v$session_wait w, v$session s, v$process p, v$sqlarea q 
			where s.paddr=p.addr and 
			s.sid=ss.sid and 
			s.sql_address=q.address 
			) SQLText
			from v$sesstat ss, v$session se 
			where ss.statistic# in 
			(select statistic# 
			from v$statname 
			where name = 'CPU used by this session') 
			and se.sid=ss.sid 
			and ss.sid>6 
			order by se.username,ss.value desc ";
	}
//   throw new Exception(sql2);
   	return sql;
}


}
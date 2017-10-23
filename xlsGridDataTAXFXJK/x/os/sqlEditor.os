function x_sqlEditor(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var pub = new JavaPackage("com.xlsgrid.net.pub");

var TABLETAG = "TABLE表格对象";
var VIEWTAG = "VIEW视图对象";
var VIEWCODETAG = "VIEW视图代码";
var sqlid="";
function getdatabase(sqlid,dsid)
{
  if(dsid=="") dsid=null;
  var db = new pub.EADatabase(dsid);
  return db;
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
        if( tagid==TABLETAG) 
        {
              if(db.getDBTYP()=="mssql")
              	sql = "select top 10000 TABLE_NAME,'' note,'' comments from INFORMATION_SCHEMA.TABLES where TABLE_TYPE='BASE TABLE' order by TABLE_NAME";
              else
                sql = "select a.table_name,a.typ,decode( INSTR(b.COMMENTS,'~'),0,b.COMMENTS,substr(b.COMMENTS,1,INSTR(COMMENTS,'~')-1)) note,substr(b.COMMENTS,INSTR(COMMENTS,'~')+1,length(b.comments)) comments from "+
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
                    xml+="<"+sTableName +" conn=\""+dsid+"\" ID=\"+sTableName +\" name=\""+sNote +"\" comment=\""+sComment +"\"/>";
              }
        }
        else if ( tagid==VIEWTAG || tagid== VIEWCODETAG  ) {
              if(db.getDBTYP()=="mssql")
              	sql = "select top 10000 TABLE_NAME,'' note,'' comments from INFORMATION_SCHEMA.TABLES where TABLE_TYPE='VIEW' order by TABLE_NAME";
              else
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
                          xml+="<"+sTableName +" conn=\""+dsid+"\" ID=\""+sTableName +"\" name=\""+sNote +"\" comment=\""+sComment +"\"/>";
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
        if(db.getDBTYP()=="mssql")
          sql = "select top 300 TABLE_NAME,COLUMN_NAME,''note,''comments from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='"+tablename+"' order by ORDINAL_POSITION";
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
        var sql = "select TEXT from user_views where view_name='"+tablename+"'";
        if(db.getDBTYP()=="mssql")
          sql = "select VIEW_DEFINITION TEXT from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='"+tablename+"'";
        var ds = db.QuerySQL(sql);        
        if ( ds.getRowCount()> 0 ) 
              return ds.getStringAt(0,"TEXT");
        else return "";
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
    sb.append("<"+TABLETAG +" conn=\\\""+connid+"\\\"/>");
    sb.append("<"+VIEWTAG+" conn=\\\""+connid+"\\\"/>");
    //sb.append("<"+VIEWCODETAG+" conn=\\\""+connid+"\\\"/>");
    sb.append("</");sb.append(ds.getStringAt(i,"name"));sb.append(">");
  }
  sb.append("</数据库>\";\n");
  sb.append("\nvar G_DSID=\"\";");
  sb.append("\nvar G_DSNAME=\"默认连接\";");
  var sqlid=pub.EAFunc.DateToStr(new java.util.Date(),"MMddHHmmssSSS");
  sb.append("\nvar G_SQLID=\""+sqlid+"\";");
  sb.append("</script>");
}


//页面BODY处理完毕后事件
//sb里面是body元素及前面的head内容
//bodysb里面是body的innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
  sb.append(
"<table height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" width=\"100%\" border=\"0\">\n" +
"<tr><td height=20 width=\"100%\" colspan=\"3\">\n" + 
"SQL数据源:<select id=sqllist  style=\"WIDTH: 180px\" onchange=\"return sqllist_onchange()\"></select>\n" + 
"<button onclick='saveCurSql();'>保存</button>\n" + 
"<button onclick='saveAll();'>保存到服务器</button>\n" + 
"<button onclick='closeMe();'>关闭</button>\n" + 
"</td></tr><tr><TD id=leftTd></TD>\n" + 
"<TD></TD>\n" + 
"<td width=\"100%\">");
}
}
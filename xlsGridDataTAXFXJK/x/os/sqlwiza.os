function x_sqlwiza(){
var pub = new JavaPackage("com.xlsgrid.net.pub");

function getdatabase(dsid)
{
    if(dsid=="") dsid=null;
    var db = new pub.EADatabase(dsid);

  return db;
}

function GetColumnList()
{
   var db = getdatabase(dsid);
        var sql = "select a.column_name name,decode( INSTR(b.COMMENTS,'~'),0,b.COMMENTS,substr(b.COMMENTS,1,INSTR(COMMENTS,'~')-1)) note from "+
            "( select TABLE_NAME,COLUMN_NAME,COLUMN_ID from user_tab_columns) a,user_col_comments b "+
            "where a.TABLE_NAME=b.table_name(+) and a.COLUMN_NAME=b.COLUMN_NAME(+) and a.TABLE_NAME=UPPER('"+tablename+"') order by a.COLUMN_ID";
        if(db.getDBTYP()=="mssql")
          sql = "select top 300 COLUMN_NAME name,'' note from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='"+tablename+"' order by ORDINAL_POSITION";
        //throw new Exception(sql);
        var ds = db.QuerySQL(sql);        

        return ds.GetXml();
}

}
function x_sqlEditor(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var pub = new JavaPackage("com.xlsgrid.net.pub");

var TABLETAG = "TABLE������";
var VIEWTAG = "VIEW��ͼ����";
var VIEWCODETAG = "VIEW��ͼ����";
var sqlid="";
function getdatabase(sqlid,dsid)
{
  if(dsid=="") dsid=null;
  var db = new pub.EADatabase(dsid);
  return db;
}

//================================================================// 
// ������GetTableTree
// ˵�����õ����ݵ�TABLE��TREE���б�
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�12/11/05 14:48:21
// �޸���־��
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
// ������GetColumnList
// ˵�����õ�ĳ�������ֶ��б�
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�12/12/05 14:04:33
// �޸���־��
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
// ������GetViewCode
// ˵�����õ���ͼ�Ĵ���
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�04/02/06 15:57:54
// �޸���־��
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

//��Head�����ö���ű�
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
  ds.setValueAt(0,"name","Ĭ������");
  var c=ds.getRowCount();
  sb.append("<script>\nvar treexml=\"<���ݿ�>");
  for(var i=0;i<c;i++)
  {
    var connid=ds.getStringAt(i,"id");
    sb.append("<");sb.append(ds.getStringAt(i,"name"));sb.append(" conn=\\\""+connid+"\\\">");
    sb.append("<"+TABLETAG +" conn=\\\""+connid+"\\\"/>");
    sb.append("<"+VIEWTAG+" conn=\\\""+connid+"\\\"/>");
    //sb.append("<"+VIEWCODETAG+" conn=\\\""+connid+"\\\"/>");
    sb.append("</");sb.append(ds.getStringAt(i,"name"));sb.append(">");
  }
  sb.append("</���ݿ�>\";\n");
  sb.append("\nvar G_DSID=\"\";");
  sb.append("\nvar G_DSNAME=\"Ĭ������\";");
  var sqlid=pub.EAFunc.DateToStr(new java.util.Date(),"MMddHHmmssSSS");
  sb.append("\nvar G_SQLID=\""+sqlid+"\";");
  sb.append("</script>");
}


//ҳ��BODY������Ϻ��¼�
//sb������bodyԪ�ؼ�ǰ���head����
//bodysb������body��innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
  sb.append(
"<table height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" width=\"100%\" border=\"0\">\n" +
"<tr><td height=20 width=\"100%\" colspan=\"3\">\n" + 
"SQL����Դ:<select id=sqllist  style=\"WIDTH: 180px\" onchange=\"return sqllist_onchange()\"></select>\n" + 
"<button onclick='saveCurSql();'>����</button>\n" + 
"<button onclick='saveAll();'>���浽������</button>\n" + 
"<button onclick='closeMe();'>�ر�</button>\n" + 
"</td></tr><tr><TD id=leftTd></TD>\n" + 
"<TD></TD>\n" + 
"<td width=\"100%\">");
}
}
function x_Expdbtolocal(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage("com.xlsgrid.net.web");

// JS传入的参数（yymm）可以直接使用
function save()
{
      var db = null;
      var ds = null;
      var msg= "";
      try {
            	db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		ds = new pubpack.EAXmlDS(xml);
		
		for ( var i=0;i<ds.getRowCount();i++){
			var selflg = ds.getStringAt(i,"SELECTFLAG" );
			if ( selflg == "1" ) {
				var table_name = ds.getStringAt(i,"TABLENAME" );
				var where = ds.getStringAt(i,"WHERE" );
				if ( where.length() > 0 ) {
					where = pubpack.EAFunc.Replace(where,"[%DAT]",dat );
				}
				var colds = db.QuerySQL("select COLUMN_NAME,DATA_TYPE from USER_TAB_COLUMNS where table_name=UPPER('"+table_name+"')" ); 
				var collist= "";
				var colheadlist = "";
				for ( var j=0;j<colds .getRowCount();j++){
					var colnam=colds.getStringAt(j,"COLUMN_NAME");
					var dattyp=colds.getStringAt(j,"DATA_TYPE");
					if ( j>0) colheadlist += ",";
					colheadlist +=colnam;
					if ( j>0) collist+= "||','||";
					if ( dattyp== "DATE" ) 
						collist+="DECODE("+colnam+",NULL,'','TO_DATE('''||"+"to_char("+colnam+",'YYYY-MM-DD hh24:mi:ss')"+"||''',''YYYY-MM-DD hh24:mi:ss'')')";
					else collist+="''''||"+colnam+"||''''";
				}
				msg += "delete from "+table_name ;
				if ( where.length() > 0 ) {
					msg += " WHERE " + where;
				}	
				msg += "\r";			
				msg += "insert into "+table_name +"("+colheadlist +") \r";
				var sql = "SELECT "+collist+" str FROM "+table_name ;
				if ( where.length() > 0 ) {
					sql += " WHERE " + where;
				}
				var datds = db.QuerySQL(sql);
				for ( var k = 0 ;k<datds.getRowCount();k++){
					msg += datds.getStringAt( k,"str" )+"\n\r";
				}
			}			
		}
      }
      catch ( ee ) {
            db.Rollback();
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      //var usrinfo = web.EASession.GetLoginInfo(request);
      //var homeurl = usrinfo.getHomeURL();
      if ( fileurl  == "" ) 
      	fileurl = "/tmp/"+dat+".bak";

      pubpack.EAFunc.WriteToFileEx(fileurl,msg,false);
      return fileurl ;
}



}
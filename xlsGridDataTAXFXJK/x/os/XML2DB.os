function x_XML2DB(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
//作为.sp服务时的入口
//预定义变量：request,response
// 参数
//	dbname : 数据库的别名,如ISOGRAPH
//      dbtype:  数据库的类型,如ORACLE/SQLSERVER/ACCESS
//	dbxml:数据库结构定义的XML，该XML需要包括的字段是 TABLEID，COLID，COLTYP，COLLEN， 
//      。。。 每个TABLE的XML，这些TABLE需要出现在dbxml的TABLEID中
// 返回：
//	操作结果说明
function Response()
{
      var dbname =pubpack.EAFunc.NVL( request.getParameter("dbname"),"" );
      var dbtype =pubpack.EAFunc.NVL( request.getParameter("dbtype"),"ORACLE" );
      var dbxml =pubpack.EAFunc.NVL( request.getParameter("dbxml"),"" );

      if ( dbxml == "" ) return "参数dbxml必须";
      var db = null;
      var ret= "";
      var tablename="";
      try {
      		
            db = new pubpack.EADatabase(dbname);	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
	
            var tabds = new pubpack.EAXmlDS(dbxml);
            var oldtablename = "";
            var createsql = "";
            var collistsql = "";
            var inscollist = "";
            var inscoltyplist = "";
            //创建表结构
            var tablelist= "";
            for ( var i=0;i<tabds.getRowCount();i++) {
            	tablename = tabds.getStringAt(i,"TABLEID");
            	var colid = tabds.getStringAt(i,"COLID");
            	var coltyp = tabds.getStringAt(i,"COLTYP");
            	var collen = tabds.getStringAt(i,"COLLEN");

            	if ( tablename!=oldtablename&& oldtablename!= ""){
 
            			createsql = "create table " + oldtablename + "(" + collistsql + ")";
            			try {db.ExcecutSQL("drop table " + oldtablename );}catch( e ) {}
            			db.ExcecutSQL(createsql);
            			if ( tablelist!= "" ) tablelist+=",";
            			tablelist+=oldtablename ;
            			collistsql = "";
            			
            			inscollist +="～";//分割
            			inscoltyplist +="～";
            			
            	}
            	if ( collistsql !="" ) {collistsql += ",";inscollist +=","; inscoltyplist +=",";}
		collistsql += colid +" "+coltyp ;
		if ( collen!="" ) collistsql +="("+collen +")";          
		inscollist += colid ;  
		inscoltyplist += coltyp;   
            	oldtablename=tablename ;
            }

            if ( oldtablename!= "" ) {
		createsql = "create table " + oldtablename+ "(" + collistsql + ")";
		try {db.ExcecutSQL("drop table " + oldtablename);}catch( e ) {}
		db.ExcecutSQL(createsql);
            	if ( tablelist!= "" ) tablelist+=",";
            	tablelist+=oldtablename ;
		
            }
	   
            var stablelist = tablelist.split(",");
            var sinscollist = inscollist.split("～");
            var sinscoltyplist  = inscoltyplist.split("～");

            var nCount = 0;
            for ( var t=0;t<stablelist.length();t++) {
            	var xml =pubpack.EAFunc.NVL( request.getParameter(stablelist [t]),"" );
		if ( xml == "" ) throw new Exception ( "参数"+ stablelist [t] + "没有传入" );
            	var ds = new pubpack.EAXmlDS(xml);
            	
            	for ( var i=0;i<ds.getRowCount();i++ ) {
            		var sql = "insert into " + stablelist[t]+ "( " +sinscollist [t] + " ) values( " ;  
            		var ss = sinscollist[t] .split( "," );// 得到每个列	
            		var ss_coltyp = sinscoltyplist[t].split( "," );// 得到每个列	
            		for ( var c= 0;c<ss.length() ;c++ ) {
            			if ( c!= 0 ) sql += ",";
            			try {
            				if ( ss_coltyp[c]=="FLOAT" || ss_coltyp[c]=="INT" || ss_coltyp[c]=="NUMBER" ) {
            					if(ds.getStringAt(i,ss[c])=="")
            						 sql += "null";
            					else sql +=ds.getStringAt(i,ss[c]); 
            				}
					else 
		            			sql += "'"+ds.getStringAt(i,ss[c])+"'"; 
	            		}
	            		catch ( e ) {
	            			throw new pubpack.EAException ( stablelist[t]+"的字段"+ss[c]+"在参数" +stablelist[t]+"描述的XML中不存在"  );
	            		}
            		
            		}
            		sql += " )";
            		pubpack.EAFunc.Log( sql);

            		nCount += db.ExcecutSQL(sql);
            	}
            	

            }
            
            return "导入"+stablelist.length()+"个表共"+nCount +"笔记录";
	
      }
      catch ( ee ) {
            db.Rollback();
            ret = ee.toString();
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      return ret ;
}


}
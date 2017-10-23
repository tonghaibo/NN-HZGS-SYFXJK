function x_apiaddtemp(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
//作为.sp服务时的入口
//预定义变量：request,response
function Response()
{
      var code = request.getParameter("CODE");
      var db = null;
      var guid= "";
      try {
            db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
	    guid=db.GetSQL( "select sys_guid() from dual" );
	    var sql = "insert into funclist (guid, class, note ) values (?,?,?)";
	    var eadml = new baskpack.EADML(db,sql);
	    eadml.createPreparedStatement();
	    eadml.setString(1,guid);
	    eadml.setString(2,"TEMP");
	    eadml.setString(3,code );
	    //var sdf = new textpack.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    //eadml.setTimestamp(4,pubpack.EAFunc.StrToTimestamp("2008-01-01"));
	    eadml.execute();
	    eadml.closeStatement();

	    //db.ExcecutSQL("insert into funclist (guid, class, note ) values ( '"+guid+"','TEMP','"+code +"' )" ); 
      }
      catch ( ee ) {
            db.Rollback();
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      return guid ;
}
}
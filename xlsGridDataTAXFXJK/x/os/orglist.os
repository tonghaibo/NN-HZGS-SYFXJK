function x_orglist(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
//作为.sp服务时的入口
//预定义变量：request,response
function Response()
{
      var orgid = request.getParameter("orgid");
      var db = null;
      var guid= "";
      try {
            db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
	    var ds =db.QuerySQL( "select id,name from usr " );//where orgid='"+orgid+"'
	    return ds.GetXml();
      }
      catch ( ee ) {
            db.Rollback();
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      return "" ;
}
}
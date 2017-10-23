function XLSGRID_NewInsertDuty(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" );
function InsertDuty()
{
      var db = null;
      var msg= 0;
      var sql = "";
      try {
         db = new pubpack.EADatabase();// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
         sql="insert into duty (dat,dayusr,ngtusr) values(to_date('"+insdat+"','yyyy-mm-dd'),'"+insdu+"','"+insnu+"')";
         db.ExcecutSQL(sql);
	 //throw new Exception(sql);
         db.Commit();
         return msg++;
      }
      catch ( ee ) {
            db.Rollback();
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
}
function UpdateDuty()
{
      var db = null;
      var ret= 0;
      var sql = "";
      try {
         db = new pubpack.EADatabase();// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
         sql="update duty set dayusr = '"+updu+"' , ngtusr = '"+upnu+"' where dat = to_date('"+updat+"','yyyy-mm-dd')";
         db.ExcecutSQL(sql);
	 //throw new Exception(sql);
         db.Commit();
         return ret++;
      }
      catch ( ee ) {
            db.Rollback();
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }


}


function getUsrInfo(){
		// OS 中如何得到登录的信息
	var usr=web.EASession.GetLoginInfo(request);
	var orgid=usr.getOrgid();
	var sytid=usr.getSytid();
	var accid=usr.getAccid();

}









}
function x_orglist(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
//��Ϊ.sp����ʱ�����
//Ԥ���������request,response
function Response()
{
      var orgid = request.getParameter("orgid");
      var db = null;
      var guid= "";
      try {
            db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
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
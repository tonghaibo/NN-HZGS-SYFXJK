function XLSGRID_ESTYLE(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" );
function filterXmlDS()
{
      var db = null;
      try 
      {
            db = new pubpack.EADatabase();
            var ds = null;
            var sql = "select id,name,note from trktyp order by id";
            ds = db.QuerySQL(sql);
            return ds.GetXml();
      }
      catch (e)
      {
              db.Rollback();
               throw new pubpack.EAException ( e.toString() );
      }
      finally 
      {
            if (db!=null) db.Close();
      }

      
          
      
      
}
}
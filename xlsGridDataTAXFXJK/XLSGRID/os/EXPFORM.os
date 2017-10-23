function XLSGRID_EXPFORM(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" );
function save()
{
   var db = null;
   var ds = null;
   var ret = "";
    var tid = pubpack.EAFunc.SQLIN( id ); 
    var sql  = " select rownum rid,t.* from (select distinct project,proorg,prousr,prodat,note "+  
                " from trkhdr "+
                " where id in ("+tid+") order by prodat desc) t ";
     try 
    {  
         db = new pubpack.EADatabase();
         ds = db.QuerySQL(sql);
         ret = ds.GetXml();
         return ret;
      
   }
    catch(e)
      {
            throw e;
      }
      finally
      {
            db.Close(); 
      }       

   

}
}
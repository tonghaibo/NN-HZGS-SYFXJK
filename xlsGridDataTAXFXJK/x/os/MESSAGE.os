function x_MESSAGE(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//º”‘ÿ¿‡∞¸
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" );

function save()
{
      var ret = 0;
      var db = null;
      var ds = null;
      var sql = "insert into msg (title,note,crtusr,tousr) "+
                " values ('"+title+"','"+note+"','"+crtusr+"','"+tousr+"')";
      try
      {
            db = new pubpack.EADatabase();
            ret =  db.ExcecutSQL(sql);
            return ret ;
      }
      catch(e)
      {
      
      }
      finally
      {
         db.Close(); 
      }       



}
}
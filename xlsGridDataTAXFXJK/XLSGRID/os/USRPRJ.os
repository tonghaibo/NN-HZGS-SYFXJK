function XLSGRID_USRPRJ(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//º”‘ÿ¿‡∞¸  
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" );  

function save() 
{
       var db = null;
       var ds = null;
       var ps1 = null;
       var ps2 = null;
       var sql1 = "";
       var sql2 = "";
       var ret = 0;
      try
      {              
             db = new pubpack.EADatabase();
             sql1 = "insert into prjusr(prj,usr,usrlvl,note,cost,crtusr,org) values(?,?,?,?,?,?,?)";             
             ps1 = db.prepareStatement(sql1);
             ps1.setString(1,prjguid);
             ps1.setString(2,usrguid);
             ps1.setString(3,usrlvl);
             ps1.setString(4,note);
             ps1.setString(5,cost);
             ps1.setString(6,crtusr);       
             ps1.setString(7,org);      
             ret = ps1.executeUpdate();    
             ps1.close();
             db.Commit();         
             return ret ;   
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
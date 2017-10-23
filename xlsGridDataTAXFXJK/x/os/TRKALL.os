function x_TRKALL(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" );
function filterXmlDS()
{
      var ret = 0; 
      var db = null;  
      var ds = null; 
      var sql = "select project,id,title,retitle,stat,prio,crtusr,crtdat,note "+
                " from trkhdr where project='"+project+"' and title='"+title+"' "+
                " and retitle='"+retitle+"'";
               // throw new Exception (sql);
      try  
      { 
            db = new pubpack.EADatabase(); 
            ds = db.QuerySQL(sql);           
            return ds.GetXml() ; 
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
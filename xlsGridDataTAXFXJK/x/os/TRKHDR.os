function x_TRKHDR(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//加载类包 
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" ); 

function save() 
{
      var ret = 0;
      var db = null;
      var ds = null;
      var sql = "";
                  
     // var sql1 = "insert into trkdtl(trkguid) select guid from trkhdr where project='"+project+"'";有待解决     
      try
      {
            db = new pubpack.EADatabase();
          //  sql = "SELECT SYS_GUID() FROM DUAL" ;
           // var guid = db.GetSQL( sql);
            sql = "insert into trkhdr(id,title,retitle,note,prio,crtusrorg,crtusr,stat, " +
                  " dtlusr,dtlusrorg,project) values (seq.nextval,'"+title+"','"+retitle+"','"+note+"' ," +
                  " '"+prio+"','"+crtusrorg+"','"+crtusr+"', "+
                  " '"+stat+"','"+dtlusr+"','"+dtlusrorg+"','"+project+"')";
            ret = db.ExcecutSQL(sql);
//            sql = "insert into trkdtl(guid,id,title,retitle,note,prio,crtusrorg,crtusr,stat, " +
//                  " dtlusr,dtlusrorg,project) values ('"+guid+"',seq.nextval,'"+title+"','"+retitle+"','"+note+"' ," +
//                  " '"+prio+"','"+crtusrorg+"','"+crtusr+"', "+
//                  " '"+stat+"','"+dtlusr+"','"+dtlusrorg+"','"+project+"')";
//            ret = db.ExcecutSQL(sql);
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
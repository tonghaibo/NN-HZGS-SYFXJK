function x_TRKDTL(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//加载类包 
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" ); 

function commit() 
{
      var ret = 0; 
      var db = null; 
      var ds = null; 
      var usrid  = SYS_USRID;
      try
      {
             db = new pubpack.EADatabase();
             var guid = db.GetSQL("select guid from trkhdr where project='"+project+"'");// and title='"+title+"' and retitle='"+retitle+"'");
             var sql = "insert into trkdtl (trkguid,pro_note,tousr,pro_record, "+
                       " style,crtusrorg,crtusr,result,project ) values ('"+guid+"','"+pro_note+"', "+
                       " '"+tousr+"','"+pro_record+"','"+style+"','"+crtusrorg+"','"+usrid+"','2','"+project+"')";//有待解决

            ret = db.ExcecutSQL(sql);
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
function XLSGRID_NEWTYP(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//º”‘ÿ¿‡∞¸ 
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" ); 

function save() 
{
      var ret = 0;
      var db = null;
      var ds = null;
      var sql = "";
      try
      {
            db = new pubpack.EADatabase();
            var sql1 =  "SELECT trk_seq.nextval FROM DUAL" ; 
            var trk_id = db.GetSQL(sql1);
            sql = "insert into trktyp(id,name,note,finkey,trsflg,sendto,endflg,retflg,toptyp,crtusr ) "+
                  "values('"+trk_id+"','"+name+"','"+note+"','"+finkey+"','"+trsflg+"','"+sendto+"','"+endflg+"',"+
                  "'"+retflg+"','"+toptyp+"','"+crtusr +"')"; 
            ret = db.ExcecutSQL(sql);
            var guid = db.GetSQL("select guid from trktyp where id='"+trk_id+"'");            
            return guid ;      
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
function XLSGRID_WAITORG(){//var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//�������  
//var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" );  
//
//function save() 
//{
//      var ret = 0;
//      var db = null;
//      var ds = null;
//      var sql = "";
//      try
//      { 
//             db = new pubpack.EADatabase();
//             var usr = db.GetSQl("select distinct crtusr from trkdtl ");
//             if ( usr != "" )
//             {
//             
//             sql = "select distinct a.title,a.crtusr,to_char(a.crtdat,'yyyy-mm-dd hh24:mi:ss') crtdat,a.id,a.show from  "+ 
//			"trkhdr a,trkdtl b,v_usr c,v_prj d ,trktyp e,prjusr pu  "+
//			"where c.orgid=(select orgid from v_usr where id='"+usrid+"') "+
//			//"and b.crtusr not in (select name from v_usr where id='"+usrid+"')"+
//			"and b.crtusr=c.orgid"+
//			"and a.show=e.id "+
//			"and a.guid=b.trkguid "+
//			"and pu.usr=c.guid  "+
//			"and pu.prj=d.guid "+
//			"and a.dtlusr=c.name "+
//			"and a.project=d.id "+
//			"and  b.style='δ����'  "+
//			"and e.id in ('4','5','16','17') "+
//			"and d.id like '"+prj+"%' "+
//			"and a.crtusr like '"+create+"%' "+
//			"and a.title like '"+title+"%' "+
//			"and e.id like '"+trktyp+"%'  "+
//			"order by crtdat desc "; 
//			//throw new Exception (sql);
//			 ds = db.QuerySQL(sql);
//			 return ds.GetXml();
//		}
//				
//       }
//	     catch(e)
//	      {
//	            throw e;
//	      }
//	      finally
//	      {
//	            db.Close(); 
//      }       
//}
//
}
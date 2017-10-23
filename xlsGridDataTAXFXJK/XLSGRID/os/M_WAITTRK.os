function XLSGRID_M_WAITTRK(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//加载类包  
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
             sql = "select distinct a.title,a.crtusr,to_char(a.crtdat,'yyyy-mm-dd hh24:mi:ss') crtdat,a.id,a.show from  "+ 
			"trkhdr a,trkdtl b,v_usr c,v_prj d ,trktyp e,prjusr pu  "+
			"where c.id='"+usrid+"' "+
			"and a.show=e.id "+
			"and a.guid=b.trkguid "+
			"and pu.usr=c.guid  "+
			"and pu.prj=d.guid "+
			"and a.dtlusr=c.name "+
			"and a.project=d.id "+
			"and  b.style='未处理'  "+
			"and e.id in ('4','5','16','17') "+
			"and d.id like '"+prj+"%' "+
			"and a.crtusr like '"+create+"%' "+
//			"and a.title like '%[%title]%' "+
//			"and e.id like '[%trktyp]%'  "+
			"order by crtdat desc "; 
			//throw new Exception (sql);
			 ds = db.QuerySQL(sql);
			 return ds.GetXml();
				
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
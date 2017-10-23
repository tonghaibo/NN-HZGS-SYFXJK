function x_WG_URLCONF(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
function Save()
{
	var db = null;
	var ds1 = null;
	var ds2 = null;
	var sql = "";
	try{
		db = new pubpack.EADatabase();
		throw new Exception(xml1);
		ds1 = new pubpack.EAXmlDS(xml1);
		ds2 = new pubpack.EAXmlDS(xml2);
		for (var r = 0;r< ds1.getRowCount();r++)
		{
			var flag = ds1.getStringAt(r,"FLAG");
			var guid = ds1.getStringAt(r,"GUID");
			if (flag.equals("I"))
			{
				sql = " insert into WG_CONF(ka,uri1,uri2,uri3,uri4,uri5,uri6,uri7,uri8)
					values('"+ds.getStringAt(r,"KA")+"','"+ds.getStringAt(r,"URI1")+"','"+ds.getStringAt(r,"URI2")+"','"+ds.getStringAt(r,"URI3")+"','"+ds.getStringAt(r,"URI4")+"','"+ds.getStringAt(r,"URI5")+"','"+ds.getStringAt(r,"URI6")+"','"+ds.getStringAt(r,"URI7")+"','"+ds.getStringAt(r,"URI8")+"')
				      ";
				db.ExcecutSQL(sql);					
			}
			if (flag.euqals("U"))
			{
				sql = "update WG_CONF SET KA='"+ds.getStringAt(r,"KA")+"',URI1='"+ds.getStringAt(r,"URI1")+"',URI2='"+ds.getStringAt(r,"URI2")+"',URI3='"+ds.getStringAt(r,"URI3")+"',URI4='"+ds.getStringAt(r,"URI4")+"',URI5='"+ds.getStringAt(r,"URI5")+"',URI6='"+ds.getStringAt(r,"URI6")+"',URI7='"+ds.getStringAt(r,"URI7")+"',URI8='"+ds.getStringAt(r,"URI8")+"' 
					where guid='"+guid+"'
				      ";
				db.ExcecutSQL(sql);				      
			}
			if (flag.euqals("D"))
			{
				sql = "delete from WG_CONF where guid='"+guid+"'";
				db.ExcecutSQL(sql);				
				sql = "delete from WG_CONF_EXT where ka='"+ds.getStringAt(r,"KA")+"'";
				db.ExcecutSQL(sql);				
			}
			sql = " delete from WG_CONF_EXT where uri not in ('"+ds.getStringAt(r,"URI1")+"','"+ds.getStringAt(r,"URI2")+"','"+ds.getStringAt(r,"URI3")+"','"+ds.getStringAt(r,"URI4")+"','"+ds.getStringAt(r,"URI5")+"','"+ds.getStringAt(r,"URI6")+"','"+ds.getStringAt(r,"URI7")+"','"+ds.getStringAt(r,"URI8")+"')";
			db.ExcecutSQL(sql);

		}
		
		for (var j = 0;j<ds2.getRowCount();j++)
		{
			var flag = ds2.getStringAt(j,"FLAG");
			var guid = ds2.getStringAt(j,"GUID");
			if (flag.equals("U"))
			{
				sql = "update WG_CONF_EXT set ka='"+ ds2.getStringAt(j,"KA")+"',URI='"+ ds2.getStringAt(j,"URI")+"',PARAMS='"+ ds2.getStringAt(j,"PARAMS")+"',CODE='"+ ds2.getStringAt(j,"CODE")+"',METHOD='"+ ds2.getStringAt(j,"METHOD")+"'";
				db.ExcecutSQL(sql);
			}
			if (flag.equals("I"))
			{
				sql = "insert into WG_CONF_EXT(ka,uri,params,code,method) values('"+ ds2.getStringAt(j,"KA")+"','"+ ds2.getStringAt(j,"URI")+"','"+ ds2.getStringAt(j,"PARAMS")+"','"+ ds2.getStringAt(j,"CODE")+"','"+ ds2.getStringAt(j,"METHOD")+"')";
				db.ExcecutSQL(sql);
			}
		}
		
		
		db.Commit();
	}catch(e)
	{
		db.Rollback();
		throw new Exception(e);
	}
	
}



}
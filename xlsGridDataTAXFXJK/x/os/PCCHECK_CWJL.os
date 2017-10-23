function x_PCCHECK_CWJL(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
function Gen()
{
	var db = null;
	var sql = "";
	try
	{
		db = new pubpack.EADatabase();
		sql="update bilhdr set refnam6='' where acc='"+acc+"' and guid='"+guid+"'";			
		db.ExcecutSQL(sql);
		db.Commit();
	}
	catch(e)
	{
		db.Rollback();
		throw new pubpack.EAException(e.toString());
	}
	finally
	{
		if(db != null)
			db.Close();
	}
}
}
function x_apiupdate(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//������� 
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" ); 

function save()
{
	var db = null;	
	var sql = "";
	var ret=0; 
	try
	{
		db = new pubpack.EADatabase();
		if ( action  == "over" )			
			sql = "update funclist set note=(select note from funclist where guid='"+guid+"' ) where guid='"+newguid+"'";     //����
		else 
			sql = "update funclist set id='"+ids+"',class='"+typ+"',function='"+name+"',name='"+name+"',lang='CODE' where guid='"+guid+"'" ;   //����
                 ret += db.ExcecutSQL(sql);		
		db.Commit(); 		
	}
	catch(e)
	{
	    if (db!=null) 
	    db.Rollback();
            throw e;
	}
	finally
	{
	    if (db!=null)
            db.Close(); 
	}
	return ret;
	
	///
}

}
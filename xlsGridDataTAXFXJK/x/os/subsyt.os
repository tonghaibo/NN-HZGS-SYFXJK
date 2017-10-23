function x_subsyt(){var xmldbpack = new JavaPackage("com.xlsgrid.net.xmldb");
var pub = new JavaPackage("com.xlsgrid.net.pub");

function load( ) { 
	var ds0 = xmldbpack.EAXmlDB.getSubSytDB(mysytid);
	if( ds0 == null )
		return pub.EAFunc.readFile(pub.EAOption.dynaDataRoot+"/xmldb/sytdb/nullsubsytdb.xml");
	
	//if ( ds0!=null && ds0.GetRowCount()==0 )
	//	return pub.EAFunc.readFile(pub.EAOption.dynaDataRoot+"/xmldb/sytdb/nullsubsytdb.xml");
		
	return ds0.GetXml();
}  

function save( ) { 
	pub.EAFunc.WriteToFile(pub.EAOption.dynaDataRoot+"/"+mysytid+"/subsytdb.xml",xml);
	return "±£´æ³É¹¦" ;
}  

function genguid(){
	var db = null;
	try
	{
            db = new pub.EADatabase();
            var sql = "SELECT sys_guid() FROM DUAL" ; 
            var guid = db.GetSQL(sql);
            return guid;
	}catch(e){
		if( db!= null ) db.Rollback();
		throw new Exception(e);
	}
	finally{
		if(db!=null)db.Close(); 
	}       
}
}
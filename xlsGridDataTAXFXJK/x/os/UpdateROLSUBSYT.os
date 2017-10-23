function x_UpdateROLSUBSYT(){var xmldbpack = new JavaPackage("com.xlsgrid.net.xmldb");
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
//	pub.EAFunc.WriteToFile(pub.EAOption.dynaDataRoot+"/"+mysytid+"/subsytdb.xml",xml);
//	return "保存成功" ;

	var db = null;
	var sql = "";
	
	try {
		db = new pub.EADatabase();
		
		var subds = null;
		var itmds = null;		
		if (subsytxml != "") subds = new pub.EAXmlDS(subsytxml);
		if (subitemxml != "") itmds = new pub.EAXmlDS(subitemxml);
		
		if (subds != null) {
			sql = "delete from rolsubsyt where rol='"+rolguid+"' and syt='"+thissytid+"' and ord='0'";
			db.ExcecutSQL(sql);
			for (var i=0;i<subds.getRowCount();i++) {
				var subid = subds.getStringAt(i,"SUBID");
				var auth = subds.getStringAt(i,"AUTH");
				var show = subds.getStringAt(i,"SHOW");
				if (subid != "" && auth == "1") {
					sql = "insert into rolsubsyt(rol,syt,subsytid,show,ord,auth) values ('%s','%s','%s','%s','0','%s')".format([rolguid,thissytid,subid,show,auth]);
					db.ExcecutSQL(sql);
				}
			}
		}
		
		if (itmds != null) {
			if (itmds.getRowCount() > 0) {
				var subsytid = itmds.getStringAt(0,"SUBID");
				sql = "delete from rolsubsyt where rol='"+rolguid+"' and syt='"+thissytid+"' and ord!='0' and subsytid='"+subsytid+"'";
				db.ExcecutSQL(sql);
			}
			for (var i=0;i<itmds.getRowCount();i++) {
				var subid = itmds.getStringAt(i,"SUBID");
				var auth = itmds.getStringAt(i,"AUTH");
				var show = itmds.getStringAt(i,"SHOW");
				var ord = itmds.getStringAt(i,"ORDER");
				if (subid != "" && auth == "1") {
					sql = "insert into rolsubsyt(rol,syt,subsytid,show,ord,auth) values ('%s','%s','%s','%s','%s','%s')".format([rolguid,thissytid,subid,show,ord,auth]);
					db.ExcecutSQL(sql);
				}
			}
		}
		
		db.Commit();
		return "保存成功!";
		
	}
	catch(e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
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
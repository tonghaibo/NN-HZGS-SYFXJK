function x_EBItemIns(){var pubpack = new JavaPackage("com.xlsgrid.net.pub"); 
function saveEBItem()
{
	var db = null;
	var sql = "";
	var i = 0;
	try{
		db = new pubpack.EADatabase();
		var ds = new pubpack.EAXmlDS(xml);	
			
		sql = " update corpitem set ebitem=? where CORP=? and item=?";
		var pstmt = db.GetConn().prepareStatement(sql);
		
		for (var r = 0;r< ds.getRowCount();r++)
		{				
			pstmt.setString(1,ds.getStringAt(i,"EBITEM"));
			pstmt.setString(2,ds.getStringAt(i,"KAGUID"));
			pstmt.setString(3,ds.getStringAt(i,"ITEMGUID"));
			pstmt.addBatch();
			i++;
		}
		pstmt.executeBatch();		

		db.Commit();
		return i;
	}catch(e){
		db.Rollback();
		throw new Exception(e);
	}

}
}
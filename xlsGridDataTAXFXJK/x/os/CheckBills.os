function x_CheckBills(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var grd = new JavaPackage ( "com.xlsgrid.net.grd" );
// 客户端param传入的参数可以直接使用

function operate(){
//	throw new pubpack.EAException(xmlstr);
	var db = null;
	
	try{
		var xmlds = new pubpack.EAXmlDS(xmlstr);
		var e = new grd.EABillGrid();	
		db = new pubpack.EADatabase();
//		throw new Exception("o:"+o);
		var msg = 0;	
		for(var row=0;row< xmlds.getRowCount();row++)
		{
			var guid = xmlds.getStringAt(row,"guid");
			var biltyp = xmlds.getStringAt(row,"biltyp");
			var bilid = xmlds.getStringAt(row,"bilid");
			
			if(o=="CHECK"){
				e.CheckOneBill(db,acc,biltyp,bilid,usrid);
//				db.Commit();
			}else if(o=="UNCHECK"){
				e.CheckOneBill(db,acc,biltyp,bilid,usrid,true);
			}else{
				throw new pubpack.EAException("发现异常操作指示:"+o);
			}

			msg++;
		}
		db.Commit();
		return msg;	
	}catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
}





}
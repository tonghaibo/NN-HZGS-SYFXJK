function x_KIT(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

//单据审核前
function fos_beforecheck(eaContext)
{
	var db = null;
	var sql = "";
	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var xmlhdr = new pubpack.EAXmlDS(eaContext.getXmlhdr());
		var xmldtl = new pubpack.EAXmlDS(eaContext.getXmldtl());
		var crtusr = xmlhdr.getStringAt(0, "CRTUSR");
		var crtdat = xmlhdr.getStringAt(0, "DAT");
		for (var i = 0; i < xmldtl.getRowCount(); i ++) {
			var kaid = xmldtl.getStringAt(i, "ITEMPC");
			var itemid = xmldtl.getStringAt(i, "ITMID");
			if (kaid != "" && itemid != "") {
				sql = "select count(*) count from corpitem where CORP=(select guid from v_ka where id='"+ kaid
					+"') and item=(select guid from v_item where id='"+ itemid +"')";
				var ds = db.QuerySQL(sql);
				var price = xmldtl.getStringAt(i, "PRICE");
				var note = xmldtl.getStringAt(i, "REFNAM2");
				if (ds.getStringAt(0, "count")*1 > 0) {
					sql = "update corpitem set price="+ price +",note='"+ note +"'"
						+" where CORP=(select guid from v_ka where id='"+ kaid
						+"') and item=(select guid from v_item where id='"+ itemid +"')";
//						throw new Exception(sql);
				} else {
					sql = "insert into corpitem(item,CORP,price,note,crtusr,crtdat) values((select guid from v_item where id='"+ itemid
						+"'),(select guid from v_ka where id='"+ kaid +"'),"+ price +",'"+ note +"','"+ crtusr +"',to_date('"+ crtdat +"','yyyy-mm-dd'))";
				}
//				throw new Exception(sql);
				db.ExcecutSQL(sql);
			} else {
				throw new pubpack.EAException ( "商品、渠道不可为空！！！" );
			}
		}
		db.Commit();
	} catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	} finally {
		if (db!=null) db.Close();
	}
	
}

}
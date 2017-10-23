function x_SytXml(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var xmldb = new JavaPackage("com.xlsgrid.net.xmldb");

function GetTreeXML()
{
	var db = null;
	var ds = null;
	var sql = "";
	var xml = "";
	var title = "源";
	
	try {
		db = new pub.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		
		sql = "select nvl(typ,'未分类') typ,id repid,id,name from SYSMW where syt='%s' and decode('%s','','~',typ)=decode('%s','','~','%s') and decode('%s','','~',mwtyp)=decode('%s','','~','%s') and decode('%s','','~',id)=decode('%s','','~','%s') order by decode(typ,'未分类','9','0'),typ,mwtyp,id"
			.format([syt,typ,typ,typ,mwtyp,mwtyp,mwtyp,mwid,mwid,mwid]);
		
		if (syt == "MEA") {
			sql = "select nvl(a.typ,'未分类') typ,b.repid,a.id,a.name from sysmw a, mea_report b where a.syt=b.syt and a.id=b.grdid order by decode(a.typ,'未分类','9','0'),a.typ,a.mwtyp,b.seq";
		}
		
		ds = db.QuerySQL(sql);
		
		xml += "<"+title+">"; 
		var tmp = "";
		for (var i = 0; i < ds.getRowCount(); i ++) {
			var typ = ds.getStringAt(i,"TYP");
			
			if (typ != tmp) {
				xml += "<"+typ+" imageid=\"2\" mwid=\"\" refid=\"\" >";
				
				for (var j = 0; j < ds.getRowCount(); j ++) {
					var _typ = ds.getStringAt(j,"TYP");
					var _repid = ds.getStringAt(j,"REPID");
					var _id = ds.getStringAt(j,"ID");
					var _name = ds.getStringAt(j,"NAME");
					
					if (_typ == typ) {
						xml += "<"+_repid+"."+_name+" imageid=\"3\" mwid=\""+_id+"\" refid=\""+_typ+"\" />";
					}
				}
				
				xml += "</"+typ+">";
			}
			
			tmp = typ;
		}
		xml += "</"+title+">";
	}
	catch ( ee ) {
		db.Rollback();
		throw new pub.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	
	return xml;
}

function GetDesDef()
{
	var grdxmldb = new xmldb.EAGRDXmlDB(syt,mwid);
	var grdcelds = grdxmldb.getGrdCelDS();
	var grdcolds = grdxmldb.getGrdColDS();
	
	for (var i = 0; i < grdcelds.getRowCount(); i ++) {
		var id = grdcelds.getStringAt(i,"ID");
		
		var arr = id.split(",");
		if (arr.length() >= 3) {
			if (arr[1] == row && arr[2] == col) {
				return "CELL_"+row+"_"+col;
			}
		}
	}
	
	for (var i = 0; i < grdcolds.getRowCount(); i ++) {
		var id = grdcolds.getStringAt(i,"ID");
		
		var arr = id.split(",");
		if (arr.length() >= 2) {
			if (arr[1] == col) {
				return "COL_"+col;
			}
		}
	}
	
	return " ";
}

// 客户端param传入的参数可以直接使用
function save()
{
	var db = null;
	var sql = "";
	var ct1 = 0;
	var ct2 = 0;
	var msg = "";
	
	try {
		db = new pub.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var ds = new pub.EAXmlDS(xmlstr);	// 客户端可以传入一个xml
		
		db.ExcecutSQL("delete from SytXmlCellDef where sytid='"+syt+"' and grdid='"+grd+"'");
		db.ExcecutSQL("delete from SytXmlColDef where sytid='"+syt+"' and grdid='"+grd+"'");
		
		for (var r = 0; r < ds.getRowCount(); r ++) {
			for (var c = 3; c < ds.getColumnCount(); c ++) {
				var str = ds.getStringAt(r,c);
				if (str != "") {
					var arr = str.split("~!~");
					var id1 = "";
					var name1 = "";
					var id2 = "";
					var name2 = "";
					
					try { id1 = arr[0]; } catch ( e ) { }
					try { name1 = arr[1]; } catch ( e ) { }
					try { id2 = arr[2]; } catch ( e ) { }
					try { name2 = arr[3]; } catch ( e ) { }
					
					if (r != ds.getRowCount()-1) {
						sql = "insert into SytXmlCellDef(sytid,grdid,grdrow,grdcol,id1,name1,id2,name2) values('%s','%s',%s,%s,'%s','%s','%s','%s')"
							.format([syt,grd,""+r,""+(c-3),id1,name1,id2,name2]);
						ct1 += db.ExcecutSQL(sql);
					} else {
						sql = "insert into SytXmlColDef(sytid,grdid,grdcol,id1,name1,id2,name2) values('%s','%s','%s','%s','%s','%s','%s')"
							.format([syt,grd,""+(c-3),id1,name1,id2,name2]);
						ct2 += db.ExcecutSQL(sql);
					}
				}
			}
		}
		
		db.Commit();
		msg = "保存成功!\n基本属性:"+ct1+"\n明细列属性:"+ct2;
	}
	catch ( ee ) {
		db.Rollback();
		throw new pub.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}

}
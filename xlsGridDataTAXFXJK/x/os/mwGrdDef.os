function x_mwGrdDef(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var xmldb = new JavaPackage("com.xlsgrid.net.xmldb");
var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

function getDtlrng()
{
	var grdxmldb = new xmldb.EAGRDXmlDB(cursytid,mwid);
	var grdds = grdxmldb.getGrdDS();
	var dtlrng = grdds.getStringAt(0,"DTLRNG");
	return dtlrng;
}

// 客户端param传入的参数可以直接使用
function save()
{
	var db = null;
	var msg= "";
	var sql = "";
	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var rowds = new pubpack.EAXmlDS(rowxml);	// 客户端可以传入一个xml
		
		sql = "delete from Mwgrddef where sytid='"+cursytid+"' and grdid='"+mwid+"'";
		db.ExcecutSQL(sql);
		sql = "insert into Mwgrddef(sytid,grdid,lms,collist) values('"+cursytid+"','"+mwid+"','"+lms+"','"+collist+"')";
		db.ExcecutSQL(sql);
		
		sql = "delete from Mwgrdrowdef where sytid='"+cursytid+"' and grdid='"+mwid+"'";
		db.ExcecutSQL(sql);
		for ( var row=0;row<rowds.getRowCount();row ++ ) {
			var LM = rowds.getValueAt(row,"LM");
			var IDS = rowds.getValueAt(row,"ID");
			var NAMES = rowds.getValueAt(row,"NAME");
			sql = "insert into Mwgrdrowdef(sytid,grdid,LM,ID,NAME) values('"+cursytid+"','"+mwid+"','"+LM+"','"+IDS+"','"+NAMES+"') ";
			db.ExcecutSQL(sql);
		}
		
		sql = "delete from Mwgrdcoldef where sytid='"+cursytid+"' and grdid='"+mwid+"'";
		db.ExcecutSQL(sql);
		var colds = new pubpack.EAXmlDS(colxml);
		for ( var col=0;col<colds.getRowCount();col ++ ) {
			var LM = colds.getValueAt(col,"LM");
			var IDS = colds.getValueAt(col,"ID");
			var NAMES = colds.getValueAt(col,"NAME");
			sql = "insert into Mwgrdcoldef(sytid,grdid,LM,ID,NAME) values('"+cursytid+"','"+mwid+"','"+LM+"','"+IDS+"','"+NAMES+"') ";
			db.ExcecutSQL(sql);
		}
		
		sql = "update mwformdtl d set (idx,idxitem) =
			       (select b.name, c.name
			          from mwformhdr h, mwgrdrowdef b, mwgrdcoldef c
			         where d.formguid=h.guid and h.repid='"+mwid+"'
			           and d.syt=b.sytid and h.repid=b.grdid
			           and d.syt=c.sytid and h.repid=c.grdid
			           and d.seqid=b.lm || '_' || b.id || '_' || c.id
			           and b.lm=c.lm)
			 where formguid in (select guid from mwformhdr where repid='"+mwid+"')";
                db.ExcecutSQL(sql);
		
		db.Commit();
		msg = "保存成功！";
	}
	catch ( e ) {
		db.Rollback();
		throw new pubpack.EAException ( e.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}
}
function x_KALOC(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
function updateKaLoc()
{
	var db = null;
	var sql = "";
	try{
		db = new pubpack.EADatabase();
		sql = "
			insert into kaloc 
			select b.id kaid,b.name kanam,a.id locid,a.name locnam,'0' endflg 
			  from v_ebloc a,v_ka b 
			 where not exists ( select 1 from kaloc k where k.kaid = b.id and k.locid = a.id)
			 order by b.id,a.id		
		";
		db.ExcecutSQL(sql);
		db.Commit();		
	}catch(e){
		db.Rollback();
		throw new Exception(e);
	}
}

function saveUpdate()
{
	var db = null;
	var ds = null;
	var pstmt = null;
	var sql = "";
	var i = 0;
	try{
		db = new pubpack.EADatabase();
		ds = new pubpack.EAXmlDS(xml);		
		sql = " update kaloc set endflg=? where kaid=? and locid=?";
		pstmt = db.GetConn().prepareStatement(sql);
		if ( ds.getRowCount()>0 ){
			for (var r = 0;r< ds.getRowCount();r++)
			{				
				pstmt.setInt(1,Integer.parseInt(ds.getStringAt(i,"VALUE")));
				pstmt.setString(2,ds.getStringAt(i,"KAID"));
				pstmt.setString(3,ds.getStringAt(i,"LOCID"));
				pstmt.addBatch();
				i++;
			}
			pstmt.executeBatch();		
		}
		db.Commit();
		return i;
	}catch(e){
		db.Rollback();
		throw new Exception(e);
	}

}
}
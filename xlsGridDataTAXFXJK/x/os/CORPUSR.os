function x_CORPUSR(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
function updateKaLoc()
{
	var db = null;
	var sql = "";
	try{
		db = new pubpack.EADatabase();
//		sql = "
//			insert into kaloc 
//			select b.id kaid,b.name kanam,a.id locid,a.name locnam,'0' endflg 
//			  from v_ebloc a,v_ka b 
//			 where not exists ( select 1 from kaloc k where k.kaid = b.id and k.locid = a.id)
//			 order by b.id,a.id		
//		";
		sql = "insert into a3_usrcust select SYS_GUID() guid ,a.guid usr, b.guid corp,'' sortid ,'' note,'' crtusr,'' crtdat,'' itemno,'' price ,'' code, '' extflg,'3ABill' org,'0' endflg  
        from (select guid,name,id from usr where org='3ABill') a,a3_cust b  
       where not exists ( select 1 from a3_usrcust k where k.corp = b.guid and k.usr = a.guid) 
       order by b.guid,a.guid ";
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
	var db2 = null;
	var ds = null;
	var ds2 = null;
	var pstmt = null;
	var sql = "";
	var sql2 = "";
	var i = 0;
	try{
		db = new pubpack.EADatabase();
		db2 = new pubpack.EADatabase();
		ds = new pubpack.EAXmlDS(xml);	
			
		sql = " update a3_usrcust set endflg=? where corp=? and usr=?";
		pstmt = db.GetConn().prepareStatement(sql);
		if ( ds.getRowCount()>0 ){
			for (var r = 0;r< ds.getRowCount();r++)
			{				
				pstmt.setInt(1,Integer.parseInt(ds.getStringAt(i,"VALUE")));
				//throw new Exception(ds.getStringAt(i,"VALUE"));
				sql2 = "select guid from a3_cust where id='"+ds.getStringAt(i,"KAID")+"'";
				var KAID ="";
				ds2 = db.QuerySQL(sql2);
				
				if(ds2.getRowCount()>0){
					KAID = ds2.getStringAt(0,"guid");
				}
				//throw new Exception(KAID+"|"+sql2);
				pstmt.setString(2,KAID);
				sql2 = "select guid from USR where id='"+ds.getStringAt(i,"LOCID").split("-")[0]+"'";
				var LOCID ="";
				ds2 = db.QuerySQL(sql2);
				if(ds2.getRowCount()>0){
					LOCID = ds2.getStringAt(0,"guid");
				}
				//throw new Exception(LOCID +"|"+sql2);
				pstmt.setString(3,LOCID);
				
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
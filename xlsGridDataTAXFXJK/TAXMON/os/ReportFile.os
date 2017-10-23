function TAXMON_ReportFile(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//加载类包 
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" ); 

// 新增事务的保存
function save1() 
{
      var ret = 0;
      var db = null;
      var ds = null;
      var sql = "";
      var ps1 = null;

      try
      {
            db = new pubpack.EADatabase();
            if ( edit == "save" )
            {
            	sql = "SELECT SYS_GUID() FROM DUAL" ;
            	var hdrguid = db.GetSQL(sql);
            
                  sql = "insert into tax_filedata(guid,org,title,note,crtusr,filepath,filenote,yymm,noteblob)  values ( ?,?,?,?,?,?,?,?,empty_blob())"; 
                  ps1 = db.prepareStatement(sql);
                  
                  ps1.setString(1,hdrguid);//数据库查询的结果
                  ps1.setString(2,selforg);//数据库查询的结果
                  ps1.setString(3,title);
                  ps1.setString(4,note);
                  ps1.setString(5,crtusr);
                  ps1.setString(6,filepath);
                  ps1.setString(7,filenote); 
		  ps1.setString(8,yymm); 
		  
		  ret = ps1.executeUpdate(); 
                  ps1.close();

//                  sql = "select noteblob from tax_filedata where guid='"+hdrguid+"' for update";
//                   var blob = db.GetSQL(sql);
//                  db.UpdateBlobWithStr(sql,"noteblob",note);
                  
                  db.Commit();

            }
            if ( edit == "modify" )
            {
                  sql = "update tax_filedata set title=?,note=?,crtusr=?,filepath=?,filenote=?,yymm=? where guid=?";
                  ps1 = db.prepareStatement(sql);
                  ps1.setString(1,title);
                  ps1.setString(2,note);
                  ps1.setString(3,crtusr);
                  ps1.setString(4,filepath);
                  ps1.setString(5,filenote);
                  ps1.setString(6,yymm);
                  ps1.setString(7,hdrguid);

                  ret = ps1.executeUpdate();
                  ps1.close();

                  db.Commit();
            }
            
           return ret ;
	}catch(e){
		if( db!= null ) db.Rollback();
		throw e;
	}
	finally{
		db.Close(); 
	}       
}

function file()
{
     // return  "/"+pubpack.EAOption.get("xlsgrid.file.dynadata.root")+"upload/";  
      return  "/"+pubpack.EAOption.get("filestore")+"upload/";  
}


function getBlob(){
	var db = null;
	var sql = "";
	try {
		db = new pubpack.EADatabase();
		sql = "select noteblob from trkhdr where id='"+id+"'";
		var blob = db.getBlob2String(sql,"noteblob");
		return blob;
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( sql+ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
}
    
  



}
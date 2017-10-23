function x_nlsEdit(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

//保存单据
function save()
{
	var db = null;
	var sql = "";	
	var ret = 0;
	try {   
		db = new pubpack.EADatabase();
		var ds = new pubpack.EAXmlDS(xmlstr);	
 		for (var row=0;row<ds.getRowCount();row++) { 
			var guid =  ds.getStringAt(row,"GUID");
			var classid=ds.getStringAt(row,"CLASSID");
			var sytid = ds.getStringAt(row,"SYTID");
			var cnstr = ds.getStringAt(row,"CNSTR");
			var nls = ds.getStringAt(row,"NLS");
			var deststr = ds.getStringAt(row,"DESTSTR");	
			var flag = ds.getStringAt(row,"FLG");
			
			//判断是否已新增						
			if((guid == "" || guid == null) && cnstr != ""){
				sql = " insert into NLS(GUID,SYTID,CNSTR,NLS,DESTSTR,CLASSID) values (sys_guid(),'%s','%s','%s','%s','%s')".format([sytid,cnstr,nls,deststr,classid]);					
				ret += db.ExcecutSQL(sql);
			}
			else if (flag == "*"){	
				sql = " update NLS set SYTID='"+sytid+"',CNSTR='"+cnstr+"',NLS='"+nls+"',DESTSTR='"+deststr+"',CLASSID='"+classid+"' where guid ='"+guid+"'";		
				ret += db.ExcecutSQL(sql);
			}
			else if (flag == "-"){	
				sql = " delete from NLS  where guid ='"+guid+"'";		
				ret += db.ExcecutSQL(sql);
			}	
		}	
		db.Commit();		
	} catch ( e ) {
		db.Rollback(); 
		return e.toString();
		throw new pubpack.EAException(e.toString());
	}	
	return ret;
}
}
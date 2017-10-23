function x_TIMBER_NSRPP(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function Save()
{
	var db=null;
	var cnt="";
	var sql="";
	try{
		db = new pub.EADatabase();
		var ds = new pub.EAXmlDS(xmlstr);
		var cnt = 0;
		//return xmlstr;
		for (var i=0;i<ds.getRowCount();i++) {
			var fhdw=ds.getStringAt(i,"FHDW");
			var nsrsbh=ds.getStringAt(i,"NSRSBH");
			var nsrmc = ds.getStringAt(i,"NSRMC");
			if(fhdw !=""&&nsrsbh !=""&&nsrmc !=""){
				sql="update tax_tree_mc_wh a set nsrsbh='"+nsrsbh+"',nsrmc='"+nsrmc+"' where fhdw='"+fhdw+"'";
				cnt+=db.ExcecutSQL(sql);
			}
		}
		db.Commit();
		return "更新石材数据成功！更新记录数"+cnt;	
	}
	catch(e){
		if(db !=null)db.Rollback();
		return e.toString();	
	}
	finally{
		if(db !=null)db.Close();
	}
}
}
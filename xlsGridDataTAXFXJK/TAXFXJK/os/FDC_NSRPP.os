function TAXFXJK_FDC_NSRPP(){var pub = new JavaPackage("com.xlsgrid.net.pub");

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
			var FDCKFQYMC=ds.getStringAt(i,"FDCKFQYMC");
			var nsrsbh=ds.getStringAt(i,"NSRSBH");
			var nsrmc = ds.getStringAt(i,"NSRMC");
			if(FDCKFQYMC !=""&&nsrsbh !=""&&nsrmc !=""){
				sql="update TAX_FDCKFQYMC_NSRSBH_DZB a set nsrsbh='"+nsrsbh+"',nsrmc='"+nsrmc+"' where FDCKFQYMC='"+FDCKFQYMC+"'";
				cnt+=db.ExcecutSQL(sql);
			}
		}
		db.Commit();
		return "更新房地产数据成功！更新记录数"+cnt;	
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
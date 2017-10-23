function TAXMON_CMEDIT(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function save()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "";
		var ret = 0;
		if (action == "update") {
			sql = "update tax_company set ammno='"+ammno+"',pwdept='"+pwdept+"' where guid='"+guid+"'";
		}
		else if (action == "add") {
			sql = "insert into tax_company(ID,NAME,AMMNO,HYCODE,PWDEPT,TYP,TAXMAN,TOWNS,LAWMAN,ADDR,YTAXMAN,typclsid,stat) 
			select ID,NAME,'"+ammno+"',HYCODE,PWDEPT,TYP,TAXMAN,TOWNS,LAWMAN,ADDR,YTAXMAN,typclsid,stat 
			from tax_company where guid='"+guid+"'";
		}
		ret += db.ExcecutSQL(sql);
		db.Commit();
		
		return "²Ù×÷³É¹¦£¡";
	}
	catch(e) {
		if (db != null) db.Rollback();
		throw new Exception(e.toString());
	}	
	finally {
		if (db != null) db.Close();
	}
}
}
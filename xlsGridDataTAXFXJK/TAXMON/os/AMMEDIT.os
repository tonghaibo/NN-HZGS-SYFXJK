function TAXMON_AMMEDIT(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );

//更新
function save()
{
 	var db=null;
 	var ds= null;
 	var count1=0;
 	var sql = "";
	try {   
		db = new pubpack.EADatabase();
		var ds = new pubpack.EAXmlDS(xmlstrs);	

		for(var row=0;row<ds.getRowCount();row++){
			var id =ds.getStringAt(row,"ID");
			var name= ds.getStringAt(row,"name");
	 		var ammno=  ds.getStringAt(row,"ammno");
			var typ= ds.getStringAt(row,"typ");
			var pwdept= ds.getStringAt(row,"idd");
			var hycode= ds.getStringAt(row,"hycode");
			var ytaxman= ds.getStringAt(row,"idc");
			var taxman= ds.getStringAt(row,"taxman");
			var towns= ds.getStringAt(row,"idb");
			var lawman= ds.getStringAt(row,"lawman");
			var addr= ds.getStringAt(row,"addr");
		
		sql = "update tax_company a set (name,hycode,pwdept,typ,taxman,towns,lawman,addr,ytaxman)=
			(select '"+name+"','"+hycode+"',(select name from V_TAX_ELECOMPANY WHERE ID='"+pwdept+"'),'"+typ+"','"+taxman+"',(select name from V_TAX_TOWNS WHERE ID='"+towns+"'),'"+lawman+"','"+addr+"',(select name from V_TAX_YTAXMAN WHERE ID='"+ytaxman+"')
			 from tax_company where tax_company.ID='"+id+"'and tax_company.ammno='"+ammno+"')
			where id = (select distinct '"+id+"'from tax_company)";

			count1 = db.ExcecutSQL(sql);
	  	}
	  	 db.Commit();
	 	 return "更新"+count1+"条";
	}catch(e){
		if(db != null) db.Rollback();
		throw new Exception(e);
	}finally{
	
		db.Close();
	}
}

function del()
{
	try {
		var sql = "delete from tax_company where guid='"+guid+"'";
		var ret = pubpack.EADbTool.ExcecutSQL(sql);
		return ret;
	}
	catch(e) {
		return e.toString();
	}
}

//添加
function save1()
{
 	var db = null;
	var ds = null;
	var sql = "";
	var count = 0;
	try {   
		db = new pubpack.EADatabase();

		sql = "insert into tax_company(ID,NAME,AMMNO,HYCODE,PWDEPT,TYP,TAXMAN,TOWNS,LAWMAN,ADDR,YTAXMAN,typclsid,stat) 
			select ID,NAME,'"+addammno+"',HYCODE,PWDEPT,TYP,TAXMAN,TOWNS,LAWMAN,ADDR,YTAXMAN,typclsid,stat 
			from tax_company where id='"+cmid+"' and rownum=1";
			       
		count = db.ExcecutSQL(sql);  
	 	db.Commit();
		return "添加电表号成功，表电号："+addammno;
	}catch(e){
		if(db != null) db.Rollback();
		throw new Exception(e);
	}finally{
		db.Close();
	}
}








}
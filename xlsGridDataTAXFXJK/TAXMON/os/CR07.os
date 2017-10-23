function TAXMON_CR07(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );

function insert()
{
	var db = null;
	var ds = null;
	var sql = "";
	var id=id;
	var name=name;
	var eleqty=eleqty;
	var taxman=taxman;
	var star=star;
	try{
		
		db = new pubpack.EADatabase();
		var chkusr =db.GetBillid(thisaccid,"","1");    //随机产生审批人编号
		var sysdat=db.GetSQL("select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') from dual");
		
		sql="insert into tax_trkhdr(ACC,ORG,SYT,CHKUSR,CHKUSRNAM,CHKDAT,Cmid,Cmnam,Tousr,SUBTYP) 
		select '"+thisaccid+"','"+thisorg+"','"+thissyt+"','"+chkusr+"','"+usrid+"',to_date('"+sysdat+"','yyyy-MM-dd hh24:mi:ss'),'"+id+"' ,'"+name+"','"+taxman+"','1'  
		from dual where not exists (select 1 from tax_trkhdr a where a.cmid='"+id+"')";
		var count = db.ExcecutSQL(sql);
		if(count>0)
			return "生成成功";
		else
			return "以生成";
	}
	catch(e){
		if(db != null) db.Rollback();
			return e.toString();
	}
	finally {
		if(db != null)	db.Close();
	}
}


}
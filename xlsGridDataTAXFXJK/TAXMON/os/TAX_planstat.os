function TAXMON_TAX_planstat(){
var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//加载类包 

function save(){
	var db = null;
	
	try
	{
		db = new pubpack.EADatabase();
		
		var sql = "UPDATE PRJPHASE 
		   SET  stat='"+stat+"',
		       memo = MEMO || TO_CHAR(sysdate, 'yyyy-mm-dd') ||
		              (select name from v_prjphasestat where id = '"+stat+"') ||
		              '\r"+memo+"\r'
			WHERE GUID = '"+guid+"'";
		db.ExcecutSQL(sql);
		db.Commit();
	}catch(e){
		if( db!= null ) db.Rollback();
		throw e;
	}
	finally{
		db.Close(); 
	}    
	return "";
}

//单据保存前
function fos_beforesave(eaContext)
//var eaContext=new pub.EAContext();
{

}

}
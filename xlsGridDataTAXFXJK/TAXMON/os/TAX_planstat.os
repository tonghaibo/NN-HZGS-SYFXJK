function TAXMON_TAX_planstat(){
var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//������� 

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

//���ݱ���ǰ
function fos_beforesave(eaContext)
//var eaContext=new pub.EAContext();
{

}

}
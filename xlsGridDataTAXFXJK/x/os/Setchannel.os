function x_Setchannel(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//������� 
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" ); 

//�����û�ץȡ������Ҫ����Ϣ.��:���ָ���¼��Ҫ���û�������
function setchannel(){
	var usr=web.EASession.GetLoginInfo(request);//��ȡ��ǰ�û���Ϣ		
	var crtusr=usr.getUsrid();
	var acc = usr.getOrgid();
	var sql= "";
	
	
	var db = null;
	
	if(kaid==""||passwd==""||usrid==""){
		throw new Exception("����������Ϣ");
	}
	//throw new Exception(acc);
	
	
	try{
		db = new pubpack.EADatabase();
		//��ȡ���û�������˾����֯
		sql = "select loc from usr where id='"+crtusr+"'";
		var ds = db.QuerySQL(sql);
		var loc = "";
		if(ds.getRowCount()>0){
			loc = ds.getStringAt(0,"loc");
		}else{
			throw new Exception("�Ҳ������û��û�"+sql);
		}
		sql = "insert into EBCONFIG (USERID,PASSWD,ACC,KAID,CRTUSR)values('"+usrid+"','"+passwd+"','"+loc+"','"+kaid+"','"+crtusr+"')";
		
		db.ExcecutSQL(sql);
		throw new Exception(sql);
	}	
	catch(e)
	{
		if( db!= null ) db.Rollback();
		throw e;
	}
	finally
	{
		db.Close(); 
	}       

	
	return "���óɹ�";
	
}
}
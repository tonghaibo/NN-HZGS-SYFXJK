function x_newuser(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//������� //
function newsave(){
	var msg = "";
	var db = null;
	var sql = "";
	var ps1 = null;
	//���ж�������ַ��Ƿ����һ���ʽ.���������,���ش���
	
	try
	{
		
		db = new pubpack.EADatabase();
		//��ѯ��ǰid�Ƿ��Ѿ���ʹ����
		sql = "select guid from usr where id='"+usrid+"' and org='3ABill'";
		var ds = db.QuerySQL(sql);
		if(ds.getRowCount()>0){
			//�Ѿ������й�����û��˷���
			throw new Exception("���û����ѱ�ע��");
		}
		//useflag=2��ʾδ������û�
		sql = "insert into usr (org,id,passwd,post,crtdat,USEFLG,mainurl,name)values(?,?,?,?,sysdate,'1','../../../ROOT_3ABill/Layout.sp?id=Billmain','"+usrname+"')";
		ps1 = db.prepareStatement(sql);
		
		ps1.setString(1,"3ABill");
		ps1.setString(2,usrid);
                ps1.setString(3,password);
                ps1.setString(4,email);
                
                

		//throw new Exception("sql");
		//sql = sql.replace("usr","abc");
		
		var ret = ps1.executeUpdate();
		//��ȡ�������û���id.���Ҷ�ȡguid,��Ϊ�����ȷ����
		sql="select guid from usr where id='"+usrid+"' and org='3ABill'";
		var guid = "";
		ds = db.QuerySQL(sql);
		var url = "";
		if(ds.getRowCount()>0){
			//��ȡguid
			guid=ds.getStringAt(0,"guid");
			//����û���ϸ��Ϣ
			sql = "insert into hr_usr(id,name,mobile,phone,email,adds,FILE_PLACE,PREF,NATIONAL,TYPE,INITADDS)values('"+usrid+"','"+name+"','"+mobile+"','"+tel+"','"+email+"','"+ads+"','"+comname+"','"+guid+"','"+province+"','"+city+"','"+business+"')";
                	db.ExcecutSQL(sql);
                	//throw new Exception(sql);
			//throw new Exception(password+"|"+passwordconfirm+"|"+usrid+"|"+email);
			//������û�����һ��guid���Ӹ��û������email.���м���ȷ��
			//throw new Exception("��ʼ���ʼ�");new EAMail("smtp.163.com","25","foolraty@163.com","foolraty","foolraty");
			var eaMail= new pubpack.EAMail();
			url="http://3abill.com/xlsgrid/Layout.sp?id=Usraction&org=3ABill&guid="+guid+"";
			//var i=eaMail.sendMail(email,"3ABill�����ʼ�","<html><body>��������:<a href='"+url+"'>"+url+"</a></body></html>");
			//throw new Exception("���ʼ�����");
			
		}else{
			//�Ҳ����Ѿ���ӵ��û�,�����û�����
			throw new Exception("�����û�����" +ret);
		}
		
		msg = "ע���û��ɹ�"+url;	
		db.Commit();	
			
	}
	catch(e)
	{
		if( db!= null ) db.Rollback();
		throw e;
	}
	finally
	{
		db.Close(); 
		//db=null;
	}       


	
	
	return msg;
}
//����ķ���
function useraction(){
	//��ѯ��Ӧguid...������ʺŵĻ�.��δ�����򼤻�,���򷵻�˵���Ѿ�����
	var sql="";
	var GUID = "";
	var db = null;
	try{
		GUID=guid;
	}catch(e){
		GUID="";
	}
	
	sql = "select useflg from usr where guid='"+GUID+"'";
	
	try
	{
		db = new pubpack.EADatabase();
		var ds = db.QuerySQL(sql);
		var USEFLG = "";//ds.getStringAt(0,"useflg");
		if(ds.getRowCount()>0){
			var USEFLG = ds.getStringAt(0,"USEFLG");
			if(USEFLG == "2"){
				//����״̬Ϊ����״̬
				sql = "update usr set USEFLG='1' where guid='"+GUID+"'";
				db.ExcecutSQL(sql);
				db.Commit();
			}else if(USEFLG == "1"){
				//�����Ѿ������
				throw new Exception("���ʺ��Ѿ�Ϊ����״̬");
			}else{
				//���ظ��ʺ���Ч
				throw new Exception("���ʺ���Ч");
			}
		}else{
			//������Ч��ע������
			throw new Exception("��Ч��ע������");
		}
			
	}
	catch(e)
	{
		if( db!= null ) db.Rollback();
		throw e;
	}
	finally
	{
		db.Close(); 
		//db=null;
	}     
	
	throw new Exception("ע��ɹ�");
	
}

function newusersave(){
	var msg = "";
	var db = null;
	var sql = "";
	var ps1 = null;
	var org = "";
	//���ж�������ַ��Ƿ����һ���ʽ.���������,���ش���
	
	try
	{
		
		db = new pubpack.EADatabase();
		//��ѯ��ǰid�Ƿ��Ѿ���ʹ����
		sql = "select guid from usr where id='"+usrid+"' and org='3ABill'and USEFLG='1'";
		var ds = db.QuerySQL(sql);
		if(ds.getRowCount()>0){
			//�Ѿ������й�����û��˷���
			throw new Exception("���û����ѱ�ע��");
		}
		var usr = web.EASession.GetLoginInfo(request);//��ȡ��ǰ�û���Ϣ,�ڵ�һ����ʱ���ȡ
		var curusrid = usr.getUsrid();
		
		sql = "select org from usr where id='"+curusrid+"'";
		var ds = db.QuerySQL(sql);
		if(ds.getRowCount()>0){
			//�Ѿ������й�����û��˷���
			org = ds.getStringAt(0,"org");
		}else{
			throw new Exception("��ȡ��ǰ�û�����");
		}
		
		//useflag=2��ʾδ������û�
		sql = "insert into usr (org,id,passwd,post,crtdat,USEFLG,mainurl,name)values(?,?,?,?,sysdate,'1','../../../ROOT_3ABill/Layout.sp?id=Billmain','"+usrname+"')";
		ps1 = db.prepareStatement(sql);
		
		ps1.setString(1,"3ABill");
		ps1.setString(2,usrid);
                ps1.setString(3,passwd);
                ps1.setString(4,"");
                
                

		
		//sql = sql.replace("usr","abc"); 
		
		var ret = ps1.executeUpdate();
		//throw new Exception(sql); 
		
		db.Commit();		
	}
	catch(e)
	{
		if( db!= null ) db.Rollback();
		throw e;
	}
	finally
	{
		db.Close(); 
		//db=null;
	}       


	throw new Exception("��ӳɹ�");	
	
	return msg;

}

}
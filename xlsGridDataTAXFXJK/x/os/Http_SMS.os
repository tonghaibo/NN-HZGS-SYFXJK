function x_Http_SMS(){var pub = new JavaPackage("com.xlsgrid.net.pub");
function Response()
{

  	
	
	var db = null;
	      try
	      {
	      		//��ȡ����ʱ��
			db = new pub.EADatabase();
			var sql = "SELECT sysdate FROM DUAL" ; 
	            	var nowdatetime = db.GetSQL(sql);
			//��ʼ���Ͷ���
			if(msg!=""){
				msg = "["+msg+"]";
			}
//		    	var eaSms = new pub.EASMS();
		    	var eaSms= new pub.EASendSMSSutien();
		    	eaSms.getClient();
		    	eaSms.activeCDKey();
//		    	throw new Exception("����");
			var i ="";
//			throw new Exception("����");
			var i=eaSms.SendSMS( moblies,msg+note);
//			throw new Exception("�������");
			
			
			//�ѷ��Ͷ��ŵ����ݼ�¼����
//	                sql = "insert into smslog( NOTE,CRTUSR,SENDDAT,ORG) values (?,?,?,?) ";
//	                var ps2 = db.prepareStatement(sql);
//	                ps2.setString(1,note);
//                	ps2.setString(2,crtusrnam);
//                	ps2.setString(3,nowdatetime );
//                	ps2.setString(4,org);
//	                var ret=ps2.executeUpdate();
//	                ps2.close();
//	         	throw new Exception(i);
	     		if(i!="success"){ 
				return  "faile="+i+"|org="+org;
			}else if(i!="1"&&i!="success"){
				return  "faile="+i+"|org="+org;
			}else if(i=="success"){
				return "Send to "+moblies+" success";
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
	      }       
	return "send faile";  
} 

}
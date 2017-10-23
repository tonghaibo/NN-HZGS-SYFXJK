function x_Http_SMS(){var pub = new JavaPackage("com.xlsgrid.net.pub");
function Response()
{

  	
	
	var db = null;
	      try
	      {
	      		//读取发送时间
			db = new pub.EADatabase();
			var sql = "SELECT sysdate FROM DUAL" ; 
	            	var nowdatetime = db.GetSQL(sql);
			//开始发送短信
			if(msg!=""){
				msg = "["+msg+"]";
			}
//		    	var eaSms = new pub.EASMS();
		    	var eaSms= new pub.EASendSMSSutien();
		    	eaSms.getClient();
		    	eaSms.activeCDKey();
//		    	throw new Exception("结束");
			var i ="";
//			throw new Exception("发送");
			var i=eaSms.SendSMS( moblies,msg+note);
//			throw new Exception("发送完毕");
			
			
			//把发送短信的内容记录下来
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
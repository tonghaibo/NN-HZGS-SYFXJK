function x_newuser(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//加载类包 //
function newsave(){
	var msg = "";
	var db = null;
	var sql = "";
	var ps1 = null;
	//先判断输入的字符是否符合一般格式.如果不符合,返回错误
	
	try
	{
		
		db = new pubpack.EADatabase();
		//查询当前id是否已经被使用了
		sql = "select guid from usr where id='"+usrid+"' and org='3ABill'";
		var ds = db.QuerySQL(sql);
		if(ds.getRowCount()>0){
			//已经生成有过这个用户了返回
			throw new Exception("此用户名已被注册");
		}
		//useflag=2表示未激活的用户
		sql = "insert into usr (org,id,passwd,post,crtdat,USEFLG,mainurl,name)values(?,?,?,?,sysdate,'1','../../../ROOT_3ABill/Layout.sp?id=Billmain','"+usrname+"')";
		ps1 = db.prepareStatement(sql);
		
		ps1.setString(1,"3ABill");
		ps1.setString(2,usrid);
                ps1.setString(3,password);
                ps1.setString(4,email);
                
                

		//throw new Exception("sql");
		//sql = sql.replace("usr","abc");
		
		var ret = ps1.executeUpdate();
		//读取新增的用户的id.并且读取guid,作为激活的确认码
		sql="select guid from usr where id='"+usrid+"' and org='3ABill'";
		var guid = "";
		ds = db.QuerySQL(sql);
		var url = "";
		if(ds.getRowCount()>0){
			//获取guid
			guid=ds.getStringAt(0,"guid");
			//添加用户详细信息
			sql = "insert into hr_usr(id,name,mobile,phone,email,adds,FILE_PLACE,PREF,NATIONAL,TYPE,INITADDS)values('"+usrid+"','"+name+"','"+mobile+"','"+tel+"','"+email+"','"+ads+"','"+comname+"','"+guid+"','"+province+"','"+city+"','"+business+"')";
                	db.ExcecutSQL(sql);
                	//throw new Exception(sql);
			//throw new Exception(password+"|"+passwordconfirm+"|"+usrid+"|"+email);
			//添加了用户后发送一个guid连接给用户输入的email.进行激活确认
			//throw new Exception("开始发邮件");new EAMail("smtp.163.com","25","foolraty@163.com","foolraty","foolraty");
			var eaMail= new pubpack.EAMail();
			url="http://3abill.com/xlsgrid/Layout.sp?id=Usraction&org=3ABill&guid="+guid+"";
			//var i=eaMail.sendMail(email,"3ABill激活邮件","<html><body>请点击激活:<a href='"+url+"'>"+url+"</a></body></html>");
			//throw new Exception("发邮件完了");
			
		}else{
			//找不到已经添加的用户,新增用户错误
			throw new Exception("新增用户出错" +ret);
		}
		
		msg = "注册用户成功"+url;	
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
//激活的方法
function useraction(){
	//查询对应guid...有这个帐号的话.且未激活则激活,否则返回说明已经激活
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
				//更新状态为激活状态
				sql = "update usr set USEFLG='1' where guid='"+GUID+"'";
				db.ExcecutSQL(sql);
				db.Commit();
			}else if(USEFLG == "1"){
				//返回已经激活过
				throw new Exception("该帐号已经为激活状态");
			}else{
				//返回该帐号无效
				throw new Exception("该帐号无效");
			}
		}else{
			//返回无效的注册链接
			throw new Exception("无效的注册链接");
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
	
	throw new Exception("注册成功");
	
}

function newusersave(){
	var msg = "";
	var db = null;
	var sql = "";
	var ps1 = null;
	var org = "";
	//先判断输入的字符是否符合一般格式.如果不符合,返回错误
	
	try
	{
		
		db = new pubpack.EADatabase();
		//查询当前id是否已经被使用了
		sql = "select guid from usr where id='"+usrid+"' and org='3ABill'and USEFLG='1'";
		var ds = db.QuerySQL(sql);
		if(ds.getRowCount()>0){
			//已经生成有过这个用户了返回
			throw new Exception("此用户名已被注册");
		}
		var usr = web.EASession.GetLoginInfo(request);//获取当前用户信息,在第一步的时候读取
		var curusrid = usr.getUsrid();
		
		sql = "select org from usr where id='"+curusrid+"'";
		var ds = db.QuerySQL(sql);
		if(ds.getRowCount()>0){
			//已经生成有过这个用户了返回
			org = ds.getStringAt(0,"org");
		}else{
			throw new Exception("读取当前用户出错");
		}
		
		//useflag=2表示未激活的用户
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


	throw new Exception("添加成功");	
	
	return msg;

}

}
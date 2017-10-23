function x_Setchannel(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//加载类包 
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" ); 

//设置用户抓取订单需要的信息.如:家乐福登录需要的用户名密码
function setchannel(){
	var usr=web.EASession.GetLoginInfo(request);//获取当前用户信息		
	var crtusr=usr.getUsrid();
	var acc = usr.getOrgid();
	var sql= "";
	
	
	var db = null;
	
	if(kaid==""||passwd==""||usrid==""){
		throw new Exception("请输入完信息");
	}
	//throw new Exception(acc);
	
	
	try{
		db = new pubpack.EADatabase();
		//获取该用户所属公司或组织
		sql = "select loc from usr where id='"+crtusr+"'";
		var ds = db.QuerySQL(sql);
		var loc = "";
		if(ds.getRowCount()>0){
			loc = ds.getStringAt(0,"loc");
		}else{
			throw new Exception("找不到此用户用户"+sql);
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

	
	return "设置成功";
	
}
}
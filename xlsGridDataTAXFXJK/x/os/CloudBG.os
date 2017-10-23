function x_CloudBG(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//加载类包 
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );//加载类包 

function save(){
	var db = null;
	var orgid =  webpack.EAWebDeforg.GetDeforg(request);
	var usr=web.EASession.GetLoginInfo(request);//获取当前用户信息	
	var orgid= usr.getLogorg();
	try {
		db = new pubpack.EADatabase();
		var sql = "";
		sql = "select * from usrprofile where id='"+usrid+"'AND ORG='"+orgid+"'";
		var ds = db.QuerySQL(sql);
		if(ds.getRowCount()<1){
			//找不到该用户的信息添加记录
			sql = "insert into usrprofile (id,org,BGPICTURE )values('"+usrid+"','"+orgid+"','"+imgpath+"')";
			db.ExcecutSQL(sql);
		}else{
			sql = "update usrprofile set BGPICTURE ='"+imgpath+"' where id='"+usrid+"'AND ORG='"+orgid+"'";
			db.ExcecutSQL(sql);
		}
		
//		throw new Exception(orgid+"imgpath="+imgpath);
	}catch(e){
		db.Rollback();
		throw new Exception(e);
	}finally{
		if ( db != null )
		db.Close();
	}	
}

function adddesktop(){
	var db = null;
	var usr=web.EASession.GetLoginInfo(request);//获取当前用户信息		
	var usrid=usr.getUsrid();
	var orgid= usr.getLogorg();
 
	try {
		db = new pubpack.EADatabase();
		pubpack.EAFunc.Log("CloudBG.adddesktop--");
		var sql = "";
		sql = "select * from usrprofiledtl where id='"+usrid+"'AND ORG='"+orgid+"'and refguid='"+guid+"'AND TYP='MYDESKTOP'";
		
		var ds = db.QuerySQL(sql);
 
		if(ds.getRowCount()<1){
			//找不到该用户的信息添加记录
			sql = "insert into usrprofiledtl (id,org,refguid ,TYP)values('"+usrid+"','"+orgid+"','"+guid+"','MYDESKTOP')";
			db.ExcecutSQL(sql);
			pubpack.EAFunc.Log(sql);
 		}
		db.Commit();
 
		return sql;
	}catch(e){
		db.Rollback();
		pubpack.EAFunc.Log("CloudBG.adddesktop:"+e.toString());
		throw new Exception(e);
	}finally{
		if ( db != null )
		db.Close();
	}	
}
function deldesktop(){
	var db = null;
	var usr=web.EASession.GetLoginInfo(request);//获取当前用户信息		
	var usrid=usr.getUsrid();
	var orgid= usr.getLogorg();

	try {
		db = new pubpack.EADatabase();
		var sql = "";
		sql = "delete from usrprofiledtl where id='"+usrid+"'AND ORG='"+orgid+"'and refguid='"+guid+"'AND TYP='MYDESKTOP'";
		var str = db.ExcecutSQL(sql);
		db.Commit();
		return sql;
	}catch(e){
		db.Rollback();
		throw new Exception(e);
	}finally{
		if ( db != null )
		db.Close();
	}	
}

// 复制xlsGridData到web
// 参数 deforg  sysurlid 
function copytoweb()
{
	var srcpath = basePath +"webresource/images/"+ deforg  + "/"+sysurlid+"/"; 
	var destpath = pubpack.EAOption.approot+"/images/"+ deforg  + "/"+sysurlid+"/";
	pubpack.EAFunc.copyDirectiory(srcpath,destpath,"","CVS",true );
	return "服务端：文件已从"+ srcpath +"同步到"+destpath ;
}

}
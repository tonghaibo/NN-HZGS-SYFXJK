function x_CloudBGPreview(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//加载类包 
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );//加载类包 
var basePath = pubpack.EAOption.dynaDataRoot;
// 复制xlsGridData到web
// 参数 deforg  sysurlid 
function copytoweb()
{
	var srcpath = basePath +"webresource/images/"+ deforg  + "/usr"+usrid+"/"; 
	var destpath = pubpack.EAOption.approot+"/images/"+ deforg  + "/usr"+usrid+"/";
	pubpack.EAFunc.copyDirectiory(srcpath,destpath,"","CVS",true );
	return "服务端：文件已从"+ srcpath +"同步到"+destpath ;
}


function savetoprofile(){
	var db = null;
	var usr=web.EASession.GetLoginInfo(request);//获取当前用户信息		
	var usrid=usr.getUsrid();
	var orgid= usr.getLogorg();
	pubpack.EAFunc.Log("adddesktop");
	try {
		db = new pubpack.EADatabase();
		var sql = "";
//		sql = "select * from usrprofiledtl where id='"+usrid+"'AND ORG='"+orgid+"'and refguid='"+guid+"'AND TYP='MYBG'";
//		var ds = db.QuerySQL(sql);
//		if(ds.getRowCount()<1){
			sql = "insert into usrprofiledtl (id,org,refid1 ,TYP)values('"+usrid+"','"+orgid+"','"+imagepath+"','MYBG')";
			db.ExcecutSQL(sql);
//		}
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
}
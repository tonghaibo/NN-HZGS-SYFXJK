function x_CloudBGPreview(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//������� 
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );//������� 
var basePath = pubpack.EAOption.dynaDataRoot;
// ����xlsGridData��web
// ���� deforg  sysurlid 
function copytoweb()
{
	var srcpath = basePath +"webresource/images/"+ deforg  + "/usr"+usrid+"/"; 
	var destpath = pubpack.EAOption.approot+"/images/"+ deforg  + "/usr"+usrid+"/";
	pubpack.EAFunc.copyDirectiory(srcpath,destpath,"","CVS",true );
	return "����ˣ��ļ��Ѵ�"+ srcpath +"ͬ����"+destpath ;
}


function savetoprofile(){
	var db = null;
	var usr=web.EASession.GetLoginInfo(request);//��ȡ��ǰ�û���Ϣ		
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
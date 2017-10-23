function x_URLBODY(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var pubpack= new JavaPackage("com.xlsgrid.net.pub");
var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var iopack = new JavaPackage ( "java.io" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var utilpack = new JavaPackage ( "java.util");
var basePath = pubpack.EAOption.dynaDataRoot;


//页面BODY处理完毕后事件
//sb里面是body元素及前面的head内容
//bodysb里面是body的innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
  bodysb.append("
<SCRIPT LANGUAGE=javascript FOR=svg EVENT=\"ShellExecuteFileModify(filepath,classname)\">
<!--
	svg.LoadZXGFile( filepath, 0, svg.GetCurrentSheet() );
//}
-->
</SCRIPT>
<SCRIPT> var deforg = '"+webpack.EAWebDeforg.GetDeforg(request)+"';
</SCRIPT>
  ");
  bodysb.insert(0,"<input type=\"file\" id=\"myfile\" style=\"display:none\"></input>");
}


function save()
{
	var db = null;
	var sql = "";
	try {
		db = new pub.EADatabase();
		sql = "delete from urlbody where fromguid='"+urlguid+"'";
		db.ExcecutSQL(sql);
		sql = "insert into urlbody(contents,fromguid) values(empty_blob(),'"+urlguid+"')";
		db.ExcecutSQL(sql);
		var contents = new java.lang.String(body);
//		var out = new java.io.ByteArrayOutputStream(); 
//		out.write(contents.getBytes("GBK")); 
//		var buff = out.toByteArray(); 
		sql = "select contents from urlbody where fromguid='"+urlguid+"' for update";
		
		db.UpdateBlobWithStr(sql,"CONTENTS",contents);
		
	}
	catch(e) {
		db.Rollback();
		throw new Exception(e.toString());
	}
	finally {
		if (db != null) db.Close();
	}
}

function getBlob()
{
	var db = null;
	var sql = "";
	try {
		db = new pub.EADatabase();
		sql = "select contents from urlbody where fromguid='"+urlguid+"'";
		return db.getBlob2String(sql,"CONTENTS");
	}
	catch(e) {
		db.Rollback();
		throw new Exception(e.toString());
	}
	finally {
		if (db != null) db.Close();
	}
}


// 得到webresource的定义
// sysurlid, deforg 
function GetWebresourceXMLDS()
{
       var xml = "";
        var sytds = xmldbpack.EASYTXmlDB.getSytDS();
	var ds = new pubpack.EAXmlDS();
	var num = 0;

	var fileurl=pubpack.EAOption.dynaDataRoot + "webresource/images/" +deforg +"/" + sysurlid+"/";     
//	throw new pubpack.EAException(fileurl);         
	var folds = (new java.io.File(fileurl)).listFiles();
	if ( folds != null ) {
		folds=pub.EAFunc.sort(folds);
		var c = folds.length();
		
		for(var i=0;i<c;i++) {
			
			var f=folds[i];
			if(!f.isDirectory() ) {
				var filename = f.getName();
            			
					var row= ds.AddRow(ds.getRowCount()-1);
					num++;
					ds.setValueAt(row,"FILENAME",filename);


			}
		}
	}
        return ds.GetXml();
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
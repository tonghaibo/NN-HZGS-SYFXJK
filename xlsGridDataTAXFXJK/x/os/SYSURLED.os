function x_SYSURLED(){var pubpack= new JavaPackage("com.xlsgrid.net.pub");
var pub = new JavaPackage("com.xlsgrid.net.pub");

var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var iopack = new JavaPackage ( "java.io" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var utilpack = new JavaPackage ( "java.util");
var basePath = pubpack.EAOption.dynaDataRoot;
function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
  
  sb.append("<script>\n");
  var thisorgid=pubpack.EAFunc.NVL(request.getParameter("thisorgid"),webpack.EAWebDeforg.GetDeforg(request));
  sb.append("\nvar thisorgid=\""+thisorgid+"\";");
  sb.append("</script>");
  
}
  
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
  bodysb.insert(0,"<form id=\"myfilef\"><input type=\"file\" id=\"myfile\" style=\"display:none\"></input></form>");//
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

// 客户端param传入的参数可以直接使用
function save()
{
	var db = null;
	var sql= "";
	var msg= "";
	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var ds = new pubpack.EAXmlDS(xmlstr);	// 客户端可以传入一个xml
		var EAfunc = new pubpack.EAFunc();
		
		for ( var row=0;row<ds.getRowCount();row ++ ) {
	
			var guid = ds.getStringAt(row,"GUID");
			var org = ds.getStringAt(row,"ORG");
			var refid = ds.getStringAt(row,"REFID");
			var id = ds.getStringAt(row,"ID");
			var name = ds.getStringAt(row,"NAME");
			var note = ds.getStringAt(row,"NOTE");
			var url = ds.getStringAt(row,"URL");
			var target = ds.getStringAt(row,"TARGET");
			var icon = ds.getStringAt(row,"ICON");
			var icon2 = ds.getStringAt(row,"ICON2");
			var srcfilnam = ds.getStringAt(row,"SRCFILNAM");
			var supperid = ds.getStringAt(row,"SUPPERID");
			var seqid = ds.getStringAt(row,"SEQID");
			
			url = EAfunc.Replace(url,"#$amp;","&");
			
			if (guid != ""){
				sql = "update sysurl set refid='%s',name='%s',note='%s',url='%s',target='%s',icon='%s',icon2='%s',srcfilnam='%s',supperid='%s',seqid='%s' where guid='%s'"
					.format([refid,name,note,url,target,icon,icon2,srcfilnam,supperid,seqid,guid]);
				db.ExcecutSQL(sql);
			} else {
				if (org != "" && refid != "") {
					sql = "insert into sysurl (guid,org,refid,id,name,note,url,target,icon,icon2,srcfilnam,supperid,seqid) values (sys_guid(),'%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s')"
						.format([org,refid,id,name,note,url,target,icon,icon2,srcfilnam,supperid,seqid]);
					db.ExcecutSQL(sql);
				}
			}
		}
		
		db.Commit();
		msg = "保存成功!";
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}

// 客户端param传入的参数可以直接使用
function delt()
{
	var db = null;
	var sql= "";
	var cnt = 0;
	var msg= "";
	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var ds = new pubpack.EAXmlDS(xmlstr);	// 客户端可以传入一个xml
		
		for ( var row=0;row<ds.getRowCount();row ++ ) {
			var flg = ds.getStringAt(row,"FLG");
			var guid = ds.getStringAt(row,"GUID");
			
			if (flg == "1") {
				sql = "delete sysurl where guid='"+guid+"'";
				cnt += db.ExcecutSQL(sql);
			}
		}
		
		db.Commit();
		msg = "删除成功! 共 "+cnt+" 行";
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}

}
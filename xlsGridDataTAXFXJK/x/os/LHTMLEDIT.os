function x_LHTMLEDIT(){var pub  = new JavaPackage ( "com.xlsgrid.net.pub" );
var basePath = pub.EAOption.dynaDataRoot;
var pubpack= new JavaPackage("com.xlsgrid.net.pub");
var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var iopack = new JavaPackage ( "java.io" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var utilpack = new JavaPackage ( "java.util");



function test(){
	var a = "";
	var eas = new pub.EAScript(null);                		 
	//参数找到后，就执行方法，上面所指的funname其实是文件名字，MyFun是文件的根节点，funName是方法名字
	try{
		
		eas.DefineScopeVar("request", request);
		var a =  eas.CallClassFunc("x_LHTMLEDIT","t",null).castToString();
		return a;
	}catch(e){
		throw new Exception(e);
	}
 		
}

function t(){
	var a = request.getParameterNames();
		var ret = "";
		var ret2 = "";
		var i=0;
		while(a.hasMoreElements()&&i<10){
			var paramnam = a.nextElement().toString();
			ret +=paramnam+"|";
			ret2 +=request.getParameter(paramnam)+"|";
			i++;
		}
		 
		return ret+"\n哈哈成功\n"+ret2 ;
	return "进来了v"+abc;
}


function GetBody()
{
	var html = "";
	
	var layhdrguid= request.getParameter( "layhdrguid" ) ;
	var sql = "select A.* from LSYSURL a,formblob b,formblob img where a.icon=img.guid(+) and a.htmlguid=b.guid and a.guid='"+layhdrguid+"'";
	var ds = db.QuerySQL(sql);
	var title = "";
	var crtdat = "";
	var image = "";
	if(ds.getRowCount()>0){
		title = ds.getStringAt(0,"NAME");
		crtdat = ds.getStringAt(0,"CRTDAT");
		image = ds.getStringAt(0,"ICON");
	}
	var context = db.getBlob2String("select b.bdata from LSYSURL a,formblob b where a.htmlguid=b.guid and a.guid='"+layhdrguid+"' for update","bdata");
	html = "  
		<table   >
		<tr><td><h1 style=\"   text-align: center; \">"+title +"</h1></td></tr>
		 <tr><td align=center >"+crtdat+"</td></tr>
		 <tr><td><hr style=\"border-bottom: 1px solid #DFDFDF; padding-left: 4px; padding-right: 4px; padding-top: 1px; padding-bottom: 1px\" size=\"0\"></td></tr>
		 ";
	if(image!=""){
		html +="<tr><td align=center ><img src=\""+image +"\" border=\"0\"></td></tr>";
	}
	
	html+= "
		 <tr><td align=center ><table     width=90% style=\"text-align: left;\"  ><tr><td>"+context +" </td></tr></table></td></tr>
		</table>

		 ";
//	html = "<p align=\"center\"><b><font size=\"4\">标题</font></b></p>
//		<hr style=\"border-bottom: 1px solid #DFDFDF; padding-left: 4px; padding-right: 4px; padding-top: 1px; padding-bottom: 1px\" size=\"0\">
//		<p></p>
//		<p><img src=\"\"></p>
//		<table border=\"0\" width=\"80%\" cellspacing=\"10\">
//		 <tr>
//		  <td>"+context +"</td>
//		 </tr>
//		</table>
//		<p></p>";
//	html = "  <h1 style=\" height: auto;  text-align: center;margin-top: 10px;\">"+title +"</h1>
//		<div id=\"fbdate\" style=\"text-align: center;\">2014</div>
//		<div id=\"wenzi\" style=\"width: 630px; text-align: justify;margin: 0 auto;line-height: 23px;;BSHARE_POP blkContainerSblkCon clearfix blkContainerSblkCon_14;\">
//		<div id=\"maincontent\"><div id=\"ivs_content\">"+context +"</div><br></div> ";
//	html = "<h1 style=\" text-align: center;margin-top: 10px;\">"+title +"</h1>";
	return  html;
}
//单据保存后
function fos_aftersave(eaContext)
//var eaContext=new pub.EAContext();
{
	var db = eaContext.getEADatabase();
	var ds = db.QuerySQL("select * from LHTML ");
	var xml = ds.GetXml();
	pub.EAFunc.WriteToFile(basePath +"LHTML.xml",xml);
	var ds = db.QuerySQL("select * from LHTMLDTL ");
	var xml = ds.GetXml();
	pub.EAFunc.WriteToFile(basePath +"LHTMLDTL.xml",xml);
}



// 保存
function SaveCSSJS()
{
	var udir = basePath +"syt/syt"+thissytid+"/";
	var ufile = thisid;
	pubpack.EAFunc.WriteToFileEx(udir+"css/"+ufile+".css",css,false);
	pubpack.EAFunc.WriteToFileEx(udir+"js/"+ufile+".js",js,false);
		
	var srcpath = udir  ;//+ "/" +filename
	var destpath = pubpack.EAOption.approot+"/syt"+thissytid;//+ "/"+filename

	pubpack.EAFunc.copyDirectiory(udir,destpath,"","CVS",true );
	return "服务端：文件已从"+ srcpath +"同步到"+destpath ;
}


// get css file text
function GetCSS()
{
	var udir = basePath +"syt/syt"+thissytid+"/";
	var ufile = thisid;
	
	return pubpack.EAFunc.readFile(udir+"css/"+ufile+".css");
}

// get css file text
function GetJS()
{
	var udir = basePath +"syt/syt"+thissytid+"/";
	var ufile = thisid;
	return pubpack.EAFunc.readFile(udir+"js/"+ufile+".js");
}

function savetable (){
		var web = new JavaPackage ( "com.xlsgrid.net.web" );
		var usr = web.EASession.GetLoginInfo(request);
		var homeurl = usr.getHomeURL();
		var orgid = usr.getOrgid();
		var accid = usr.getAccid();
		var usrid = usr.getUsrid();
		var usrnam = usr.getUsrnam();
		var db = null;
		var ds = "";
		var ret ="";
		var sql = "";
		try{
			db = new pubpack.EADatabase();
			var table = "LHTML ";
			var ds = db.QuerySQL("select * from "+table +" ");
			var xml = ds.GetXml();
			pub.EAFunc.WriteToFile(basePath +""+table +".xml",xml);
			return "ok";
		}catch(e){
			if(db!=null)db.Rollback();
			throw new Exception(e);
		}finally{
			if(db!=null) db.Close();
		}
		return "error";
}

function implhtml(){
		var web = new JavaPackage ( "com.xlsgrid.net.web" );
		var usr = web.EASession.GetLoginInfo(request);
		var homeurl = usr.getHomeURL();
		var orgid = usr.getOrgid();
		var accid = usr.getAccid();
		var usrid = usr.getUsrid();
		var usrnam = usr.getUsrnam();
		var db = null;
		var ds = "";
		var ret ="";
		var sql = "";
		try{
			db = new pubpack.EADatabase();
			var xml = pubpack.EAFunc.readFile(basePath +"LHTML.xml");
			var ds = new pubpack.EAXmlDS( xml );//把xml读取成ds
			for(var i=0;i<ds.getRowCount();i++){
				var cols = "";
				for (var c=1;c<ds.getColumnCount();c++){
					if(cols==""){
						cols +=" '"+ds.getStringAt(i,c)+"' ";
					}else if(c==2||c==3){
						cols +=" ,sysdate ";
					}else{
						cols +=" ,'"+ds.getStringAt(i,c)+"' ";
					}
				}
				sql = "insert into lhtml select "+cols+" from dual";
 
				db.ExcecutSQL(sql);
			}
			
			
			var xml = pubpack.EAFunc.readFile(basePath +"LHTMLDTL.xml");
			var ds = new pubpack.EAXmlDS( xml );//把xml读取成ds
			for(var i=0;i<ds.getRowCount();i++){
				var cols = "";
				for (var c=1;c<ds.getColumnCount();c++){
					if(cols==""){
						cols +=" '"+ds.getStringAt(i,c)+"' ";
					}else{
						cols +=" ,'"+ds.getStringAt(i,c)+"' ";
					}
				}
				sql = "insert into lhtmlDTL select "+cols+" from dual";
 
				db.ExcecutSQL(sql);
			}
			//throw new Exception(sql);
			ret = "OK";
		}catch(e){
			if(db!=null)db.Rollback();
			throw new Exception(e);
		}finally{
			if(db!=null) db.Close();
		}
		return ret;
}




}
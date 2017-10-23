function x_mwcvs(){var db=new JavaPackage("com.xlsgrid.net.xmldb");
var pub = new JavaPackage("com.xlsgrid.net.pub");
var pubpack = new JavaPackage("com.xlsgrid.net.pubpack");
var mutil = new JavaPackage("java.util");
var text = new JavaPackage("java.text");
var io = new JavaPackage("java.io");
//var a=pub.EAOption.get("xlsgrid.file.dynadata.root");
//var r= a.substring(0,a.length()-1);
var cvsroot = pub.EAOption.dynaBakDataRoot;
var uroot = pub.EAOption.dynaDataRoot;

//删除版本
function delectpb()
{	
	try{
		var fold=pb.split(",");
		for(var i=0;i<fold.length();i++)
		{
			var path= cvsroot + "/xmldb/grddb/syt"+cursytid+"/"+mwid+"/"+fold[i].trim()+"/";//动态路径（中间件）
			var file = new java.io.File(path);
			var fi=file.list();
			for(var j=0;j<fi.length();j++)
			{
				var zpath=path+fi[j];
				var zfile = new java.io.File(zpath);
				zfile.delete();
			}
			file.delete();
		}
		for(var k=0;k<fold.length();k++)
		{
			var path= cvsroot + "/xmldb/grddb/syt"+cursytid+"/"+mwid+"/"+fold[k].trim()+"/";//动态路径（中间件）
			var file = new java.io.File(path);
			if(!file.exists())
			{
				return true;
			}
		}
	}
	catch(e){
		throw new Exception(e);
	}

}
//还原中间件
function copyfile()
{	
	try{
		var path = cvsroot+"/xmldb/grddb/syt"+cursytid+"/"+mwid+"/"+pb.trim()+"/";
		var file = new java.io.File(path);//目录
	    	var fold = file.list();
	    	var count=0;
	    	for(var i=0;i<fold.length();i++)
	    	{
	    		var srcfile=path+fold[i];
	    		var destfile=uroot+"/xmldb/grddb/syt"+cursytid+"/";
			count+=pub.EAFunc.copyFile(srcfile,destfile,fold[i]);//srcfile原文件路径 destfile复制文件的路径 newfileName 文件名的名称
		}
		//重置中间件
		db.EAXmlDB.loadOnwMW(sytid,db.EAGRDXmlDB.getMWDefineFile(cursytid,mwid));
		return count;
	}
	catch(e){
		throw new Exception(e);
	}
}
//获取文件类容
function getcontent()
{	

	var filetext="";//定义服务端
	var ph = cvsroot+"/xmldb/grddb/syt"+cursytid+"/"+mwid+"/"+pb.trim()+"/";//动态路径（中间件）
	var bit=mwid+".xml";
	var str = pub.EAFunc.readFile(ph+bit,"GBK");
	var js = str.substring(str.indexOf("<grdjsds>")+"<grdjsds>".length(),str.indexOf("</grdjsds>")-1);
	var os= str.substring(str.indexOf("<grdosds>")+"<grdosds>".length(),str.indexOf("</grdosds>")-1);
	return js+os;
}
//获取文件大小
function getbit()
{	
	var fold=fold.split(",");
	var a="";
	for(var i=0;i<fold.length();i++)
	{	
		var ph = cvsroot + "/xmldb/grddb/syt"+cursytid+"/"+mwid+"/"+fold[i].trim()+"/";//动态路径（中间件）
		var bit=mwid+".xml";
		var f = new java.io.File(ph+bit);   
        	var fis = new io.FileInputStream(f);
		a+=fis.available()/1024+",";   
	}
	return a;

}
//获取文件名
function getfilesum()
{	
	var path = cvsroot+ "/xmldb/grddb/syt"+cursytid+"/"+mwid+"/";//动态路径（中间件）
	var file = new java.io.File(path);//目录
    	var fold = file.list();
    	return fold;

}

//获取文件修改时间
function getftime()
{
	var fold=fold.split(",");
	var a="";
	for(var i=0;i<fold.length();i++)
	{	
		
		var ph = cvsroot + "/xmldb/grddb/syt"+cursytid+"/"+mwid+"/"+fold[i].trim()+"/";//动态路径（中间件）
		var filetime = new java.io.File(ph);//目录
		var time = new mutil.Date(filetime.lastModified());//获取时间
		
		var simpleDateFormat = new text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		var dat = simpleDateFormat.format(filetime.lastModified());
		a+=dat+",";
	}
	return a;
}



}
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

//ɾ���汾
function delectpb()
{	
	try{
		var fold=pb.split(",");
		for(var i=0;i<fold.length();i++)
		{
			var path= cvsroot + "/xmldb/grddb/syt"+cursytid+"/"+mwid+"/"+fold[i].trim()+"/";//��̬·�����м����
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
			var path= cvsroot + "/xmldb/grddb/syt"+cursytid+"/"+mwid+"/"+fold[k].trim()+"/";//��̬·�����м����
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
//��ԭ�м��
function copyfile()
{	
	try{
		var path = cvsroot+"/xmldb/grddb/syt"+cursytid+"/"+mwid+"/"+pb.trim()+"/";
		var file = new java.io.File(path);//Ŀ¼
	    	var fold = file.list();
	    	var count=0;
	    	for(var i=0;i<fold.length();i++)
	    	{
	    		var srcfile=path+fold[i];
	    		var destfile=uroot+"/xmldb/grddb/syt"+cursytid+"/";
			count+=pub.EAFunc.copyFile(srcfile,destfile,fold[i]);//srcfileԭ�ļ�·�� destfile�����ļ���·�� newfileName �ļ���������
		}
		//�����м��
		db.EAXmlDB.loadOnwMW(sytid,db.EAGRDXmlDB.getMWDefineFile(cursytid,mwid));
		return count;
	}
	catch(e){
		throw new Exception(e);
	}
}
//��ȡ�ļ�����
function getcontent()
{	

	var filetext="";//��������
	var ph = cvsroot+"/xmldb/grddb/syt"+cursytid+"/"+mwid+"/"+pb.trim()+"/";//��̬·�����м����
	var bit=mwid+".xml";
	var str = pub.EAFunc.readFile(ph+bit,"GBK");
	var js = str.substring(str.indexOf("<grdjsds>")+"<grdjsds>".length(),str.indexOf("</grdjsds>")-1);
	var os= str.substring(str.indexOf("<grdosds>")+"<grdosds>".length(),str.indexOf("</grdosds>")-1);
	return js+os;
}
//��ȡ�ļ���С
function getbit()
{	
	var fold=fold.split(",");
	var a="";
	for(var i=0;i<fold.length();i++)
	{	
		var ph = cvsroot + "/xmldb/grddb/syt"+cursytid+"/"+mwid+"/"+fold[i].trim()+"/";//��̬·�����м����
		var bit=mwid+".xml";
		var f = new java.io.File(ph+bit);   
        	var fis = new io.FileInputStream(f);
		a+=fis.available()/1024+",";   
	}
	return a;

}
//��ȡ�ļ���
function getfilesum()
{	
	var path = cvsroot+ "/xmldb/grddb/syt"+cursytid+"/"+mwid+"/";//��̬·�����м����
	var file = new java.io.File(path);//Ŀ¼
    	var fold = file.list();
    	return fold;

}

//��ȡ�ļ��޸�ʱ��
function getftime()
{
	var fold=fold.split(",");
	var a="";
	for(var i=0;i<fold.length();i++)
	{	
		
		var ph = cvsroot + "/xmldb/grddb/syt"+cursytid+"/"+mwid+"/"+fold[i].trim()+"/";//��̬·�����м����
		var filetime = new java.io.File(ph);//Ŀ¼
		var time = new mutil.Date(filetime.lastModified());//��ȡʱ��
		
		var simpleDateFormat = new text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		var dat = simpleDateFormat.format(filetime.lastModified());
		a+=dat+",";
	}
	return a;
}



}
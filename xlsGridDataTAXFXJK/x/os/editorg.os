function x_editorg(){var pubpack= new JavaPackage("com.xlsgrid.net.pub");
var pub = new JavaPackage("com.xlsgrid.net.pub");

var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var iopack = new JavaPackage ( "java.io" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var utilpack = new JavaPackage ( "java.util");
var basePath = pubpack.EAOption.dynaDataRoot;


// ����xlsGridData��web
// ���� deforg  sysurlid 
function copytoweb()
{
	var srcpath = basePath +"org/"+ deforg  ;//+ "/" +filename
	var destpath = pubpack.EAOption.approot+"/org/"+ deforg  ;//+ "/"+filename

	pubpack.EAFunc.copyDirectiory(srcpath,destpath,"","CVS",true );
	return "����ˣ��ļ��Ѵ�"+ srcpath +"ͬ����"+destpath ;
}

}
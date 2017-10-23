function x_SYSURLEDIT(){
var pubpack= new JavaPackage("com.xlsgrid.net.pub");
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
  var thisorgid=pubpack.EAFunc.NVL(request.getParameter("thisorgid"),"");
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
}
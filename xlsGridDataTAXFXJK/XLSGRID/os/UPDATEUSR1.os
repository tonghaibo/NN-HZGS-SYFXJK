function XLSGRID_UPDATEUSR1(){
var pubpack= new JavaPackage("com.xlsgrid.net.pub");

function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
  
  sb.append("<script>\n");
  var thisorgid=pubpack.EAFunc.NVL(request.getParameter("thisorgid"),"");
  sb.append("\nvar thisorgid=\""+thisorgid+"\";");
  sb.append("</script>");
}
}
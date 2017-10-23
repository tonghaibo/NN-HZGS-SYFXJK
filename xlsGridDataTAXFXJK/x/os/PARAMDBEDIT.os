function x_PARAMDBEDIT(){var pub = new JavaPackage ( "com.xlsgrid.net.pub" );
function addBottomHtml(mwobj,request,sb,usrinfo)
{
  var script = request.getParameter("script");
  if(!pub.EAFunc.isEmptyStr(script))
  {
    sb.append("<SCRIPT language=jscript src='"+script+"'></SCRIPT>");  
  }
}

}
function x_TestHtmlView(){var pub= new JavaPackage("com.xlsgrid.net.pub");
var web= new JavaPackage("com.xlsgrid.net.web");
function addHeaderHtml(mwobj,request,sb,usrinfo)
{
      // 载入一个在其他中间件中定义的HTML模版
      var file= "xlsgrid/js/x/StdHtmlViewModule.djs" ; 
      var basePath = pub.EAOption.getRealpath();
      var path = basePath + file;
      var html =pub.EAFunc.readFile(path);
      sb.append(html);   
}

function addBottomHtml(mwobj,request,sb,usrinfo)
{
      sb.append( "e" );  
  
}

}
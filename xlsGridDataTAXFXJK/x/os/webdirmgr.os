function x_webdirmgr(){
var pub = new JavaPackage("com.xlsgrid.net.pub");

var fileEditor = new x_fileEditor();
mixin fileEditor;
cvshome=pub.AppStartListener.approot;
roolen = cvshome.length();

function syncRes()
{
  return "nothing to do.";
}

//����x.fileEditor�Ŀͻ��˴���
function addHeaderHtml(mwobj,request,sb,usrinfo)
{
  mwobj.EnsureMwJsFile("x","fileEditor");
  sb.append("<SCRIPT language=jscript src=\"xlsgrid/js/x/fileEditor.djs\"></SCRIPT>");
}

}
function x_asdirmgr(){var fileEditor = new x_fileEditor();
mixin fileEditor;
cvshome=pub.AppStartListener.approot;
var f = new java.io.File(cvshome);
cvshome = f.getParentFile().getParentFile().getParentFile().getPath();
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
function x_showflow(){
var pub = new JavaPackage("com.xlsgrid.net.pub");

// 得到某一个数据流图
function loadDataflwGraph()
{

	var path = pub.EAOption.dynaDataRoot+ pub.EAOption.get("xmldb.file.grddb")+"/syt" + selsytid + "/" + filename;
 
    return pub.EAFunc.readFile(path);
}
}
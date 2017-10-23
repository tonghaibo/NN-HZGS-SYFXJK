function x_JSDOC(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var iopack = new JavaPackage("java.io.File");
var ospack = new JavaPackage("oscript.*");
var osdatapack = new JavaPackage("oscript.data.*");

var basePath = pub.EAOption.dynaDataRoot;

//保存OS脚本到文件
function saveFuncToFile()
{
	var path = "/" + basePath  + "xmldb/grddb/syt" + sytid + "/ETLOS/";
	var file =  basePath  + "xmldb/grddb/syt" + sytid + "/ETLOS/" + osName + ".os";
	var ret = "";

//	var f = new java.io.File(file);
//	if (f.exists() && osName == "yourFuncName")
//		return "该函数已存在，请使用其他名字！";
	try{
//		ret = checkOs(path,str);
		pubpack.EAFunc.WriteToFile(file,str);		
//		pubpack.EAScript.LoadSystemWideScript(file);
	}catch(Exception e)
	{
		throw new pubpack.Exception("保存出错："+e.toString());
	}
//	if (ret != "")
//		return ret;
//	else
//		return "成功保存文件到 " + file;
	return "OS保存成功！" + file;
}

//保存前检查OS语法正确性
function checkOs(path,scriptStrings)
{
	var msg = "";
	try
      	{
		var eaDatabase = new pubpack.EADatabase();
		var eaScript = new pubpack.EAScript(eaDatabase );
//		pubpack.EAScript.AddScriptRootPath(path);
		msg = (eaScript.LoadLocalScript(scriptStrings)).toString();
	}
	catch(Exception e )
      	{
	        msg += " [ OS脚本有错误 ]" + e.toString()+path+scriptStrings;
      	}
      	return msg;
}

function getFuncFileToStr()
{
	var file =  basePath  + "xmldb/grddb/syt" + sytid + "/ETLOS/" + osName + ".os";
	var str = "";
	try{
		str = pubpack.EAFunc.readFile(file);
		return str;
	}
	catch(e){
		return "";
	}
}

}
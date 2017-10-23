function x_GRIDold(){var xmldb = new JavaPackage("com.xlsgrid.net.xmldb");
var eapub = new JavaPackage("com.xlsgrid.net.pub");
function loadDocument()
{
  var filepath = eapub.EAOption.dynaDataRoot+eapub.EAOption.get("xmldb.file.grddb")+"/syt"+ssytid+"/";
  var fname = filepath+sgrdid+".dxml";
  try
  {
  return eapub.EAFunc.readFile(fname);
  }
  catch(e)
  {
  }
}

function fos_beforesave(eaContext){
      try{
           // var dsxml = eaContext.getXmlhdr();
           // System.out.println(dsxml+"niujian");
      }catch(e){
            throw e;
      }
}

function fos_aftersave(eaContext){
      try{
	var sgrdid= eaContext.getAttribute("sgrdid");
   	var accid = eaContext.getAttribute("accid");
   	var ssytid = eaContext.getAttribute("ssytid");
   	var richxml = eaContext.getAttribute("richxml");
   	var sytid = (new xmldb.EAACCXmlDB(accid)).getSytid();
   	//System.out.println("sgrdid:"+sgrdid+" accid:"+accid+" ssytid:"+sytid);
   	//System.out.println("richxml"+richxml);
   	var filepath = eapub.EAOption.dynaDataRoot+eapub.EAOption.get("xmldb.file.grddb")+"/syt"+ssytid+"/";
   	var fname = sgrdid+".dxml";
   	
   	
   	eapub.EAFunc.WriteToFile(filepath+fname,richxml);
   	//var upload = new eapub.EAUpload();
   	//upload.setFolderstore(filepath);
   	//upload.store(eaContext.getAttribute(eaContext.MREQUEST),fname);
   	//System.out.println("中间件"+sgrdid);
   	return "中间件"+sgrdid;
   }catch(e){
         //System.out.println(e.toString());
         //throw e;
         return e.toString();
   }      
}
}
function x_DefXml(){var pub= new JavaPackage("com.xlsgrid.net.pub");
var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
//var flwLnkdbpath = pub.EAOption.getRealpath()+pub.EAOption.get("xmldb.file.flwLnkdb");
var basePath = pub.EAOption.dynaDataRoot;
  function  XmlToStd(xml)
  {
      xml = pub.EAFunc.Replace(xml, "&"+"quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"amp;quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"apos;", "'"  );
    return xml;
  }
  
function saveBilDef()
{
  //xmlstr = pub.EAFunc.XmlToStd(xmlstr);
  xmlstr = XmlToStd(xmlstr);
  var path = basePath + xmlfile;
  pub.EAFunc.WriteToFile(path,xmlstr);
//throw new pub.EAException(xmlstr);
  if(isDatFlw=="1")
  {
     xmldb.EAXmlDB.initFlwLnkDB();
  }
  return "����ɹ�!";
}
 
function delBilDef()
{
  var path = basePath + xmlfile;
  var f = new java.io.File(path);
  var ok = f.delete();
  if(ok && isDatFlw=="1")
  {
     xmldb.EAXmlDB.initFlwLnkDB();
  }
  if(ok)
    return "ɾ���ɹ���" ;
  else
    return "ɾ��ʧ�ܣ������ļ�����ʹ�á�";
}

function loadBilDef()
{
  var path = basePath + xmlfile;
  try
  {
    return pub.EAFunc.readFile(path);
  }
  catch(e)
  {
    var temp = pub.EAOption.dynaDataRoot + pub.EAOption.get("xmldb.file.flwLnkdb") + "/sytx/template.xml";
    return pub.EAFunc.readFile(temp );
  }
}
}
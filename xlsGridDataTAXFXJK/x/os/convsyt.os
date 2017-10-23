function x_convsyt(){function conv()
{
  //var xmldb=new JavaPackage("com.xlsgrid.net.xmldb");
  var froot = pub.EAOption.dynaDataRoot;
  var ds0 = xmldb.EAXmlDB.getXmlDbDs("subsytdb");
  //throw new Exception(ds0.GetXml());
  var nRow = ds0.getRowCount();
  var oldsyt = ds0.getStringAt(0,"SYTID");
  var xmlds = new pub.EAXmlDS();
  xmlds.AddNullRow(-1);
  for ( var i =0 ; i< nRow; i ++ )
  {
	var id = ds0.getStringAt(i,"ID") ;
	var sytid = ds0.getStringAt(i,"SYTID") ;
	if(sytid!=oldsyt)
	{
	  //throw new Exception(xmlds.GetXml());
	  var r = xmlds.getRowCount()-1;
	  xmlds.DeleteRow(r);
	  pub.EAFunc.WriteToFile(froot+oldsyt+"/subsytdb.xml",xmlds.GetXml());
	  oldsyt=sytid;
	  xmlds = new pub.EAXmlDS();
	  xmlds.AddNullRow(-1);
	}
	var r = xmlds.getRowCount()-1;  
	r = xmlds.AddNullRow(r)-1;
	var order=0;
	xmlds.setValueAt(r,"subid",id);
	xmlds.setValueAt(r,"typ",0);
	xmlds.setValueAt(r,"order",order++);
	xmlds.setValueAt(r,"name",ds0.getStringAt(i,"name"));
	xmlds.setValueAt(r,"TITLE",ds0.getStringAt(i,"TITLE"));
	xmlds.setValueAt(r,"ICON",ds0.getStringAt(i,"DESKICON"));
	xmlds.setValueAt(r,"URL",ds0.getStringAt(i,"BANNER"));
      	for(var j=1;j<10;j++)
  	{
		var name = ds0.getStringDef(i,"name"+j,"");
		if(name=="") break;
		r = xmlds.getRowCount()-1;
		xmlds.AddNullRow(r)-1;
		//r--;
		xmlds.setValueAt(r,"subid",id);
		xmlds.setValueAt(r,"typ",0);
		xmlds.setValueAt(r,"order",order++);
		xmlds.setValueAt(r,"name",name);
		xmlds.setValueAt(r,"ICON",ds0.getStringDef(i,"ICON"+j,""));
		//xmlds.setValueAt(r,"TITLE",ds0.getStringAt(i,"TITLE"));
		xmlds.setValueAt(r,"URL",ds0.getStringDef(i,"URL"+j,""));
 	}
  	
  }
	//if(sytid!=oldsyt)
	{
	  var r = xmlds.getRowCount()-1;
	  xmlds.DeleteRow(r);
	  pub.EAFunc.WriteToFile(froot+oldsyt+"/subsytdb.xml",xmlds.GetXml());
	}
  return "done";
}

function getsubsyt()
{
  return  xmldb.EAXmlDB.getSubSytDB(syt).GetXml();
}
}
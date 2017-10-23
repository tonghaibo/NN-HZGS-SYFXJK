function x_layout(){var pub= new JavaPackage("com.xlsgrid.net.pub");
var pubpack= new JavaPackage("com.xlsgrid.net.pub");
var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var iopack = new JavaPackage ( "java.io" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var utilpack = new JavaPackage ( "java.util");
var basePath = pubpack.EAOption.dynaDataRoot;

//var flwLnkdbpath = pub.EAOption.getRealpath()+pub.EAOption.get("xmldb.file.flwLnkdb");
var basePath = pub.EAOption.dynaDataRoot;

  function  XmlToStd(xml)
  {
      xml = pub.EAFunc.Replace(xml, "&"+"quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"amp;quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"apos;", "'"  );
    return xml;
  }
  
function GetDefOrg()
{
	return webpack.EAWebDeforg.GetDeforg(request);

}

function GetOrgDS()
{
        var xml = "";
        var sytds = xmldbpack.EAORGXmlDB.getOrgDs();
        var ds = new pubpack.EADS();
        for( var i=0;i< sytds.getRowCount(); i ++ ) {
              var selsytid = sytds.getStringAt(i,"ID");
              var selsytname = sytds.getStringAt(i,"NAME");
	      var row = ds.AddRow(ds.getRowCount()-1 );
	      ds.setValueAt(row,"ID", selsytid );
	      ds.setValueAt(row,"NAME", selsytname );

              xml+="<"+selsytid+" imageid=\"0\" sytflg=\""+selsytid+"\">"+selsytid+":"+selsytname ;      // sytflg说明该节点是一个系统
              //xml+="<流程图 selgrdtyp=\"S\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
              //xml+="<单据中间件 selgrdtyp=\"B\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
              //xml+="<报表中间件 selgrdtyp=\"R\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
              //xml+="<查询中间件 selgrdtyp=\"Q\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
              //xml+="<表单中间件 selgrdtyp=\"F\" imageid=\"0\" sytflg=\""+selsytid+"\"/>";
              //xml+="<自定义中间件 selgrdtyp=\"M\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
	
              xml+="</"+selsytid+">";
        }    
 //       xml+="</中间件对象>";
        return ds.GetXml();
}

// 系统的下拉式列表
function GetOrgListForCombo()
{
        var xml = "";
        var sytds = xmldbpack.EAORGXmlDB.getOrgDs();
        var ds = new pubpack.EAXmlDS();
        for( var i=0;i< sytds.getRowCount(); i ++ ) {
              var selsytid = sytds.getStringAt(i,"ID");
              var selsytnam = sytds.getStringAt(i,"NAME");
              var row = ds.AddRow(ds.getRowCount()-1 ) ;
              ds.setValueAt(row,"ID" , selsytid );
              ds.setValueAt(row,"NAME" ,selsytid + selsytnam );

        }    
        return ds.GetXml();
}

// 由于目前没有数据流单据的对应关系，暂时从Datflwsrc取数
function GetFlwList()
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var ds = xmldbpack.EAXmlDB.getFlwLnkDestDs(selsytid);

	for ( var i=0;i<ds.getRowCount() ; i ++ ) {
		var id =ds.getStringAt(i,"LnkID");
		var name = ds.getStringAt(i,"DESC");

		xml+="<"+id + " name=\""+name+"\" id=\""+id+"\" sytflg=\""+selsytid+"\" />";

	}
	return xml;

}
// 得到数据流的定义
function GetLayout()
{
       var xml = "";
        var sytds = xmldbpack.EAORGXmlDB.getOrgDs();
	var ds = new pubpack.EAXmlDS();
	

	var num = 0;
        for( var i=0;i< sytds.getRowCount(); i ++ ) {
		var selsytid = sytds.getStringAt(i,"ID");
		
		if ( thissytid == selsytid ) {
			var fileurl=pubpack.EAOption.dynaDataRoot + "org/" + selsytid+"/layout";     
			var fileurl1=pubpack.EAOption.dynaDataRoot + "org/" + selsytid+"/layout/index.layout";   
			var pagexml = "";
			try { pagexml =pubpack.EAFunc.readFile(fileurl1);}catch(e) {}
		        var pageds  = new pubpack.EAXmlDS(pagexml); 
			var folds = (new java.io.File(fileurl)).listFiles();
			if ( folds != null ) {
				folds=pub.EAFunc.sort(folds);
				var c = folds.length();
				for(var i=0;i<c;i++) {
					var f=folds[i];
					if(!f.isDirectory() ) {
						var filename = f.getName();
		            			var index = filename.indexOf(".sxg");	
						if ( index >=0  ) {
							var row= ds.AddRow(ds.getRowCount()-1);
							num++;
							ds.setValueAt(row,"SEQID",num);
							ds.setValueAt(row,"FILENAME",filename);
							ds.setValueAt(row,"NOTE","");

							var layoutid = filename.substring(0,index);
							for ( var j=0;j<pageds.getRowCount();j++){
								if ( pageds.getStringAt(j,"ID")==layoutid ){
									ds.setValueAt(row,"NOTE",pageds.getStringAt(j,"TITLE"));
									break;
								}
							}
							ds.setValueAt(row,"SYTID",selsytid );
							ds.setValueAt(row,"ACTION","修改布局" );
							ds.setValueAt(row,"ACTION1","删除布局" );
							
							

	
	
							
						}	
					}
				}
			}
		}
	}
        return ds.GetXml();
}

// sub 后缀
function GetDatflwGraph()
{
        var xml = "";
        var sytds = xmldbpack.EASYTXmlDB.getSytDS();
	var ds = new pubpack.EAXmlDS();
	var num = 0;
	if( sub=="" ) sub="flow";
	
        for( var i=0;i< sytds.getRowCount(); i ++ ) {
		var selsytid = sytds.getStringAt(i,"ID");
		if ( thissytid == selsytid ) {
			var fileurl=basePath + pub.EAOption.get("xmldb.file.grddb")+"/syt" + selsytid;     
			//throw new pubpack.EAException(fileurl);         
			var folds = (new java.io.File(fileurl)).listFiles();
			if ( folds != null ) {
				folds=pub.EAFunc.sort(folds);
				var c = folds.length();
				for(var i=0;i<c;i++) {
					var f=folds[i];
					if(!f.isDirectory() ) {
						var filename = f.getName();
		            			var index = filename.indexOf("."+sub);	
						if ( index >=0  ) {
							var row= ds.AddRow(ds.getRowCount()-1);
							num++;
							ds.setValueAt(row,"SEQID",num);
							ds.setValueAt(row,"FILENAME",filename);
							ds.setValueAt(row,"NOTE","业务流程图"+filename);
							ds.setValueAt(row,"SYTID",selsytid );
							
							if(sub=="flow")	ds.setValueAt(row,"ACTION","修改流程图" );
							else ds.setValueAt(row,"ACTION","修改DB图" );
							ds.setValueAt(row,"ACTION1","删除图" );
							
	
	
							
						}	
					}
				}
			}
		}
	}
        return ds.GetXml();

}
// 得到单据的数据流
function GetWrkflwGraph()
{
        var xml = "";
        var sytds = xmldbpack.EASYTXmlDB.getSytDS();
	var ds = new pubpack.EAXmlDS();
	var num = 0;
        for( var i=0;i< sytds.getRowCount(); i ++ ) {
		var selsytid = sytds.getStringAt(i,"ID");
		if ( thissytid == selsytid ) {
			var fileurl=basePath + pub.EAOption.get("xmldb.file.grddb")+"/syt" + selsytid;     
			//throw new pubpack.EAException(fileurl);         
			var folds = (new java.io.File(fileurl)).listFiles();
			if ( folds != null ) {
				folds=pub.EAFunc.sort(folds);
				var c = folds.length();
				for(var i=0;i<c;i++) {
					var f=folds[i];
					if(!f.isDirectory() ) {
						var filename = f.getName();
		            			var index = filename.indexOf(".process");	
						if ( index >=0  ) {
							var row= ds.AddRow(ds.getRowCount()-1);
							num++;
							ds.setValueAt(row,"SEQID",num);
							ds.setValueAt(row,"FILENAME",filename);
							ds.setValueAt(row,"NOTE",filename);
							ds.setValueAt(row,"SYTID",selsytid );
							ds.setValueAt(row,"ACTION","修改工作流" );
							ds.setValueAt(row,"ACTION1","删除图" );
							
	
	
							
						}	
					}
				}
			}
		}
	}
        return ds.GetXml();

}

// 得到数据流来源列表
function GetDatflwsrc()
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var ds = xmldbpack.EAXmlDB.getFlwLnkSrcDs(selsytid);
	var ds1= new pubpack.EAXmlDS();

	//为了得到名称
	var bilds = xmldbpack.EAGRDXmlDB.getSytWMList(selsytid,"B");
	var bilds1= new pubpack.EAXmlDS();
	for ( var i=0;i<bilds.getRowCount() ; i ++ ) {
		var id =bilds.getStringAt(i,"MWID");
		var name = bilds.getStringAt(i,"NAME");
		var newrow = bilds1.AddRow(bilds1.getRowCount()-1);
		bilds1.setValueAt(newrow,"MWID" ,id );
		bilds1.setValueAt(newrow,"NAME" ,name );
	}
	
	for ( var i=0;i<ds.getRowCount() ; i ++ ) {
		var id =ds.getStringAt(i,"LnkID");
		var srcid = ds.getStringAt(i,"SRCCLS");
		var destid = "";
		var index = id .indexOf("2");
		if ( index > 0 ) 
			destid = id.substring(index +1);	// 由于目前没有数据流单据的对应关系，暂时从LnkID得到destid
		var newrow = ds1.AddRow(ds1.getRowCount()-1);
		ds1.setValueAt(newrow,"ID" ,id );
		ds1.setValueAt(newrow,"SRCID" ,srcid );
		ds1.setValueAt(newrow,"DESTID" ,destid );
		var srcnam= "";
		var destnam= "";
		for ( var j=0;j<bilds1.getRowCount() ;j++ ) {
			if ( bilds1.getStringAt(j,"MWID") == srcid ) {
				srcnam= bilds1.getStringAt(j,"NAME"); 
				break;
			}
		}
		for ( var j=0;j<bilds1.getRowCount() ;j++ ) {
			if ( bilds1.getStringAt(j,"MWID") == destid ) {
				destnam= bilds1.getStringAt(j,"NAME"); 
				break;
			}
		}
		ds1.setValueAt(newrow,"SRCNAM" ,srcnam);
		ds1.setValueAt(newrow,"DESTNAM" ,destnam);
	}
	return ds1.GetXml();


}
// 得到数据流目标列表
function GetDatflwdest()
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var ds = xmldbpack.EAXmlDB.Eru43wPo
	(selsytid);
	return ds.GetXml();
	for ( var i=0;i<ds.getRowCount() ; i ++ ) {
		var id =ds.getStringAt(i,"LnkID");
		var name = ds.getStringAt(i,"DESC");

		xml+="<"+id + " name=\""+name+"\" id=\""+id+"\" sytflg=\""+selsytid+"\" />";

	}
	return xml;

}
}
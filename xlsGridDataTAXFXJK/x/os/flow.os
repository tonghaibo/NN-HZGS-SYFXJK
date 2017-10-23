function x_flow(){var pub= new JavaPackage("com.xlsgrid.net.pub");
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
  
function GetDefSyt()
{
	var deforg = webpack.EAWebDeforg.GetDeforg(request);

	var accds = xmldbpack.EAACCXmlDB.getAccDS();
	var defsyt = "";
	for ( var i=0;i< accds.getRowCount(); i ++ ) {
		var orgid = accds.getStringAt(i,"ORG");
		var sytid = accds.getStringAt(i,"SYT");
		if ( orgid == deforg ) 
			return sytid; 

	}
	return "";
}

function GetSytDS()
{
//"<?xml version = '1.0' encoding='GBK'?>";
//        xml+="<�м������>";
        var xml = "";
        var sytds = xmldbpack.EASYTXmlDB.getSytDS();
        var ds = new pubpack.EADS();
        for( var i=0;i< sytds.getRowCount(); i ++ ) {
              var selsytid = sytds.getStringAt(i,"ID");
              var selsytname = sytds.getStringAt(i,"NAME");
	      var row = ds.AddRow(ds.getRowCount()-1 );
	      ds.setValueAt(row,"ID", selsytid );
	      ds.setValueAt(row,"NAME", selsytname );

              xml+="<"+selsytid+" imageid=\"0\" sytflg=\""+selsytid+"\">"+selsytid+":"+selsytname ;      // sytflg˵���ýڵ���һ��ϵͳ
              //xml+="<����ͼ selgrdtyp=\"S\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
              //xml+="<�����м�� selgrdtyp=\"B\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
              //xml+="<�����м�� selgrdtyp=\"R\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
              //xml+="<��ѯ�м�� selgrdtyp=\"Q\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
              //xml+="<���м�� selgrdtyp=\"F\" imageid=\"0\" sytflg=\""+selsytid+"\"/>";
              //xml+="<�Զ����м�� selgrdtyp=\"M\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
	
              xml+="</"+selsytid+">";
        }    
 //       xml+="</�м������>";
        return ds.GetXml();
}

// ϵͳ������ʽ�б�
function GetSytListForCombo()
{
        var xml = "";
        var sytds = xmldbpack.EASYTXmlDB.getSytDS();
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

// ����Ŀǰû�����������ݵĶ�Ӧ��ϵ����ʱ��Datflwsrcȡ��
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
// �õ��������Ķ���
function GetFlwXMLDS()
{
       var xml = "";
        var sytds = xmldbpack.EASYTXmlDB.getSytDS();
	var ds = new pubpack.EAXmlDS();
	var num = 0;
        for( var i=0;i< sytds.getRowCount(); i ++ ) {
		var selsytid = sytds.getStringAt(i,"ID");
		if ( thissytid == selsytid ) {
			var fileurl=pubpack.EAOption.dynaDataRoot + pubpack.EAOption.get("xmldb.file.flwLnkdb") +"/syt" + selsytid;     
			//throw new pubpack.EAException(fileurl);         
			var folds = (new java.io.File(fileurl)).listFiles();
			if ( folds != null ) {
				folds=pub.EAFunc.sort(folds);
				var c = folds.length();
				for(var i=0;i<c;i++) {
					var f=folds[i];
					if(!f.isDirectory() ) {
						var filename = f.getName();
		            			var index = filename.indexOf(".xml");	
						if ( index >=0  ) {
							var row= ds.AddRow(ds.getRowCount()-1);
							num++;
							ds.setValueAt(row,"SEQID",num);
							ds.setValueAt(row,"FILENAME",filename);
							ds.setValueAt(row,"NOTE","������"+filename);
							ds.setValueAt(row,"SYTID",selsytid );
							ds.setValueAt(row,"ACTION","�޸�������" );
							ds.setValueAt(row,"ACTION1","ɾ��������" );
							
	
	
							
						}	
					}
				}
			}
		}
	}
        return ds.GetXml();
}

// sub ��׺
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
							ds.setValueAt(row,"NOTE","ҵ������ͼ"+filename);
							ds.setValueAt(row,"SYTID",selsytid );
							
							if(sub=="flow")	ds.setValueAt(row,"ACTION","�޸�����ͼ" );
							else ds.setValueAt(row,"ACTION","�޸�DBͼ" );
							ds.setValueAt(row,"ACTION1","ɾ��ͼ" );
							
	
	
							
						}	
					}
				}
			}
		}
	}
        return ds.GetXml();

}
// �õ����ݵ�������
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
							ds.setValueAt(row,"ACTION","�޸Ĺ�����" );
							ds.setValueAt(row,"ACTION1","ɾ��ͼ" );
							
	
	
							
						}	
					}
				}
			}
		}
	}
        return ds.GetXml();

}

// �õ���������Դ�б�
function GetDatflwsrc()
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var ds = xmldbpack.EAXmlDB.getFlwLnkSrcDs(selsytid);
	var ds1= new pubpack.EAXmlDS();

	//Ϊ�˵õ�����
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
			destid = id.substring(index +1);	// ����Ŀǰû�����������ݵĶ�Ӧ��ϵ����ʱ��LnkID�õ�destid
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
// �õ�������Ŀ���б�
function GetDatflwdest()
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var ds = xmldbpack.EAXmlDB.getFlwLnkDestDs(selsytid);
	return ds.GetXml();
	for ( var i=0;i<ds.getRowCount() ; i ++ ) {
		var id =ds.getStringAt(i,"LnkID");
		var name = ds.getStringAt(i,"DESC");

		xml+="<"+id + " name=\""+name+"\" id=\""+id+"\" sytflg=\""+selsytid+"\" />";

	}
	return xml;

}
}
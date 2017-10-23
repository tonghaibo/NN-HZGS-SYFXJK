function x_sytall(){var pub= new JavaPackage("com.xlsgrid.net.pub");
var pubpack= new JavaPackage("com.xlsgrid.net.pub");
var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var iopack = new JavaPackage ( "java.io" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var utilpack = new JavaPackage ( "java.util");
var basePath = pubpack.EAOption.dynaDataRoot;



function GetSytList()
{
//"<?xml version = '1.0' encoding='GBK'?>";
//        xml+="<中间件对象>";
        var xml = "";
        var sytds = xmldbpack.EASYTXmlDB.getSytDS();
        var ds = new pubpack.EAXmlDS();
        for ( var i=0;i<sytds.getRowCount();i++ ) {
        	var row = ds.AddRow(ds.getRowCount()-1 );
        	ds.setValueAt(row,"ID", sytds.getStringAt(i,"ID" ));
        	ds.setValueAt(row,"NAME", sytds.getStringAt(i,"NAME" ));
        	ds.setValueAt(row,"REFID", sytds.getStringAt(i,"INHERTEDFROM" ));
        	
        
        }
        return ds.GetXml();
        

}

}
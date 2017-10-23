function x_sytgraph(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );

// JS传入的参数（yymm）可以直接使用
function GetORGDS()
{
      var ds0 = xmldbpack.EASYTXmlDB.getSytDS();	
      var ds = new pubpack.EADS();
      ds.copyfrom(ds0);
      for ( var c=0;c<ds.getColumnCount();c++ ) {
      	var colnam= ds.getColumnName(c);
      	if ( colnam!= "ID" && colnam!="NAME" && colnam!="INHERTEDFROM" ) {
      		ds.removeColumn(c);
      		c--;
      	}
      }
      return ds.GetXml();
      
}

}
function x_orggraph(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );

// JS传入的参数（yymm）可以直接使用
function GetORGDS()
{
      var ds0 = xmldbpack.EAORGXmlDB.getOrgDs();	
      var ds = new pubpack.EADS();
      ds.copyfrom(ds0);
      for ( var c=0;c<ds.getColumnCount();c++ ) {
      	var colnam= ds.getColumnName(c);
      	if ( colnam!= "ID" && colnam!="NAME" && colnam!="REFID" ) {
      		ds.removeColumn(c);
      		c--;
      	}
      }
      /*
      for ( var r=0;r<ds.getRowCount();r++){
      	if(ds.getStringAt(r,"REFID")=="")
      		ds.setValueAt(r,"REFID","ROOT" );
      }
      var newrow = ds.AddRow(-1);
      ds.setValueAt(newrow,"ID", "ROOT");
      ds.setValueAt(newrow,"ID", "根");
      ds.setValueAt(newrow,"REFID", "");
	*/
      return ds.GetXml();
      
}

}
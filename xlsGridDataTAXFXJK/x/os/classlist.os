function x_classlist(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var langpack = new JavaPackage ( "java.lang" );

//��Ϊ.sp����ʱ�����
//Ԥ���������request,response
function Response()
{
	var classname = request.getParameter("classname");
	var cls = langpack.Class.forName(classname);
	var Methods = cls.getMethods();
	var ds = new pubpack.EAXmlDS();
	
	for ( var i=0;i<Methods.length;i++ ) {
		var methos = Methods[i];
		
      		row = ds.AddRow(ds.getRowCount()-1);
      		ds.setValueAt(row,"NAME", methos .getName() );
      		ds.setValueAt(row,"RETURN", methos.getReturnType().toString());

      	}
      	
      	return ds.GetXml();
}
}
function x_SelFlwDtl(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var utilpack = new JavaPackage("java.util");
var grd = new JavaPackage("com.xlsgrid.net.grd");
var xmldbpack = new JavaPackage("com.xlsgrid.net.xmldb");

// �ͻ���param����Ĳ�������ֱ��ʹ��
// �������ɵĵ��ݺ���
function Send()
{
	var db = null;
	var sql = "";
	var ret = "";	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		
		var ds = new pubpack.EAXmlDS(xmlstr);	// �ͻ��˿��Դ���һ��xml
		var typ = "";
		if( ds.getRowCount()==0){
			throw new pubpack.EAException("û��ѡ����Ҫת���ɵ����ݣ�");
		}
		// �����������У�MappedMode name="����ӳ���ϵ��0:(Ĭ��)��Դ���ݶ�һĿ�굥��ӳ�䣻1:һ��һӳ��"
		// OnceClose ת��һ�α�ǿ�ƹر�������
		var flwdb = xmldbpack.EAXmlDB.getFlwLnkDestDs(mysytid );
		var MappedMode = "0";
		var OnceClose = "0"; // �Ƿ�ǿ�ƹر�������
		var destBiltyp = "";
		for ( var i=0;i<flwdb.getRowCount();i++ ) {
			if ( flwdb.getStringAt(i,"LnkID" )== FLW ){
				MappedMode = flwdb.getStringAt(i,"MappedMode" );
				OnceClose =  flwdb.getStringDef(i,"OnceClose","0" );
				destBiltyp = flwdb.getStringAt(i,"DESTCLS" );
 
				break;
			}
		}
		var gen = new x_flwpub();
		var bClose = false;
		if (OnceClose =="1") bClose =true;
		
		if (MappedMode.equals("1")){	// ����ͬʱ���ɶ���Ŀ�굥�ݣ�N2M�Ƕ�Զ�
			ret = gen.GenN2M(db,FLW,acc,xmlstr,usrid,false );// ���ݵ��б�
		}
		else {
			ret = gen.GenN2NClose(db,FLW,acc,xmlstr,bClose).split(",")[1];// ���ݺ�
		}
		db.Commit();
		return destBiltyp+","+ret;
	}
	catch ( ee ) {
		db.Rollback();
		throw new Exception ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
}

}
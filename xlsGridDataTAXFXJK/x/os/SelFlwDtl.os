function x_SelFlwDtl(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var utilpack = new JavaPackage("java.util");
var grd = new JavaPackage("com.xlsgrid.net.grd");
var xmldbpack = new JavaPackage("com.xlsgrid.net.xmldb");

// 客户端param传入的参数可以直接使用
// 返回生成的单据号码
function Send()
{
	var db = null;
	var sql = "";
	var ret = "";	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		
		var ds = new pubpack.EAXmlDS(xmlstr);	// 客户端可以传入一个xml
		var typ = "";
		if( ds.getRowCount()==0){
			throw new pubpack.EAException("没有选择需要转生成的数据！");
		}
		// 数据流定义中：MappedMode name="单据映射关系。0:(默认)多源单据对一目标单据映射；1:一对一映射"
		// OnceClose 转换一次便强制关闭数据流
		var flwdb = xmldbpack.EAXmlDB.getFlwLnkDestDs(mysytid );
		var MappedMode = "0";
		var OnceClose = "0"; // 是否强制关闭数据流
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
		
		if (MappedMode.equals("1")){	// 可能同时生成多张目标单据，N2M是多对多
			ret = gen.GenN2M(db,FLW,acc,xmlstr,usrid,false );// 单据的列表
		}
		else {
			ret = gen.GenN2NClose(db,FLW,acc,xmlstr,bClose).split(",")[1];// 单据号
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
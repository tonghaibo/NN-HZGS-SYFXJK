function TAXFXJK_FXZT_InitFP(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var servletPack = new JavaPackage("com.xlsgrid.net.servlet");

//���ɷ�������
//���ݷ����������м��������ԴMAIN������
function genData()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "";
		var mwsql = new servletPack.MWSQL();
		var ds = new pub.EAXmlDS(xmlstr);
		for (var i=0;i<ds.getRowCount();i++) {
			var flag = ds.getStringAt(i,"FLAG");
			var fxbh = ds.getStringAt(i,"FLBH");
			if (fxbh != "" && flag == "1") {
				var mwid = "FX" + fxbh; //�м���ı��
				var dssql = "";
				try { dssql = mwsql.GetQuerySQL(request,db,"TAXFXJK",mwid,"MAIN"); } catch (e1) { }
				if (dssql != "" && dssql != null) {
					var table_name = "TAX_FXJK_TEMP_" + fxbh;
					sql = "drop table " + table_name;
					try { db.ExcecutSQL(sql); } catch (e2) { }
					
					//�滻sql�Ĳ�ѯ����
					dssql = pub.EAFunc.Replace(dssql,"[%ZGSWJG]",zgswjg);
					dssql = pub.EAFunc.Replace(dssql,"[%ZWBFB]",zwbfb);
					dssql = pub.EAFunc.Replace(dssql,"[%DAT1]",dat1);
					dssql = pub.EAFunc.Replace(dssql,"[%DAT2]",dat2);
					dssql = pub.EAFunc.Replace(dssql,"[%MAXJE]",maxje);
					dssql = pub.EAFunc.Replace(dssql,"[%YYYY]",yyyy);
					dssql = pub.EAFunc.Replace(dssql,"[%HY]",hy_dm);
					
					sql = "create table " + table_name + " as select * from ( \n"+dssql+" \n)";
					db.ExcecutSQL(sql);
					
				}
			}
		}
		
		db.Commit();
		return "���ɷ������ݳɹ���";
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}


}
function x_DIM_DEFINE(){var pub = new JavaPackage ( "com.xlsgrid.net.pub" );

// �ͻ���param����Ĳ�������ֱ��ʹ��

function save()
{
	var db = null;
	var msg= "";
	var sql = "";
	var sql_1 = "";
	try {
		db = new pub.EADatabase();
		//����ά�ȱ�	
		var ds = new pub.EAXmlDS(dimxml);
		sql = "delete from dim_dim where  refmod='%s'".format([modguid]);
		db.ExcecutSQL(sql);
		for ( var row=0;row<ds.getRowCount();row ++ ) {
			var id = ds.getStringAt(row,"COL0");
			var name = ds.getStringAt(row,"COL1");
			var datatyp = ds.getStringAt(row,"COL2");
			var control = ds.getStringAt(row,"COL3");
			var keyval = ds.getStringAt(row,"COL4");
			var defval = ds.getStringAt(row,"COL5");
			var wher = pub.EAFunc.Replace(ds.getStringAt(row,"COL6"),"'","''");
			var seq = ds.getStringAt(row,"COL7");
			sql_1= "select count(1) from dim_dim where id = '"+id+"' and refmod = '"+modguid+"'";
			sql = "insert into dim_dim(id,name,datatyp,refmod,control,keyval,defval,wher,seq) values('%s','%s','%s','%s','%s','%s','%s','%s','%s')".format([id,name,datatyp,modguid,control,keyval,defval,wher,seq]);
			if (id != null && id != "") 
			{
				var count = 1.0 * db.GetSQL(sql_1);
				if(count == 0)
					db.ExcecutSQL(sql);
			}
		}	
		//����Ŀ���	
		var ds = new pub.EAXmlDS(tarxml);
		sql = "delete from dim_target where  refmod='%s'".format([modguid]);
		db.ExcecutSQL(sql);
		for ( var row=0;row<ds.getRowCount();row ++ ) {
			var id = ds.getStringAt(row,"COL0");
			var name = ds.getStringAt(row,"COL1");
			sql_1 = "select count(1) from dim_target where id = '"+id+"' and refmod = '"+modguid+"'";
			sql = "insert into dim_target(id,name,refmod) values('%s','%s','%s')".format([id,name,modguid]);
			if (id != null && id != "") 
			{
				var count = 1.0 * db.GetSQL(sql_1);
				if(count == 0)
					db.ExcecutSQL(sql);	
			}	
		}
		db.Commit();
		return "�ɹ�";
	}
	catch ( ee ) {
		db.Rollback();
		throw new pub.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
}

//ɾ�����ʱ��һ����ά�Ⱥ�Ŀ��ɾ����
function delete()
{
	var db = null;
	var sql = "";
	try
	{
		db = new pub.EADatabase();
		sql = "delete from dim_dim where refmod = '"+formguid+"'";
		db.ExcecutSQL(sql);
		sql = "delete from dim_target where refmod = '"+formguid+"'";
		db.ExcecutSQL(sql);
		
		db.Commit();
	}
	catch(e)
	{
		db.Rollback();
		throw new Exception(e);
	}
	finally
	{
		if(db != null)
			db.Close();
	}
}

}
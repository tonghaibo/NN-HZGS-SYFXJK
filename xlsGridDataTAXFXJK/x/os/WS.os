function x_WS(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// �ͻ���param����Ĳ�������ֱ��ʹ��
function save()
{
	var db = null;
	var msg= "�����ɹ�";
	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		db.ExcecutSQL("delete from wsretdtl where formguid='" + FORMGUID+"' " );
		
		var ds = new pubpack.EAXmlDS(xmlstr);	// �ͻ��˿��Դ���һ��xml
		for ( var row=0;row<ds.getRowCount();row ++ ) {
			if (ds.getStringAt(row,"ID")=="")break; 
			var sql = "insert into wsretdtl ( formguid,seqid,id,name,note,coltyp,collen,notnull ) " + 
				" values ('"+FORMGUID+"','"+(row+1)+"','"+ds.getStringAt(row,"ID")+"','"+ds.getStringAt(row,"NAME")+"','"+ds.getStringAt(row,"NOTE")+"','"+ds.getStringAt(row,"COLTYP")+"','"+ds.getStringAt(row,"COLLEN")+"','"+ds.getStringAt(row,"NOTNULL")+"')";
			db.ExcecutSQL(sql );
		}
		db.Commit();	
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}
// �ͻ���param����Ĳ�������ֱ��ʹ��
// ������[%G_SYTID]','[%GRDID].[%FUNCID]','[%NAME]','[%] NOTE 
function AddSYSMOD()
{
	var sql = "select * from sysmod where syt='"+G_SYTID+"' and id='"+GRDID+"."+FUNCID+"' ";
	

	var inssql = "insert into sysmod ( syt,id,name,note,action,modtyp,grdid) "+
		" values( '"+G_SYTID+"','"+GRDID+"."+FUNCID+"','"+NAME+"','"+NOTE+"','"+FUNCID+"','3','"+GRDID+"') " ;
	
	var db = null;
	var msg= "�����ɹ�";
	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		
		var ds = db.QuerySQL(sql);
		
		if (ds.getRowCount()>0 ) throw new pubpack.EAException("��Ȩ���Ѿ���ӹ��ˣ�������ӣ�" );
		db.ExcecutSQL(inssql);
		
		
		db.Commit();	
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
	
}


var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
//��Ϊ.sp����ʱ�����
//Ԥ���������request,response
function Response()
{
      var code = request.getParameter("CODE");
      var db = null;
      var ret= "100";
      try {
            db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
                  }
      catch ( ee ) {
            db.Rollback();
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      return ret ;
}

}
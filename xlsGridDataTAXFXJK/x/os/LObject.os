function x_LObject(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var pub= new JavaPackage("com.xlsgrid.net.pub");


// �ͻ���param����Ĳ�������ֱ��ʹ��
function SaveAS()
{
	var db = null;
	var guid = "";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		guid = db.GetSQL("select sys_guid() guid from dual");
		var ds = db.QuerySQL("select COLUMN_NAME from user_tab_columns where table_name='LAYOBJ'");
		var cols="";
		for ( var i=0;i<ds.getRowCount();i++){
			var colname= ds.getStringAt(i,"COLUMN_NAME");
			if(colname!="GUID"&& colname!="ID"){
				cols+=","+colname;	
			}
		}
		var sql ="insert into LAYOBJ(guid,id"+cols+") select '"+guid+"','"+id+"'"+cols+" from LAYOBJ where id='"+oldid+"' and deforg='"+deforg+"'";
		
		var retnum=db.ExcecutSQL(sql);
		
		db.Commit();	
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	
	return guid ;
}

//д��xml
function WriteXml(){
	var db = null;
	var path="";
	var bo = "д��ɹ�";
	try{
	db = new pubpack.EADatabase();
	var ds = db.QuerySQL("select guid,crtdat,dat,id,name,cls,ossyt,osmwid,osfunc,osparam,note,previews from LHTML
");	
	path = "//u//xlsGridDataXLSGRID//" + "html.xml";
	if(ds.getRowCount() != null){
		pub.EAFunc.WriteToFile(path,ds.GetXml());
	}
	var ds1 = db.QuerySQL("select guid,id,name,memo,seqid,formguid from lhtmldtl");	
	var path1 = "//u//xlsGridDataXLSGRID//" + "htmldtl.xml";
	if(ds1.getRowCount() != null){
		pub.EAFunc.WriteToFile(path1,ds1.GetXml());
	}
	
	
	
	}catch ( ee ) {
		bo = "д��ʧ��";
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	
	return bo;
}





//ɾ����
function DelTable(sql){
	var db = null;	
	try{
	db = new pubpack.EADatabase();
	
	var retnum=db.ExcecutSQL(sql);
	db.Commit();

	}catch ( ee ) {

		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
}


//ɾ����
function  CreateTable(ustab,drotab,sql){
	var bo = "�ɹ�";
	var db = null;
	try{
	db = new pubpack.EADatabase();
	var ds = db.QuerySQL(ustab);

	if(ds.getValueAt(0,0) > 0){
		db.ExcecutSQL(drotab);
		db.Commit();
	}
	//������
	CreateLHMTL(sql);
	db.Commit();
	}catch ( ee ) {
		bo = "ʧ��";
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();	
	}
	return bo;
}

//������
function CreateLHMTL(sql){
	var bo ="�ɹ�";
	var db = null;
	try{
	db = new pubpack.EADatabase();

	db.ExcecutSQL(sql);
	db.Commit();
	}catch ( ee ) {
		bo = "ʧ��";
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();	
	}
	return bo;

}



}
function TAXMON_TK_SP2(){var pub = new JavaPackage("com.xlsgrid.net.pub");
function updateFlag()
{
	var db = null;
	var sql = "";
	var ret = 0;
	try {
		db = new pub.EADatabase();
		sql = "insert into tax_notinammno(ammno,crtusr) values('"+ammno+"','"+thisusrid+"')";
		ret += db.ExcecutSQL(sql);
		db.Commit();
		return "�������! �ѱ�־����Ϊ�ǹ�˰�ܻ�"+ret;
	}
	catch(e) {
		if (db != null) db.Rollback();
		return "����ʧ��"+e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

function updateFlag2()
{
	var db = null;
	var sql = "";
	var ret = 0;
	try {
		db = new pub.EADatabase();
		sql = "delete from tax_notinammno where ammno='"+ammno+"'";
		ret += db.ExcecutSQL(sql);

		db.Commit();
		return "�����˻�! �ѱ�־����Ϊ��˰�ܻ�"+ret;
	}
	catch(e) {
		if (db != null) db.Rollback();
		return "����ʧ��"+e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}



function updateFlag3()
{
	var db = null;
	var sql = "";
	var ret = 0;
	try {
		db = new pub.EADatabase();
		sql = "insert into TAX_NOTAXCOM(cmid,crtusr) values('"+ammno+"','"+thisusrid+"')";
		ret += db.ExcecutSQL(sql);
		
		db.Commit();
		return "�������! �ѱ�־��ҵΪ�ǹ�ҵ��˰��ҵ"+ret;
	}
	catch(e) {
		if (db != null) db.Rollback();
		return "����ʧ��"+e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

function updateFlag4()
{
	var db = null;
	var sql = "";
	var ret = 0;
	try {
		db = new pub.EADatabase();
		sql = "delete from TAX_NOTAXCOM where cmid='"+ammno+"'";
		ret += db.ExcecutSQL(sql);
	
		db.Commit();
		return "�����˻�! �ѱ�־��ҵΪ��ҵ��˰��ҵ"+ret;
	}
	catch(e) {
		if (db != null) db.Rollback();
		return "����ʧ��"+e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}
}
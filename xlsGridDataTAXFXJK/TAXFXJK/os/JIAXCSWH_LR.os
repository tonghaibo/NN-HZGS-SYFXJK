function TAXFXJK_JIAXCSWH_LR(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//�޸�
function UpdateXg()
{
	var db = null;
	var ds = null;
	var sql = "";
	try{
		db = new pub.EADatabase();
		sql = "update TAX_JIAXSFCSB set sfcsdm='"+sfcsdm+"',diqlx='"+diqlx+"',jiazlx='"+jiazlx+"',lingqlx='"+lingqlx+"',baomf='"+baomf+"',
		yxqq=to_date('"+yxqq+"','yyyy-mm-dd'),yxqz=to_date('"+yxqz+"','yyyy-mm-dd') where jiaxsfcsuuid='"+guid+"' ";
		var updcount=db.ExcecutSQL(sql);
		var ret = "����"+updcount +"����¼";
		return ret;	
        }
	catch(e) {
		if(db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if(db != null)	db.Close();
	}

}

//����
function AddXz()
{
	var db = null;
	var ds = null;
	var sql = "";
	try{
		db = new pub.EADatabase();
		sql = "insert into TAX_JIAXSFCSB(sfcsdm,diqlx,jiazlx,lingqlx,baomf,yxqq,yxqz)
		 values ('"+sfcsdm+"','"+diqlx+"','"+jiazlx+"','"+lingqlx+"','"+baomf+"',to_date('"+yxqq+"','yyyy-mm-dd'),to_date('"+yxqz+"','yyyy-mm-dd')) ";
		var addcount=db.ExcecutSQL(sql);
		var ret = "����"+addcount +"����¼";
		return ret;	
        }
	catch(e) {
		if(db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if(db != null)	db.Close();
	}
}



}
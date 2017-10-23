function TAXFXJK_JIAXCSWH_LR(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//修改
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
		var ret = "更新"+updcount +"条记录";
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

//新增
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
		var ret = "新增"+addcount +"条记录";
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
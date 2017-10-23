function TAXFXJK_FDCCSWHB_LR(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//修改
function UpdateXg()
{
	var db = null;
	var ds = null;
	var sql = "";
	try{
		db = new pub.EADatabase();
		sql = "update TAX_FDCKFQYMC_NSRSBH_DZB set fdckfqymc='"+fdckfqymc+"',nsrsbh='"+nsrsbh+"',nsrmc='"+nsrmc
			+"',zzjj='"+zzjj+"',zzqhl='"+zzqhl+"',spjj='"+spjj+"',spqhl='"+spqhl+"',qsrq='"+qsrq+"',
			jzrq='"+jzrq+"' where FDCDZUUID='"+guid+"' ";
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
		sql = "insert into TAX_FDCKFQYMC_NSRSBH_DZB(fdckfqymc,nsrsbh,nsrmc,zzjj,zzqhl,spjj,spqhl,qsrq,jzrq)
		 values ('"+fdckfqymc+"','"+nsrsbh+"','"+nsrmc+"','"+zzjj+"','"+zzqhl+"','"+spjj+"','"+spqhl+"','"+qsrq+"','"+jzrq+"') ";
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
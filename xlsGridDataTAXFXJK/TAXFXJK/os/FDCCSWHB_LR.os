function TAXFXJK_FDCCSWHB_LR(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//�޸�
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
		sql = "insert into TAX_FDCKFQYMC_NSRSBH_DZB(fdckfqymc,nsrsbh,nsrmc,zzjj,zzqhl,spjj,spqhl,qsrq,jzrq)
		 values ('"+fdckfqymc+"','"+nsrsbh+"','"+nsrmc+"','"+zzjj+"','"+zzqhl+"','"+spjj+"','"+spqhl+"','"+qsrq+"','"+jzrq+"') ";
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
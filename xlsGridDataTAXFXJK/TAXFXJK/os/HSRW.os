function TAXFXJK_HSRW(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//���ݱ����
function fos_aftersave(eaContext)
//var eaContext=new pub.EAContext();
{
	var db = eaContext.getEADatabase();
	var guid = eaContext.getGuid();
	var sql = "select stat from tax_trkhdr where guid='"+guid+"'";
	var stat = db.GetSQL(sql);
	if (stat == 2) {
		sql = "update tax_trkhdr set stat=3 where guid='"+guid+"'";
		db.ExcecutSQL(sql);
	}
}


//���ɶ��κ�ʵ����
function genTrk2()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "select * from tax_trkhdr where guid='"+trkguid+"'";
		var trkds = db.QuerySQL(sql);
		var bilid =db.GetBillid(accids,"TK","TK");
		var hsje = 1.0*trkds.getStringAt(0,"CYJE");
		var pch = trkds.getStringAt(0,"PCH");
		var nsrsbh = trkds.getStringAt(0,"CMID");
		
		//����������
		sql = "select * from tax_trk_js2b where pch='"+pch+"' and nsrsbh='"+nsrsbh+"'";
		var ds = db.QuerySQL(sql);
		var cbskje = 1.0*ds.getStringAt(0,"CBSK_XJ"); //�鲹˰��С��
		var cyje2 = hsje - cbskje*0.17;
		
		var note = "���κ�ʵ����\n�ϴκ�ʵ��" + hsje + "��"+ "�ϴ�׷����" + cbskje + "\n"
			+ "���κ�ʵ��" + cyje2 + "";
		sql = "insert into tax_trkhdr(bilid,dat,crtusr,crtusrnam,stat,acc,org,syt,cmid,cmnam,note,yymm1,yymm2,subtyp,typ,swjg_dm,fxdj,cyje)
			select '"+bilid+"' bilid,trunc(sysdate) dat,'"+usrid+"' crtusr,'"+usrnam+"' crtusrnam,'1' stat,acc,org,syt,cmid,cmnam,
				'"+note+"' note,yymm1,yymm2,subtyp,typ,swjg_dm,fxdj,'"+cyje2+"' cyje
			from tax_trkhdr 
			where guid='"+trkguid+"'";
		db.ExcecutSQL(sql);
		
		//�Զ�������������
		sql = "update tax_trkhdr set stat='9' where guid='"+trkguid+"'";
		db.ExcecutSQL(sql);

		db.Commit();
		return "���ɶ��κ�ʵ����ɹ���";
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
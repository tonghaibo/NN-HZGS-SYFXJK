function TAXFXJK_FangDCData(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );

//��У���ݵ���
function importTree()
{
	var db = null;
	var ds = null;
	var sql = "";
	var tabname = tabnam;
	//var typ = typ;
	var ret = "";
	var updcount = 0;
	var inscount = 0;
	try{
		db = new pubpack.EADatabase();
		
		sql = "select * from user_tables where table_name=upper('"+tabname+"')";
		var cnt = db.GetSQLRowCount(sql);
		if(cnt <= 0) return "�����ݿ��Ե���";
		
		var mycnt = 0;
		
		//ɾ������
		sql="delete from "+tabname+"  where co0 like '%������ҵ%'  ";
		db.ExcecutSQL(sql);	
		
		//�޸ı������������洢���������·�
		//sql = "alter table "+tabname+" add sjssyf varchar2(60)";		
		//mycnt = db.ExcecutSQL(sql);	
		
              

		//��������--�������ݵ���
		
	sql = " insert into TAX_FANGDCDATA (FDCKFQYMC,YSZPZSJ,XSLHMC,ZTS,ZMJ,ZZNXSJJ,KSTS,PZTS,YSMJ,YSZZMJ,YSSYMJ,YSCKMJ,YSQTMJ)
   		select co0,co1,co2,to_number(co3),to_number(co4),to_number(co5),to_number(co6),to_number(co7),to_number(co8),to_number(co9),to_number(co10),to_number(co11),to_number(co12) 
		from "+tabname+" 
		where not exists (
			select  FDCKFQYMC,YSZPZSJ,XSLHMC,ZTS,ZMJ,ZZNXSJJ,KSTS,PZTS,YSMJ,YSZZMJ,YSSYMJ,YSCKMJ,YSQTMJ,a.SJSSYF
			from TAX_FANGDCDATA  a ,"+tabname+"  t
   			where a.FDCKFQYMC=t.co0 and a.YSZPZSJ=t.co1 and a.XSLHMC=t.co2 and a.ZTS=to_number(t.co3) and 
         			a.ZMJ=to_number(t.co4) and a.ZZNXSJJ=to_number(t.co5) and a.KSTS=to_number(t.co6) and a.PZTS=to_number(co7) and
         			a.YSMJ=to_number(t.co8) and a.YSZZMJ=to_number(t.co9) and a.YSSYMJ=to_number(t.co10) and a.YSCKMJ=to_number(t.co11)
         		and a.YSQTMJ=to_number(t.co12) 
        ) ";			
		inscount = db.ExcecutSQL(sql);	
							
		ret = "������ɣ�������"+inscount+"����¼������"+updcount +"����¼";
		
		//ɾ����ʱ��
		sql = "drop table "+tabname;
		db.ExcecutSQL(sql);			

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
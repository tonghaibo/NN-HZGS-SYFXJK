function TAXFXJK_JiaXData(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
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
		
		//�޸ı������������洢���������·�
		sql = "alter table "+tabname+" add sjssyf varchar2(60)";		
		mycnt = db.ExcecutSQL(sql);	
		//if(mycnt == 0) {
		//	db.Rollback();
		//	return "����ʧ�ܣ�������ļ���ʽ����ȷ"+tabname;
		//}
		
		//�������ݵ�������	
		sql = "update "+tabname+"  set sjssyf=(select (case when yf<=9 then concat(nd,concat(0,yf)) else concat(nd,yf) end) sjssyf
                from( select substr(substr(trim(ny),instr(trim(ny),'2')),1,4)nd,substr(ny,instr(ny,'��')+1, instr(ny,'��')-instr(ny,'��')-1)yf 
                    from (select co0,substr(trim(co0),instr(trim(co0),'2')) ny from "+tabname+"  where rownum=1) ))";
		db.ExcecutSQL(sql);
		
		//ɾ������������
               sql="delete from "+tabname+" where (co0 like '%ÿ���������ѵ��У��ʻ���±���%' or co0 like '%��У����%' or co0 like '%�ϼ�%'or co0 is null)";
               db.ExcecutSQL(sql); 
                                             

		//��������--�������ݵ�����У�������ݱ�TAX_JIAXDATA������ת���ٲ�������	
		//JIAXGUID ��У����UUID ; DIQLX �������ͣ����ء����ڡ����� ;JIAZLX	 �������ͣ�A1��A2��A3��B1��B2��C1��C2��C5	;
            //LINGQLX ��ȡ���ͣ����졢����;SHOULRS ��������;SJDRRQ ���ݵ�������;SJSSYF ���������·�;JIAXMC ��У����;SFCSDM �շѲ�������

		sql = " insert into TAX_JIAXDATA (JIAXMC,sfcsdm,diqlx,jiazlx,lingqlx,shoulrs,sjssyf)
with tmp_hzl_jx as(
select co0,sfcsdm,diqlx,jiazlx,lingqlx,to_number(shoulrs)shoulrs,sjssyf from 
( 
select co0,'01' sfcsdm,'����' diqlx ,'A1'jiazlx,'����'lingqlx, co1 as shoulrs ,sjssyf  from  "+tabname+"  union all
select co0,'02' sfcsdm,'����' diqlx ,'A1'jiazlx,'����'lingqlx, co2 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'03' sfcsdm,'����' diqlx ,'A2'jiazlx,'����'lingqlx, co3 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'04' sfcsdm,'����' diqlx ,'A2'jiazlx,'����'lingqlx, co4 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'05' sfcsdm,'����' diqlx ,'A3'jiazlx,'����'lingqlx, co5 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'06' sfcsdm,'����' diqlx ,'A3'jiazlx,'����'lingqlx, co6 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'07' sfcsdm,'����' diqlx ,'B1'jiazlx,'����'lingqlx, co7 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'08' sfcsdm,'����' diqlx ,'B1'jiazlx,'����'lingqlx, co8 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'09' sfcsdm,'����' diqlx ,'B2'jiazlx,'����'lingqlx, co9 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'10' sfcsdm,'����' diqlx ,'B2'jiazlx,'����'lingqlx, co10 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'11' sfcsdm,'����' diqlx ,'C1'jiazlx,'����'lingqlx, co11 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'12' sfcsdm,'����' diqlx ,'C1'jiazlx,'����'lingqlx, co12 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'13' sfcsdm,'����' diqlx ,'C2'jiazlx,'����'lingqlx, co13 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'14' sfcsdm,'����' diqlx ,'C2'jiazlx,'����'lingqlx, co14 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'15' sfcsdm,'����' diqlx ,'C5'jiazlx,'����'lingqlx, co15 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'16' sfcsdm,'����' diqlx ,'C5'jiazlx,'����'lingqlx, co16 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'17' sfcsdm,'����' diqlx ,'C1'jiazlx,'����'lingqlx, co17 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'18' sfcsdm,'����' diqlx ,'C1'jiazlx,'����'lingqlx, co18 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'19' sfcsdm,'����' diqlx ,'C1'jiazlx,'����'lingqlx, co19 as shoulrs ,sjssyf from  "+tabname+"  union all
select co0,'20' sfcsdm,'����' diqlx ,'C1'jiazlx,'����'lingqlx, co20 as shoulrs ,sjssyf from  "+tabname+"  
)where (to_number(shoulrs)<>0 and shoulrs is not null) 
)select * from tmp_hzl_jx 
where not exists (
select a.JIAXMC,a.sfcsdm,a.diqlx,a.jiazlx,a.lingqlx,a.shoulrs,a.sjssyf
 from TAX_JIAXDATA a ,tmp_hzl_jx t
    where a.JIAXMC=t.co0 and a.sfcsdm=t.sfcsdm and a.diqlx=t.diqlx and a.jiazlx=t.jiazlx and a.lingqlx=t.lingqlx and a.shoulrs= t.shoulrs 
       and a.sjssyf=t.sjssyf ) ";	
			
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
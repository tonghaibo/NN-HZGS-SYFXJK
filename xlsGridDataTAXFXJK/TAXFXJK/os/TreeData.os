function TAXFXJK_TreeData(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );

//��ҵ���ݵ���
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
		
		//������м����������ɾ���ļ��е����������ݣ�ɾ��������
		sql = "delete from "+tabname+" where  co0 like '%�ر�%' or co0 like '%ľ�����������嵥%'";
		mycnt = db.ExcecutSQL(sql);	
		if(mycnt == 0) {
			db.Rollback();
			return "����ʧ�ܣ�������ļ���ʽ����ȷ"+tabname;
		}
		
		//�������ݵ�������	
		sql = "update "+tabname+" set co0=to_char(sysdate,'yyyy-mm-dd')";
		db.ExcecutSQL(sql);
		
		//���� �ɷ�֤��ȡ�ǩ֤�·�
               sql="update "+tabname+" set co3=(select distinct co3 from "+tabname+" where co3 is not null and rownum=1),
               co33=(select distinct co33 from "+tabname+" where co33 is not null and rownum=1)
               where co3 is null or co33 is null";
               db.ExcecutSQL(sql); 
                                             

		//��������--�������ݵ���ľ�����ݱ�TAX_TREE_MC������ת���ٲ�������	
		//0����	1����֤��� 2��֤���� 3�ɷ�֤��� 4����֤���� 5��������	6ľ�Ĳ��� 8������λ 9���� ��ҵ��Ʒ������룬��ҵ��Ʒ�������ƣ�33ǩ֤�·ݣ����ݵ�������
		sql = " insert into TAX_TREE_MC (YSZBH,FZYJ_DM,CFZND,YSZSX_DM,XSSX_DM,MCCD_DM,FHDW,XZ,LYCPZL_DM,LYCPZLMC,XSSL,QZYF,SJDRRQ,SJSSYF)
with tmp_hzl as(
select co1,co2,co3,co4,co5,co6,co8,co9,LYCPZL_DM,LYCPZLMC,XSSL,to_number(co33)yf,to_date(co0,'yyyy-mm-dd'),
(case when to_number(co33)<=9 then concat(concat(to_number(co3),0),to_number(co33)) else concat(to_number(co3),to_number(co33)) end)sjssyf 
from 
( 
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'01' lycpzl_dm,'ɼԭ��ľ' lycpzlmc ,   co10 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'02' lycpzl_dm,'ɼ���' lycpzlmc ,     co11 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'03' lycpzl_dm,'��ԭ��ľ' lycpzlmc ,   co12 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'04' lycpzl_dm,'�ɾ��' lycpzlmc ,     co13 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'05' lycpzl_dm,'�ɻ���Ƭ' lycpzlmc , co14 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'06' lycpzl_dm,'��ԭ��ľ' lycpzlmc ,   co15 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'07' lycpzl_dm,'�Ӿ��' lycpzlmc ,     co16 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'20' lycpzl_dm,'��ľ�¼ܼ�' lycpzlmc , co17 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'08' lycpzl_dm,'��ά��' lycpzlmc ,     co18 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'09' lycpzl_dm,'���ϰ�' lycpzlmc ,     co19 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'10' lycpzl_dm,'������' lycpzlmc ,     co20 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'21' lycpzl_dm,'����' lycpzlmc ,     co21 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'11' lycpzl_dm,'ľ�ذ�' lycpzlmc ,     co22 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'12' lycpzl_dm,'�Ҿ�����' lycpzlmc ,   co23 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'22' lycpzl_dm,'��ľ��' lycpzlmc ,     co24 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'23' lycpzl_dm,'�Ҿ߼�' lycpzlmc ,     co25 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'24' lycpzl_dm,'ʣ������' lycpzlmc , co26 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'13' lycpzl_dm,'ľƬ��' lycpzlmc ,     co27 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'25' lycpzl_dm,'ʣ��������' lycpzlmc , co28 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'14' lycpzl_dm,'ʣ�����' lycpzlmc ,   co29 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'26' lycpzl_dm,'���' lycpzlmc ,       co30 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'27' lycpzl_dm,'���' lycpzlmc ,       co31 as xssl from  "+tabname+"  union all
select co1,co2,co3,co4,co5,co6,co8,co9,co33,co0,'28' lycpzl_dm,'����Ʒ��' lycpzlmc , co32 as xssl from  "+tabname+"  
)where (to_number(xssl)<>0 and xssl is not null) 
)select * from tmp_hzl 
where not exists (
select a.YSZBH,a.FZYJ_DM,a.CFZND,a.YSZSX_DM,a.XSSX_DM,a.MCCD_DM,a.FHDW,a.XZ,a.LYCPZL_DM,a.LYCPZLMC,a.XSSL,a.QZYF,a.sjssyf
 from TAX_TREE_MC a ,tmp_hzl t
    where a.YSZBH=t.co1 and a.fzyj_dm=t.co2 and a.CFZND=t.co3 and a.yszsx_dm=t.co4 and a.XSSX_DM=t.co5 and a.MCCD_DM= t.co6 
       and a.FHDW=t.co8 and nvl(a.xz,'N')=nvl(t.co9,'N') and a.lycpzl_dm=t.lycpzl_dm and a.xssl=to_number(t.xssl) 
        and to_number(a.QZYF) = to_number(t.yf)and a.sjssyf=t.sjssyf)  ";	
			
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
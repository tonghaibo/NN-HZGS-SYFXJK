function TAXFXJK_StoneData(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );

//ʯ�����ݵ��루�����������ݺͼӹ���ҵ�ջ����ݣ�
function importStone()
{
	var db = null;
	var ds = null;
	var sql = "";
	var tabname = tabnam;
	var typ = typ;
	var ret = "";
	var updcount = 0;
	var inscount = 0;
	try{
		db = new pubpack.EADatabase();
		
		sql = "select * from user_tables where table_name=upper('"+tabname+"')";
		var cnt = db.GetSQLRowCount(sql);
		if(cnt <= 0) return "�����ݿ��Ե���";
		
		//������˰�˵Ǽ������
		sql = "alter table "+tabname+" add djxh varchar2(30)";
		db.ExcecutSQL(sql);
		
		//��˰��ʶ���Ҳ�п��ܱ���ˣ�������ʯ��ϵͳ��û�и��� �����
		

		var mycnt = 0;
		
		if (typ == 1) {
		
			//ȡ�õ������ݵ�����
			sql = "select substr(co0,6,7) yymm from "+tabname+" where co0 like '%��ѯ����%'";
			var yymm = db.GetSQL(sql);	
			
			//������м����������ɾ���ļ��е�����������
			sql = "delete from "+tabname+" where co0 like '%��������±���%' or co0 is null or co1 is null or co0 = '��˰��ʶ���' or co2 is null";
			mycnt = db.ExcecutSQL(sql);		
			if(mycnt == 0) {
				db.Rollback();
				return "����ʧ�ܣ�������ļ���ʽ����ȷ"+tabname;
			}
			
			sql = "update "+tabname+" tmp set djxh=(select djxh from TAX_STONE_DZB dzb where (tmp.co0=dzb.nsrsbh or tmp.co1=dzb.qymc) and rownum=1)";
			db.ExcecutSQL(sql);

			//�ȸ��� �����
			//������������ļ���ʽ
			//0���� 1��˰��ʶ��� 2������ҵ���� 3��Ӧ��ҵ 4���� 5�������� 6�ջ���ҵ 7�����ϼ�(��) 8��ʯ(��) 9����(��) 10���(��) 11��ʯ�����ࣩ 12����(��) 13���з���(��) 14�����ô���ʯ 15������ɰ
			//0��˰��ʶ��� 1������ҵ���� 2��Ӧ��ҵ 3���� 4�������� 5�ջ���ҵ 6�����ϼ�(��) 7��ʯ(��) 8����(��) 9���(��) 10��ʯ�����ࣩ 11����(��) 12���з���(��) 13�����ô���ʯ 14������ɰ
			sql = "update tax_stonedata a set (NSRMC,DYQYMC,CS,KHKZ,QYS,ZLHJ,SS,HL,BC,SS2L,TK,FXFL,JZYDLS,JZYS) =(
					select co1,co2,co3,co4,co5,co6,co7,co8,co9,co10,co11,co12,co13,co14
					from "+tabname+" b 
					where a.YYMM='"+yymm+"' and a.nsrsbh = b.co0 and rownum=1) 
				where a.YYMM='"+yymm+"' and a.crbz='1' and a.nsrsbh in (select co0 from "+tabname+")";	
			updcount = db.ExcecutSQL(sql);
			
			sql = "insert into tax_stonedata(CRBZ,YYMM,NSRSBH,NSRMC,DYQYMC,CS,KHKZ,QYS,ZLHJ,SS,HL,BC,SS2L,TK,FXFL,JZYDLS,JZYS,DJXH)
			       select '1' crbz,'"+yymm+"' yymm,co0,co1,co2,co3,co4,co5,co6,co7,co8,co9,co10,co11,co12,co13,co14,djxh 
			       from "+tabname+" a 
			       where not exists (select 1 from tax_stonedata b where b.yymm='"+yymm+"' and b.nsrsbh=a.co0 and b.crbz='1') ";					
			inscount = db.ExcecutSQL(sql);
		
		}
		//�ջ��ӹ���ҵ����
		else if (typ == 2) {
			//������˰�˵Ǽ������
			sql = "alter table "+tabname+" add nsrsbh varchar2(30)";
			db.ExcecutSQL(sql);
			
			//����sbh,djxh
			sql = "update "+tabname+" tmp set (djxh,nsrsbh)=(select djxh,nsrsbh from TAX_STONE_DZB dzb where tmp.co1=dzb.qymc and rownum=1)";
			db.ExcecutSQL(sql);
		
			//ȡ�õ������ݵ�����
			sql = "select substr(co0,6,7) yymm from "+tabname+" where co0 like '%��ѯ����%'";
			var yymm = db.GetSQL(sql);
			sql = "update "+tabname+" set co0='"+yymm+"'";
			db.ExcecutSQL(sql);
			
			//������м����������ɾ���ļ��е�����������
			//sql = "delete from "+tabname+" where co1 is null or co1 like '��˰��ʶ���%'";
			sql = "delete from "+tabname+" where co1 is null or co1 like '%�ջ���λ%' or co0='��ҵ�ջ��±���' or co0='�ջ��·�' or co0 like '%��ѯ����%'";
			mycnt = db.ExcecutSQL(sql);			
			if(mycnt == 0) {
				db.Rollback();
				return "����ʧ�ܣ�������ļ���ʽ����ȷ"+tabname+",mycnt="+mycnt ;
			}
			
			
			//�ȸ��� �����
			//�ӹ���ҵ�����ļ���ʽ
			//0���� 1��˰��ʶ��� 2�ջ���λ	3�ջ����� 4������ҵ 5���� 6�ջ��ϼ�(��) 7��ʯ(��) 8����(��) 9���(��) 10��ʯ�����ࣩ(��) 11���� 12���з���(��)	
			//0�ջ��·� 1�ջ���λ 2�ջ����� 3������ҵ 4���� 5�ջ��ϼ�(��) 6��ʯ(��)	7����(��) 8���(��) 9��ʯ�����ࣩ(��)10���� 11���з���(��)	

			sql = "update tax_stonedata a set (CS,QYS,KHKZ,ZLHJ,SS,HL,BC,SS2L,TK,FXFL) =(
					select co2,co3,co4,co5,co6,co7,co8,co9,co10,co11
					from "+tabname+" b 
					where a.YYMM = b.co0 and a.nsrmc=b.co1) 
				where crbz='2' and (yymm,nsrmc) in (select co0,co1 from "+tabname+")";	
			updcount = db.ExcecutSQL(sql);
			
			sql = "insert into tax_stonedata(CRBZ,YYMM,NSRSBH,NSRMC,CS,QYS,KHKZ,ZLHJ,SS,HL,BC,SS2L,TK,FXFL,DJXH)
			       select '2' crbz,nvl(co0,' ') co0,nsrsbh,co1,co2,co3,co4,co5,co6,co7,co8,co9,co10,co11,djxh 
			       from "+tabname+" a 
			       where not exists (select 1 from tax_stonedata b where b.yymm=a.co0 and b.nsrmc=a.co1 and b.crbz='2') ";					
			inscount = db.ExcecutSQL(sql);
		
		}
		
		//�Զ�ƥ��д����ձ�
		sql = "insert into tax_stone_dzb(nsrsbh,qymc,djxh)
			select * from (
			select distinct a.nsrsbh,a.nsrmc,dj.djxh 
			from tax_stonedata a,dj_nsrxx dj
			where a.nsrsbh=dj.nsrsbh
			and a.djxh is null
			and a.nsrsbh not in (select nsrsbh from tax_stone_dzb)
			)";
		db.ExcecutSQL(sql);
		
		sql = "insert into tax_stone_dzb(nsrsbh,qymc,djxh)
			select * from (
			select distinct dj.nsrsbh,a.nsrmc,dj.djxh 
			from tax_stonedata a,dj_nsrxx dj
			where a.nsrmc=dj.nsrmc
			and a.djxh is null
			and a.nsrmc not in (select qymc from tax_stone_dzb)
			)";
		db.ExcecutSQL(sql);
		
		//����ʯ�����ݱ�����
		sql = "update tax_stonedata a set (nsrsbh,djxh)=(select nsrsbh,djxh from TAX_STONE_DZB b where a.nsrmc=b.qymc and rownum=1)
			where exists (select 1 from TAX_STONE_DZB dzb where a.nsrmc=dzb.qymc)";
		db.ExcecutSQL(sql);

		
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
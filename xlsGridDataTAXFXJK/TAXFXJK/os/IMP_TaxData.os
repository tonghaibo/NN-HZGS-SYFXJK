function TAXFXJK_IMP_TaxData(){var pub = new JavaPackage("com.xlsgrid.net.pub");

/***************************************************************************************
//DBLINK�Ĵ������
--��˰���ڲ�ѯ��
create database link JS3Q
  connect to hzcx identified by "hzgs#1234"
  using '(DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 87.12.74.12)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = gxsthxcx)
    )
  )';
  
--ctais��ѯ��
create database link CTAIS
  connect to hzcx identified by "hzgs#1234"
  using '(DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 87.16.16.4)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = ctais)
    )
  )';    
  
--���ӵ��˲�ѯ
create database link DZDZ
  connect to dzdzcx_hz identified by "dzdz#hz69"
  using '(DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 87.16.19.34)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dzdz)
    )
  )';  

--���ݲֿ�
create database link GXDW
  connect to hzgs identified by "hzgs6286"
  using '(DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 87.16.17.161)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SID = gxdw)
    )
  )'; 
*/
///////////////////////////////////////////////////////////////////////////////////////////////////////
  

//�����־Ϊͬ���ı���Ϣ
function Save()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		
		var ds = new pub.EAXmlDS(xmlstr);
		for (var i=0;i<ds.getRowCount();i++) {
			var guid = ds.getStringAt(i,"GUID");
			var tbbz = ds.getStringAt(i,"TBBZ");
			var sql = "update tax_jssjtbb set tbbz='"+tbbz+"' where guid='"+guid+"'";
			db.ExcecutSQL(sql);
		}
		
		db.Commit();
		return "����ɹ������¼�¼��"+ds.getRowCount();
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

//ɾ������Ϣ
function Delete()
{	
	
	var db = null;
	try {
		db = new pub.EADatabase();
		
		var ds = new pub.EAXmlDS(xmlstr);
		for (var i=0;i<ds.getRowCount();i++) {
			var guid = ds.getStringAt(i,"GUID");
			var sql = "delete from tax_jssjtbb where guid='"+guid+"'";
			db.ExcecutSQL(sql);
		}
		
		db.Commit();
		return "ɾ���ɹ�����¼��"+ds.getRowCount();
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}


//ִ��ͬ����Ĳ���
function RunTB()
{
	var CJK_OWNER = "CJ_FXJK"; //���ռ��ƽ̨�ɼ����ݿ��û�
	var db = null;					
	var tb_note = "�ɹ�"; //�ɼ����˵��
				
	try {
		db = new pub.EADatabase();
		var sql = "";
		var ds = null;
		
		//������ǽ��洫��ͬ���Ĳ�������ô���Ǻ�̨����ִ�е�
		if (xmlstr == "") {
			sql = "select * from tax_jssjtbb where tbbz='1' order by tbxh,owner,table_name";
			ds = db.QuerySQL(sql);
		}
		else {
			ds = new pub.EAXmlDS(xmlstr);
		}
		for (var i=0;i<ds.getRowCount();i++) {
			tb_note = "�ɹ�"; //�ɼ����˵��
			var guid = ds.getStringAt(i,"GUID");
			var tbbz = ds.getStringAt(i,"TBBZ");
			var dblink = ds.getStringAt(i,"DBLINK");
			var owner = ds.getStringAt(i,"OWNER");
			var table_name = ds.getStringAt(i,"TABLE_NAME");
			var sourceTable = owner + "." + table_name + "@" + dblink;
			var tabds = db.QuerySQL("select * from tax_jssjtbb where guid='"+guid+"'");
			var zlbz = tabds.getStringAt(0,"ZLBZ");
			var zlwherestr = tabds.getStringAt(0,"WHERESTR");
			
			var start_time = db.GetSQL("select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') from dual"); //ͬ����ʼʱ��
			var tb_jls = 0; //ͬ����¼��
				
			if (tbbz == "1") {
				try {
					try { sql = "alter table " + CJK_OWNER + "." + table_name + " nologging";
					  db.ExcecutSQL(sql);
					} catch(e) {}
					
					//���ɼ������Ƿ��Ѿ����б�
					var chktab = checkTableExists(db,CJK_OWNER,table_name);
					//�������ڣ���ɾ����¼���ٲ���
					if (chktab == 1 && zlbz != "1") {
						sql = "drop table " + CJK_OWNER + "." + table_name;
						db.ExcecutSQL(sql);
						
						sql = "create table " + CJK_OWNER + "." + table_name + " as select * from " + sourceTable + " where 1>2";
						db.ExcecutSQL(sql);

					}				
										
					//�ӽ�˰�������ݿ�ͬ������
					if (chktab != "1") {
						sql = "create table " + CJK_OWNER + "." + table_name + " as select * from " + sourceTable + " where 1>2";
						db.ExcecutSQL(sql);
					}
					
					//ץȡ���ݵĹ���������ֻץ���ݵ����ݣ�
					var wherestr = ""; 
					var filterstr = "";
					var chktabcols = checkTableHasColumn(db,CJK_OWNER,table_name,"SJGSDQ"); //SJGSDQ���ݹ�������
					if (chktabcols == 1) {
//						chktabcols = checkTableHasColumn(db,CJK_OWNER,table_name,"DJXH"); //DJXH��˰�˵Ǽ����
//						if (chktabcols == 1) {
//							if (filterstr == "") filterstr += " ( SJGSDQ like '14511%' or djxh in (select djxh from hx_dj.dj_nsrxx@js3q where zgswj_dm like '14511%') ) ";
//							else filterstr += " or ( SJGSDQ like '14511%' or djxh in (select djxh from hx_dj.dj_nsrxx@js3q where zgswj_dm like '14511%') ) ";
//						}
//						else {
							if (filterstr == "") filterstr += " SJGSDQ like '14511%'";
							else filterstr += " or SJGSDQ like '14511%'";
//						}
					}
					chktabcols = checkTableHasColumn(db,CJK_OWNER,table_name,"ZGSWSKFJ_DM"); //ZGSWSKFJ_DM����˰�����Ʒ־�
					if (chktabcols == 1) {
						if (filterstr == "") filterstr += " ZGSWSKFJ_DM like '14511%'";
						else filterstr += " or ZGSWSKFJ_DM like '14511%'";
					}
					chktabcols = checkTableHasColumn(db,CJK_OWNER,table_name,"ZGSWJ_DM"); //ZGSWJ_DM ����˰�����
					if (chktabcols == 1) {
						if (filterstr == "") filterstr += " ZGSWJ_DM like '14511%'";
						else filterstr += " or ZGSWJ_DM like '14511%'";
					}
					
					if (filterstr != "") {
						wherestr = " and ( " + filterstr + " ) ";
					}
					////////
					
					sql = "insert into "+ CJK_OWNER + "." + table_name + " select * from " + sourceTable;
					if (wherestr != "") sql += " where 1=1 " + wherestr;
					//����ͬ��ģʽ�µ�����
					if (zlbz == "1") {
						if (wherestr != "") sql += " and ( " + zlwherestr + " )";
						else sql += " where ( " + zlwherestr + " )";

						//��ɾ����ͬ��
						var delsql = "delete from " + CJK_OWNER + "." + table_name + " where 1=1 " + wherestr + " and ("+zlwherestr+")";
						db.ExcecutSQL(delsql);

					}
					
					//throw new Exception(sql);
					tb_jls = db.ExcecutSQL(sql);
					
				} catch (e) {
					tb_note = pub.EAFunc.Replace(e.toString(),"'","''");
					pub.EAFunc.Log("�ɼ�:table_name="+table_name+" ����="+e.toString());						
				}
				finally {
					try {sql = "alter table " + CJK_OWNER + "." + table_name + " logging";
					db.ExcecutSQL(sql);
					} catch(e) {}
				}
				
				//дͬ����־
				sql = "insert into tax_jssjtb_log(guid,dblink,owner,table_name,tb_start_time,tb_end_time,tb_jls,tb_note)
				  values(sys_guid(),'%s','%s','%s',to_date('%s','yyyy-mm-dd hh24:mi:ss'),sysdate,'%s',substr('%s',0,1000))"
				  .format([dblink,owner,table_name,start_time,""+tb_jls,tb_note]);
				pub.EADbTool.ExcecutSQL(sql);
				
				//ÿͬ��һ�������һ�������ύ
				db.Commit();
				db = new pub.EADatabase();
		
			}
		}
		
		db.Commit();
		
		//��̨�����Զ�ͬ�������Ŀ�
		var hxret = "";
		if (xmlstr == "") {
			hxret = "  >>>" + RunToHXK();
		}
		if (tb_note == "�ɹ�") {
			return "���ݲɼ��ɹ������¼�¼��"+ds.getRowCount() + hxret;
		}
		return "���ݲɼ�ʧ�ܣ�"+tb_note;
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

//����û����ݿ�����Ƿ����
function checkTableExists(db,owner,table_name)
{
	try {
		var sql = "select count(*) from dba_tables where owner=upper('"+owner+"') and table_name=upper('"+table_name+"')";
		var cnt = db.GetSQL(sql);
		if (cnt > 0) return 1;
	}
	catch (e) {
		return 0;
	}
	return 0;
}

//�������Ƿ���ĳ��
function checkTableHasColumn(db,owner,table_name,col_name)
{
	try {
		var sql = "select count(*) from dba_tab_columns where owner=upper('"+owner+"') and table_name=upper('"+table_name+"') and column_name=upper('"+col_name+"')";
		var cnt = db.GetSQL(sql);
		if (cnt > 0) return 1;
	}
	catch (e) {
		return 0;
	}
	return 0;
}

//ִ��ͬ�������Ŀ�Ĳ���
function RunToHXK()
{
	var CJK_OWNER = "CJ_FXJK"; //���ռ��ƽ̨�ɼ����ݿ��û�
	var db = null;
	var tbxmlstr  = "";
	try { tbxmlstr = xmlstr; } catch (e) { }
	try {
		db = new pub.EADatabase();
		var sql = "";
		var ds = null;
		
		//������ǽ��洫��ͬ���Ĳ�������ô���Ǻ�̨����ִ�е�
		if (tbxmlstr == "") {
			sql = "select a.* from tax_jssjtbb a,tax_jssjtb_log b
				where a.tbbz='1' 
				  and a.owner=b.owner
				  and a.table_name=b.table_name
				  and a.dblink=b.dblink
				  and to_char(tb_end_time,'yyyymmdd')=to_char(sysdate,'yyyymmdd')
				  and tb_note='�ɹ�'
				order by a.tbxh,a.owner,a.table_name";
			ds = db.QuerySQL(sql);
		}
		else {
			ds = new pub.EAXmlDS(tbxmlstr);
		}
		for (var i=0;i<ds.getRowCount();i++) {
			var guid = ds.getStringAt(i,"GUID");
			var tbbz = ds.getStringAt(i,"TBBZ");
			var dblink = ds.getStringAt(i,"DBLINK");
			var owner = ds.getStringAt(i,"OWNER");
			var table_name = ds.getStringAt(i,"TABLE_NAME");
			var sourceTable = CJK_OWNER + "." + table_name;
			var tabds = db.QuerySQL("select * from tax_jssjtbb where guid='"+guid+"'");
			var zlbz = tabds.getStringAt(0,"ZLBZ");
			var zlwherestr = tabds.getStringAt(0,"WHERESTR");
			
			if (tbbz == "1") {
				//���ɼ������Ƿ��Ѿ����б�
				var chktab = checkTableExists(db,"HX_FXJK",table_name);
				//�������ڣ���ɾ����¼���ٲ���
				var tabrows = 0;				
				var tb_note2 = ""; //ͬ�����˵��				
				if (chktab == 1) {
					sql = "select count(*) from " + sourceTable;
					tabrows = db.GetSQL(sql);	
					tb_note2 = "�ɹ�["+tabrows+"]";				
					if (tabrows > 0) {
						var start_time = db.GetSQL("select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') from dual"); //ͬ����ʼʱ��
						try {
							sql = "alter table " + table_name + " nologging";
							db.ExcecutSQL(sql);
							
							//�Ӳɼ����ݿ�ͬ�����ݵ����Ŀ�
							if (zlbz != "1") { //ȫ����ģʽ
//								sql = "drop table " + table_name;
//								db.ExcecutSQL(sql);
//								sql = "create table " + table_name + " as select * from " + sourceTable;
//								db.ExcecutSQL(sql);
								
								sql = "truncate table " + table_name;
								db.ExcecutSQL(sql);
								sql = "insert into " + table_name + " select * from " + sourceTable;
								db.ExcecutSQL(sql);

							}
							else if (zlbz == "1") { //����ģʽ
								//��ɾ����ͬ��
								var delsql = "delete from " + table_name + " where ("+zlwherestr+")";
								db.ExcecutSQL(delsql);
								sql = "insert into " + table_name + " select * from " + sourceTable + " where ("+zlwherestr+")";
								db.ExcecutSQL(sql);	
								tabrows = db.GetSQL("select count(1) from " + table_name + " where ("+zlwherestr+")");
								tb_note2 = "�ɹ�["+tabrows+"]";								
							}
						} catch (e) {
							tb_note2 = pub.EAFunc.Replace(e.toString(),"'","''");							
							pub.EAFunc.Log("ͬ�������Ŀ�:table_name="+table_name+" ����="+e.toString());							
						}	
						finally {
							sql = "alter table " + table_name + " logging";
							db.ExcecutSQL(sql);
						}					
					}					
				}
				else {
					sql = "create table " + table_name + " as select * from " + sourceTable;
					db.ExcecutSQL(sql);
				}		
				
				//дͬ����־
				sql = "update tax_jssjtb_log set tb_note2='"+tb_note2+"'||' '||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') 
					where guid=(select guid from (select * from tax_jssjtb_log 
						where upper(table_name)=upper('"+table_name+"') order by tb_end_time desc) where rownum=1)";
				pub.EADbTool.ExcecutSQL(sql);		
								
			}
			
			//ÿͬ��һ�������һ�������ύ
			db.Commit();
			db = new pub.EADatabase();

		}
		
		db.Commit();
		
		if (xmlstr == "") {
			//ͬ�������Ŀ����Ҫ���⴦���
			updateTaxCompany();
			genTaxData();
			updateGbCompclass();
		}
		
		return "ͬ�������Ŀ�ɹ���";
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

//��˰�˻�����Ϣ��Ĵ���
function updateTaxCompany()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "";
		
		//2013.11.29
		//sql = "delete from tax_company";
		//db.ExcecutSQL(sql);
		
		//��������˰��������Ʒ־֡�˰��Ա
		sql = "update /*+ BYPASS_UJVC*/(
			select a.id,a.name,a.swjg_dm,b.zgswskfj_dm,a.taxman,b.SSGLY_DM
			from tax_company a,dj_nsrxx b
			where a.djxh=b.djxh
			) set swjg_dm=trim(zgswskfj_dm),taxman=trim(SSGLY_DM)";
		db.ExcecutSQL(sql);
		
		sql = "insert into tax_company (djxh,id,name,typ,taxman,lawman,addr,stat,flag,SWJG_DM,hy_dm)
			  select djxh,nsrsbh,nsrmc,typ,SSGLY_DM,FDDBRXM,scjydz,nsrzt_dm,flag,swjg_dm,hy_dm from ( 
			    select t.*,row_number() over (partition by nsrsbh order by nsrsbh) rn from (     
			    select to_char(a.djxh) djxh,a.nsrsbh,a.nsrmc,a.djzclx_dm typ,trim(SSGLY_DM) SSGLY_DM,FDDBRXM,scjydz,
			      nsrzt_dm,GDSLX_DM flag,trim(a.zgswskfj_dm) swjg_dm,hy_dm
			    from dj_nsrxx a,dj_nsrxx_kz b
			    where a.djxh=b.djxh(+) 
			    and (a.nsrsbh) not in (select id from tax_company)
			    ) t
			  ) where rn=1";
		db.ExcecutSQL(sql);

		//������ҵ����
		sql = "update tax_company a set hy_mc=(select hymc from dm_gy_hy b where a.hy_dm=b.hy_dm)";
		db.ExcecutSQL(sql);
		
		try {
			//��ҵ ��ϸ��ҵ
			sql = "update tax_company a set (hycode,hymx_dm)=(select qysbh,hymx_dm from dj_nsrxx_kz@taxdb b where a.id=b.nsrsbh)
				where a.id in (select nsrsbh from dj_nsrxx_kz@taxdb)";
			//db.ExcecutSQL(sql);
			//���Ի���ҵ
			sql = "update tax_company a set typclsid=(select max(id) from tax_compclass b
			           where nvl(a.hycode,'%') like '%'||b.hycode||'%')";
			db.ExcecutSQL(sql);
		
		}
		catch(ee) { }
		
		//һ����˰�˱�־
		sql = "update tax_company a set ytaxman=0";
		db.ExcecutSQL(sql);
		sql = "update tax_company a set ytaxman=1 where djxh in (select djxh from v_tax_ybnsr_djxx)";
		db.ExcecutSQL(sql);			

		db.Commit();
		return "��˰�˻�����Ϣ����³ɹ���";
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}


//����˰�����ݱ� sb_sbxx -> tax_taxdata
function genTaxData()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "delete from tax_taxdata where yymm>=to_char(sysdate-1,'YYYY-MM')";
		db.ExcecutSQL(sql);
		
		sql = "insert into tax_taxdata(yymm,id,name,somny,taxmny,sdtaxmny,org,djxh)
			select yymm,id,name,somny,taxmny,sdtaxmny,org,djxh 
			from v_tax_taxdata
			where yymm>=to_char(sysdate-1,'YYYY-MM')";
		db.ExcecutSQL(sql);

		db.Commit();
		return "����˰������ݳɹ���";
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

//������ҵ˰����
function updateGbCompclass()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "select count(*) from tax_gbcompclass where year=to_char(sysdate,'YYYY')";
		if (1*db.GetSQL(sql) <= 0) {
			sql = "insert into tax_gbcompclass(id,name,tax,avgsale,envload,se_ybnsr,se_xgm,env,year)
				select id,name,tax,avgsale,envload,se_ybnsr,se_xgm,env,to_char(sysdate,'YYYY') year
				from tax_gbcompclass
				where year=to_char(sysdate,'YYYY')-1";
			db.ExcecutSQL(sql);
		}
		
		//ֻȡС���
		sql = "insert into tax_gbcompclass(id,name,year)
			select hy_dm,hymc,to_char(sysdate,'yyyy') yyyy 
			from DM_GY_HY where hy_dm not in (select id from tax_gbcompclass where year=to_char(sysdate,'yyyy'))
			and xlbz='Y'";
		db.ExcecutSQL(sql);
		
		sql = "update tax_gbcompclass a set name=(select hymc from DM_GY_HY b where a.id=b.hy_dm)
			where a.year=to_char(sysdate,'YYYY')";
		db.ExcecutSQL(sql);
		
		db.Commit();
		return "���ɹ�����ҵ˰�������ݳɹ���";
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

function New()
{
	return 1;
}



}
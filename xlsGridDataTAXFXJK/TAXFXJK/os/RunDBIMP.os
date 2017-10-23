function TAXFXJK_RunDBIMP(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var timepack = new JavaPackage( "com.xlsgrid.net.time" );

//��̨ͬ�����ݿ�
function syncDB() 
{
	var db = null;					

	try {
		db = new pub.EADatabase();
		var sql = "select * from (select distinct owner from tax_jssjtbb where tbbz='1')";
		var userds = db.QuerySQL(sql);
		var owners = "";
		for (var i=0;i<userds.getRowCount();i++) {
			var owner = userds.getStringAt(i,"OWNER");
			var tim = new timepack.EARunOSTimer(); 
			var jobseqid = db.GetSQL("select to_char(sysdate,'yyyymmddhh24miss')||'-"+(i+1)+"' from dual");
			var jobname = owner+"."+jobseqid;
			tim.init(jobseqid,jobname,"TAXFXJK","RunDBIMP","syncUserTables","owner="+owner);
			if (owners == "") owners += owner;
			else owners += ","+owner;
		}
				
		return "���ݲɼ���...["+owners+"]";
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}

}

//��̨ͬ��һ���û������ݱ� 
//���� owner = ""
function syncUserTables()
{
	var CJK_OWNER = "CJ_FXJK"; //���ռ��ƽ̨�ɼ����ݿ��û�
	var db = null;					
	var tb_note = "�ɹ�"; //�ɼ����˵��
	var impUtil = new TAXFXJK_IMP_TaxData();
				
	try {
		db = new pub.EADatabase();
		var sql = "";

		sql = "select * from tax_jssjtbb where owner='"+owner+"' and tbbz='1' order by tbxh,owner,table_name";
		var ds = db.QuerySQL(sql);		
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
					try {
						sql = "alter table " + CJK_OWNER + "." + table_name + " nologging";
						db.ExcecutSQL(sql);					
					} catch(e) {}
					
					//���ɼ������Ƿ��Ѿ����б�
					var chktab = impUtil.checkTableExists(db,CJK_OWNER,table_name);
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
					var chktabcols = impUtil.checkTableHasColumn(db,CJK_OWNER,table_name,"SJGSDQ"); //SJGSDQ���ݹ�������
					if (chktabcols == 1) {
						if (filterstr == "") filterstr += " SJGSDQ like '14511%'";
						else filterstr += " or SJGSDQ like '14511%'";
					}
					chktabcols = impUtil.checkTableHasColumn(db,CJK_OWNER,table_name,"ZGSWSKFJ_DM"); //ZGSWSKFJ_DM����˰�����Ʒ־�
					if (chktabcols == 1) {
						if (filterstr == "") filterstr += " ZGSWSKFJ_DM like '14511%'";
						else filterstr += " or ZGSWSKFJ_DM like '14511%'";
					}
					chktabcols = impUtil.checkTableHasColumn(db,CJK_OWNER,table_name,"ZGSWJ_DM"); //ZGSWJ_DM ����˰�����
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
					try {
						sql = "alter table " +  CJK_OWNER + "." + table_name + " logging";
						db.ExcecutSQL(sql);
					} catch(e) { }
				}
				
				//дͬ����־
				sql = "insert into tax_jssjtb_log(guid,dblink,owner,table_name,tb_start_time,tb_end_time,tb_jls,tb_note)
				  values(sys_guid(),'%s','%s','%s',to_date('%s','yyyy-mm-dd hh24:mi:ss'),sysdate,'%s',substr('%s',0,1000))"
				  .format([dblink,owner,table_name,start_time,""+tb_jls,tb_note]);
				pub.EADbTool.ExcecutSQL(sql);
				
				
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				//ͬ�������Ŀ�
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				try {
					try {
						sql = "alter table " + table_name + " nologging";
						db.ExcecutSQL(sql);
					} catch(e) { }
					
					//���ɼ������Ƿ��Ѿ����б�
					var chktab = impUtil.checkTableExists(db,"HX_FXJK",table_name);
					//�������ڣ���ɾ����¼���ٲ���
					var tabrows = 0;				
					var tb_note2 = ""; //ͬ�����˵��				
					if (chktab == 1) {
						sql = "select count(*) from " + sourceTable;
						tabrows = db.GetSQL(sql);	
						tb_note2 = "�ɹ�["+tabrows+"]";				
						if (tabrows > 0) {
							var start_time = db.GetSQL("select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') from dual"); //ͬ����ʼʱ��
							//�Ӳɼ����ݿ�ͬ�����ݵ����Ŀ�
							if (zlbz != "1") { //ȫ����ģʽ
								//sql = "drop table " + table_name;
								//db.ExcecutSQL(sql);
								//sql = "create table " + table_name + " as select * from " + sourceTable;
								//db.ExcecutSQL(sql);
								
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
				catch (e) {
					tb_note2 = pub.EAFunc.Replace(e.toString(),"'","''");							
					pub.EAFunc.Log("ͬ�������Ŀ�:table_name="+table_name+" ����="+e.toString());
				}
				finally {
					try {
						sql = "alter table " + table_name + " logging";
						db.ExcecutSQL(sql);
					}
					catch(e) { }
				}
				
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				//�ɼ���ɺ���¡���������ƽ̨��������ݱ�
				if (table_name == "tax_taxdata".toUpperCase()) {
					impUtil.genTaxData();
				}
				if (table_name == "dj_nsrxx".toUpperCase()) {
					impUtil.updateTaxCompany();
				}
				
				//ÿͬ��һ�������һ�������ύ
				db.Commit();
				db = new pub.EADatabase();
		
			}
		}
		
		db.Commit();
		
		return "���ݲɼ��ɹ���";
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
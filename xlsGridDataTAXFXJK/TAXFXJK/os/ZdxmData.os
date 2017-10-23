function TAXFXJK_ZdxmData(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );


//��Ŀ��Ϣ����
function importXM()
{
	var db = null ;
	var ds = null ;
	var ps = null;
	var sql = "";
	var ret = 0;

	try {		
		db = new pub.EADatabase();
		//filename = "/u/filestore/u/filestore/u/filestoreupload/pgtmp/guiyuan.xls";
		if (typ == 2) { //��������ƽ̨��Ŀ����
			//����xmlDS
			var excelgrid = new xlsdb.excelgrid();	
			for (var sheet = 0;sheet <= 4;sheet++) {
				var xmlds = excelgrid.GetXmlDS(filename,sheet);	
				if (xmlds.getColumnCount() > 3) {
					var table =  db.GetSQL("select 'PG_'||TAX_NEXTVAL.nextval from dual");
					var params = "";
					var columns = "";
	
					//������ʱ��		
					sql = "create table "+table+" (";
					for (var col = 0;col < xmlds.getColumnCount();col ++) {
						if (col > 0) sql += ",";
						sql += "CO"+col+" varchar2(500) \n";
						if (columns != "") columns += ",";
						columns += "CO"+col;
						if (params != "") params += ",";
						params += "?";
					}
					sql += ") ";
					db.ExcecutSQL(sql);
					
					//������ʱ��
					//���һ���������͵� ������������֣����ת�����ڣ�
					//to_char(to_date('19000101','yyyymmdd')+to_number(co5),'yyyy-mm') co5
					var updatesql = "insert into "+table+" ("+columns +") values ("+params+")";
					ps = db.GetConn().prepareStatement(updatesql);
					
					var rowcount = xmlds.getRowCount();
					for(var rows=0;rows<rowcount;rows++) {
						for(var cols=0;cols<xmlds.getColumnCount();cols++) {
							var colname=xmlds.getColumnName(cols);
							var colstr=xmlds.getStringAt(rows,colname);
							ps.setString(cols+1,colstr);
						}
						ps.addBatch();
					}
					ps.executeBatch();
	
					//д����ʽĿ��� 
					var drlx = "����";
					if (sheet == 0) drlx = "���̽�����";
					else if (sheet == 1) drlx = "�����ɹ���";
					else if (sheet == 2) drlx = "��������ʹ��Ȩ�Ϳ�ҵȨ����";
					else if (sheet == 3) drlx = "����������Դ����";
					else if (sheet == 4) drlx = "����";
					
					sql = "select substr(co0,0,4) yy from "+table+" where co1 is null";
					var yyyy = db.GetSQL(sql);
					sql = "insert into TAX_ZDXM_JYPTXM(DRLX,TJYF,XMQY,XMMC,CGDW,JYJE,ZBDWMC)
						select '"+drlx+"' drlx,'"+yyyy+"'||to_char(to_number(co0),'FM00') tjyf,co1 xmqy,co2 xmmc,co3 cgdw,co4 jyje,co5 zbdwmc
						from "+table+" a 	
						where co1 is not null 
						  and not (co2='��Ŀ����' or co3='�ɹ���λ' or co5='�б굥λ')
						  and not exists (select 1 from TAX_ZDXM_JYPTXM b where '"+yyyy+"'||to_char(to_number(co0),'FM00')=b.tjyf 
						  and co2=b.xmmc and co3=b.cgdw and co5=b.zbdwmc)";
					ret += db.ExcecutSQL(sql);
					
					//�Զ�ƥ��д����ձ�
					sql = "insert into tax_zdxm_jyptwbbyxm_dzb
						select sys_guid(),jyptxmuuid,djxh,bydjuuid,sysdate from (
						select distinct a.jyptxmuuid,b.djxh,b.bydjuuid
						from TAX_ZDXM_JYPTXM a,(
						select bydjuuid,djxh,wcjyhwmc from dj_wbnsrjydbydj_hwxx
						union all
						select bydjuuid,djxh,wcjylwmc from dj_wbnsrjydbydj_lwxx
						) b
						where a.xmmc=b.wcjyhwmc
						  and (a.jyptxmuuid,b.djxh,b.bydjuuid) not in (select jyptxmuuid,djxh,bydjuuid from tax_zdxm_jyptwbbyxm_dzb)
						)";
					db.ExcecutSQL(sql);
						
					//drop��ʱ��
		  			sql = "drop table " + table;
		 			db.ExcecutSQL(sql);
	
				}
			}
		}
		else if (typ == 1) { //����ί��Ŀ����
			var excelgrid = new xlsdb.excelgrid();	
			var table =  db.GetSQL("select 'PG_'||TAX_NEXTVAL.nextval from dual");
				
			var xmlds = excelgrid.GetXmlDS(filename,0);	
			if (xmlds.getColumnCount() > 3) {
				var params = "";
				var columns = "";

				//������ʱ��		
				sql = "create table "+table+" (";
				for (var col = 0;col < xmlds.getColumnCount();col ++) {
					if (col > 0) sql += ",";
					sql += "CO"+col+" varchar2(500) \n";
					if (columns != "") columns += ",";
					columns += "CO"+col;
					if (params != "") params += ",";
					params += "?";
				}
				sql += ") ";
				db.ExcecutSQL(sql);
				
				//������ʱ��
				//���һ���������͵� ������������֣����ת�����ڣ�
				//to_char(to_date('19000101','yyyymmdd')+to_number(co5),'yyyy-mm') co5
				var updatesql = "insert into "+table+" ("+columns +") values ("+params+")";
				ps = db.GetConn().prepareStatement(updatesql);
				
				var rowcount = xmlds.getRowCount();
				for(var rows=0;rows<rowcount;rows++) {
					for(var cols=0;cols<xmlds.getColumnCount();cols++) {
						var colname=xmlds.getColumnName(cols);
						var colstr=xmlds.getStringAt(rows,colname);
						ps.setString(cols+1,colstr);
					}
					ps.addBatch();
				}
				ps.executeBatch();
			}
			
			sql = "delete from "+table+" where co0='��Ŀ����'";
			db.ExcecutSQL(sql);
			
			sql = "insert into tax_zdxm_fgwxm(xmdm,xmmc,zyjsnrgm,ztzje,xmssdw,xmzrdw,qqgzjzqk,jhkgsj)
				select co0,co1,co2,co3,co4,co5,co6,co7 
				from "+table+"
				where co0 not in (select xmdm from tax_zdxm_fgwxm)";
			ret += db.ExcecutSQL(sql);
			
			//drop��ʱ��
  			sql = "drop table " + table;
 			db.ExcecutSQL(sql);

			
		}
			
		db.Commit();
		return "����ɹ�����¼��"+ret;

	}
	catch(e) {
		if(db != null) db.Rollback();
		return e.toString();
		throw new Exception(e);
	}
	finally {
		if(db != null) db.Close();
		//�ļ�����ɹ���ɾ��
		var file = new java.io.File(filename);   
         	if(file.exists()){   
         		file.delete();
         	}
	}
}

}
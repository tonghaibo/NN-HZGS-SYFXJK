function TAXMON_EleData(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );

function insert()
{
	var db = null;
	var ds = null;
	var sql = "";
	var tabname = tabnam;
	var typ = typ;
	var ret = "";

	try{
		db = new pubpack.EADatabase();
		
		sql = "select * from user_tables where table_name=upper('"+tabname+"')";
		var cnt = db.GetSQLRowCount(sql);
		if(cnt <= 0) return "�����ݿ��Ե���";

		//ƽ�����
		if(typ == 1) {
			//sql = "delete from "+tabname+" where co0='�û���'";
			sql = "delete from "+tabname+" where co0 like 'sz_id_user%'";
			db.ExcecutSQL(sql);
			//�����õ粻����
			sql = "delete from "+tabname+" where co10 ='0.4563' or co10 ='0.6003' or co10 ='0.5283'";
			db.ExcecutSQL(sql);
			
			sql = "update tax_eledata a set (ELEQTY,ELEPRICE,ELEMNY)=(select sum(co9),max(co10),sum(co11) 
				       from "+tabname+" b where a.usrid=b.co0 and a.yymm=b.co12
				       group by co0,co12)
				where a.typ='1' and exists (select 1 from "+tabname+" b where b.co0=a.usrid and b.co12=a.yymm)";
			var upcnt = db.ExcecutSQL(sql);
			
			sql = "insert into tax_eledata(YYMM,USRID,USRNAM,ELEQTY,ELEPRICE,ELEMNY,typ,TOWN)"+
				"select co12,co0,max(co1) co1,sum(co9) co9,max(co10) co10,sum(co11) coll,'1','ƽ��' from "+tabname+" a" +
				" where not exists (select 1 from tax_eledata b where b.usrid=a.co0 and b.YYMM=a.co12 and b.typ='1') group by co0,co12";
			var count = db.ExcecutSQL(sql);
			db.ExcecutSQL("drop table "+tabname);
			
			return  "����"+count+"�ʼ�¼������"+upcnt+"�ʼ�¼��";	
		}
		//��ɽ����
		else if (typ == "4") {
			sql = "delete from "+tabname+" where co0 like '�ͻ����%'";
			db.ExcecutSQL(sql);
			
			sql = "update tax_eledata a set (ELEQTY)=(select sum(co3) 
				       from "+tabname+" b where a.usrid=b.co0 and a.yymm=b.co2
				       group by co0,co2)
				where a.typ='4' and exists (select 1 from "+tabname+" b where b.co0=a.usrid and b.co2=a.yymm)";
			var upcnt = db.ExcecutSQL(sql);
			
			sql = "insert into tax_eledata(YYMM,USRID,USRNAM,ELEQTY,typ,TOWN)"+
				"select to_char(to_date(to_number(co2),'yyyymm'),'yyyy-mm'),co0,max(co1) co1,sum(co3) co3,'4','��ɽ' from "+tabname+" a" +
				" where not exists (select 1 from tax_eledata b where b.usrid=a.co0 and b.YYMM=to_char(to_date(to_number(co2),'yyyymm'),'yyyy-mm') and b.typ='4') group by co0,co2";
			var count = db.ExcecutSQL(sql);
			db.ExcecutSQL("drop table "+tabname);
			
			return  "����"+count+"�ʼ�¼������"+upcnt+"�ʼ�¼��";	
		}
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

//��Դ��������
function impGuiYuan()
{
	var db = null ;
	var ds = null ;
	var ps = null;
	var sql = "";
	var ret = 0;
	var typ=typ;
	try {		
		db = new pubpack.EADatabase();
		//filename = "/u/filestore/u/filestore/u/filestoreupload/pgtmp/guiyuan.xls";
		
		//����xmlDS
		var excelgrid = new xlsdb.excelgrid();	
		for (var sheet = 0;sheet <= 12;sheet++) {
			var xmlds = excelgrid.GetXmlDS(filename,sheet);	
			if (xmlds.getColumnCount() > 3) {
				var table =  db.GetSQL("select 'PG_'||TAX_NEXTVAL.nextval from dual");
				var params = "";
				var columns = "";

				//������ʱ��		
				sql = "create table "+table+" (";
				for (var col = 0;col < xmlds.getColumnCount();col ++) {
					if (col > 0) sql += ",";
					sql += "CO"+col+" varchar2(255) \n";
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
//				pubpack.EAFunc.Log(updatesql);
				ps = db.GetConn().prepareStatement(updatesql);
				
				var rowcount = xmlds.getRowCount();
				for(var rows=0;rows<rowcount;rows++) {
					for(var cols=0;cols<xmlds.getColumnCount();cols++) {
						var colname=xmlds.getColumnName(cols);
						var colstr=xmlds.getStringAt(rows,colname);
//						if (rows > 0 && cols == 5) throw new Exception(colstr);
						ps.setString(cols+1,colstr);
					}
					ps.addBatch();
				}
				ps.executeBatch();
				
				if(typ==2){
					//д����ʽĿ��� 
					sql = "delete from "+table+" where co0='�û����'";
					db.ExcecutSQL(sql);
					
					//���Ϊ0.5283���õ��¼�����ھ����õ磬���赼��
					sql = "delete from "+table+" where co5='0.5283'";
					db.ExcecutSQL(sql);
			
					sql = "insert into tax_eledata(YYMM,USRID,USRNAM,ELEQTY,ELEMNY,typ,TOWN)
					select yymm,usrid,usrnam,eleqty,elemny,typ,town from (
		  			select to_char(to_date('19000101','yyyymmdd')+to_number(co2),'yyyy-mm') yymm,
					decode(instr(co0,'.'),0,co0,to_number(co0)) usrid,max(co1) usrnam,sum(co3) eleqty,sum(co4) elemny,'2' typ,max(co6) town from "+table+" a 
					group by co2,co0
					) a where not exists (select 1 from tax_eledata b where b.usrid=a.usrid and b.YYMM=a.yymm)";
					ret += db.ExcecutSQL(sql);
					//drop��ʱ��
		  			sql = "drop table " + table;
		 			db.ExcecutSQL(sql);
	 			}
	 			else if(typ==3){
					sql="delete from "+table+" where co5 is null";
					db.ExcecutSQL(sql);
					
					sql="select * from "+table+" where co2='�û���'";
					ds = db.QuerySQL(sql);
					for (var i=3;i<15;i++) {
						var colnam = ds.getColumnName(i);
						var yymm = ds.getStringAt(0,i);
						sql = "insert into tax_eledata(YYMM,USRID,USRNAM,ELEQTY,typ,TOWN)
							select yymm,co2,co1,co3,typ,'��' from(select to_char(to_date('"+yymm+"','yyyy-mm'),'yyyy-mm') yymm,decode(instr(co2,'.'),0,co2,to_number(co2)) co2,max(co1) co1,nvl(sum("+colnam+"),0) co3,'3' typ from "+table+" a
							where co2 !='�û���'and "+colnam+" is not null and co2 is not null group by co2 ) a where not exists (select 1 from tax_eledata b where a.co2=b.usrid and b.yymm=a.yymm) ";
							ret += db.ExcecutSQL(sql);
							
					}
					//drop��ʱ��
		  			sql = "drop table " + table;
		 			db.ExcecutSQL(sql);
	 			}
			}
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
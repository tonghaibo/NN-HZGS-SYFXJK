function TAXMON_COMPANY(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");

//��Ӷ���html
//afterBodyHtml�¼��󴥷����ѹ�ʱ��������afterBodyHtml�¼����д���
function addBottomHtml(mwobj,request,sb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("<input type='file' id='fileInput'/>");
}

//co0 ��ҵ����	
//co1 ��˰��ʶ���	
//co2 ��˰������	
//co3 ����������	
//co4 ���粿��	
//co5 ����	
//co6 һ����˰�˱�־	
//co7 ��ҵ����	
//co8 ˰��Ա	
//co9 ��˰��״̬	
//co10 ��������	
//co11 ������Ӫ��ַ	
function insert()
{
	var db = null;
	var sql = "";
	var ds = null;
	var table = tabnam;
	try
	{
		db = new pubpack.EADatabase();	
		sql = "select * from user_tables where table_name = upper('"+table+"')";
		ds = db.QuerySQL(sql);
		if (ds.getRowCount() > 0)
		{
			sql = "update "+table+" set co6=decode(co6,'Y','1','��','1','0')";
			db.ExcecutSQL(sql);
			
			sql = "update tax_company a set (name,hycode,pwdept,typ,taxman,towns,lawman,addr,ytaxman,stat)=
		        (select trim(co2),replace(replace(trim(co0),'--','_'),' ',''),trim(co4),trim(co7),trim(co8),trim(co10),trim(co3),trim(co11),co6,trim(co9) from "+table+" b
		          where a.id=trim(b.co1) and nvl(a.ammno,'A')=nvl(trim(b.co5),'A') and nvl(a.pwdept,'A')=nvl(trim(b.co4),'A'))
		        where (id,nvl(ammno,'A'),nvl(pwdept,'A')) in (select co1,nvl(trim(co5),'A'),nvl(co4,'A') from "+table+")";
			var count1 = db.ExcecutSQL(sql);
		
	          	sql = "insert into tax_company (ID,NAME,HYCODE,PWDEPT,AMMNO,TYP,TAXMAN,TOWNS,LAWMAN,ADDR,YTAXMAN,STAT)
			select co1,co2,hycode,co4,co5,co7,co8,co10,co3,co11,co6,co9 from (
			select co1,co2,replace(replace(trim(co0),'--','_'),' ','') hycode,co4,decode(instr(co5,'.'),0,co5,to_number(co5)) co5,co7,co8,co10,co3,co11,co6,co9 from "+table+" a 
			where co1 !='��˰��ʶ���') a
			where not exists (select 1 from tax_company where tax_company.ID=a.co1 and nvl(tax_company.ammno,'1')=nvl(a.co5,'1') )";
	          	var count2 = db.ExcecutSQL(sql);
	          	
	            	//�޸�typclsid�ֶ�
	            	sql = "update tax_company a set typclsid =nvl((select max( b.id)  from tax_compclass b 
         			where  substr(replace(a.hycode,'-','_'),instr(replace(a.hycode,'-','_'),replace(b.hycode,'nsrbm_',''),1,1),length(replace(b.hycode,'nsrbm_',''))) = replace(b.hycode,'nsrbm_','')),'')         			     
	        		where exists (select 1 from tax_company a,tax_compclass b   where  
    				substr(replace(a.hycode,'-','_'),instr(replace(a.hycode,'-','_'),replace(b.hycode,'nsrbm_',''),1,1),length(replace(b.hycode,'nsrbm_','')))= replace(b.hycode,'nsrbm_','') )
    				and to_char(crtdat,'yyyymmdd')=to_char(sysdate,'yyyymmdd')";
	            	db.ExcecutSQL(sql);
	            	
	            	db.Commit();
			return "���¼�¼"+count1+"�ʣ������¼"+count2+"��";
		}
		else
			return "�����ݿ��Ե���ģ�";
	}
	catch ( e )
	{
		if(db != null) db.Rollback();
		throw new Exception(e);
	}
	finally
	{
		sql = "select * from user_tables where table_name = upper('"+table+"')";
		ds = pub.EADbTool.QuerySQL(sql);
		if (ds.getRowCount() > 0)
		{
			sql = "drop table "+ table;
			pub.EADbTool.ExcecutSQL(sql);
		}
		if(db != null) db.Close();
	}	
}


}
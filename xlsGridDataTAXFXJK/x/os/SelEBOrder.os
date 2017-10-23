function x_SelEBOrder(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
//================================================================// 
// ������getTreeXml
// ˵�����������ؼ���xml
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�06/02/10 10:43:54
// �޸���־��
//================================================================// 
function getTreeXml()
{
	var db = null; 
	var sql = "";
	var xml = "<?xml version='1.0' encoding='GBK'?>\n<"+dat+">\n";
	try{
		var scorpid = "";
		var scorpnam = "";
		var ordid = "";
		db = new pubpack.EADatabase();
		      	
		//�����������Ѵ���������Ȳ��Ҵ���״̬Ϊ1(�Ѵ���)
		sql = "select distinct ordid from ord_tmp where qty<>nvl(traqty,0) and  nvl(stat,'0') <> '1' and dat ='"+dat+"' and kaid='"+ka+"'\n";
		var cds = db.QuerySQL(sql);
		var sCount = cds.getRowCount();
		xml += "<δ����("+sCount+")>\n";		
		sql = "select distinct ecorpid,ecorpnam from ord_tmp where qty<>nvl(traqty,0) and nvl(stat,'0') <>1 and dat ='"+dat+"' and kaid='"+ka+"'";
		var ds = db.QuerySQL(sql);		
		for (var r = 0 ; r < ds.getRowCount(); r++)
		{
			scorpid = ds.getStringAt(r,"ECORPID");
			scorpnam = ds.getStringAt(r,"ECORPNAM");			
			xml += "<"+scorpnam+" id='"+scorpid+"'>";
			
			var ordsql = "select distinct ordid from ord_tmp where ecorpid ='"+scorpid+"' and qty<>nvl(traqty,0) and nvl(stat,'0') <>1 and dat ='"+dat+"' and kaid='"+ka+"'";
			var ords = db.QuerySQL(ordsql);
			for (var i = 0 ; i< ords.getRowCount(); i++)
			{
				ordid = ords.getStringDef(i,"ORDID","δ�ҵ�");
				xml += "<"+ordid+" id='"+ordid+"' stat='0'/>";
			}				

			xml += "</"+scorpnam+">";

		}
		//xml += "<����ȫ�� id='all'/>";
		xml += "<�޶�Ӧ�ͻ� id='nocorp'/>";
		xml += "<�޶�Ӧ��Ʒ id='noitem'/>";				
		xml += "<�۸�һ�� id='diffprice'/>";
		xml += "<���������ǵ���/>";
		xml += "</δ����>\n";
		sql = "select distinct ordid from ord_tmp where (qty=nvl(traqty,0) or stat=1) and dat ='"+dat+"' and kaid='"+ka+"'\n";
		var tds = db.QuerySQL(sql);
		var tCount = tds.getRowCount();
		xml += "<�Ѵ���("+tCount+")>\n";		
		sql = "select distinct ecorpid,ecorpnam from ord_tmp where (qty=nvl(traqty,0) or stat=1) and dat ='"+dat+"' and kaid='"+ka+"'";
		var ds = db.QuerySQL(sql);		
		for (var r = 0 ; r < ds.getRowCount(); r++)
		{
			scorpid = ds.getStringAt(r,"ECORPID");
			scorpnam = ds.getStringAt(r,"ECORPNAM");			
			xml += "<"+scorpnam+" id='"+scorpid+"'>";
			
			var ordsql = "select distinct ordid from ord_tmp where ecorpid ='"+scorpid+"' and (qty=nvl(traqty,0) or stat=1) and dat ='"+dat+"' and kaid='"+ka+"'";
			var ords = db.QuerySQL(ordsql);
			for (var i = 0 ; i< ords.getRowCount(); i++)
			{
				ordid = ords.getStringDef(i,"ORDID","δ�ҵ�");
				xml += "<"+ordid+" id='"+ordid+"' stat='1'/>";
			}				

			xml += "</"+scorpnam+">";

		}

		xml += "</�Ѵ���>\n";	
		xml += "</"+dat+">";	
		db.Commit();
		return xml;
	}catch(Exception e){
		db.Rollback();
		throw new Exception(e);
	}
}

//================================================================// 
// ������ModifyPrice
// ˵�������¿����۸񣬵��۸�ά����ȥ��ʱ����Բ���ˢ������ҳ��
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�06/02/10 10:26:06
// �޸���־��
//================================================================// 
function ModifyPrice()
{
	var db = null;
	var sql = "";
	try{
		db = new pubpack.EADatabase();
		//���»�����Ϣ��
		//���»����۸�,ͬ���Ѵ���Ķ�������������
		sql = "
		       update ord_tmp a set sprice=eprice
			where a.dat = '"+dat+"'
			  and a.qty<>a.traqty
			  and a.stat <> '2'
			  and a.kaid='"+ka+"'
			  and eprice= (select case when protprice<>0 then protprice else case when kaprice<>0 then kaprice else baseprice end end  
			                  from v_bilprice b
			                 where a.dat = b.dat
			                   and a.scorpid = b.corpid
			                   and a.sitmid = b.itmid
			                )
			  and exists (select 1 from v_bilprice c  
			                where a.dat = c.dat
			                  and a.scorpid = c.corpid
			                  and a.sitmid = c.itmid
			               )                          
               ";
               db.ExcecutSQL(sql);		
               db.Commit();
	}catch(e)
	{
		db.Rollback();
		throw new Exception(e);
	}               
}
//================================================================// 
// ������ModifyBaseInfo
// ˵�������»�����Ϣ��������ά����ȥ��ʱ����Բ���ˢ������ҳ��
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�06/02/10 10:25:24
// �޸���־��
//================================================================// 
function ModifyBaseInfo()
{
	var db = null;
	var sql = "";
	try{
		db = new pubpack.EADatabase();
		//���»�����Ϣ��	
		//���¿ͻ�,��Ʒ��Ϣ�Ѿ�������Ķ�������ǿ�ƽ����Ķ���������
		sql = "update ord_tmp a set scorpid = (select id from corp b where b.ordcorp = a.ecorpid),
					     scorpnam = (select name from corp b where b.ordcorp = a.ecorpid),
					     sitmid = (select c.id from corpitem b,item c where b.ebitem = a.eitmid and b.item = c.guid),
					     sitmnam = (select c.name from corpitem b,item c where b.ebitem = a.eitmid and b.item = c.guid)
					     
			where a.dat = '"+dat+"'
			  and a.qty<>a.traqty 
			  and a.stat<>'2'	
			  and kaid='"+ka+"'		     
		      ";
//		      throw new Exception(sql);
		db.ExcecutSQL(sql);

               db.Commit();
	}catch(e)
	{
		db.Rollback();
		throw new Exception(e);
	}               
}


//================================================================// 
// ������getListData
// ˵��������ԭʼ������ϸ���ݵķ�ҳxml
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�06/02/10 10:24:50
// �޸���־��
//================================================================// 
function getListData()
{
	var db = new pubpack.EADatabase();
	var sql = "
			select eitmid||'      001/01' itmid,code||'              '||spec cs,eitmnam,untnum,'N  '||qty qty,zpqty,qty*untnum sqty,eprice notaxprice,eprice*qty*untnum notaxmny
			  from ord_tmp 
			 where ordid='"+ordid+"'
			   and kaid = '"+kaid+"'
		  ";
	var xmlds = db.GetXMLSQL(sql,pageno,pagesize);
	xmlds.removeColumn("RID_");
        xmlds.removeColumn("num");
        var xml = xmlds.GetXml();
  	return xml;
}

//================================================================// 
// ������closeOrder
// ˵����ǿ�ƽ�������,δ������Ķ���������һ�������ı�־
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�06/02/10 10:24:12
// �޸���־��
//================================================================// 
function closeOrder()
{
	var db = null;
	var sql = "";
	var ret = 0;
	try{
		db = new pubpack.EADatabase();
		sql = " update ord_tmp set stat='1' where ordid='"+tag+"' and kaid='"+ka+"' and stat='0'";
		ret = db.ExcecutSQL(sql);
		if(ret > 0){
			return ret;
		}	
	}catch(e)
	{
		db.Rollback();
		throw new Exception(e);
	}
}
//��ѯ���û��Ƿ�󶨿��
function IsLoc(){
	var IsLoc="1";
	return IsLoc;
}










}
function x_AnalyseInv(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var utlpack = new JavaPackage("java.util");
function doAction()
{
	var db = null;
	var ds = null;
	try
	{	
		db = new pubpack.EADatabase();
		ds = new pubpack.EAXmlDS(xml);
		var nxml = "<?xml version = '1.0'?><ROWSET></ROWSET>";
		var nds = new pubpack.EAXmlDS(nxml);
		var colnam = "";
		for (var r = 0;r< ds.getRowCount();r++)
		{
			if( ds.getStringAt(r,"�������")!="")
			{
				nds.copyOneRow(ds,r);
				nds.removeColumn("num");
				nds.removeColumn("SELECTFLAG");
				nds.removeColumn("name");					
			}	
		}
		var i = 15;
		while(i>0)
		{
			var lcol = 4;		
			while(lcol< nds.getColumnCount() )
			{
				colnam = nds.getColumnName(lcol);
				colnam = colnam.substring(1,5);
				if(ModLoc.indexOf(colnam)<0)
				{
					nds.removeColumn(lcol+1);
					nds.removeColumn(lcol); 
				} 
				lcol += 2;
			}
			i--;
		}			 
		var ret = buildSBil(db,nds);		
		db.Commit();	
		return ret;	
	}catch(e){
		db.Rollback();
		throw new Exception(e);
	}

}

//================================================================// 
// ������buildSaleBil(ordid)
// ˵����
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�05/25/10 14:43:02
// �޸���־��
//================================================================// 
function buildSBil(db,ds) 
{


	var sql = "";
	var locCol = 4;		//��һ���ֿ���
	var locid = "";		//�ֿ���
	var saleQty = 0;	//��������
	var ordid = "";		//�������
	var itmid = "";		//��Ʒ���
	var saleBil = "";	//���۵��ݺ�
	var tax = "";		//˰��	
	var keyStr = "";        //��ֵ������ȡ�����ݱ��
	var seqid = 1;
	var ret = "";
	var map = new utlpack.HashMap();	
	var seqmap = new utlpack.HashMap();
	//����ʲô�ֿ⣬ֻҪ�ֿ��������־Ͳ��뵥����ϸ��
	while(locCol < ds.getColumnCount())
	{
		locid = ds.getColumnName(locCol);
		locid = locid.substring(1,5);
		for (var row=0;row< ds.getRowCount();row++)
		{
			saleQty = 1.0 * ds.getStringDef(row,locCol,"0");
			if(saleQty == 0) 
				continue;
			else {
				ordid = ds.getStringAt(row,"�������");
				itmid = ds.getStringAt(row,"��Ʒ���");
				//�ڲ����ʱ��Ҫ�ٴμ���Ƿ��пɿ�������û���׳��쳣(����)
				//var invqty = db.GetSQL("select nvl(GENINVQTY('"+itmid+"','"+locid+"'),0) from dual");
				var invqty = db.GetSQL("select decode(GENINVQTY('"+itmid+"','"+locid+"'),0,200,GENINVQTY('"+itmid+"','"+locid+"')) from dual"); 
				if(invqty == 0) 
					throw new Exception("��Ʒ��"+itmid+"�ڲֿ⣺"+locid+"�޿ɿ���棬�����ѱ�ռ�ã�"); 
				//˰��
				sql = "select to_number(nvl((select potax from item where id='"+itmid+"'),0.17)) TAX from dual";
				tax = db.GetSQL(sql);
				//ȷ�����ݵ�Ψһ��
				keyStr = locid+"#"+ordid+"#"+tax;
				//�ӵ��ݿ���ȡ������
				if(!map.containsKey(keyStr))
				{
					saleBil = db.GetBillid(acc,"EB","EB");
					map.put(keyStr,saleBil);
				}
				else
					saleBil = map.get(keyStr);
				//�ӵ�����ϸ����ȡ����Ӧ����ϸ��
				if(!seqmap.containsKey(keyStr))
				{
					seqid = 1;
					seqmap.put(keyStr,seqid);
				}
				else
					seqid =1+1*seqmap.get(keyStr);
				
				sql = "
					insert into bildtl (ACC,SYT,ORG,BILID,BILTYP,SUBTYP,CORPID,LOCID,DAT,STAT,SEQID,ITMID,ITMNAM,ITMSPC,UNIT,UNTNUM,TONNUM,PRICE,QTY,
							    TAXTYP,NOTAXMNY,TAXMNY,MNY,REFID1,REFNAM1,REFID2,REFNAM2,DATFLW,SMLUNT,ITEMPC,REFID3,REFNAM3,REFID4,REFNAM4,REFID5,REFNAM5)
					 select '"+acc+"' ACC,'"+syt+"' SYT,'"+org+"' ORG,'"+saleBil+"' BILID,'"+saleClass+"' BILTYP,decode('"+saleClass+"','SO',2,'SX',1) SUBTYP,
					        c.id CORPID,'"+locid+"' LOCID,to_date('"+dat+"','yyyy-mm-dd') DAT,'1' STAT,"+seqid+" SEQID,i.id ITMID,i.name ITMNAM,
					        i.spec ITMSPC,i.unit UNIT,i.untnum UNTNUM,i.tonnum TONNUM,a.sprice*(1+to_number('"+tax+"')) PRICE,
					        case when a.qty>"+invqty+" then "+invqty+" else a.qty end QTY,
					        to_number('"+tax+"') TAX,a.sprice*(1+to_number('"+tax+"'))*qty/(1+to_number('"+tax+"')) NOTAXMNY /*����˰����*/,
					        a.sprice*(1+to_number('"+tax+"'))*to_number('"+tax+"') TAXMNY ,sprice*(1+to_number('"+tax+"'))*qty MNY,'' REFID1/*�ۿ۲���˰��*/,'' REFNAM1/*�ۿ�*/,
					       /* decode(GENPROTPRICE('"+itmid+"',a.scorpid,'"+dat+"'),sprice,'1','0')*/i.price REFID2,/*nvl(GENKAPRICE('"+itmid+"',scorpid),i.PRICE)*/i.price REFNAM2 /*ԭʼ����*/,'' DATFLW,i.smlunt SMLUNT,
					        trim(a.deptid) ITEMPC/*�����ֶδ�Ų���*/,'' REFID3,'' REFNAM3,'' REFID4,'' REFNAM4,
					        /*(select TO_CHAR(to_date('"+dat+"','yyyy-mm-dd')-to_number(nvl(extcal1,'0'))*to_number(decode(imitmflg,'0',nvl(b.CUSTBZQBL,'0.1'),nvl(b.ECUSTBZQBL,'0.1')))+to_number(nvl(b.KAZTDAT,'7')),'YYYY-MM-DD') YCDAT  
				 		    from item c,(select nvl(b.CUSTBZQBL,'1') CUSTBZQBL,nvl(b.ECUSTBZQBL,'1') ECUSTBZQBL,nvl(b.EXTCAT7,'0') KAZTDAT from V_CUST a ,v_ka b where a.id=C.ID and a.refid = b.id )b
 						    where c.id = i.id)*/'2010-05-07' REFID5,'' REFNAM5
					   from ord_tmp a,item i,corp c
					  where a.scorpid = c.id and a.sitmid = i.id
					    and nvl(i.potax,to_number('0.17')) = to_number('"+tax+"')
					    and a.ordid = '"+ordid+"' 
					    and a.sitmid = '"+itmid+"' and dat = '"+dat+"' 							
				";	
				db.ExcecutSQL(sql);
			}
		}
		
		locCol+=2; 
	}
	//���굥����ϸ��bildtl����ɸ��ݵ�����ϸ���쵥��ͷ��Ϣ��
	var sobil = "";	
	if(map.size == 0) return;	
	else{
		var keys = map.keySet();		
		var it = keys.iterator();
		while(it.hasNext())
		{	
			keyStr = it.next();		 
			sobil = map.get(keyStr);
			ret += sobil+",";
			ordid = keyStr.split("#")[1];		
			locid = keyStr.split("#")[0];	
			sql = "
				insert into bilhdr(ACC,SYT,ORG,BILID,BILTYP,SUBTYP,CORPID,CORPNAM,LOCID,LOCNAM,DAT,STAT,CRTUSR,CRTUSRNAM,NOTE,SUMQTY,SUMMNY,REFID1,REFNAM1,
						  REFID2,REFNAM2,REFID3,REFNAM3,REFID4,REFNAM4,REFID5,REFNAM5,REFID6,REFNAM6)
				select bl.acc,max(bl.SYT) syt,max(bl.ORG) org,bl.BILID,bl.BILTYP,decode('"+saleClass+"','SO',2,'SX',1) SUBTYP,c.id CORPID,c.name CORPNAM,
				       '"+locid+"',(select name from loc where id='"+locid+"') LOCNAM,sysdate DAT,'1' STAT, '"+usrid+"' CRTUSR,'"+usrnam+"' CRTUSRNAM,'' NOTE,
				       sum(bl.qty) SUMQTY,sum(bl.mny) SUMMNY,'"+tax+"' REFID1/*˰��*/,'"+ordid+"' REFNAM1/*�Է�������*/,
				       /*(select usrid from v_kausr where kaid=c.refid) */ ''REFID2/*ҵ��Ա���*/, '' REFNAM2/*��Ӧ�ĵ��ݺ�*/,
				       /*(select addr from v_onlyaddr where id=c.id)*/'' REFID3 /*�ͻ���ַ*/,to_char(sysdate+1,'yyyy-mm-dd') REFNAM3/*�ͻ�����*/,
				       '' REFID4 /*��ʱ�ͻ�����*/,'1' REFNAM4 /*�ͻ���־*/,'0' REFID5/*�Ƿ���ǩ��*/,/*(select usrname from v_kausr where kaid=c.refid)*/'' REFNAM5/*ҵ��Ա����*/,
				       trim(bl.itempc) REFID6/*��ͬ���*/,(select name from v_dept b where b.id=trim(bl.itempc)) REFNAM6/*��ͬ����*/
				   from bildtl bl,corp c
				  where bl.corpid = c.id
				    and bl.acc = '"+acc+"'
				    and bl.bilid = '"+sobil+"'
				    and bl.biltyp = '"+saleClass+"'
				  group by bl.acc, bl.BILID, bl.BILTYP,c.id, c.name,c.refid,bl.itempc			
			";
			db.ExcecutSQL(sql);
			//���ɵ��ݺ�Ҫ�Ѷ��������������������д
			sql = " 
				update ord_tmp o
				   set traqty = (  select sum(bl.qty) qty from bilhdr bh,bildtl bl
				                    where bh.acc = bl.acc and bh.bilid = bl.bilid and bh.biltyp = bl.biltyp
				                      and trim(bh.refnam1) = o.ordid
				                      and bl.itmid = o.sitmid
				                      and bh.biltyp in ('SX','SO')
				                )
				  where o.ordid='"+ordid+"'
			
			      ";
			db.ExcecutSQL(sql);	
			//������ɵ��������������Ҫ��״̬��Ϊ�Ѵ���
			sql = " update ord_tmp set stat='1' where ordid='"+ordid+"' and qty = traqty";
			db.ExcecutSQL(sql);
		}
	     }		   
	return ret;
}













}
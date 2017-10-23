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
			if( ds.getStringAt(r,"订单编号")!="")
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
// 函数：buildSaleBil(ordid)
// 说明：
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：05/25/10 14:43:02
// 修改日志：
//================================================================// 
function buildSBil(db,ds) 
{


	var sql = "";
	var locCol = 4;		//第一个仓库列
	var locid = "";		//仓库编号
	var saleQty = 0;	//销售数量
	var ordid = "";		//订单编号
	var itmid = "";		//商品编号
	var saleBil = "";	//销售单据号
	var tax = "";		//税率	
	var keyStr = "";        //键值，用来取出单据编号
	var seqid = 1;
	var ret = "";
	var map = new utlpack.HashMap();	
	var seqmap = new utlpack.HashMap();
	//不管什么仓库，只要仓库列有数字就插入单据明细表。
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
				ordid = ds.getStringAt(row,"订单编号");
				itmid = ds.getStringAt(row,"商品编号");
				//在插入的时候要再次检查是否有可开库存如果没有抛出异常(并发)
				//var invqty = db.GetSQL("select nvl(GENINVQTY('"+itmid+"','"+locid+"'),0) from dual");
				var invqty = db.GetSQL("select decode(GENINVQTY('"+itmid+"','"+locid+"'),0,200,GENINVQTY('"+itmid+"','"+locid+"')) from dual"); 
				if(invqty == 0) 
					throw new Exception("商品："+itmid+"在仓库："+locid+"无可开库存，可能已被占用！"); 
				//税率
				sql = "select to_number(nvl((select potax from item where id='"+itmid+"'),0.17)) TAX from dual";
				tax = db.GetSQL(sql);
				//确定单据的唯一键
				keyStr = locid+"#"+ordid+"#"+tax;
				//从单据库中取出单据
				if(!map.containsKey(keyStr))
				{
					saleBil = db.GetBillid(acc,"EB","EB");
					map.put(keyStr,saleBil);
				}
				else
					saleBil = map.get(keyStr);
				//从单据明细库中取中相应的明细号
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
					        to_number('"+tax+"') TAX,a.sprice*(1+to_number('"+tax+"'))*qty/(1+to_number('"+tax+"')) NOTAXMNY /*不含税单价*/,
					        a.sprice*(1+to_number('"+tax+"'))*to_number('"+tax+"') TAXMNY ,sprice*(1+to_number('"+tax+"'))*qty MNY,'' REFID1/*折扣不含税额*/,'' REFNAM1/*折扣*/,
					       /* decode(GENPROTPRICE('"+itmid+"',a.scorpid,'"+dat+"'),sprice,'1','0')*/i.price REFID2,/*nvl(GENKAPRICE('"+itmid+"',scorpid),i.PRICE)*/i.price REFNAM2 /*原始单价*/,'' DATFLW,i.smlunt SMLUNT,
					        trim(a.deptid) ITEMPC/*借用字段存放部门*/,'' REFID3,'' REFNAM3,'' REFID4,'' REFNAM4,
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
	//插完单据明细表（bildtl）后可根据单据明细表构造单据头信息表
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
				       sum(bl.qty) SUMQTY,sum(bl.mny) SUMMNY,'"+tax+"' REFID1/*税率*/,'"+ordid+"' REFNAM1/*对方订单号*/,
				       /*(select usrid from v_kausr where kaid=c.refid) */ ''REFID2/*业务员编号*/, '' REFNAM2/*对应的单据号*/,
				       /*(select addr from v_onlyaddr where id=c.id)*/'' REFID3 /*送货地址*/,to_char(sysdate+1,'yyyy-mm-dd') REFNAM3/*送货日期*/,
				       '' REFID4 /*临时客户名称*/,'1' REFNAM4 /*送货标志*/,'0' REFID5/*是否已签单*/,/*(select usrname from v_kausr where kaid=c.refid)*/'' REFNAM5/*业务员名称*/,
				       trim(bl.itempc) REFID6/*合同编号*/,(select name from v_dept b where b.id=trim(bl.itempc)) REFNAM6/*合同名称*/
				   from bildtl bl,corp c
				  where bl.corpid = c.id
				    and bl.acc = '"+acc+"'
				    and bl.bilid = '"+sobil+"'
				    and bl.biltyp = '"+saleClass+"'
				  group by bl.acc, bl.BILID, bl.BILTYP,c.id, c.name,c.refid,bl.itempc			
			";
			db.ExcecutSQL(sql);
			//生成单据后要把订单表的生成销售数量回写
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
			//如果生成的数量跟订单相等要把状态设为已处理
			sql = " update ord_tmp set stat='1' where ordid='"+ordid+"' and qty = traqty";
			db.ExcecutSQL(sql);
		}
	     }		   
	return ret;
}













}
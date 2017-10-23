function x_SelEBOrder(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
//================================================================// 
// 函数：getTreeXml
// 说明：返回树控件的xml
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：06/02/10 10:43:54
// 修改日志：
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
		      	
		//订单数量与已处理数量相等并且处理状态为1(已处理)
		sql = "select distinct ordid from ord_tmp where qty<>nvl(traqty,0) and  nvl(stat,'0') <> '1' and dat ='"+dat+"' and kaid='"+ka+"'\n";
		var cds = db.QuerySQL(sql);
		var sCount = cds.getRowCount();
		xml += "<未处理("+sCount+")>\n";		
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
				ordid = ords.getStringDef(i,"ORDID","未找到");
				xml += "<"+ordid+" id='"+ordid+"' stat='0'/>";
			}				

			xml += "</"+scorpnam+">";

		}
		//xml += "<当天全部 id='all'/>";
		xml += "<无对应客户 id='nocorp'/>";
		xml += "<无对应商品 id='noitem'/>";				
		xml += "<价格不一致 id='diffprice'/>";
		xml += "<到货日期是当天/>";
		xml += "</未处理>\n";
		sql = "select distinct ordid from ord_tmp where (qty=nvl(traqty,0) or stat=1) and dat ='"+dat+"' and kaid='"+ka+"'\n";
		var tds = db.QuerySQL(sql);
		var tCount = tds.getRowCount();
		xml += "<已处理("+tCount+")>\n";		
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
				ordid = ords.getStringDef(i,"ORDID","未找到");
				xml += "<"+ordid+" id='"+ordid+"' stat='1'/>";
			}				

			xml += "</"+scorpnam+">";

		}

		xml += "</已处理>\n";	
		xml += "</"+dat+">";	
		db.Commit();
		return xml;
	}catch(Exception e){
		db.Rollback();
		throw new Exception(e);
	}
}

//================================================================// 
// 函数：ModifyPrice
// 说明：更新开单价格，当价格维护进去的时候可以不用刷新整个页面
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：06/02/10 10:26:06
// 修改日志：
//================================================================// 
function ModifyPrice()
{
	var db = null;
	var sql = "";
	try{
		db = new pubpack.EADatabase();
		//更新基础信息：
		//更新基础价格,同样已处理的订单不再做处理
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
// 函数：ModifyBaseInfo
// 说明：更新基础信息，当基础维护进去的时候可以不用刷新整个页面
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：06/02/10 10:25:24
// 修改日志：
//================================================================// 
function ModifyBaseInfo()
{
	var db = null;
	var sql = "";
	try{
		db = new pubpack.EADatabase();
		//更新基础信息：	
		//更新客户,商品信息已经处理过的订单，或强制结束的订单不处理
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
// 函数：getListData
// 说明：返回原始订单明细数据的分页xml
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：06/02/10 10:24:50
// 修改日志：
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
// 函数：closeOrder
// 说明：强制结束订单,未处理完的订单，打上一个结束的标志
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：06/02/10 10:24:12
// 修改日志：
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
//查询该用户是否绑定库存
function IsLoc(){
	var IsLoc="1";
	return IsLoc;
}










}
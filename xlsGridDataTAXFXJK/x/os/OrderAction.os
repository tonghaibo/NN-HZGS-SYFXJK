function x_OrderAction(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var iopack = new JavaPackage("java.io");
var utilpack = new JavaPackage("java.util");
//================================================================// 
// 函数：doStrToDB
// 说明：把服务器返回的字符串插入数据库
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：05/18/10 11:30:09
// 修改日志：
//================================================================// 
var EBID = 4;//订单单据号对应的列号
var EBSEQ = 12;//订单单据明细号对应列号
var EBKA = 2;
var MidTab = "ORD_TMP";//订单中间表
function doStrToDB()
{
	var db = null;
	var br = null;
	var ds = null;
	var s = "";
	var sql = "";
	var pstmt = null;
	var msg = 0;
	var map = new utilpack.HashMap();	
	var row = null;//字符串中的每一行都是一张订单的商品明细,商品明细中以"~~~"分割的数组
	try{
		db = new pubpack.EADatabase(); 
		br = new iopack.BufferedReader(new iopack.StringReader(str));
		while((s = br.readLine())!=null)
		{
			row = s.split("~~~");
			sql = "select * from ord_tmp where ordid='"+row[EBID]+"' and seqid='"+row[EBSEQ]+"'";
			var tmpds = db.QuerySQL(sql);
			if (tmpds.getRowCount()==0)
			{
				if(map.containsKey(row[EBKA]))
				{
					var tmp = map.get(row[EBKA]);
					tmp += row[EBID];
					map.remove(row[EBKA]);
					map.put(row[EBKA],row[EBID]);
				}
				else{
					map.put(row[EBKA],row[EBID]);
				}
				//这里要过滤掉如果订单每一个商品明细对应的订单单据号与订单明细号在数据库如果有存在就不做插入数据库的动作
				sql = " insert into "+MidTab+" a(srflg,userid,deptid,kaid,bilid,ecorpnam,ecorpid,itmclass,ordid,dat,arrdat,tel,fax,seqid,eitmid,code,spec,eitmnam,untnum,qty,zpqty,eprice) 
				        values(trim(?),trim(?),trim(?),trim(?),trim(?),trim(?),trim(?),trim(?),trim(?),to_char(to_date(?,'dd/mm/yyyy'),'yyyy-mm-dd'),to_char(to_date(?,'dd/mm/yyyy'),'yyyy-mm-dd'),trim(?),trim(?),trim(?),trim(?),trim(?),trim(?),trim(?),to_number(?),to_number(?),to_number(?),to_number(?,'999999.9999'))
				       ";
				//throw new Exception (sql);
				pstmt = db.GetConn().prepareStatement(sql);	
						
				if(tmpds.getRowCount()==0)			
				{
					//var xyz="";
					for ( var r=0;r<row.length();r++)
					{					
						pstmt.setString(r+1,row[r]);	
						//xyz+=(r+1)+":"+row[r]+"|";
					}
					//throw new Exception(xyz);
					pstmt.addBatch();
					msg++;
				}
				pstmt.executeBatch();
			}														
		 }		
		 var set = map.keySet();
		 var it = set.iterator();
		 while(it.hasNext())
		 {
		 	var ka = it.next();
		 	sql = " insert into msg(title,note)values('"+ka+"'||'新订单','"+ka+"'||'新订单明细：'||'"+map.get(ka)+"')";
		 	db.ExcecutSQL(sql);
		 }
		db.Commit();
		return msg;
	}catch(e){
		db.Rollback();
		throw new Exception(e);
	}	 
	finally{
		if(br!=null) 
			br.close();
	}
} 
function SendSMS(){
	var msg = "";
	var eaSms= new pubpack.EASendSMS();
	
	var i=eaSms.SendSMS( phone,sms);
	//eaSms.CloseChannel();
	var balance=eaSms.getBalance();

	msg = i+"发送短信成功"+balance;
	
	return msg;
}

function getStr(){
	var func = new x_WG_Currefour();
	//var ret = func.getOrderStr(acc,dat,kaid,userid,passwd,deptid,code);//抓下来的订单的字符串 
	var ret = func.getOrderStr(acc,dat,kaid,userid,passwd,deptid,code);//抓下来的订单的字符串 

	return ret;
}

}
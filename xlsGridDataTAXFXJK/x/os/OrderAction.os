function x_OrderAction(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var iopack = new JavaPackage("java.io");
var utilpack = new JavaPackage("java.util");
//================================================================// 
// ������doStrToDB
// ˵�����ѷ��������ص��ַ����������ݿ�
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�05/18/10 11:30:09
// �޸���־��
//================================================================// 
var EBID = 4;//�������ݺŶ�Ӧ���к�
var EBSEQ = 12;//����������ϸ�Ŷ�Ӧ�к�
var EBKA = 2;
var MidTab = "ORD_TMP";//�����м��
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
	var row = null;//�ַ����е�ÿһ�ж���һ�Ŷ�������Ʒ��ϸ,��Ʒ��ϸ����"~~~"�ָ������
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
				//����Ҫ���˵��������ÿһ����Ʒ��ϸ��Ӧ�Ķ������ݺ��붩����ϸ�������ݿ�����д��ھͲ����������ݿ�Ķ���
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
		 	sql = " insert into msg(title,note)values('"+ka+"'||'�¶���','"+ka+"'||'�¶�����ϸ��'||'"+map.get(ka)+"')";
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

	msg = i+"���Ͷ��ųɹ�"+balance;
	
	return msg;
}

function getStr(){
	var func = new x_WG_Currefour();
	//var ret = func.getOrderStr(acc,dat,kaid,userid,passwd,deptid,code);//ץ�����Ķ������ַ��� 
	var ret = func.getOrderStr(acc,dat,kaid,userid,passwd,deptid,code);//ץ�����Ķ������ַ��� 

	return ret;
}

}
function x_WG_RtMart(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var util = new JavaPackage("java.util");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var EAfunc = new pubpack.EAFunc();
var HtmlParser = new x_WG_HtmlParser();
var protocolpack = new JavaPackage("org.apache.commons.httpclient.protocol");
function start()
{
	return getOrderStr("jqpx","2011-05-13","0001","rt23886","6969","5","GBK");
}
var order = new pubpack.EAXmlDS();
var row = -1;

function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code)
{ 
	var db = null;
	code = "GBK";
	try{
		db = new pubpack.EADatabase();
		var map = new util.HashMap();
		var httpcall = new webget.HttpCall();	
		
		var myhttps = new protocolpack.Protocol("https", new webget.MySecureProtocolSocketFactory(), 443); 
		protocolpack.Protocol.registerProtocol("https", myhttps);
					
		//��½ҳ��
		var ret = httpcall.Get("https://supplier.rt-mart.com.cn/index.php",code);
		//��̨��֤ҳ��
		ret = httpcall.Get("https://supplier.rt-mart.com.cn/php/scm_login_check.php?area=1&userid="+userid+"&passwd="+passwd+"&image.x=15&image.y=12",code);
		//��½�����ҳ��
		ret = httpcall.Get("https://supplier.rt-mart.com.cn/php/scm_main.php",code);
		//��������´�
		ret = httpcall.Get("https://supplier.rt-mart.com.cn/php/scm_basic.php?status=0",code);
		//ȡ����Ҫ�´��Ķ����б�����Map������
		var rootlist = HtmlParser.parserHtml(ret,code);
		var aTagList = HtmlParser.filterHtml(rootlist,"A");
		var attr = "";
		for (var i = 0;i<aTagList.size();i++)
		{
			var aTag = aTagList.elementAt(i);
			attr = aTag.getAttribute("class");
			if (attr!="" && attr!=null && attr.equals("class1"))
			{
				map.put(aTag.toPlainTextString().trim()+"_"+i,aTag.getAttribute("href"));
			}							
		}
		//����Map�����д��ڵĶ�������Ӧ�Ķ�����ϸ�б�
		var host = "https://supplier.rt-mart.com.cn/php/";
		var ordlist = map.keySet();
		var it = ordlist.iterator();
		var row = -1;
		while(it.hasNext())
		{
			var ordid = it.next();
			if (ordid != "")
			{
				var url = host+map.get(ordid);
				//������ϸ(���)�б�
				ret = httpcall.Get(url,code);
				//�����ӡ����
				//+"&store_no=999&ord_no="+ordid
				//��ԭordid
				ordid = ordid.split("_")[0];
				ret = httpcall.Get(host+"scm_temp_print.php?URL=scm_basic_print.php&"+url.split("&")[1]+"&ord_no="+ordid+"&sup_no="+passwd,code);
				var params = "code=&InputDate=&key=&key1=&key2=&ord_no="+ordid+"&orderby=&pay_date=&pay_group=&pcode=&"+url.split("&")[1]+"&type="; 
				var srcode = httpcall.Post(host+"scm_basic_print.php",params,code);
				parserOrderList(db,srcode,order,code,ordid,userid,kaid,deptid);
			}
		}
		
		return HtmlParser.parserDsToString(order,"","","");								 
	
	}catch(e){
		throw new Exception(e);
	}
	finally
	{
		if(db != null)
			db.Close();
	}
}


function parserOrderList(db,srcode,order,code,ordid,userid,kaid,deptid)
{
	//��ʼ��������
	var nodelist = HtmlParser.parserHtml(srcode,code);
	var tablist = HtmlParser.filterHtml(nodelist,"TABLE");
	var title1 = HtmlParser.parserTable(tablist,code,new Array(1),"T");
	var title2 = HtmlParser.parserTable(tablist,code,new Array(3),"T");
	
	//���<TH>�е�����
	var cont = HtmlParser.ReplaceStrToNull(tablist.elementAt(3).toPlainTextString().trim(),new Array("&nbsp;"));
	var corpnam = cont.substring(cont.indexOf("�����ص�")+6,cont.indexOf("��ַ")).trim();
	var listnode = tablist.elementAt(7);
	var rows = listnode.getRows();
	var s = "";
	var seq = 1;
	for (var r = 2;r < rows.length();r++)
	{
		var cols = rows[r].getColumns();
		var count = cols.length();
		var ordid = "";
		if (count > 3)
		{
			row = order.AddNullRow(row);
			order.setValueAt(row,"CODE",HtmlParser.ReplaceStrToNull(cols[0].toPlainTextString().trim(),new Array("&nbsp;","/"))); 
			order.setValueAt(row,"EITMID",HtmlParser.ReplaceStrToNull(cols[1].toPlainTextString().trim(),new Array("&nbsp;","/")));
			order.setValueAt(row,"EITMNAM",HtmlParser.ReplaceStrToNull(cols[2].toPlainTextString().trim(),new Array("&nbsp;","/")));
			order.setValueAt(row,"SPEC",HtmlParser.ReplaceStrToNull(cols[3].toPlainTextString().trim(),new Array("&nbsp;","/")));   			
			var qty = HtmlParser.ReplaceStrToNull(cols[4].toPlainTextString().trim(),new Array("&nbsp;","/"));
			if(qty.indexOf("(") > -1)
			{
				order.setValueAt(row,"QTY",qty.substring(0,qty.indexOf("(")));
				var untnum = (1 * qty.substring(0,qty.indexOf("(")))/(1 * qty.substring(qty.indexOf("(")+1,qty.length()-1));
				order.setValueAt(row,"UNTNUM",untnum);
			}
			else
			{
				order.setValueAt(row,"QTY",qty);
				order.setValueAt(row,"UNTNUM",1);
			}
			order.setValueAt(row,"ZPQTY","0");
			order.setValueAt(row,"QTYFLG","N");
			order.setValueAt(row,"SEQID",seq);
			order.setValueAt(row,"EPRICE","0");
			order.setValueAt(row,"SRFLG","NR");
			order.setValueAt(row,"USERID",userid);
			order.setValueAt(row,"KAID",kaid);
			order.setValueAt(row,"DEPTID",deptid);
			order.setValueAt(row,"ECORPNAM",corpnam);
			order.setValueAt(row,"ECORPID",corpnam);
//			order.setValueAt(row,"ORDCONTENT",srcode); 
			//����ͷ������<1>		
			for (var a = 0; a < title1.length(); a++)
			{
				if (title1[a].split(":").length()> 1)
				{				
					var key = HtmlParser.ReplaceStrToNull(title1[a].split(":")[0],new Array("&nbsp;"));
					var val = HtmlParser.ReplaceStrToNull(title1[a].split(":")[1],new Array("&nbsp;"));
					if (key.indexOf("��������")>-1)	order.setValueAt(row,"DAT",db.GetSQL("select to_char(to_date('"+val+"','yyyy-mm-dd'),'dd/mm/yyyy') from dual "));
					if (key.indexOf("��������")>-1) { order.setValueAt(row,"ORDID",val); order.setValueAt(row,"BILID",val);}
					//��Ϊ���󷢵Ķ�����������Ч�ģ�û���ͻ����ڵ�
					//order.setValueAt(row,"ARRDAT",db.GetSQL("select to_char(to_date('"+val+"','yyyy-mm-dd'),'dd/mm/yyyy') from dual "));
					if (key.indexOf("��������")>-1) order.setValueAt(row,"ARRDAT","31/12/2099");
					//order.setValueAt(row,"NOTE",HtmlParser.ReplaceStrToNull(val,new Array("&nbsp;","")))
					if (key.indexOf("��ע")>-1) order.setValueAt(row,"NOTE","");
				}	
				
			}
				//return s;
			//����ͷ������<2>
			//throw new Exception(title2.length());
			for (var b = 0; b < title2.length(); b++)
			{
				if (title2[b].split("��").length()>1)
				{
					var key = HtmlParser.ReplaceStrToNull(title2[b].split("��")[0],new Array("&nbsp;"));
					var val = HtmlParser.ReplaceStrToNull(title2[b].split("��")[1],new Array("&nbsp;"));
					if (key.indexOf("��ַ")>-1) order.setValueAt(row,"CORPADDR",val);
					if (key.indexOf("�绰")>-1) order.setValueAt(row,"TEL",val);
					if (key.indexOf("����")>-1) order.setValueAt(row,"FAX",val);
				}	
			}
			seq++;	
		}
	}
	 
	return order;
	
} 

}
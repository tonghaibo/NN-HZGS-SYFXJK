function x_WG_TescoBak(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var pub = new JavaPackage("com.xlsgrid.net.pub");
var protocolpack = new JavaPackage("org.apache.commons.httpclient.protocol");
var EAfunc = new pubpack.EAFunc();
var HtmlParser = new x_WG_HtmlParser();
var httpcall = new webget.HttpCall();
var HtmlParser = new x_WG_HtmlParser();
//var order = new pubpack.EAXmlDS();
//var row = -1;

var msg = "";

function start()
{
	return getOrderStr("GMHD","2014-01-17","0007","10000704","654321","dept","utf-8");
}

function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code)
{
	var ret = "";
	var param = "";
	var url = "";
	var db="";
	var sql="";
	var msg="";
	try
	{
	       db=new pubpack.EADatabase();
	       //�������û���������ڣ������ʽ����ǿ�Ƹ�Ϊutf-8
	       code="utf-8";
	       var dat1=dat;
	       var dat2=dat;
		url = "https://tesco.chinab2bi.com";
		ret = httpcall.Get(url+"/mainLogon.hlt",code);
		param = "j_captcha=&j_username="+userid+"&j_password="+passwd+"&Submit=   ��¼" ;
		ret = httpcall.Post(url+"/j_spring_security_check",param,code);
		//������Ӧ�̱����Ҫ������1-------12255751
		param = "downFlag=&readFlag=&page.jumpNumber=1&page.pageNo=1&page.totalPages=2&page.pageSize=100&orderDateStart="+dat1+"&orderDateEnd="+dat1+"&parentVendor=100255&vendor=12255751&page.togglestatus=null&status=sell" ;
		ret = httpcall.Post(url+"/tesco/sp/purOrder/sellPubOrderQry.hlt",param,code);//��ѯ
	        ret =GetBillist(ret,httpcall,userid,dat,deptid,kaid,code);
	        msg+=ret ;
	        //1-------12256086
	        param = "downFlag=&readFlag=&page.jumpNumber=1&page.pageNo=1&page.totalPages=2&page.pageSize=100&orderDateStart="+dat1+"&orderDateEnd="+dat1+"&parentVendor=100255&vendor=12256086&page.togglestatus=null&status=sell" ;
		ret = httpcall.Post(url+"/tesco/sp/purOrder/sellPubOrderQry.hlt",param,code);//��ѯ
	        ret =GetBillist(ret,httpcall,userid,dat,deptid,kaid,code);
	        msg += "��";
 		msg+=ret ;
	        
	       // return ret; 
	}
	catch(e)
	{
	 	db.Rollback();
		throw new Exception(e);
	}
	finally{
		if(db!=""){
			db.Close();
		}
	}
	//throw new Exception(msg);
	return msg;
}

//�ݹ飬ȡ�������б�
function GetBillist(node,httpcall,userid,dat ,deptid,kaid,code)
{
	
			 /*  ���嶩������Ʒ��Ϣ  ds��ʽ
					<ROW num="1" >
						<_���>2</_���>
						<_��Ӧ�̱��>100255</_��Ӧ�̱��>
						<_��Ӧ��8λ���>12255751</_��Ӧ��8λ���>
						<_��Ӧ������>�Ϻ���ǿ�̲��ǾƼ�����������</_��Ӧ������>
						<_֪ͨ����>2012-12-21</_֪ͨ����>
						<_֪ͨ״̬>���Ķ�</_֪ͨ״̬>
						<_����״̬>������</_����״̬>
						<_���һ�η���IP>218.242.148.242</_���һ�η���IP>
						<_������ʱ��>2012-12-2413:34</_������ʱ��>
						<_�������IP>218.242.148.242</_�������IP>
						<_�������ʱ��>2012-12-2413:34</_�������ʱ��>
						<_����>"#"onclick="openPDF('2050606','100255','MERGE_12255751@supplier.cn.tesco.com_20121221132444.txt','2012-12-2113:29:08.0')">[��ϸ]</_����>
						<_����__����>"#"onclick="downPDF('2050606','100255','MERGE_12255751@supplier.cn.tesco.com_20121221132444.txt','2012-12-2113:29:08.0')">[PDF����]</_����__����>
					</ROW>
			*/
			
			node=pub.EAFunc.Replace(node,"<th>","<td>");//�滻
			node=pub.EAFunc.Replace(node,"</th>","</td>");//�滻
			node=pub.EAFunc.Replace(node,"<a href=","");//�滻
			node=pub.EAFunc.Replace(node,"</a>","");//�滻
			
			var nodelist = HtmlParser.parserHtml(node,code); 
			var tablist = HtmlParser.filterHtml(nodelist,"table"); 
			var ds = HtmlParser.parserTableOne(tablist,code,new Array("5"));
			//throw new Exception(ds.GetXml());
			//��������ĵ���
			var url="https://tesco.chinab2bi.com";
			var param="";
			var createDate="";
			var str ="";
			var fileName="";
			var poid="";
			var parentVendor="";
			for (var r=0;r<ds.getRowCount();r++){ 
				str=ds.getStringAt(r,"_����");
				str=str.substring(str.indexOf( "(" )+1,str.indexOf( ")" ));
				var strsplits =str.split(",");
				//strsplits[0] =2054340
				//strsplits[1] =100255
				//strsplits[2] =MERGE_12255751@supplier.cn.tesco.com_20121221185044.txt
				//strsplits[3] =2012-12-2118:58:59.0
				createDate=strsplits[3];
				createDate=createDate.substring(1,11);
				createDate=pub.EAFunc.Replace(createDate,"-","");//�滻
				fileName=strsplits[2];
				fileName=fileName.substring(1,fileName.length()-1);
				poid=strsplits[0];
				poid=poid.substring(1,poid.length()-1);
				parentVendor=strsplits[1];
				parentVendor=parentVendor.substring(1,parentVendor.length()-1);
				param="seed&fileName="+fileName+"&createDate="+createDate+"&poId="+poid+"&parentVendor="+parentVendor+"";
				var txt = httpcall.Post(url+"/tesco/sp/purOrder/pdfView.hlt",param,code);
				if(msg != "")
		          	msg += "��";
		          	msg += parseOneBill(httpcall,txt,userid,deptid,kaid);
				
			}
			return msg ;
   }

//����һ�ŵ���
//httpcall
//str�����ݵ��ı�
//���أ��ַ����ָ���ַ�
function  parseOneBill(httpcall,str,userid,deptid,kaid)
{
      /**
	*		               TESCO ��  ��  ��  Ʒ  ��  ��
	*	    ���:  �Ϻ��󻪵�                     ҳ1  ҳ
	*	����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
	*	  ��������  12000323          ��������                    ��������                  
	*	  ��������  2012/12/21        ��������  2012/12/25        ��������  -DSD PO-        
	*	  ��  ��    66405003          ��  ��                                                
	*	  ��  ַ    �Ϻ���·518��                               ��  ��                    
	*	  ���̱��  12255751                                      ��  ��    �Ϻ���ǿ�̲��ǾƼ�����������-
	*	  ��  ��    02158357527       ��  ��    02158203461       �� ϵ ��  ��ݼ            
	*	  ��  ַ    �ֶ���������·579��9¥�����������            ��  ��    200120          
	*	  ��  ע                                                
	*	����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
	*	 ��Ʒ����/       Ʒ��                           ���     ����   ��   �����ɱ�     �ɱ�   �ܳɱ� ��������     Ӧ�� Ӧ������  ����     ����
	*	 ������Ʒ����                                   �������� ��λ   ����                            ��������     ���� ����      (Ti Hi)  Ʊ��
	*	����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
	*	 150502662/      SP_24_52�������Ͻ�ͷ��1        ƿ       ��       24     9.23   221.54   221.54        1        1       24    1    1 N   
	*	 103067890       25ml/ƿ                        6901798132611                                       0.00                             Y   
	*
	*	����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
	*	 Terms & Conditions /  ��ע :                                                    
	*	 1.�ջ�ʱ�� ��һ������5 30-19 00 ����5 30-12 00 ������ڼ���һ������8 00-21 00
	*	 ......
	*	 9.��Ʒ���۲�������Ӧ������Ʒ������ͬ�г�ŵ������ۿ�!
	*	����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
	*/
	var ret = str; 
	var title_param = "TESCO ��  ��  ��  Ʒ  ��  ��\n";
	var title_params = ret.split(title_param);                         
	var line = "����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������\n";
	var msgs = "";
	for(var r = 1;r < title_params.length();r ++)
	{
		
		var lines = title_params[r].split(line);
		var corpnam = lines[0].substring(lines[0].indexOf(":")+3,lines[0].indexOf("ҳ")); 
		corpnam  = EAfunc.regexReplace(corpnam , "\\s+","");
		
		var bilid = lines[1].substring(lines[1].indexOf("��������")+6,lines[1].indexOf("��������"));//�������
		bilid = EAfunc.regexReplace(bilid, "\\s+","");
		var date = lines[1].substring(lines[1].indexOf("��������")+6,lines[1].indexOf("��������"));//��������
		date = EAfunc.regexReplace(date, "\\s+","");
		//dd/mm/yyyy
		var _date = date.split("/")[2]+"/"+date.split("/")[1]+"/"+date.split("/")[0];
		var addrdate = lines[1].substring(lines[1].indexOf("��������")+6,lines[1].indexOf("��������"));//��������
		addrdate = EAfunc.regexReplace(addrdate, "\\s+","");
		if (addrdate == "") addrdate = date;
		var _addrdate = addrdate.split("/")[2]+"/"+addrdate.split("/")[1]+"/"+addrdate.split("/")[0];
		var tel = lines[1].substring(lines[1].indexOf("��  ��")+6,lines[1].indexOf("��  ��"));//�绰
		tel = EAfunc.regexReplace(tel, "\\s+","");
		var fax = lines[1].substring(lines[1].indexOf("��  ��")+6,lines[1].indexOf("��  ַ"));//����
		fax = EAfunc.regexReplace(fax, "\\s+","");
		var addr = lines[1].substring(lines[1].indexOf("��  ַ")+6,lines[1].indexOf("��  ��"));//��ַ
		addr = EAfunc.regexReplace(addr, "\\s+","");
//		throw new Exception("corpnam"+corpnam+",bilid="+bilid+",date="+_date+",addrdate="+_addrdate+",tel="+tel+",fax="+fax+"\n,addr="+addr);
                //˫���������\r�����з�
		var details = lines[3].split("\n");
		//throw  new Exception(lines[1]);
		var count = 1;
		for(var details_r = 0;details_r < details.length();details_r++)
		{
			if(details[details_r].length() > 0&&details[details_r] != "������")
			{
				var detail = EAfunc.regexReplace(details[details_r] , "\\s+",",");//ץ��ϸ
				var detail1 = EAfunc.regexReplace(details[details_r+1] , "\\s+",",");//ץ��ϸ
//				,102717619/,Ҭ��¹���һ��33��/500,ƿ,��,12,-,-,12.00,-,12.00,12.00,1,1,***,6901160007073,ml/ƿ,0.00,	
				var itmid = detail.split(",")[1];
			
				var _itmnam = "";
				var zpqty = "";
			
				if(detail1.split(",").length() > 2)
					_itmnam = detail1.split(",")[2];
				zpqty = detail1.split(",")[detail1.split(",").length()-2];

//				if((detail1.split(",")[3]).indexOf(".") == -1)
//				{
//					_itmnam = detail1.split(",")[2];
//					zpqty = detail1.split(",")[4];
//				}
//				else
//				{
//					zpqty = detail1.split(",")[3];
//				}
			
				if(msgs != "")
				 	msgs += "��";
				//srflg,userid,deptid,kaid,bilid,ecorpnam,ecorpid,itmclass,ordid,dat,arrdat,tel,fax,seqid,eitmid,code,spec,eitmnam,untnum,qtyflg,qty,zpqty,eprice,corpaddr,note,EBOPTION,org
				//&100143587&���֮����ǿ������(&��&EA&12&12.00&0&12.00&1&1&ԭζ)/11g/��
				//SRFLG~~~USERID~~~DEPTID~~~KAID~~~BILID~~~ECORPNAM~~~ECORPID~~~ITMCLASS~~~ORDID~~~DAT~~~ARRDAT~~~
				//TEL~~~FAX~~~SEQID~~~EITMID~~~CODE~~~SPEC~~~EITMNAM~~~
				//QTYFLG~~~UNTNUM~~~QTY~~~ZPQTY~~~EPRICE~~~CORPADDR~~~NOTE~~~NULL
				msgs += "NR ~~~"+userid+"~~~"+deptid+"~~~"+kaid+"~~~"+bilid+"~~~"+corpnam+"~~~"+corpnam+"~~~ ~~~"+bilid+"~~~"+_date+"~~~"+_addrdate+"~~~"+
					tel+"~~~"+fax+"~~~"+count+"~~~"+itmid.substring(0,itmid.length()-1)+"~~~ ~~~"+detail.split(",")[3]+"~~~"+detail.split(",")[2]+_itmnam+
					"~~~ ~~~"+detail.split(",")[5]+"~~~"+detail.split(",")[9]+"~~~"+zpqty+"~~~"+detail.split(",")[6]+"~~~"+addr+"~~~ ~~~ ";
				count ++;
				details_r++;
			}
		}
	}
	return msgs;

}

//���ַ����е�ĳЩ�ַ��滻��""
function ReploaceStatment(str,array)
{
	
	for(var r = 0;r < array.length() ;r ++)
	{
		var replacestatment = array[r];
		while(true)
		{
			if (str.indexOf(replacestatment)>-1)			
				str = EAfunc.Replace(str,replacestatment,"");	
			else
			     break;
		}
	}
	return str;
}

function DeleteSameStatment(str,replacement1,replacement2)
{
	var strs = str.split(replacement1);
	var strs_1 = strs[1];
	for(var r = 2;r < strs.length()-1;r ++)
	{
		if(strs[r+1] == replacement2&&strs[r] == strs[r+1])
		{
			strs[r] = EAfunc.Replace(strs[r],replacement2,"");
			strs_1 += strs[r];
		}
		else
			strs_1 += strs[r];
	}
	return strs_1;
}


}
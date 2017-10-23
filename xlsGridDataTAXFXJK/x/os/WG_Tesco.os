function x_WG_Tesco(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var protocolpack = new JavaPackage("org.apache.commons.httpclient.protocol");
var EAfunc = new pubpack.EAFunc();
var HtmlParser = new x_WG_HtmlParser();
//var order = new pubpack.EAXmlDS();
//var row = -1;

var msg = "";

function start()
{
	return getOrderStr("GMHD","2013-01-21","0007","10000704","654321","dept","utf-8");
}

function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code)
{
	var ret = "";
	var param = "";
	var url = "";
	try
	{
		var myhttps = new protocolpack.Protocol("https",new webget.MySecureProtocolSocketFactory(),443);   // CarrefourFactory
		protocolpack.Protocol.registerProtocol("https",myhttps);
		var httpcall = new webget.HttpCall();
		ret = httpcall.Get("https://mailsupplier.cn.tesco.com/exchweb/bin/auth/owalogon.asp?url=https://mailsupplier.cn.tesco.com/exchange&reason=0",code);
		//1.��¼
		var loginurl="https://mailsupplier.cn.tesco.com/exchweb/bin/auth/owaauth.dll";
		var params = "destination=https://mailsupplier.cn.tesco.com/exchange&flags=0&username="+userid+"&password="+passwd+"&SubmitCreds=��¼&forcedownlevel=0&trusted=0";
//		ret = httpcall.Post(loginurl,"flags=0&username="+userid+"&password="+passwd+"&destination=https://mailsupplier.cn.tesco.com/exchange/",code);
		ret = httpcall.Post(loginurl,params,code);
//		throw new Exception(ret);
	        //2.ͨ��WebDAV�õ��ʼ��б�
	        var pageurl="https://mailsupplier.cn.tesco.com/exchange/"+userid+"/Inbox/";//?Cmd=contents
	        if(userid=="12256086"||userid=="12255751") //��������֪��Ϊʲô��Ҫ2��SEARCH���
	        	pageurl="https://mailsupplier.cn.tesco.com/exchange/"+userid+"/%E6%94%B6%E4%BB%B6%E7%AE%B1//";//?Cmd=contents	        
//	        var pageurl="https://mailsupplier.cn.tesco.com/exchange/"+userid+"/#";
	        var pagedata = "<searchrequest xmlns=\"DAV:\"><sql>SELECT \"http://schemas.microsoft.com/exchange/smallicon\" as smicon, \"http://schemas.microsoft.com/mapi/sent_representing_name\" as from, \"urn:schemas:httpmail:datereceived\" as recvd, \"http://schemas.microsoft.com/mapi/proptag/x10900003\" as flag, \"http://schemas.microsoft.com/mapi/subject\" as subj, \"http://schemas.microsoft.com/exchange/x-priority-long\" as prio, \"urn:schemas:httpmail:hasattachment\" as fattach,\"urn:schemas:httpmail:read\" as r, \"http://schemas.microsoft.com/exchange/outlookmessageclass\" as m, \"http://schemas.microsoft.com/mapi/proptag/x10950003\" as flagcolor "+
				" FROM Scope('SHALLOW TRAVERSAL OF \"\"')"+
				" WHERE \"http://schemas.microsoft.com/mapi/proptag/0x67aa000b\" = false AND \"DAV:isfolder\" = false"+
				" ORDER BY \"urn:schemas:httpmail:datereceived\" DESC"+
				" </sql><range type=\"row\">0-24</range></searchrequest>";
//	        msg=pageurl;
//		msg += httpcall.Search(pageurl,pagedata,"GBK");
//		return pagedata ;
		var node =  httpcall.SearchAndParse(pageurl,pagedata,code);//"GBK");
		
	        return GetBillist(node,httpcall,userid,dat,deptid,kaid);
	}
	catch(e)
	{
//		return e;
		throw new Exception(e);
	}
//	return msg;
}

//�ݹ飬ȡ�������б�
function GetBillist(node,httpcall,userid,dat ,deptid,kaid)
{
	var nodename=""+node.getNodeName();
//	throw new Exception(nodename);
//	msg+="["+nodename+"[";
	if ( "a:href" == nodename ||"A:HREF" ==nodename ) {
	        var url = node.getFirstChild().getNodeValue();
	        var frameHtml= httpcall.Get(url,"UTF-8") ;
	        var BASE="";
	        //ֱ�����ַ���λ�ҳ�FRAME�����Ŀ��URL
	        var loc1 = frameHtml.indexOf("<BASE");
	        if( loc1>=0) {
	          loc1=frameHtml.indexOf("href=\"",loc1+1);
	          BASE= frameHtml.substring(loc1+6,frameHtml.indexOf("\"",loc1+8));
	        }	       
	        var FRAMESRC="";
	        loc1 = frameHtml.indexOf("<FRAME");
	        if(loc1>=0) loc1=frameHtml.indexOf("<FRAME",loc1+10);//��2��
	        if(loc1>=0) loc1=frameHtml.indexOf("<FRAME",loc1+10);//��3��
	        if( loc1>=0) {
	          loc1=frameHtml.indexOf("src=\"",loc1+1);
	          FRAMESRC= frameHtml.substring(loc1+5,frameHtml.indexOf("\"",loc1+8));
	        }
	        var orderHtml= httpcall.Get(BASE+FRAMESRC,"UTF-8");
	        //�ҳ�����ʱ��   ����ʱ��:&nbsp;</TD> <TD><NOBR>2011-3-27 (������) 17:01
	        var billdat = "";
	        loc1 = orderHtml.indexOf("����ʱ��:");
	        if( loc1>=0) {
	          loc1=orderHtml.indexOf("<NOBR>",loc1+1);//2011-3-9 (������)
	          var sss= orderHtml.substring(loc1+"<NOBR>".length(),loc1+"<NOBR>".length()+10).trim();
	          var sss = sss.split(" ")[0];
	          var ss = sss.split("-");
	          if ( ss.length() >= 3){
	          	var yy=ss[0];var mm=ss[1];var dd=ss[2];
	          	if( mm.length()<2 ) mm = "0"+mm;
	          	if( dd.length()<2 ) dd = "0"+dd;
	          	billdat=yy+"-"+mm+"-"+dd;
	          }
	          
	        }
	        if(billdat==dat){
		        //ֱ�����ַ���λ�ҳ��ż���������ĸ���URL
		        loc1 = orderHtml.indexOf("<DIV id=\"idAttachmentWell\" class=\"AttachmentWell\">");
		        if( loc1>=0) {
		          loc1=orderHtml.indexOf("<A href=\"",loc1+1);
		          var url1= orderHtml.substring(loc1+"<A href=\"".length(),orderHtml.indexOf("\"",loc1+"<A href=\"".length()+2));
		          //������Ǹ�������
		          if (url1 != "TP-EQUIV=") {
		            var orderText = httpcall.Get0(url1,"GBK","\r");
		            if(msg != "") msg += "��";
		            msg += parseOneBill(httpcall,orderText,userid,deptid,kaid);
		          }
		        }
		}
      }
      
      var children = node.getChildNodes();
      if ( children != null ) {
        var len = children.getLength();
        for ( var i = 0; i < len; i++ ) {
          GetBillist(children.item(i),httpcall,userid,dat,deptid,kaid);//�ݹ����DOM��
        }
      }

      return msg;
}

//����һ�ŵ���
//httpcall
//str�����ݵ��ı�
//���أ��ַ����ָ���ַ�
function  parseOneBill(httpcall,str,userid,deptid,kaid)
{
	var ret = str; 
	var title_param = "                  TESCO ��  ��  ��  Ʒ  ��  ��\r";
	var title_params = ret.split(title_param);
	var line = "����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������\r";
	var msgs = "";
	for(var r = 1;r < title_params.length();r ++)
	{
		var lines = title_params[r].split(line);
		var corpnam = lines[0].substring(lines[0].indexOf(":")+3,lines[0].indexOf("ҳ")); 
		corpnam  = EAfunc.regexReplace(corpnam , "\\s+","");
		if (corpnam.indexOf("EXPRESS") != -1) return;
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
		var details = lines[3].split("\r");

		var count = 1;
//		if(bilid == "10239238")
//			throw new Exception(details.length());

		for(var details_r = 0;details_r < details.length();details_r++)
		{
			if(details[details_r].length() > 0&&details[details_r] != "������")
			{
				var detail = EAfunc.regexReplace(details[details_r] , "\\s+",",");//ץ��ϸ
				var detail1 = EAfunc.regexReplace(details[details_r+1] , "\\s+",",");//ץ��ϸ
//				,102717619/,Ҭ��¹���һ��33��/500,ƿ,��,12,-,-,12.00,-,12.00,12.00,1,1,***,6901160007073,ml/ƿ,0.00,	
				var itmid = detail1.split(",")[1];
			
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
					tel+"~~~"+fax+"~~~"+count+"~~~"+itmid+"~~~ ~~~"+detail.split(",")[3]+"~~~"+detail.split(",")[2]+_itmnam+
					"~~~ ~~~"+detail.split(",")[5]+"~~~"+detail.split(",")[9]+"~~~"+zpqty+"~~~"+detail.split(",")[6]+"~~~"+addr+"~~~ ~~~ ";
				count ++;
				details_r++;
			}
		}
	}
//	throw new Exception(msgs);
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
function x_WG_RtStore(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var EAfunc = new pubpack.EAFunc();
var HtmlParser = new x_WG_HtmlParser();
var httpcall = new webget.HttpCall();
var numberVerificationCodeIdentifier = new webget.NumberVerificationCodeIdentifier();
var util = new JavaPackage("java.util");
//function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code)
function start()
{
	var userid = "00000000000018052601";
	var passwd = "276118";
	var deptid = "4";
	var date = "2010-10-05";
	var date1 = "2010-09-19";
	var kaid = "0000";
	var code = "GBK";
	var ret = "";
	var param = "";
	var url = "";
	var msg = "";
	var pagesize = 0;//ÿһҳ��ʾ�Ķ�����Ŀ
	var count = 0;//�ܹ�����ʾ��ҳ
	var allcount = 0;//�������еĶ�����Ŀ
	var nodelist = null;
	var tablist = null;
	var titlenode = null;
	var ds = null;
	try
	{
		ret = httpcall.Get("http://scm.rt-store.com/login.aspx",code);
//		httpcall.Download("http://scm.rt-store.com/ValidateCode.aspx","/RtStore.bmp");
		var imagecode = numberVerificationCodeIdentifier.parsefile("D:/RtStore.bmp");
		return imagecode;
		ret = httpcall.Get("http://www.hlb2b.com/system/login/loginAction.do",code);	
		ret = httpcall.Post("http://www.hlb2b.com/system/login/loginAction.do","password="+passwd+"&proc=login.submit&username="+userid,code);
		ret = httpcall.Post("http://www.hlb2b.com/system/login/roleSelectAction.do","proc=select.submit&currentRoleId=0",code);
		ret = httpcall.Get("http://www.hlb2b.com/_template/style2/switch.jsp?menuId=563",code);
		//����
		ret = httpcall.Post("http://www.hlb2b.com/ptw/orderLstAction.do","proc=search&demandEDate="+date+"&demandSDate="+date+"&orderNo=&ordOrgCode=&orgCode=",code);	
		nodelist = HtmlParser.parserHtml(ret,code);	 
		tablist = HtmlParser.filterHtml(nodelist,"table");
		titlenode = tablist.elementAt(18);
		var titlerows = titlenode.getRows();
		var titlecols = titlerows[0].getColumns();
		var titlenotes = titlecols[0].toPlainTextString();
		allcount = 1*titlenotes.substring(titlenotes.indexOf("��")+1,titlenotes.indexOf("�����г���"));//�������еĶ�����Ŀ
		var list1 = new util.ArrayList();
	        list1 = SetLinksByPost(httpcall ,"http://www.hlb2b.com/ptw/orderLstAction.do","proc=search&demandEDate="+date+"&demandSDate="+date+"&orderNo=&ordOrgCode=&orgCode=",code,"pageSize",list1,"input","name","value");
	        pagesize = 1*list1.get(0);//ÿһҳ��ʾ�Ķ�����Ŀ
		count = allcount<pagesize?1:allcount/pagesize+1;
		for(var allrow = 1;allrow <= count;allrow ++ )
		{
			param = "proc=search&demandEDate="+date+"&demandSDate="+date+"&orderNo=&ordOrgCode=&orgCode=&image.x=26&image.y=3&pageSize="+pagesize+"&startIndex="+((allrow-1)*pagesize+1);
			var list = new util.ArrayList();
		        list = SetLinksByPost(httpcall ,"http://www.hlb2b.com/ptw/orderLstAction.do",param,code,"/ptw/orderLstAction.do?proc=list_detail",list,"a","href","href");
			for(var _r = 0;_r < list.size();_r ++)
			{
				url = "http://www.hlb2b.com"+list.get(_r);
				ret = httpcall.Get(url,code);
				nodelist = HtmlParser.parserHtml(ret,code);	 
				tablist = HtmlParser.filterHtml(nodelist,"table");
				var nolist = parserTableTitle(tablist,code,new Array("14"));
				var bilid = nolist.split("#")[1];//�������
				var corpid = nolist.split("#")[5].substring(0,4);//�ն˱��
				var corpnam = nolist.split("#")[5].substring(4,nolist.split("#")[5].length());//�ն�����
				var loc = nolist.split("#")[7];//�ֿ�
				var addrdat = nolist.split("#")[11].substring(0,10);
				ds = HtmlParser.parserTable(tablist,code,new Array("15"),"O");
				for(var r = 0;r < ds.getRowCount();r ++)
				{
					if(msg != "")
						msg += "��";
					var row = ds.getStringAt(r,"_�к�");
					var itmid = ds.getStringAt(r,"_��Ʒ����");
					var itmnam = ds.getStringAt(r,"_��Ʒ����");
					var code = ds.getStringAt(r,"_������");
					var spec = ds.getStringAt(r,"_��װ���");
					var unit = ds.getStringAt(r,"_��λ");
					var untnum = 1*spec.substring(spec.indexOf("*")+1,spec.length());
					var qty = 1*ds.getStringAt(r,"_��װ����");//��λ����  
					qty = qty*untnum;//Ϊ�˺��˻�������һ�µ�������־������������Ҳת����С��λ������
					var price = ds.getStringAt(r,"_����");//С��λ�ĵ��ۣ����Ǻ�˰����
					var mny = ds.getStringAt(r,"_��˰���");
					//SRFLG~~~USERID~~~DEPTID~~~KAID~~~BILID~~~ECORPNAM~~~ECORPID~~~ITMCLASS~~~
					//ORDID~~~DAT~~~ARRDAT~~~TEL~~~FAX~~~SEQID~~~EITMID~~~CODE~~~SPEC~~~EITMNAM~~~
					//QTYFLG~~~UNTNUM~~~QTY~~~ZPQTY~~~EPRICE~~~CORPADDR~~~NOTE~~~NULL
					msg += "NR ~~~"+userid+"~~~"+deptid+"~~~"+kaid+"~~~"+bilid+"~~~"+corpnam+"~~~"+corpid+"~~~"+
						loc+"~~~"+bilid+"~~~"+date+"~~~"+addrdat+"~~~ ~~~ ~~~"+row+"~~~"+itmid+"~~~"+
						code+"~~~"+spec+"~~~"+itmnam+"~~~ ~~~"+untnum+"~~~"+qty+"~~~0~~~"+
						price+"~~~ ~~~ ~~~ ";								
				}
			}
		}
		//�˻���
		ret = httpcall.Get("http://www.hlb2b.com/ptw/bckOrderLstAction.do?proc=search",code);
		ret = httpcall.Post("http://www.hlb2b.com/ptw/bckOrderLstAction.do","proc=search&filEDate="+date1+"&filSDate="+date1+"&orderNo=&ordOrgCode=&orgCode=",code);	
		nodelist = HtmlParser.parserHtml(ret,code);	 
		tablist = HtmlParser.filterHtml(nodelist,"table");
		titlenode = tablist.elementAt(18);
		var titlerows = titlenode.getRows();
		var titlecols = titlerows[0].getColumns();
		var titlenotes = titlecols[0].toPlainTextString();
		allcount = 1*titlenotes.substring(titlenotes.indexOf("��")+1,titlenotes.indexOf("�����г���"));//�������еĶ�����Ŀ
		var list1 = new util.ArrayList();
	        list1 = SetLinksByPost(httpcall ,"http://www.hlb2b.com/ptw/orderLstAction.do","proc=search&demandEDate="+date+"&demandSDate="+date+"&orderNo=&ordOrgCode=&orgCode=",code,"pageSize",list1,"input","name","value");
	        pagesize = 1*list1.get(0);//ÿһҳ��ʾ�Ķ�����Ŀ
	        count = allcount<pagesize?1:allcount/pagesize+1;
		for(var allrow = 1;allrow <= count;allrow ++ )
		{
			param = "proc=search&filEDate="+date1+"&filSDate="+date1+"&orderNo=&ordOrgCode=&orgCode=&image.x=26&image.y=3&pageSize="+pagesize+"&startIndex="+((allrow-1)*pagesize+1);
			var list = new util.ArrayList();
		        list = SetLinksByPost(httpcall ,"http://www.hlb2b.com/ptw/bckOrderLstAction.do",param,code,"/ptw/bckOrderLstAction.do?proc=list_detail",list,"a","href","href");
			for(var _r = 0;_r < list.size();_r ++)
			{
				url = "http://www.hlb2b.com"+list.get(_r);
				ret = httpcall.Get(url,code);
				nodelist = HtmlParser.parserHtml(ret,code);	 
				tablist = HtmlParser.filterHtml(nodelist,"table");
				var nolist = parserTableTitle(tablist,code,new Array("14"));
				var bilid = nolist.split("#")[1];//�������
				var corpid = nolist.split("#")[5].substring(0,4);//�ն˱��
				var corpnam = nolist.split("#")[5].substring(4,nolist.split("#")[5].length());//�ն�����
				var loc = nolist.split("#")[7];//�ֿ�
				var addrdat = nolist.split("#")[11].substring(0,10);
				ds = HtmlParser.parserTable(tablist,code,new Array("15"),"O");
				for(var r = 0;r < ds.getRowCount();r ++)
				{
					if(msg != "")
						msg += "��";
					var row = ds.getStringAt(r,"_�к�");
					var itmid = ds.getStringAt(r,"_��Ʒ����");
					var itmnam = ds.getStringAt(r,"_��Ʒ����");
					var code = ds.getStringAt(r,"_������");
					var spec = ds.getStringAt(r,"_��װ���");
					var unit = ds.getStringAt(r,"_��λ");
					var qty = ds.getStringAt(r,"_��Ʒ����");//С��λ����
					var price = ds.getStringAt(r,"_����");//С��λ�ĵ��ۣ����Ǻ�˰����
					var mny = ds.getStringAt(r,"_��˰���");
					//SRFLG~~~USERID~~~DEPTID~~~KAID~~~BILID~~~ECORPNAM~~~ECORPID~~~ITMCLASS~~~
					//ORDID~~~DAT~~~ARRDAT~~~TEL~~~FAX~~~SEQID~~~EITMID~~~CODE~~~SPEC~~~EITMNAM~~~
					//QTYFLG~~~UNTNUM~~~QTY~~~ZPQTY~~~EPRICE~~~CORPADDR~~~NOTE~~~NULL
					msg += "R ~~~"+userid+"~~~"+deptid+"~~~"+kaid+"~~~"+bilid+"~~~"+corpnam+"~~~"+corpid+"~~~"+
						loc+"~~~"+bilid+"~~~"+date1+"~~~"+addrdat+"~~~ ~~~ ~~~"+row+"~~~"+itmid+"~~~"+
						code+"~~~"+spec+"~~~"+itmnam+"~~~ ~~~"+spec.substring(spec.indexOf("*")+1,spec.length())+"~~~"+qty+"~~~0~~~"+
						price+"~~~ ~~~ ~~~ ";								
				}
			}
		}
		return msg;
	}
	catch(e)
	{
		throw new Exception(e);
	}
}
//================================================================// 
// ������parserTableTitle(nodelist,code,tabidxArr)
// ˵����̧ͷ�Ĳ�����Ϊ���ǹ���Ĳ��ܽ�����XML������Array�����档
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�09/07/10 13:41:06
// �޸���־��
//================================================================// 
function parserTableTitle(nodelist,code,tabidxArr)
{
	var str = "";
	var ltab = nodelist.elementAt(tabidxArr[0]);
	var rows = ltab.getRows();
	for (var r = 0;r<rows.length();r++)
	{
		var cols = rows[r].getColumns();
		for (var c = 0;c<cols.length();c++)
		{
			if(str != "")
				str += "#";
			str += HtmlParser.ReplaceStrToNull(cols[c].toPlainTextString().trim(),new Array("&nbsp;"," "));			
		}
	}
	return str;
}

//================================================================// 
// ������SetLinksByPost(url,encoding,filterStr)
// ˵������ҳ��ȡ�����з���filterStr�ַ���������,�ַ����룺encoding,links:�����������ӵ�ArrayList
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�09/28/10 10:12:11
// �޸���־��
//================================================================// 
function SetLinksByPost(httcall,url,params,encoding,filterStr,links,str1,str2,str3)
{
	var res = httpcall.Post(url,params,encoding);
	//����ҳ��Դ��Ϊpage����
	var page = HtmlParser.parserHtml(res,encoding);	
	//�õ���ǰҳ���е�A��ǩ
//	var atag = filterHtml(page,"a");
	var atag = HtmlParser.filterHtml(page,str1);
	for (var i = 0;i<atag.size();i++)
	{
//		var attr = atag.elementAt(i).getAttribute("href");
		var attr = atag.elementAt(i).getAttribute(str2);
		if (attr != null && attr.indexOf(filterStr) > -1)
		{
			attr = atag.elementAt(i).getAttribute(str3);
			links.add(attr);
		}
	} 
	return links;	
}
}
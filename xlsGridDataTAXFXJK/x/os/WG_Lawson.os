function x_WG_Lawson(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var HClient = new JavaPackage("org.apache.commons.httpclient");
var method = new JavaPackage("org.apache.commons.httpclient.methods");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");


function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code) 
{
	var ret = "";
	try{
		var db = new pubpack.EADatabase();
		var httpcall = new webget.HttpCall();
		var httpclient = new HClient.HttpClient();
		//��¼��ɭ�Ĺ�Ӧ�����
		ret = httpcall.Post("http://edi.lawson.com.cn/login.asp","user=" + userid + "&pwd=" + passwd);
		//����Ҫץȡ��ҳ���ݵ�HTML�ĵ�
		ret = httpcall.Get("http://edi.lawson.com.cn/download.asp",code);
		//����html�ַ���
		var HtmlParser = new x_WG_HtmlParser();
		var nodelist = HtmlParser.parserHtml(ret,code);
		
		//�õ�����Ҫ����ı�ǩ���nodelist����
		nodelist = HtmlParser.filterHtml(nodelist,"Form");

		var form = null;
		var formAttr = "";
		var formlist = null;
		//ֻ����Form�а���<td></td>�Ĳ���
		for (var i = 0;i<nodelist.size();i++)
		{
			form = nodelist.elementAt(i);	
			formAttr = form.getAttribute("action");	 
			if (formAttr.indexOf("download") > -1)
			{
				formlist = form.getChildren();
				//ֻ����TD��ǩ
				var list = HtmlParser.filterHtml(formlist,"TD");
				var edidat = list.elementAt(2).getFirstChild().getText();
				
				//�õ�From�е����ڣ��ж��ǲ���ָ������
				edidat = edidat.substring(edidat.indexOf("-")-4,edidat.lastIndexOf(":")+3);
				var curdat = db.GetSQL("select to_char(to_date('"+edidat+"','yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd') from dual");

				if (curdat.equals(dat))
				{
					//����ǵ���ȡ����Ӧ��<a>��ǩ�е����ӵ�ַ
					var link = HtmlParser.filterHtml(formlist,"A");
					link = link.elementAt(0);
					var urlpath = "http://edi.lawson.com.cn"+HtmlParser.urlCodeTrnas(link.getAttribute("href"),link.getStringText(),code);
					//�����ļ���ָ��Ŀ¼
					HtmlParser.downloadFile(urlpath,"d:/EDIDownloads/"+link.getStringText());						
				}
				
			}
		}	
				
	}catch(e){
		throw new Exception(e);
	}
	finally
	{
		if(db != null)
			db.Close();
	}	
}

function Main()
{
	return getOrderStr("","2010-09-04","","003697","003697","","UTF-8"); 	
}

}
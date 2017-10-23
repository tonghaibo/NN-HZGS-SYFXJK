function x_weixinService(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var resp = new JavaPackage("com.xlsgrid.net.weixin.message.resp");
var weixin = new JavaPackage("com.xlsgrid.net.weixin");
var webget = new JavaPackage("com.xlsgrid.net.webget");
var json = new JavaPackage("net.sf.json");

/**
 * ΢�ŵĽӿ���Ϣ��Ӧ�����м��
 * @author Harry
 * @date 2013-10-11
*/


//��Ӧ΢�ŷ�������ҵ���߼�������
function doPost()
{
	// ���ݹ�˰
//	var weixinOS = new x_weixinHZGS();
//	return weixinOS.coreService(request,response);

	//�������̹�ҵ-������
//	var weixinOS = new x_weixinGxZhenLong();
//	return weixinOS.coreService(request,response);

	//��ֹ��������
	response.setContentType("content-type:text/html; charset=UTF-8");
	
	var respMessage = null;
	var textMessage = null;
	var db = null;
	
	try {
		// xml�������
		var requestMap = weixin.MessageUtil.parseXml(request);	
		// ���ͷ��ʺţ�open_id��
		var fromUserName = requestMap.get("FromUserName");
		// �����ʺ�
		var toUserName = requestMap.get("ToUserName");
		// ��Ϣ����
		var msgType = requestMap.get("MsgType");
		// �ı���Ϣ����
		var content = requestMap.get("Content");
		

		request.getSession().setAttribute("WEIXIN_FROMUSERNAME",fromUserName);

		// �ظ��ı���Ϣ
		textMessage = new resp.TextMessage();
		textMessage.setToUserName(fromUserName);
		textMessage.setFromUserName(toUserName);
		var dt = new java.util.Date();
		textMessage.setCreateTime(dt.getTime());
		textMessage.setMsgType(weixin.MessageUtil.RESP_MESSAGE_TYPE_TEXT);
		textMessage.setFuncFlag(0);
		
		// ����ͼ����Ϣ  
		var newsMessage = new resp.NewsMessage();  
		newsMessage.setToUserName(fromUserName);  
		newsMessage.setFromUserName(toUserName);  
		newsMessage.setCreateTime(dt.getTime());  
		newsMessage.setMsgType(weixin.MessageUtil.RESP_MESSAGE_TYPE_NEWS);  
		newsMessage.setFuncFlag(0);  
		
		db = new pub.EADatabase();
		
		var ds = db.QuerySQL("select * from weixin_userbind where fromusername='"+fromUserName+"'");
		//����Ƿ��Ѱ�ϵͳ
		if (ds.getRowCount() <= 0 && content.indexOf("/") == -1) {
			textMessage.setContent("����û�а󶨵�ʹ�õ�ϵͳ����ظ��û���/������а󶨣����磺guest/test");
			respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
			return respMessage;
		}
		
		var borgid = "";
		var bsytid = "XLSGRID";
		var busrid = "";
		var bpwd = "";
		
		//�Ѿ����Զ���¼
		if (ds.getRowCount() > 0) {
			borgid = pub.EAFunc.NVL(ds.getStringAt(0, "ORG"),"XLSGRID");			
			busrid = ds.getStringAt(0, "USRID");
			bpwd = ds.getStringAt(0, "PASSWD");
			//pub.EAFunc.autoLogin(request, response);
		}
		
		if (msgType.equals(weixin.MessageUtil.REQ_MESSAGE_TYPE_EVENT)) {
			// �¼�����
			var eventType = requestMap.get("Event");
			// ����
			if (eventType.equals(weixin.MessageUtil.EVENT_TYPE_SUBSCRIBE)) {
				textMessage.setContent("��л���Ĺ�ע����ظ��û���/������а󶨣����磺guest/test");
				respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
				return respMessage;
			}
			// ȡ������
			else if (eventType.equals(weixin.MessageUtil.EVENT_TYPE_UNSUBSCRIBE)) {
				// TODO ȡ�����ĺ��û����ղ������ںŷ��͵���Ϣ����˲���Ҫ�ظ���Ϣ
			}
			// �Զ���˵�����¼�
			else if (eventType.equals(weixin.MessageUtil.EVENT_TYPE_CLICK)) {             

				// �¼�KEYֵ���봴���Զ���˵�ʱָ����KEYֵ��Ӧ  
		                var eventKey = requestMap.get("EventKey");  
		  		//pub.EAFunc.Log("eventKey="+eventKey);
		                if (eventKey.equals("11")) {  
					textMessage.setContent("��ظ��û���/������а󶨣����磺guest/test <a href=\"http://www.xlsgrid.net/xlsgrid/org/XLSGRID/app/login.html\">�����¼</a>");
				} else if (eventKey.equals("12")) {  
					//textMessage.setContent("�ҵĴ������� >>");  
					//respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
					//return respMessage;
					try {
						return myTrkList(respMessage,newsMessage);
					}
					catch (e) {
						textMessage.setContent("ϵͳ����:"+e.toString());  
						respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
						return respMessage;					
					}
				} else if (eventKey.equals("13")) {  
					//textMessage.setContent("�ҷ�������� >>"); 
					return mySendTrkList(respMessage,newsMessage); 
				} else if (eventKey.equals("14")) {  
					//textMessage.setContent("�������� >>");  
					return allTrkList(respMessage,newsMessage);
				} else if (eventKey.equals("21")) {  
					//textMessage.setContent("ͨѶ¼ >>");  
					return memberActive(respMessage,newsMessage); // ������Ա����
					try {
						return contacts(respMessage,newsMessage);
					}
					catch (e) {
						textMessage.setContent("ϵͳ����:"+e.toString());  
						respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
						return respMessage;					
					}

				} else if (eventKey.equals("22")) {  //�г̼ƻ�-ǩ��
					//textMessage.setContent("������ѯ�˵�������");  
					var msg = "";
					//�жϵ����Ƿ���ǩ��
					var myds = db.QuerySQL("select to_char(crtdat,'hh24:mi:ss') crtdat from SIGNIN where org='XLSGRID' and usrid in (
							select usrid from weixin_userbind where fromusername='"+fromUserName+"' and org='XLSGRID')
							and to_char(crtdat,'yyyymmdd')=to_char(sysdate,'yyyymmdd')");
					if (myds.getRowCount() > 0) {
						msg = "����ǩ����ǩ��ʱ�䣺"+myds.getStringAt(0,"CRTDAT");  
					}
					else {
						db.ExcecutSQL("insert into signin(org,usrid,crtdat,prj)values('XLSGRID','"+busrid+"',sysdate,'XLSGRID')");
						msg = "��л���ǩ����лл֧�֣�";
					}
					
					//��ѯ��ǩ���б�
					myds = db.QuerySQL("select a.usrid,b.name,to_char(a.crtdat,'hh24:mi:ss') crtdat 
								from signin a,usr b where a.usrid=b.id and a.org=b.org and a.org='XLSGRID' 
								and to_char(a.crtdat,'yyyymmdd')=to_char(sysdate,'yyyymmdd') 
								order by a.crtdat");
					msg += "\n ��ǩ����Ա��\n";
					for (var i=0;i<myds.getRowCount();i++) {
						msg += (i+1)+" "+myds.getStringAt(i,"NAME")+" "+myds.getStringAt(i,"CRTDAT")+"\n";
					}
					textMessage.setContent(msg);
					
				} else if (eventKey.equals("23")) {  
					//textMessage.setContent("��ٹ�����δ���ߣ������ڴ���");  
					//��ǿ���� - �ι���
					//textMessage.setContent("�ι��֣�����Ӯ�󽱣�<a href='http://fl.act.qq.com/27330/addev/h5/172836?v=demo'>�������</a>\n\n
					textMessage.setContent("<a href='https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx28aa2668339fb4b2&redirect_uri=http%3a%2f%2fwww.xmidware.com%2fxlsgrid%2fwxShare.jsp&response_type=code&scope=snsapi_base&state=0&wechat_redirect&usrid=xlsgrid&userpwd=0'>OAuth2.0��ҳ����Ȩ[snsapi_base/wxShare.jsp]</a>"); 
					
				} else if (eventKey.equals("31")) {  
					textMessage.setContent("���߿ͷ��˵�������");  
				} else if (eventKey.equals("32")) {  
					textMessage.setContent("���Բ˵�������");  
				} 
				
				else if (eventKey.equals("35")) {  
					textMessage.setContent("���ڻظ���Ϣ�е�+�ţ�Ȼ��ѡ��λ���ٷ������λ����Ϣ��");  
				}
				
  				respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
				return respMessage;
			}
		}
		else if (msgType.equals(weixin.MessageUtil.REQ_MESSAGE_TYPE_LOCATION)) { 
			var lx = requestMap.get("Location_X");
			var ly = requestMap.get("Location_Y");
			var lb = requestMap.get("Label");

//			textMessage.setContent("�㷢���˵���λ����Ϣ��["+lx+","+ly+"]"+lb);
//			respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
//			return respMessage;
			
			// ����ͼ����Ϣ  
	                var newsMessage = new resp.NewsMessage();  
	                newsMessage.setToUserName(fromUserName);  
	                newsMessage.setFromUserName(toUserName);  
	                newsMessage.setCreateTime(dt.getTime());  
	                newsMessage.setMsgType(weixin.MessageUtil.RESP_MESSAGE_TYPE_NEWS);  
	                newsMessage.setFuncFlag(0);  

			var articleList = new java.util.ArrayList(); 
			var article = new resp.Article();  
                    	article.setTitle("�����Ҹ������ŵ�");  
                    	article.setDescription(lb);  
                    	article.setPicUrl("http://i3.s2.dpfile.com/2010-03-01/3803174_b.jpg(700x700)/thumb.jpg");  
                    	article.setUrl("http://www.xlsgrid.net/xlsgrid/ROOT_0/mapSearch.sp?usrid=xlsgrid&userpwd=0&lx="+lx+"&ly="+ly+"&lb="+java.net.URLEncoder.encode(lb,"gbk"));  
                    	articleList.add(article);  
                    	// ����ͼ����Ϣ����  
                    	newsMessage.setArticleCount(articleList.size());  
                    	// ����ͼ����Ϣ������ͼ�ļ���  
                    	newsMessage.setArticles(articleList);  
                   	// ��ͼ����Ϣ����ת����xml�ַ���  
                   	respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage); 
			return respMessage;

		}
		else {
			//���û�
			if (content.indexOf("/") > -1) {
				var id = content.split("/")[0];
				var pwd = content.split("/")[1];
				var usrds = db.QuerySQL("select * from usr where id='"+id+"' and passwd='"+pwd+"'");
				if (usrds.getRowCount() <= 0) {
					textMessage.setContent("�û��������벻��ȷ�����飡");
				}
				else {
					db.ExcecutSQL("insert into weixin_userbind(org,syt,FromUserName,usrid,passwd,TOUSERNAME)values('XLSGRID','XLSGRID','"+fromUserName+"','"+id+"','"+pwd+"','"+toUserName+"')");
					textMessage.setContent(usrds.getStringAt(0, "NAME")+" ��л����ʹ�ã�˶������߳�Ϊ������");
				}
				respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
				return respMessage;
			}
		}
	}
	catch (Exception e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
	textMessage.setContent("���ã������ڳɳ������У�������������Ѿ��������ҵ�֪ʶ��Χ��������գ�Thank you��");
	respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
	return respMessage;
	
}


//ȡ��TOKEN
function getToken(appid,secret)
{
	var url="https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid="+appid+"&secret="+secret;
	var httpcall = new webget.HttpCall();
	var token = httpcall.Get(url,"UTF-8");	
	var jsobj = json.JSONObject.fromObject(token); 
	token = jsobj.getString("access_token");
	return token;
}

//��ȡ��ע�û���Ϣ
function getUserInfo()
{
	var xmlstr = "<?xml version='1.0'?><ROWSET>";
	var token = getToken(appid,secret);	
	var url = "https://api.weixin.qq.com/cgi-bin/user/get?access_token="+token;
	var httpcall = new webget.HttpCall();
	var userInfos = httpcall.Get(url,"UTF-8");
	//return userInfos;
	var jsobj = json.JSONObject.fromObject(userInfos); 
	var total = jsobj.getString("total");
	var count = jsobj.getString("count");
	var data = jsobj.getString("data");
	//return data;
	jsobj = json.JSONObject.fromObject(data);
	//return jsobj.getString("openid");
	var arr = jsobj.getJSONArray("openid");
	for (var i=0;i<arr.size();i++) {
		var openid = arr.getString(i);
		url = "https://api.weixin.qq.com/cgi-bin/user/info?access_token="+token+"&openid="+openid+"&lang=zh_CN";
		var infos = httpcall.Get(url,"UTF-8");
		var jsoinfo = json.JSONObject.fromObject(infos);
		var nickname = jsoinfo.getString("nickname"); 			//�ǳ�
		var sex = jsoinfo.getString("sex");				//�Ա�
		var city = jsoinfo.getString("city");				//���ڳ���
		var country = jsoinfo.getString("country");			//���ڹ���
		var province = jsoinfo.getString("province");			//����ʡ��
		var language = jsoinfo.getString("language");			//�û�������
		var headimgurl = jsoinfo.getString("headimgurl");		//�û�ͷ��
		var subscribe_time = jsoinfo.getString("subscribe_time");	//��עʱ��
		var dateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd");  
		var date = new java.util.Date();
		date.setTime(java.lang.Long.parseLong(subscribe_time)*1000);
		subscribe_time = dateFormat.format(date);
       
		
		xmlstr += "<ROW num='"+(i+1)+"'>\n";
		xmlstr += "\t<���>"+(i+1)+"</���>\n";
		xmlstr += "\t<�û���ʶ>"+openid+"</�û���ʶ>\n";
		xmlstr += "\t<�û�ͷ��>"+headimgurl+"</�û�ͷ��>\n";
		xmlstr += "\t<�ǳ�>"+nickname+"</�ǳ�>\n";
		xmlstr += "\t<�Ա�>"+sex+"</�Ա�>\n";
		xmlstr += "\t<���ڳ���>"+city+"</���ڳ���>\n";
		xmlstr += "\t<���ڹ���>"+country+"</���ڹ���>\n";
		xmlstr += "\t<����ʡ��>"+province+"</����ʡ��>\n";
		xmlstr += "\t<�û�������>"+language+"</�û�������>\n";
		xmlstr += "\t<��עʱ��>"+subscribe_time+"</��עʱ��>\n";
		xmlstr += "</ROW>\n";
	}
	
	xmlstr += "</ROWSET>";
	return xmlstr;
}

//�ҵĴ�������
function myTrkList(respMessage,newsMessage)
{  
	var articleList = new java.util.ArrayList();  
	
	var article1 = new resp.Article();  
	article1.setTitle("�ҵĴ������� >>");  
	article1.setDescription("");  
	// ��ͼƬ��Ϊ��  
	article1.setPicUrl("");  
	article1.setUrl("");  
	articleList.add(article1);

	var sql = "select * from (select title,to_char(crtdat,'dd/mm hh24:mi') crtdat,crtusr from trkhdr where dtlusr='xlsgrid' and project='XLSGRID' order by crtdat desc) where rownum<=5";
	var ds = pub.EADbTool.QuerySQL(sql); 
	for (var i=0;i<ds.getRowCount();i++) {
		var article2 = new resp.Article();  
		article2.setTitle(ds.getStringAt(i,"TITLE")+"\n"+ds.getStringAt(i,"CRTUSR")+" - "+ds.getStringAt(i,"CRTDAT"));  
		//article2.setDescription(ds.getStringAt(i,"CRTDAT")+" "+ds.getStringAt(i,"CRTUSR"));  
		article2.setPicUrl("http://www.xlsgrid.net/xlsgrid/xlsgrid/images/entry/"+(i+1)+".png");  
		article2.setUrl("");
		articleList.add(article2);
	}
	newsMessage.setArticleCount(articleList.size());  
	newsMessage.setArticles(articleList);  
	respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage); 

	return respMessage;            
}

//�ҷ��������
function mySendTrkList(respMessage,newsMessage)
{  
	var articleList = new java.util.ArrayList();  
	
	var article1 = new resp.Article();  
	article1.setTitle("�ҷ�������� >>");  
	article1.setDescription("");  
	// ��ͼƬ��Ϊ��  
	article1.setPicUrl("");  
	article1.setUrl("");  
	articleList.add(article1);

	var sql = "select * from (select title,to_char(crtdat,'dd/mm hh24:mi') crtdat,crtusr from trkhdr where crtusr='xlsgrid' and project='XLSGRID' order by crtdat desc) where rownum<=5";
	var ds = pub.EADbTool.QuerySQL(sql); 
	for (var i=0;i<ds.getRowCount();i++) {
		var article2 = new resp.Article();  
		article2.setTitle(ds.getStringAt(i,"TITLE")+"\n"+ds.getStringAt(i,"CRTUSR")+" - "+ds.getStringAt(i,"CRTDAT"));  
		//article2.setDescription(ds.getStringAt(i,"CRTDAT")+" "+ds.getStringAt(i,"CRTUSR"));  
		article2.setPicUrl("http://www.xlsgrid.net/xlsgrid/xlsgrid/images/entry/"+(i+1)+".png");  
		article2.setUrl("");
		articleList.add(article2);
	}
	newsMessage.setArticleCount(articleList.size());  
	newsMessage.setArticles(articleList);  
	respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage); 

	return respMessage;            
}

//��������
function allTrkList(respMessage,newsMessage)
{  
	var articleList = new java.util.ArrayList();  
	
	var article1 = new resp.Article();  
	article1.setTitle("���е����� >>");  
	article1.setDescription("");  
	// ��ͼƬ��Ϊ��  
	article1.setPicUrl("");  
	article1.setUrl("");  
	articleList.add(article1);

	var sql = "select * from (select title,to_char(crtdat,'dd/mm hh24:mi') crtdat,crtusr from trkhdr where project='XLSGRID' order by crtdat desc) where rownum<=9";
	var ds = pub.EADbTool.QuerySQL(sql); 
	for (var i=0;i<ds.getRowCount();i++) {
		var article2 = new resp.Article();  
		article2.setTitle(ds.getStringAt(i,"TITLE")+"\n"+ds.getStringAt(i,"CRTUSR")+" - "+ds.getStringAt(i,"CRTDAT"));  
		//article2.setDescription(ds.getStringAt(i,"CRTDAT")+" "+ds.getStringAt(i,"CRTUSR"));  
		article2.setPicUrl("http://www.xlsgrid.net/xlsgrid/xlsgrid/images/entry/"+(i+1)+".png");  
		article2.setUrl("");
		articleList.add(article2);
	}
	newsMessage.setArticleCount(articleList.size());  
	newsMessage.setArticles(articleList);  
	respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage); 

	return respMessage;            
}

//ͨѶ¼
function contacts(respMessage,newsMessage)
{  
	var articleList = new java.util.ArrayList();  
	
	var article1 = new resp.Article();  
	article1.setTitle("ͨѶ¼ >>");  
	article1.setDescription("");  
	// ��ͼƬ��Ϊ��  
	article1.setPicUrl("");  
	article1.setUrl("");  
	articleList.add(article1);

	var sql = "select * from (select name,mobile,email from usr where org='XLSGRID' and useflg='1' and mobile is not null order by id) where rownum<=9";
	var ds = pub.EADbTool.QuerySQL(sql); 
	for (var i=0;i<ds.getRowCount();i++) {
		var article2 = new resp.Article();  
		article2.setTitle(ds.getStringAt(i,"NAME")+"\nTEL:"+ds.getStringAt(i,"MOBILE")+"\nEMAIL:"+ds.getStringAt(i,"EMAIL"));  
		//article2.setDescription(ds.getStringAt(i,"CRTDAT")+" "+ds.getStringAt(i,"CRTUSR"));  
		article2.setPicUrl("http://www.xlsgrid.net/xlsgrid/xlsgrid/images/entry/"+(i+1)+".png");  
		article2.setUrl("");
		articleList.add(article2);
	}
	newsMessage.setArticleCount(articleList.size());  
	newsMessage.setArticles(articleList);  
	respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage); 

	return respMessage;            
}

// ��ǿ���� - ��Ա����
function memberActive(respMessage,newsMessage)
{  
	var articleList = new java.util.ArrayList();  
	
	var article1 = new resp.Article();  
	article1.setTitle("����ۻ�");  
	article1.setDescription("");  
	// ��ͼƬ��Ϊ��  
	article1.setPicUrl("http://jqls.xlsgrid.net/jqfinx/ROOT_JQLS/EAFormBlob.sp?guid=F3B0557D65B5CE14E040007F010025BD");  
	article1.setUrl("����ڣ�2014-03-26 �� 2014-03-31");  
	articleList.add(article1);
	
	article1 = new resp.Article();  
	article1.setTitle("��Ʒ����");  
	article1.setDescription("");  
	// ��ͼƬ��Ϊ��  
	article1.setPicUrl("http://jqls.xlsgrid.net/jqfinx/ROOT_JQLS/EAFormBlob.sp?guid=ED8E69B0D1B42080E040007F010011BB");  
	article1.setUrl("");  
	articleList.add(article1);
	
	article1 = new resp.Article();  
	article1.setTitle("55������Һ18������");  
	article1.setDescription("");  
	// ��ͼƬ��Ϊ��  
	article1.setPicUrl("http://jqls.xlsgrid.net/jqfinx/ROOT_JQLS/EAFormBlob.sp?guid=ED7671A36901D60EE040007F010059C1");  
	article1.setUrl("");  
	articleList.add(article1);

	newsMessage.setArticleCount(articleList.size());  
	newsMessage.setArticles(articleList);  
	respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage); 

	return respMessage;            
}
}
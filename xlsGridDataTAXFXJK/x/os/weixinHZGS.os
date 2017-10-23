function x_weixinHZGS(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var resp = new JavaPackage("com.xlsgrid.net.weixin.message.resp");
var weixin = new JavaPackage("com.xlsgrid.net.weixin");

/**
 * ΢�ŵĽӿ���Ϣ��Ӧ�����м��
 * @author Harry
 * @date 2013-10-11
*/


//��Ӧ΢�ŷ�������ҵ���߼�������
//function doPost()
function coreService(request,response)
{
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
		
		if (msgType.equals(weixin.MessageUtil.REQ_MESSAGE_TYPE_EVENT)) {
			// �¼�����
			var eventType = requestMap.get("Event");
			// ����
			if (eventType.equals(weixin.MessageUtil.EVENT_TYPE_SUBSCRIBE)) {
				textMessage.setContent("���ã���л��ע���ݹ�˰�ٷ�΢�ţ�����Ϊ���ṩ��ص����߷���");
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
		  		// ֪ͨ����
		                if (eventKey.equals("11")) {  
					//textMessage.setContent("֪ͨ����˵�������");
					return notifyMessage(respMessage,newsMessage);
				} 
				// �ȵ���ѯ
				else if (eventKey.equals("12")) {  
					textMessage.setContent("�ȵ���ѯ����ظ�����ǰ�����ֱ�Ų鿴���顣\n"
					+"��01����Ӫҵִ�յ���˰���Ƿ���Ҫ����˰��Ǽǣ�\n"
					+"��02����ʧ˰��Ǽ�֤����ô�죿\n"
					+"��03������˰��Ǽ�֤�ĵ�λ�͸�����������Ʊ�칺����\n"
					+"��04��ȡ�÷�Ʊ�칺���ĵ�λ�͸�����������Ʊ��\n"
					+"��05�����幤�̻�û�ﵽ��ֵ˰�����㣬�����칺��Ʊ��\n"
					+"��06��Ŀǰ����˰�˿��Բ�����Щ�����걨��ʽ������˰�걨��\n"
					+"��07����ο�ͨ�����걨��\n");
				} 
				// ��˰ָ��
				else if (eventKey.equals("21")) {  
					//textMessage.setContent("��˰ָ�ϲ˵�������");
					return doTaxGuide(respMessage,newsMessage);
				} 
				// ��˰��ͼ 
				else if (eventKey.equals("22")) {  //�г̼ƻ�-ǩ��
					textMessage.setContent("���Ұ�˰����ַ�������Ի����·��ġ�+��������ġ�λ�á����һ�����ҵ��ġ�");
					
				} 
				// Ͷ�߽���
				else if (eventKey.equals("23")) {  
					textMessage.setContent("Ͷ�߽���˵�������");
				} 
				// ��Ʊ��α��ѯ
				else if (eventKey.equals("31")) {  
					textMessage.setContent("��Ʊ��α��ѯ�˵�������");  
				} 
				// ��������˰��Ϣ��ѯ
				else if (eventKey.equals("32")) {  
					textMessage.setContent("��������˰��Ϣ��ѯ�˵�������");  
				} 
				// ����ƱԤԼ
				else if (eventKey.equals("33")) {  
					textMessage.setContent("����ƱԤԼ");  
				}
				// �����Ŷ����
				else if (eventKey.equals("34")) {  
					textMessage.setContent("����ѯʱ�䣺2014-04-14 09:23��\n��˰��������ǰ�ȴ����� 5 �ˣ����Ժ�...");  
				}
				
  				respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
				return respMessage;
			}
		}
		// ���͵���λ����Ϣ
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
                    	article.setTitle("��˰��������ͼ");  
                    	article.setDescription(lb);  
                    	article.setPicUrl("http://hz.gxgs.gov.cn/picture/0/130106092532484.gif");  
                    	article.setUrl("http://www.xlsgrid.net/xlsgrid/ROOT_0/hztaxMap.sp?usrid=xlsgrid&userpwd=0&lx="+lx+"&ly="+ly+"&lb="+java.net.URLEncoder.encode(lb,"gbk"));  
                    	articleList.add(article);  
                    	// ����ͼ����Ϣ����  
                    	newsMessage.setArticleCount(articleList.size());  
                    	// ����ͼ����Ϣ������ͼ�ļ���  
                    	newsMessage.setArticles(articleList);  
                   	// ��ͼ����Ϣ����ת����xml�ַ���  
                   	respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage); 
			return respMessage;

		}
		
	}
	catch (Exception e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
	textMessage.setContent("�ǳ���Ǹ�������ڳɳ������У�������������Ѿ��������ҵ�֪ʶ��Χ��������գ�Thank you��");
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

// ֪ͨ����
function notifyMessage(respMessage,newsMessage)
{  
	var articleList = new java.util.ArrayList();  
	
	var article1 = new resp.Article();  
	article1.setTitle("����˰���ֹܾ���ʵʩ��˰��Ʊ֤����취����������Ĺ���");  
	article1.setDescription("");  
	// ��ͼƬ��Ϊ��  
	article1.setPicUrl("http://img1.cache.netease.com/catchpic/F/F3/F3FFD07F25948BCED092492CD782BCB0.jpg");  
	article1.setUrl("http://hz.gxgs.gov.cn/art/2013/12/24/art_102131_242057.html");  
	articleList.add(article1);
	
	article1 = new resp.Article();  
	article1.setTitle("˰��Ʊ֤����취");  
	article1.setDescription("");  
	// ��ͼƬ��Ϊ��  
	article1.setPicUrl("http://www.html5cn.org/data/attachment/portal/201404/03/132634u44dyw6yw44hduch.png");  
	article1.setUrl("http://hz.gxgs.gov.cn/art/2013/12/24/art_102131_242055.html");  
	articleList.add(article1);
	
	article1 = new resp.Article();  
	article1.setTitle("�����й���˰��ֹ���ӡ���������й���˰���˰����������������������淶���͡������й���˰���˰�����������·���������淶����֪ͨ");  
	article1.setDescription("");  
	// ��ͼƬ��Ϊ��  
	article1.setPicUrl("http://www.html5cn.org/data/attachment/portal/201404/03/132634u44dyw6yw44hduch.png");  
	article1.setUrl("http://hz.gxgs.gov.cn/art/2012/9/17/art_102131_176380.html");  
	articleList.add(article1);

	newsMessage.setArticleCount(articleList.size());  
	newsMessage.setArticles(articleList);  
	respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage); 

	return respMessage;            
}

// ��˰ָ��
function doTaxGuide(respMessage,newsMessage)
{
	var articleList = new java.util.ArrayList();  
	
	var article1 = new resp.Article();  
	article1.setTitle("��˰ָ��");  
	article1.setDescription("");  
	// ��ͼƬ��Ϊ��  
	article1.setPicUrl("http://img1.cache.netease.com/catchpic/8/81/81C43116A06DEC6ADF38DB0C9A022548.jpg");  
	article1.setUrl("http://hz.gxgs.gov.cn/art/2013/12/24/art_102131_242057.html");  
	articleList.add(article1);
	
	article1 = new resp.Article();  
	article1.setTitle("˰��Ǽ�");  
	article1.setDescription("");  
	// ��ͼƬ��Ϊ��  
	article1.setPicUrl("http://www.html5cn.org/data/attachment/portal/201404/03/132634u44dyw6yw44hduch.png");  
	article1.setUrl("http://hz.gxgs.gov.cn/art/2013/12/24/art_102131_242055.html");  
	articleList.add(article1);
	
	article1 = new resp.Article();  
	article1.setTitle("�걨����");  
	article1.setDescription("");  
	// ��ͼƬ��Ϊ��  
	article1.setPicUrl("http://www.html5cn.org/data/attachment/portal/201404/03/132634u44dyw6yw44hduch.png");  
	article1.setUrl("http://hz.gxgs.gov.cn/art/2012/9/17/art_102131_176380.html");  
	articleList.add(article1);

	article1 = new resp.Article();  
	article1.setTitle("��׼�϶�");  
	article1.setDescription("");  
	// ��ͼƬ��Ϊ��  
	article1.setPicUrl("http://www.html5cn.org/data/attachment/portal/201404/03/132634u44dyw6yw44hduch.png");  
	article1.setUrl("http://hz.gxgs.gov.cn/art/2012/9/17/art_102131_176380.html");  
	articleList.add(article1);

	article1 = new resp.Article();  
	article1.setTitle("˰���Ż�");  
	article1.setDescription("");  
	// ��ͼƬ��Ϊ��  
	article1.setPicUrl("http://www.html5cn.org/data/attachment/portal/201404/03/132634u44dyw6yw44hduch.png");  
	article1.setUrl("http://hz.gxgs.gov.cn/art/2012/9/17/art_102131_176380.html");  
	articleList.add(article1);

	newsMessage.setArticleCount(articleList.size());  
	newsMessage.setArticles(articleList);  
	respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage); 

	return respMessage;            

}
}
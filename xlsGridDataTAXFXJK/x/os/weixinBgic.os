function x_weixinBgic(){var pub = new JavaPackage("com.xlsgrid.net.pub");
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
		
		//request.getSession().setAttribute("WEIXIN_FROMUSERNAME",fromUserName);

		// �ظ��ı���Ϣ
		textMessage = new resp.TextMessage();
		textMessage.setToUserName(fromUserName);
		textMessage.setFromUserName(toUserName);
		var dt = new java.util.Date();
		textMessage.setCreateTime(dt.getTime());
		textMessage.setMsgType(weixin.MessageUtil.RESP_MESSAGE_TYPE_TEXT);
		textMessage.setFuncFlag(0);
		
		// �ı���Ϣ  
		if (msgType.equals(weixin.MessageUtil.REQ_MESSAGE_TYPE_TEXT)) {  
			// �����û����͵��ı���Ϣ����  
	                var content = requestMap.get("Content");  
	  
	                // ����ͼ����Ϣ  
	                var newsMessage = new resp.NewsMessage();  
	                newsMessage.setToUserName(fromUserName);  
	                newsMessage.setFromUserName(toUserName);  
	                newsMessage.setCreateTime(dt.getTime());  
	                newsMessage.setMsgType(weixin.MessageUtil.RESP_MESSAGE_TYPE_NEWS);  
	                newsMessage.setFuncFlag(0);  
	  
	                var articleList = new java.util.ArrayList();  
	                
	                //���û�
			if (content.indexOf("/") > -1) {
				var id = content.split("/")[0];
				var pwd = content.split("/")[1];
				pub.EADbTool.ExcecutSQL("insert into weixin_userbind(org,syt,FromUserName,usrid,passwd,TOUSERNAME)values('BGIC','BGIC','"+fromUserName+"','"+id+"','"+pwd+"','"+toUserName+"')");
				 var article = new resp.Article();  
		                 article.setTitle("��ݰ���֤");  
		                    article.setDescription("��л����ʹ�ã���֤ͨ����");  
		                    article.setPicUrl("http://www.bgic.com/dds/2.jpg");  
		                    article.setUrl("http://www.bgic.com");  
		                    articleList.add(article);  
		                    // ����ͼ����Ϣ����  
		                    newsMessage.setArticleCount(articleList.size());  
		                    // ����ͼ����Ϣ������ͼ�ļ���  
		                    newsMessage.setArticles(articleList);  
		                    // ��ͼ����Ϣ����ת����xml�ַ���  
		                    respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage);  

				return respMessage;
			}

	                // ��ͼ����Ϣ  
	                if ("1".equals(content)) {  
	                    var article = new resp.Article();  
	                    article.setTitle("ʾ��1-��ͼ����Ϣ");  
	                    article.setDescription("���壬80��΢�Ź����ʺſ�������4���¡�Ϊ������ѧ�����ţ����Ƴ���ϵ�н̳̣�Ҳϣ����˻�����ʶ����ͬ�У�");  
	                    article.setPicUrl("http://b275.photo.store.qq.com/psb?/V11JGWQf4B4Knx/XVCibE*CtxdQsJDpUa0HPM6nZqEjKFgOsCztHUa6GeE!/b/dIfG76M2IQAA&bo=wAOAAgAAAAABAGY!&rf=photoDetail");  
	                    article.setUrl("http://www.xlsgrid.net/xlsgrid/lungoTest/test1.html");  
	                    articleList.add(article);  
	                    // ����ͼ����Ϣ����  
	                    newsMessage.setArticleCount(articleList.size());  
	                    // ����ͼ����Ϣ������ͼ�ļ���  
	                    newsMessage.setArticles(articleList);  
	                    // ��ͼ����Ϣ����ת����xml�ַ���  
	                    respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage);  
                	} 
                	 // ��ͼ����Ϣ---����ͼƬ  
	                else if ("2".equals(content)) {  
	                    var article = new resp.Article();  
	                    article.setTitle("ʾ��2-��ͼ����Ϣ����ͼƬ");  
	                    // ͼ����Ϣ�п���ʹ��QQ���顢���ű���  
	                    article.setDescription("���壬80��"  
	                            + "��΢�Ź����ʺſ�������4���¡�Ϊ������ѧ�����ţ����Ƴ���ϵ�����ؽ̳̣�Ҳϣ����˻�����ʶ����ͬ�У�\n\nĿǰ���Ƴ��̳̹�12ƪ�������ӿ����á���Ϣ��װ����ܴ��QQ���鷢�͡����ű��鷢�͵ȡ�\n\n���ڻ��ƻ��Ƴ�һЩʵ�ù��ܵĿ������⣬���磺����Ԥ�����ܱ����������칦�ܵȡ�");  
	                    // ��ͼƬ��Ϊ��  
	                    article.setPicUrl("");  
	                    article.setUrl("http://blog.csdn.net/lyq8479");  
	                    articleList.add(article);  
	                    newsMessage.setArticleCount(articleList.size());  
	                    newsMessage.setArticles(articleList);  
	                    respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage);  
	                } 
	                // ��ͼ����Ϣ  
	                else if ("3".equals(content)) {  
	                    var article1 = new resp.Article();  
	                    article1.setTitle("ʾ��3-��ͼ����Ϣ\n��1ƪ ΢���ʺſ����̳�");  
	                    article1.setDescription("");  
	                    article1.setPicUrl("http://b275.photo.store.qq.com/psb?/V11JGWQf4B4Knx/XVCibE*CtxdQsJDpUa0HPM6nZqEjKFgOsCztHUa6GeE!/b/dIfG76M2IQAA&bo=wAOAAgAAAAABAGY!&rf=photoDetail");  
	                    article1.setUrl("http://blog.csdn.net/lyq8479/article/details/8937622");  
	  
	                    var article2 = new resp.Article();  
	                    article2.setTitle("��2ƪ\n΢�Ź����ʺŵ�����");  
	                    article2.setDescription("");  
	                    article2.setPicUrl("http://avatar.csdn.net/1/4/A/1_lyq8479.jpg");  
	                    article2.setUrl("http://blog.csdn.net/lyq8479/article/details/8941577");  
	  
	                    var article3 = new resp.Article();  
	                    article3.setTitle("��3ƪ\n����ģʽ���ü��ӿ�����");  
	                    article3.setDescription("");  
	                    article3.setPicUrl("http://avatar.csdn.net/1/4/A/1_lyq8479.jpg");  
	                    article3.setUrl("http://blog.csdn.net/lyq8479/article/details/8944988");  
	  
	                    articleList.add(article1);  
	                    articleList.add(article2);  
	                    articleList.add(article3);  
	                    newsMessage.setArticleCount(articleList.size());  
	                    newsMessage.setArticles(articleList);  
	                    respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage);  
	                }  
	                 // ��ͼ����Ϣ---������Ϣ����ͼƬ  
	                else if ("4".equals(content)) {  
	                    var article1 = new resp.Article();  
	                    article1.setTitle("ʾ��4-������Ϣ����ͼƬ");  
	                    article1.setDescription("");  
	                    // ��ͼƬ��Ϊ��  
	                    article1.setPicUrl("");  
	                    article1.setUrl("http://blog.csdn.net/lyq8479");  
	  
	                    var article2 = new resp.Article();  
	                    article2.setTitle("��4ƪ\n��Ϣ����Ϣ�����ߵķ�װ");  
	                    article2.setDescription("");  
	                    article2.setPicUrl("http://avatar.csdn.net/1/4/A/1_lyq8479.jpg");  
	                    article2.setUrl("http://blog.csdn.net/lyq8479/article/details/8949088");  
	  
	                    var article3 = new resp.Article();  
	                    article3.setTitle("��5ƪ\n������Ϣ�Ľ�������Ӧ");  
	                    article3.setDescription("");  
	                    article3.setPicUrl("http://avatar.csdn.net/1/4/A/1_lyq8479.jpg");  
	                    article3.setUrl("http://blog.csdn.net/lyq8479/article/details/8952173");  
	  
	                    var article4 = new resp.Article();  
	                    article4.setTitle("��6ƪ\n�ı���Ϣ�����ݳ������ƽ���");  
	                    article4.setDescription("");  
	                    article4.setPicUrl("http://avatar.csdn.net/1/4/A/1_lyq8479.jpg");  
	                    article4.setUrl("http://blog.csdn.net/lyq8479/article/details/8967824");  
	  
	                    articleList.add(article1);  
	                    articleList.add(article2);  
	                    articleList.add(article3);  
	                    articleList.add(article4);  
	                    newsMessage.setArticleCount(articleList.size());  
	                    newsMessage.setArticles(articleList);  
	                    respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage);  
	                }
	                // ��ͼ����Ϣ---���һ����Ϣ����ͼƬ  
	                else if ("5".equals(content)) {  
	                    var article1 = new resp.Article();  
	                    article1.setTitle("ʾ��5-���һ����Ϣ����ͼƬ\n��7ƪ �ı���Ϣ�л��з���ʹ��");  
	                    article1.setDescription("");  
	                    article1.setPicUrl("http://b275.photo.store.qq.com/psb?/V11JGWQf4B4Knx/XVCibE*CtxdQsJDpUa0HPM6nZqEjKFgOsCztHUa6GeE!/b/dIfG76M2IQAA&bo=wAOAAgAAAAABAGY!&rf=photoDetail");  
	                    article1.setUrl("http://blog.csdn.net/lyq8479/article/details/9141467");  
	  
	                    var article2 = new resp.Article();  
	                    article2.setTitle("��8ƪ\n�ı���Ϣ��ʹ����ҳ������");  
	                    article2.setDescription("");  
	                    article2.setPicUrl("http://avatar.csdn.net/1/4/A/1_lyq8479.jpg");  
	                    article2.setUrl("http://blog.csdn.net/lyq8479/article/details/9157455");  
	  
	                    var article3 = new resp.Article();  
	                    article3.setTitle("����������¶���������������ͨ���������Ի��ע΢�Ź����ʺ�xiaoqrobot��֧�����壡");  
	                    article3.setDescription("");  
	                    // ��ͼƬ��Ϊ��  
	                    article3.setPicUrl("");  
	                    article3.setUrl("http://blog.csdn.net/lyq8479");  
	  
	                    articleList.add(article1);  
	                    articleList.add(article2);  
	                    articleList.add(article3);  
	                    newsMessage.setArticleCount(articleList.size());  
	                    newsMessage.setArticles(articleList);  
	                    respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage);  
	                } 
                	
                	return respMessage;
	                
		}
		
	}
	catch (Exception e) {
		if (db != null) db.Rollback();
		textMessage.setContent(e.toString());
		respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
		return respMessage;
	}
	finally {
		if (db != null) db.Close();
	}
				
	textMessage.setContent("��л���Ĺ�ע�������屣�ս߳�Ϊ������");
	respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
	return respMessage;

	
}

function emoji(hexEmoji) 
{
	return java.lang.String.valueOf(java.lang.Character.toChars(hexEmoji));
}


//������Ϣ����
function sendMessage()
{
	var appid = "wx28ea8c2a0d5bd3d0";
	var secret = "a25e8d427bc2034d4be0a3c4fc36d9c9";
//	var accessToken = weixin.WeixinUtil.getAccessToken("wx28ea8c2a0d5bd3d0","a25e8d427bc2034d4be0a3c4fc36d9c9");
//	var token = accessToken.getToken();
	
	var url="https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid="+appid+"&secret="+secret;
	var httpcall = new webget.HttpCall();
	var token = httpcall.Get(url,"UTF-8");	
	var jsobj = json.JSONObject.fromObject(token); 
	token = jsobj.getString("access_token");
	//return token;
	url = "https://api.weixin.qq.com/cgi-bin/message/template/send?access_token="+token;
	
	var sendcount = 0;
	var failcount = 0;
	var arr_openid = openids.split(",");
	//return arr_openid;
	//openid=oxLTvjpEpXE_Ec_hlquFVnVdXIGE
	for (var i=0;i<arr_openid.length();i++) {
		var jsonstr = "{
			\"touser\":\""+arr_openid[i]+"\",
			\"template_id\":\"vKHqya-KyGQOn9o8KId8lQE1uSlp4a4rXAFR7UTwTfU\",
			\"url\":\"http://www.bgic.com\",
			\"topcolor\":\"#00FF00\",
			\"data\":{
				\"title\":{ \"value\":\"�ף�����������\",\"color\":\"#181818\" },
				\"work\":{ \"value\":\"�����屣��ף�������д��ˣ���ע���ߣ�����ط���\",\"color\":\"#181818\" },
				\"remark\":{ \"value\":\"���ע��˶�����\",\"color\":\"#181818\"}
			}
		}";
		
//		jsonstr = "{
//			\"touser\":\"oxLTvjoQVvJxMleyeshJif2OPEW8\",
//			\"template_id\":\"L_Iprr_uV2YC1RGZvw-UVfkxraE-9zijhQEr_aLPetM\",
//			\"url\":\"http://www.bgic.com\",
//			\"topcolor\":\"#00FF00\",
//			\"data\":{
//				\"productType\":{ \"value\":\"ҵ����\",\"color\":\"#181818\" },
//				\"name\":{ \"value\":\"�����屣��xxx��\",\"color\":\"#181818\" },
//				\"number\":{ \"value\":\"1��\",\"color\":\"#181818\" },
//				\"expDate\":{ \"value\":\"������Ч\",\"color\":\"#181818\" },
//				\"remark\":{ \"value\":\"��ע���������ʣ��벦����ѯ˶���������4006221068��\",\"color\":\"#181818\"}
//			}
//		}";
	
		var jsonObject = weixin.WeixinUtil.httpRequest(url,"POST",""+jsonstr);
		if (jsonObject != null) {
			var result = jsonObject.getInt("errcode");
			if (result == "0") sendcount ++;
			else failcount ++;
			//return result+":"+jsonObject.getString("errmsg");
		}
	}
	return "������Ϣ��ϣ��ɹ�"+sendcount+"��ʧ��"+failcount+"��";
}

}
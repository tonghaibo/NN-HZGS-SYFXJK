function x_weixinFang(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var resp = new JavaPackage("com.xlsgrid.net.weixin.message.resp");
var weixin = new JavaPackage("com.xlsgrid.net.weixin");

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
	//pub.EAFunc.Log("С��֪�� req="+request);

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
	                
	                // ��ѯ�˵���
	                if ("?".equals(content) || "��".equals(content)) {
	                	textMessage.setContent("�����˵�\n\n1) ����<a href=\"http://fl.act.qq.com/27330/addev/h5/46597?v=demo\">�ҵķ���΢վ</a>\n2) ͼ����ϢDEMO����ظ�1,2,3,4,5\n3) �����ҵ�λ��\n");
				respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
	                	return respMessage;

	                }
	                
	                // ��ͼ����Ϣ  
	                else if ("1".equals(content)) {  
	                    var article = new resp.Article();  
	                    article.setTitle("ʾ��1-��ͼ����Ϣ");  
	                    article.setDescription("΢�Ź���ƽ̨��ʼ֧��ǰ����ҳ����ҿ��ܿ����ܶ���ҳ�϶��з�������Ȧ����ע΢�ŵȰ�ť��������Ƕ��ᵯ��һ�������������͹�ע���������ôʵ�ֵ��أ�����͸���ҽ����������΢�Ź���ƽ̨ǰ����ҳ����ӷ�������Ȧ����ע΢�źŵȰ�ť��\n\n"
	                    	+ "ͨ���ڵ����ϴ�΢�ŵ���ҳ�����ǿ��Է���΢����Ƕ�����������һ��˽�� JavaScript ����WeixinJSBridge��ͨ����������������ط�������ʵ�ַ���΢������Ȧ�����ж�һ��΢�źŵĹ�ע״̬�Լ�ʵ�ֹ�עָ��΢�źŵȹ��ܡ�");  
	                    article.setPicUrl("http://b275.photo.store.qq.com/psb?/V11JGWQf4B4Knx/XVCibE*CtxdQsJDpUa0HPM6nZqEjKFgOsCztHUa6GeE!/b/dIfG76M2IQAA&bo=wAOAAgAAAAABAGY!&rf=photoDetail");  
	                    article.setUrl("http://www.xlsgrid.net/xlsgrid/ROOT_0/wxdemo.sp?usrid=xlsgrid&userpwd=0");  
	                    articleList.add(article);  
	                    // ����ͼ����Ϣ����  
	                    newsMessage.setArticleCount(articleList.size());  
	                    // ����ͼ����Ϣ������ͼ�ļ���  
	                    newsMessage.setArticles(articleList);  
	                    // ��ͼ����Ϣ����ת����xml�ַ���  
	                    respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage);  
	                    return respMessage;
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
	                    return respMessage;
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
	                    return respMessage;
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
	                    return respMessage;
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
	                    return respMessage;
	                } 
                	
                	//textMessage.setContent("Oh,sorry���������һ�С��Ҫ�۸���Ŷ��������˽������<a href=\"http://user.qzone.qq.com/281778354/infocenter\">С���Ŀռ�</a>,come in baby!");
                	textMessage.setContent("Oh,sorry���������һ�С��Ҫ�۸���Ŷ����ظ�����ѯ�����˵��лл��");
			respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
                	return respMessage;
	                
		}
		
		else if (msgType.equals(weixin.MessageUtil.REQ_MESSAGE_TYPE_EVENT)) {
			// �¼�����
			var eventType = requestMap.get("Event");
			// ����
			if (eventType.equals(weixin.MessageUtil.EVENT_TYPE_SUBSCRIBE)) {
				textMessage.setContent("��л����עС��֪���������Ҵ���к���ʶһ�°ɣ�^_^\n\n����?��ѯ�˵���");
				respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
				return respMessage;
			}
			// ȡ������
			else if (eventType.equals(weixin.MessageUtil.EVENT_TYPE_UNSUBSCRIBE)) {
				// TODO ȡ�����ĺ��û����ղ������ںŷ��͵���Ϣ����˲���Ҫ�ظ���Ϣ
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
                    	article.setTitle("����Ȧ����ͳ����ʾ");  
                    	article.setDescription(lb+"\n\n�������ҳ������ɹ������ݻ�д���ƹ�ͳ�����ݿ⣡");  
                    	article.setPicUrl("https://mmbiz.qlogo.cn/mmbiz/t4l43QDP1ohmsQhVsGQxkhl3pLUSQDd7INw7x3BpWXRGvWj5ncWuZXg6RKUQlabNWq5ibhPY2PFQA0iawpjSyGDQ/0");  
                    	article.setUrl("http://www.xlsgrid.net/xlsgrid/ROOT_0/demo1.sp?usrid=xlsgrid&userpwd=0&lx="+lx+"&ly="+ly+"&lb="+java.net.URLEncoder.encode(lb,"gbk"));  
                    	//article.setUrl("http://mp.weixin.qq.com/s?__biz=MzA5MjM2OTIwNw==&mid=200701634&idx=1&sn=97640c1097752e83d60f6f16371384be#rd");
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
		textMessage.setContent(e.toString());
		respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
		return respMessage;
	}
	finally {
		if (db != null) db.Close();
	}

	textMessage.setContent("Oh,sorry������Ŷ���һ�С��Ҫ�۸��ҡ�\n������˽�������ҵĿۿۿռ�<a href=\"http://user.qzone.qq.com/281778354/infocenter\">С���Ŀռ�</a>");
	respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
	return respMessage;

	
}

function emoji(hexEmoji) 
{
	return java.lang.String.valueOf(java.lang.Character.toChars(hexEmoji));
}

function shareDemo()
{
	return "�������ҳ";
}

}
function x_weixinGxZhenLong(){var pub = new JavaPackage("com.xlsgrid.net.pub");
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
		var dt = new java.util.Date();

		request.getSession().setAttribute("WEIXIN_FROMUSERNAME",fromUserName);

		// �ظ��ı���Ϣ
		textMessage = new resp.TextMessage();
		textMessage.setToUserName(fromUserName);
		textMessage.setFromUserName(toUserName);
		var dt = new java.util.Date();
		textMessage.setCreateTime(dt.getTime());
		textMessage.setMsgType(weixin.MessageUtil.RESP_MESSAGE_TYPE_TEXT);
		textMessage.setFuncFlag(0);
		
		//���û�
		if (content.indexOf("/") > -1) {
			db = new pub.EADatabase();
			var id = content.split("/")[0];
			var pwd = content.split("/")[1];
			var ds = db.QuerySQL("select * from weixin_userbind where fromusername='"+fromUserName+"'");
			//����Ƿ��Ѱ�ϵͳ
			if (ds.getRowCount() <= 0) {
				var usrds = db.QuerySQL("select * from usr where id='"+id+"' and passwd='"+pwd+"'");
				if (usrds.getRowCount() <= 0) {
					textMessage.setContent("�û��������벻��ȷ�����飡");
				}
				else {
					db.ExcecutSQL("insert into weixin_userbind(org,syt,FromUserName,usrid,passwd,TOUSERNAME)values('XLSGRID','XLSGRID','"+fromUserName+"','"+id+"','"+pwd+"','"+toUserName+"')");
					textMessage.setContent(usrds.getStringAt(0, "NAME")+" ���ã������ʺŰ󶨳ɹ���");
				}
			}
			else {
				textMessage.setContent("�����ʺ��Ѿ��󶨣�����Ҫ�ظ��󶨣�");
			}
			respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
			return respMessage;
		}
		
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
				textMessage.setContent("���ã���л��ע���̹�ҵ�����ٷ�΢�ţ�");
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
		  		// һ������
		                if (eventKey.equals("11")) {  
					textMessage.setContent("һ������˵�������");
				} 
				// ���빥��
				else if (eventKey.equals("12")) {  
					textMessage.setContent("���빥�Բ˵�������");
				} 
				// ��ϵ����
				else if (eventKey.equals("13")) {  
					textMessage.setContent("��ϵ���ǲ˵�������");
				} 
				// �߽�����
				else if (eventKey.equals("21")) {  
					textMessage.setContent("�߽������˵�������");
				} 
				// ΢���� 
				else if (eventKey.equals("22")) {  
					textMessage.setContent("΢�����˵�������");
				} 
				// ��������
				else if (eventKey.equals("23")) {  
					textMessage.setContent("�������ò˵�������");
				} 
				// ��������
				else if (eventKey.equals("31")) {  
					textMessage.setContent("�������Ĳ˵�������");  
				} 
				// ����΢��
				else if (eventKey.equals("32")) {  
					textMessage.setContent("����΢���˵�������");  
				} 
				// ��Ѷ΢��
				else if (eventKey.equals("33")) {  
					textMessage.setContent("��Ѷ΢���˵�������");  
				}
				
  				respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
				return respMessage;
			}
		}
		// ���͵���λ����Ϣ
		else if (msgType.equals(weixin.MessageUtil.REQ_MESSAGE_TYPE_LOCATION)) { 
			
		}
		//�ı���Ϣ
		else {
			if (content == "@1000") { //��ȡ�������
				// ����ͼ����Ϣ  
		                var newsMessage = new resp.NewsMessage();  
		                newsMessage.setToUserName(fromUserName);  
		                newsMessage.setFromUserName(toUserName);  
		                newsMessage.setCreateTime(dt.getTime());  
		                newsMessage.setMsgType(weixin.MessageUtil.RESP_MESSAGE_TYPE_NEWS);  
		                newsMessage.setFuncFlag(0);  
	
				var articleList = new java.util.ArrayList(); 
		                    	
				var ds = pub.EADbTool.QuerySQL("select * from weixin_appmsg where mid in (select mid from zywx_trklist where sysdate-dat1>=0 and dat2-sysdate>=0)");
				for (var i=0;i<ds.getRowCount();i++) {
					var mid = ds.getStringAt(i,"MID");
					var title = ds.getStringAt(i,"TITLE");
					var desc = ds.getStringAt(i,"SUMMARY");
					var imgurl = ds.getStringAt(i,"IMGURL");
					
					var article = new resp.Article();  
		                    	article.setTitle(title);  
		                    	article.setDescription(desc);  
		                    	article.setPicUrl(imgurl);  
		                    	article.setUrl("http://gxzy.xmidware.com/xlsgrid/ROOT_ZYWX/getmsg.sp?usrid=xlsgrid&userpwd=0&openid="+fromUserName+"&mid="+mid);  
		                    	articleList.add(article);  
	                    	}

	                    	// ����ͼ����Ϣ����  
	                    	newsMessage.setArticleCount(articleList.size());  
	                    	// ����ͼ����Ϣ������ͼ�ļ���  
	                    	newsMessage.setArticles(articleList);  
	                   	// ��ͼ����Ϣ����ת����xml�ַ���  
	                   	respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage); 
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
	textMessage.setContent("�ǳ���Ǹ�������ڳɳ������У�������������Ѿ��������ҵ�֪ʶ��Χ��������գ�");
	respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
	return respMessage;
	
}


}
function x_weixinGxZhenLong(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var resp = new JavaPackage("com.xlsgrid.net.weixin.message.resp");
var weixin = new JavaPackage("com.xlsgrid.net.weixin");

/**
 * 微信的接口消息响应处理中间件
 * @author Harry
 * @date 2013-10-11
*/


//响应微信服务器的业务逻辑处理方法
//function doPost()
function coreService(request,response)
{
	//防止中文乱码
	response.setContentType("content-type:text/html; charset=UTF-8");
	
	var respMessage = null;
	var textMessage = null;
	var db = null;
	
	try {
		// xml请求解析
		var requestMap = weixin.MessageUtil.parseXml(request);	
		// 发送方帐号（open_id）
		var fromUserName = requestMap.get("FromUserName");
		// 公众帐号
		var toUserName = requestMap.get("ToUserName");
		// 消息类型
		var msgType = requestMap.get("MsgType");
		// 文本消息内容
		var content = requestMap.get("Content");
		var dt = new java.util.Date();

		request.getSession().setAttribute("WEIXIN_FROMUSERNAME",fromUserName);

		// 回复文本消息
		textMessage = new resp.TextMessage();
		textMessage.setToUserName(fromUserName);
		textMessage.setFromUserName(toUserName);
		var dt = new java.util.Date();
		textMessage.setCreateTime(dt.getTime());
		textMessage.setMsgType(weixin.MessageUtil.RESP_MESSAGE_TYPE_TEXT);
		textMessage.setFuncFlag(0);
		
		//绑定用户
		if (content.indexOf("/") > -1) {
			db = new pub.EADatabase();
			var id = content.split("/")[0];
			var pwd = content.split("/")[1];
			var ds = db.QuerySQL("select * from weixin_userbind where fromusername='"+fromUserName+"'");
			//检查是否已绑定系统
			if (ds.getRowCount() <= 0) {
				var usrds = db.QuerySQL("select * from usr where id='"+id+"' and passwd='"+pwd+"'");
				if (usrds.getRowCount() <= 0) {
					textMessage.setContent("用户名或密码不正确，请检查！");
				}
				else {
					db.ExcecutSQL("insert into weixin_userbind(org,syt,FromUserName,usrid,passwd,TOUSERNAME)values('XLSGRID','XLSGRID','"+fromUserName+"','"+id+"','"+pwd+"','"+toUserName+"')");
					textMessage.setContent(usrds.getStringAt(0, "NAME")+" 您好，您的帐号绑定成功！");
				}
			}
			else {
				textMessage.setContent("您的帐号已经绑定，不需要重复绑定！");
			}
			respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
			return respMessage;
		}
		
		// 创建图文消息  
		var newsMessage = new resp.NewsMessage();  
		newsMessage.setToUserName(fromUserName);  
		newsMessage.setFromUserName(toUserName);  
		newsMessage.setCreateTime(dt.getTime());  
		newsMessage.setMsgType(weixin.MessageUtil.RESP_MESSAGE_TYPE_NEWS);  
		newsMessage.setFuncFlag(0);  
		
		if (msgType.equals(weixin.MessageUtil.REQ_MESSAGE_TYPE_EVENT)) {
			// 事件类型
			var eventType = requestMap.get("Event");
			// 订阅
			if (eventType.equals(weixin.MessageUtil.EVENT_TYPE_SUBSCRIBE)) {
				textMessage.setContent("您好！感谢关注中烟工业真龙官方微信！");
				respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
				return respMessage;
			}
			// 取消订阅
			else if (eventType.equals(weixin.MessageUtil.EVENT_TYPE_UNSUBSCRIBE)) {
				// TODO 取消订阅后用户再收不到公众号发送的消息，因此不需要回复消息
			}
			// 自定义菜单点击事件
			else if (eventType.equals(weixin.MessageUtil.EVENT_TYPE_CLICK)) {             

				// 事件KEY值，与创建自定义菜单时指定的KEY值对应  
		                var eventKey = requestMap.get("EventKey");  
		  		// 一键进入
		                if (eventKey.equals("11")) {  
					textMessage.setContent("一键进入菜单项被点击！");
				} 
				// 拍码攻略
				else if (eventKey.equals("12")) {  
					textMessage.setContent("拍码攻略菜单项被点击！");
				} 
				// 联系我们
				else if (eventKey.equals("13")) {  
					textMessage.setContent("联系我们菜单项被点击！");
				} 
				// 走进真龙
				else if (eventKey.equals("21")) {  
					textMessage.setContent("走进真龙菜单项被点击！");
				} 
				// 微社区 
				else if (eventKey.equals("22")) {  
					textMessage.setContent("微社区菜单项被点击！");
				} 
				// 真龙大讲堂
				else if (eventKey.equals("23")) {  
					textMessage.setContent("真龙大讲堂菜单项被点击！");
				} 
				// 精彩美文
				else if (eventKey.equals("31")) {  
					textMessage.setContent("精彩美文菜单项被点击！");  
				} 
				// 新浪微博
				else if (eventKey.equals("32")) {  
					textMessage.setContent("新浪微博菜单项被点击！");  
				} 
				// 腾讯微博
				else if (eventKey.equals("33")) {  
					textMessage.setContent("腾讯微博菜单项被点击！");  
				}
				
  				respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
				return respMessage;
			}
		}
		// 发送地理位置信息
		else if (msgType.equals(weixin.MessageUtil.REQ_MESSAGE_TYPE_LOCATION)) { 
			
		}
		//文本信息
		else {
			if (content == "@1000") { //领取任务代码
				// 创建图文消息  
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

	                    	// 设置图文消息个数  
	                    	newsMessage.setArticleCount(articleList.size());  
	                    	// 设置图文消息包含的图文集合  
	                    	newsMessage.setArticles(articleList);  
	                   	// 将图文消息对象转换成xml字符串  
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
	textMessage.setContent("非常抱歉，我正在成长过程中，您的问题可能已经超出了我的知识范围，请多多关照！");
	respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
	return respMessage;
	
}


}
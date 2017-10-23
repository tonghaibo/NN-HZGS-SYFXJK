function x_weixinFang(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var resp = new JavaPackage("com.xlsgrid.net.weixin.message.resp");
var weixin = new JavaPackage("com.xlsgrid.net.weixin");

/**
 * 微信的接口消息响应处理中间件
 * @author Harry
 * @date 2013-10-11
*/


//响应微信服务器的业务逻辑处理方法
function doPost()
{
	//防止中文乱码
	response.setContentType("content-type:text/html; charset=UTF-8");

	var respMessage = null;
	var textMessage = null;
	var db = null;
	//pub.EAFunc.Log("小方知道 req="+request);

	try {
		// xml请求解析
		var requestMap = weixin.MessageUtil.parseXml(request);	
		
		// 发送方帐号（open_id）
		var fromUserName = requestMap.get("FromUserName");
		
		// 公众帐号
		var toUserName = requestMap.get("ToUserName");
		// 消息类型
		var msgType = requestMap.get("MsgType");
		
		//request.getSession().setAttribute("WEIXIN_FROMUSERNAME",fromUserName);

		// 回复文本消息
		textMessage = new resp.TextMessage();
		textMessage.setToUserName(fromUserName);
		textMessage.setFromUserName(toUserName);
		var dt = new java.util.Date();
		textMessage.setCreateTime(dt.getTime());
		textMessage.setMsgType(weixin.MessageUtil.RESP_MESSAGE_TYPE_TEXT);
		textMessage.setFuncFlag(0);
		
		// 文本消息  
		if (msgType.equals(weixin.MessageUtil.REQ_MESSAGE_TYPE_TEXT)) {  
	                // 接收用户发送的文本消息内容  
	                var content = requestMap.get("Content");  
	  
	                // 创建图文消息  
	                var newsMessage = new resp.NewsMessage();  
	                newsMessage.setToUserName(fromUserName);  
	                newsMessage.setFromUserName(toUserName);  
	                newsMessage.setCreateTime(dt.getTime());  
	                newsMessage.setMsgType(weixin.MessageUtil.RESP_MESSAGE_TYPE_NEWS);  
	                newsMessage.setFuncFlag(0);  
	  
	                var articleList = new java.util.ArrayList();  
	                
	                // 查询菜单项
	                if ("?".equals(content) || "？".equals(content)) {
	                	textMessage.setContent("导航菜单\n\n1) 进入<a href=\"http://fl.act.qq.com/27330/addev/h5/46597?v=demo\">我的风铃微站</a>\n2) 图文消息DEMO，请回复1,2,3,4,5\n3) 发送我的位置\n");
				respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
	                	return respMessage;

	                }
	                
	                // 单图文消息  
	                else if ("1".equals(content)) {  
	                    var article = new resp.Article();  
	                    article.setTitle("示例1-单图文消息");  
	                    article.setDescription("微信公众平台开始支持前端网页，大家可能看到很多网页上都有分享到朋友圈，关注微信等按钮，点击它们都会弹出一个窗口让你分享和关注，这个是怎么实现的呢？今天就给大家讲解下如何在微信公众平台前端网页上添加分享到朋友圈，关注微信号等按钮。\n\n"
	                    	+ "通过在电脑上打开微信的网页，我们可以发现微信内嵌浏览器定义了一个私有 JavaScript 对象：WeixinJSBridge，通过操作这个对象的相关方法可以实现分享到微信朋友圈，和判断一个微信号的关注状态以及实现关注指定微信号等功能。");  
	                    article.setPicUrl("http://b275.photo.store.qq.com/psb?/V11JGWQf4B4Knx/XVCibE*CtxdQsJDpUa0HPM6nZqEjKFgOsCztHUa6GeE!/b/dIfG76M2IQAA&bo=wAOAAgAAAAABAGY!&rf=photoDetail");  
	                    article.setUrl("http://www.xlsgrid.net/xlsgrid/ROOT_0/wxdemo.sp?usrid=xlsgrid&userpwd=0");  
	                    articleList.add(article);  
	                    // 设置图文消息个数  
	                    newsMessage.setArticleCount(articleList.size());  
	                    // 设置图文消息包含的图文集合  
	                    newsMessage.setArticles(articleList);  
	                    // 将图文消息对象转换成xml字符串  
	                    respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage);  
	                    return respMessage;
                	} 
                	 // 单图文消息---不含图片  
	                else if ("2".equals(content)) {  
	                    var article = new resp.Article();  
	                    article.setTitle("示例2-单图文消息不含图片");  
	                    // 图文消息中可以使用QQ表情、符号表情  
	                    article.setDescription("柳峰，80后，"  
	                            + "，微信公众帐号开发经验4个月。为帮助初学者入门，特推出此系列连载教程，也希望借此机会认识更多同行！\n\n目前已推出教程共12篇，包括接口配置、消息封装、框架搭建、QQ表情发送、符号表情发送等。\n\n后期还计划推出一些实用功能的开发讲解，例如：天气预报、周边搜索、聊天功能等。");  
	                    // 将图片置为空  
	                    article.setPicUrl("");  
	                    article.setUrl("http://blog.csdn.net/lyq8479");  
	                    articleList.add(article);  
	                    newsMessage.setArticleCount(articleList.size());  
	                    newsMessage.setArticles(articleList);  
	                    respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage);  
	                    return respMessage;
	                } 
	                // 多图文消息  
	                else if ("3".equals(content)) {  
	                    var article1 = new resp.Article();  
	                    article1.setTitle("示例3-多图文消息\n第1篇 微信帐号开发教程");  
	                    article1.setDescription("");  
	                    article1.setPicUrl("http://b275.photo.store.qq.com/psb?/V11JGWQf4B4Knx/XVCibE*CtxdQsJDpUa0HPM6nZqEjKFgOsCztHUa6GeE!/b/dIfG76M2IQAA&bo=wAOAAgAAAAABAGY!&rf=photoDetail");  
	                    article1.setUrl("http://blog.csdn.net/lyq8479/article/details/8937622");  
	  
	                    var article2 = new resp.Article();  
	                    article2.setTitle("第2篇\n微信公众帐号的类型");  
	                    article2.setDescription("");  
	                    article2.setPicUrl("http://avatar.csdn.net/1/4/A/1_lyq8479.jpg");  
	                    article2.setUrl("http://blog.csdn.net/lyq8479/article/details/8941577");  
	  
	                    var article3 = new resp.Article();  
	                    article3.setTitle("第3篇\n开发模式启用及接口配置");  
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
	                 // 多图文消息---首条消息不含图片  
	                else if ("4".equals(content)) {  
	                    var article1 = new resp.Article();  
	                    article1.setTitle("示例4-首条消息不含图片");  
	                    article1.setDescription("");  
	                    // 将图片置为空  
	                    article1.setPicUrl("");  
	                    article1.setUrl("http://blog.csdn.net/lyq8479");  
	  
	                    var article2 = new resp.Article();  
	                    article2.setTitle("第4篇\n消息及消息处理工具的封装");  
	                    article2.setDescription("");  
	                    article2.setPicUrl("http://avatar.csdn.net/1/4/A/1_lyq8479.jpg");  
	                    article2.setUrl("http://blog.csdn.net/lyq8479/article/details/8949088");  
	  
	                    var article3 = new resp.Article();  
	                    article3.setTitle("第5篇\n各种消息的接收与响应");  
	                    article3.setDescription("");  
	                    article3.setPicUrl("http://avatar.csdn.net/1/4/A/1_lyq8479.jpg");  
	                    article3.setUrl("http://blog.csdn.net/lyq8479/article/details/8952173");  
	  
	                    var article4 = new resp.Article();  
	                    article4.setTitle("第6篇\n文本消息的内容长度限制揭秘");  
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
	                // 多图文消息---最后一条消息不含图片  
	                else if ("5".equals(content)) {  
	                    var article1 = new resp.Article();  
	                    article1.setTitle("示例5-最后一条消息不含图片\n第7篇 文本消息中换行符的使用");  
	                    article1.setDescription("");  
	                    article1.setPicUrl("http://b275.photo.store.qq.com/psb?/V11JGWQf4B4Knx/XVCibE*CtxdQsJDpUa0HPM6nZqEjKFgOsCztHUa6GeE!/b/dIfG76M2IQAA&bo=wAOAAgAAAAABAGY!&rf=photoDetail");  
	                    article1.setUrl("http://blog.csdn.net/lyq8479/article/details/9141467");  
	  
	                    var article2 = new resp.Article();  
	                    article2.setTitle("第8篇\n文本消息中使用网页超链接");  
	                    article2.setDescription("");  
	                    article2.setPicUrl("http://avatar.csdn.net/1/4/A/1_lyq8479.jpg");  
	                    article2.setUrl("http://blog.csdn.net/lyq8479/article/details/9157455");  
	  
	                    var article3 = new resp.Article();  
	                    article3.setTitle("如果觉得文章对你有所帮助，请通过博客留言或关注微信公众帐号xiaoqrobot来支持柳峰！");  
	                    article3.setDescription("");  
	                    // 将图片置为空  
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
                	
                	//textMessage.setContent("Oh,sorry听不懂，我还小表要欺负我哦。更多地了解我请进<a href=\"http://user.qzone.qq.com/281778354/infocenter\">小方的空间</a>,come in baby!");
                	textMessage.setContent("Oh,sorry听不懂，我还小表要欺负我哦，请回复？查询导航菜单项，谢谢！");
			respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
                	return respMessage;
	                
		}
		
		else if (msgType.equals(weixin.MessageUtil.REQ_MESSAGE_TYPE_EVENT)) {
			// 事件类型
			var eventType = requestMap.get("Event");
			// 订阅
			if (eventType.equals(weixin.MessageUtil.EVENT_TYPE_SUBSCRIBE)) {
				textMessage.setContent("感谢您关注小方知道，来和我打个招呼认识一下吧！^_^\n\n输入?查询菜单项");
				respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
				return respMessage;
			}
			// 取消订阅
			else if (eventType.equals(weixin.MessageUtil.EVENT_TYPE_UNSUBSCRIBE)) {
				// TODO 取消订阅后用户再收不到公众号发送的消息，因此不需要回复消息
			}
		}
		
		else if (msgType.equals(weixin.MessageUtil.REQ_MESSAGE_TYPE_LOCATION)) { 
			var lx = requestMap.get("Location_X");
			var ly = requestMap.get("Location_Y");
			var lb = requestMap.get("Label");

//			textMessage.setContent("你发来了地理位置信息！["+lx+","+ly+"]"+lb);
//			respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
//			return respMessage;
			
			// 创建图文消息  
	                var newsMessage = new resp.NewsMessage();  
	                newsMessage.setToUserName(fromUserName);  
	                newsMessage.setFromUserName(toUserName);  
	                newsMessage.setCreateTime(dt.getTime());  
	                newsMessage.setMsgType(weixin.MessageUtil.RESP_MESSAGE_TYPE_NEWS);  
	                newsMessage.setFuncFlag(0);  

			var articleList = new java.util.ArrayList(); 
			var article = new resp.Article();  
                    	article.setTitle("朋友圈分享统计演示");  
                    	article.setDescription(lb+"\n\n分享测试页，分享成功，数据回写到推广统计数据库！");  
                    	article.setPicUrl("https://mmbiz.qlogo.cn/mmbiz/t4l43QDP1ohmsQhVsGQxkhl3pLUSQDd7INw7x3BpWXRGvWj5ncWuZXg6RKUQlabNWq5ibhPY2PFQA0iawpjSyGDQ/0");  
                    	article.setUrl("http://www.xlsgrid.net/xlsgrid/ROOT_0/demo1.sp?usrid=xlsgrid&userpwd=0&lx="+lx+"&ly="+ly+"&lb="+java.net.URLEncoder.encode(lb,"gbk"));  
                    	//article.setUrl("http://mp.weixin.qq.com/s?__biz=MzA5MjM2OTIwNw==&mid=200701634&idx=1&sn=97640c1097752e83d60f6f16371384be#rd");
                    	articleList.add(article);  
                    	// 设置图文消息个数  
                    	newsMessage.setArticleCount(articleList.size());  
                    	// 设置图文消息包含的图文集合  
                    	newsMessage.setArticles(articleList);  
                   	// 将图文消息对象转换成xml字符串  
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

	textMessage.setContent("Oh,sorry听不懂哦，我还小表要欺负我。\n更多地了解我请进我的扣扣空间<a href=\"http://user.qzone.qq.com/281778354/infocenter\">小方的空间</a>");
	respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
	return respMessage;

	
}

function emoji(hexEmoji) 
{
	return java.lang.String.valueOf(java.lang.Character.toChars(hexEmoji));
}

function shareDemo()
{
	return "分享测试页";
}

}
function x_weixinBgic(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var resp = new JavaPackage("com.xlsgrid.net.weixin.message.resp");
var weixin = new JavaPackage("com.xlsgrid.net.weixin");
var webget = new JavaPackage("com.xlsgrid.net.webget");
var json = new JavaPackage("net.sf.json");

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
	                
	                //绑定用户
			if (content.indexOf("/") > -1) {
				var id = content.split("/")[0];
				var pwd = content.split("/")[1];
				pub.EADbTool.ExcecutSQL("insert into weixin_userbind(org,syt,FromUserName,usrid,passwd,TOUSERNAME)values('BGIC','BGIC','"+fromUserName+"','"+id+"','"+pwd+"','"+toUserName+"')");
				 var article = new resp.Article();  
		                 article.setTitle("身份绑定验证");  
		                    article.setDescription("感谢您的使用，验证通过！");  
		                    article.setPicUrl("http://www.bgic.com/dds/2.jpg");  
		                    article.setUrl("http://www.bgic.com");  
		                    articleList.add(article);  
		                    // 设置图文消息个数  
		                    newsMessage.setArticleCount(articleList.size());  
		                    // 设置图文消息包含的图文集合  
		                    newsMessage.setArticles(articleList);  
		                    // 将图文消息对象转换成xml字符串  
		                    respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage);  

				return respMessage;
			}

	                // 单图文消息  
	                if ("1".equals(content)) {  
	                    var article = new resp.Article();  
	                    article.setTitle("示例1-单图文消息");  
	                    article.setDescription("柳峰，80后，微信公众帐号开发经验4个月。为帮助初学者入门，特推出此系列教程，也希望借此机会认识更多同行！");  
	                    article.setPicUrl("http://b275.photo.store.qq.com/psb?/V11JGWQf4B4Knx/XVCibE*CtxdQsJDpUa0HPM6nZqEjKFgOsCztHUa6GeE!/b/dIfG76M2IQAA&bo=wAOAAgAAAAABAGY!&rf=photoDetail");  
	                    article.setUrl("http://www.xlsgrid.net/xlsgrid/lungoTest/test1.html");  
	                    articleList.add(article);  
	                    // 设置图文消息个数  
	                    newsMessage.setArticleCount(articleList.size());  
	                    // 设置图文消息包含的图文集合  
	                    newsMessage.setArticles(articleList);  
	                    // 将图文消息对象转换成xml字符串  
	                    respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage);  
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
				
	textMessage.setContent("感谢您的关注！北部湾保险竭诚为您服务！");
	respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
	return respMessage;

	
}

function emoji(hexEmoji) 
{
	return java.lang.String.valueOf(java.lang.Character.toChars(hexEmoji));
}


//推送消息测试
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
				\"title\":{ \"value\":\"亲，给您拜年啦\",\"color\":\"#181818\" },
				\"work\":{ \"value\":\"北部湾保险祝您马年行大运，关注我者，马年必发！\",\"color\":\"#181818\" },
				\"remark\":{ \"value\":\"请关注：硕格软件\",\"color\":\"#181818\"}
			}
		}";
		
//		jsonstr = "{
//			\"touser\":\"oxLTvjoQVvJxMleyeshJif2OPEW8\",
//			\"template_id\":\"L_Iprr_uV2YC1RGZvw-UVfkxraE-9zijhQEr_aLPetM\",
//			\"url\":\"http://www.bgic.com\",
//			\"topcolor\":\"#00FF00\",
//			\"data\":{
//				\"productType\":{ \"value\":\"业务名\",\"color\":\"#181818\" },
//				\"name\":{ \"value\":\"北部湾保险xxx险\",\"color\":\"#181818\" },
//				\"number\":{ \"value\":\"1份\",\"color\":\"#181818\" },
//				\"expDate\":{ \"value\":\"永久有效\",\"color\":\"#181818\" },
//				\"remark\":{ \"value\":\"备注：如有疑问，请拨打咨询硕格软件热线4006221068。\",\"color\":\"#181818\"}
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
	return "推送消息完毕！成功"+sendcount+"，失败"+failcount+"。";
}

}
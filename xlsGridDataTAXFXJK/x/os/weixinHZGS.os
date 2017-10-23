function x_weixinHZGS(){var pub = new JavaPackage("com.xlsgrid.net.pub");
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
		
		request.getSession().setAttribute("WEIXIN_FROMUSERNAME",fromUserName);

		// 回复文本消息
		textMessage = new resp.TextMessage();
		textMessage.setToUserName(fromUserName);
		textMessage.setFromUserName(toUserName);
		var dt = new java.util.Date();
		textMessage.setCreateTime(dt.getTime());
		textMessage.setMsgType(weixin.MessageUtil.RESP_MESSAGE_TYPE_TEXT);
		textMessage.setFuncFlag(0);
		
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
				textMessage.setContent("您好！感谢关注贺州国税官方微信，这里为您提供相关的在线服务。");
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
		  		// 通知公告
		                if (eventKey.equals("11")) {  
					//textMessage.setContent("通知公告菜单项被点击！");
					return notifyMessage(respMessage,newsMessage);
				} 
				// 热点咨询
				else if (eventKey.equals("12")) {  
					textMessage.setContent("热点咨询，请回复标题前的数字编号查看详情。\n"
					+"【01】无营业执照的纳税人是否需要办理税务登记？\n"
					+"【02】遗失税务登记证件怎么办？\n"
					+"【03】办理税务登记证的单位和个人怎样办理发票领购簿？\n"
					+"【04】取得发票领购簿的单位和个人怎样购买发票？\n"
					+"【05】个体工商户没达到增值税起征点，可以领购发票吗？\n"
					+"【06】目前，纳税人可以采用哪些电子申报方式办理纳税申报？\n"
					+"【07】如何开通网上申报？\n");
				} 
				// 办税指南
				else if (eventKey.equals("21")) {  
					//textMessage.setContent("办税指南菜单项被点击！");
					return doTaxGuide(respMessage,newsMessage);
				} 
				// 办税地图 
				else if (eventKey.equals("22")) {  //行程计划-签到
					textMessage.setContent("想找办税厅地址？请点击对话框下方的“+”发送你的“位置”，我会帮您找到的。");
					
				} 
				// 投诉建议
				else if (eventKey.equals("23")) {  
					textMessage.setContent("投诉建议菜单项被点击！");
				} 
				// 发票真伪查询
				else if (eventKey.equals("31")) {  
					textMessage.setContent("发票真伪查询菜单项被点击！");  
				} 
				// 车辆购置税信息查询
				else if (eventKey.equals("32")) {  
					textMessage.setContent("车辆购置税信息查询菜单项被点击！");  
				} 
				// 购买发票预约
				else if (eventKey.equals("33")) {  
					textMessage.setContent("购买发票预约");  
				}
				// 大厅排队情况
				else if (eventKey.equals("34")) {  
					textMessage.setContent("【查询时间：2014-04-14 09:23】\n办税服务厅当前等待人数 5 人，请稍候...");  
				}
				
  				respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
				return respMessage;
			}
		}
		// 发送地理位置信息
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
                    	article.setTitle("办税服务厅地图");  
                    	article.setDescription(lb);  
                    	article.setPicUrl("http://hz.gxgs.gov.cn/picture/0/130106092532484.gif");  
                    	article.setUrl("http://www.xlsgrid.net/xlsgrid/ROOT_0/hztaxMap.sp?usrid=xlsgrid&userpwd=0&lx="+lx+"&ly="+ly+"&lb="+java.net.URLEncoder.encode(lb,"gbk"));  
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
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
	textMessage.setContent("非常抱歉，我正在成长过程中，您的问题可能已经超出了我的知识范围，请多多关照，Thank you！");
	respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
	return respMessage;
	
}


//取得TOKEN
function getToken(appid,secret)
{
	var url="https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid="+appid+"&secret="+secret;
	var httpcall = new webget.HttpCall();
	var token = httpcall.Get(url,"UTF-8");	
	var jsobj = json.JSONObject.fromObject(token); 
	token = jsobj.getString("access_token");
	return token;
}

//获取关注用户信息
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
		var nickname = jsoinfo.getString("nickname"); 			//昵称
		var sex = jsoinfo.getString("sex");				//性别
		var city = jsoinfo.getString("city");				//所在城市
		var country = jsoinfo.getString("country");			//所在国家
		var province = jsoinfo.getString("province");			//所在省份
		var language = jsoinfo.getString("language");			//用户的语言
		var headimgurl = jsoinfo.getString("headimgurl");		//用户头像
		var subscribe_time = jsoinfo.getString("subscribe_time");	//关注时间
		var dateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd");  
		var date = new java.util.Date();
		date.setTime(java.lang.Long.parseLong(subscribe_time)*1000);
		subscribe_time = dateFormat.format(date);
       
		
		xmlstr += "<ROW num='"+(i+1)+"'>\n";
		xmlstr += "\t<序号>"+(i+1)+"</序号>\n";
		xmlstr += "\t<用户标识>"+openid+"</用户标识>\n";
		xmlstr += "\t<用户头像>"+headimgurl+"</用户头像>\n";
		xmlstr += "\t<昵称>"+nickname+"</昵称>\n";
		xmlstr += "\t<性别>"+sex+"</性别>\n";
		xmlstr += "\t<所在城市>"+city+"</所在城市>\n";
		xmlstr += "\t<所在国家>"+country+"</所在国家>\n";
		xmlstr += "\t<所在省份>"+province+"</所在省份>\n";
		xmlstr += "\t<用户的语言>"+language+"</用户的语言>\n";
		xmlstr += "\t<关注时间>"+subscribe_time+"</关注时间>\n";
		xmlstr += "</ROW>\n";
	}
	
	xmlstr += "</ROWSET>";
	return xmlstr;
}

// 通知公告
function notifyMessage(respMessage,newsMessage)
{  
	var articleList = new java.util.ArrayList();  
	
	var article1 = new resp.Article();  
	article1.setTitle("国家税务总局关于实施《税收票证管理办法》若干问题的公告");  
	article1.setDescription("");  
	// 将图片置为空  
	article1.setPicUrl("http://img1.cache.netease.com/catchpic/F/F3/F3FFD07F25948BCED092492CD782BCB0.jpg");  
	article1.setUrl("http://hz.gxgs.gov.cn/art/2013/12/24/art_102131_242057.html");  
	articleList.add(article1);
	
	article1 = new resp.Article();  
	article1.setTitle("税收票证管理办法");  
	article1.setDescription("");  
	// 将图片置为空  
	article1.setPicUrl("http://www.html5cn.org/data/attachment/portal/201404/03/132634u44dyw6yw44hduch.png");  
	article1.setUrl("http://hz.gxgs.gov.cn/art/2013/12/24/art_102131_242055.html");  
	articleList.add(article1);
	
	article1 = new resp.Article();  
	article1.setTitle("贺州市国家税务局关于印发《贺州市国家税务局税务行政审批保留事项操作规范》和《贺州市国家税务局税务行政审批下放事项操作规范》的通知");  
	article1.setDescription("");  
	// 将图片置为空  
	article1.setPicUrl("http://www.html5cn.org/data/attachment/portal/201404/03/132634u44dyw6yw44hduch.png");  
	article1.setUrl("http://hz.gxgs.gov.cn/art/2012/9/17/art_102131_176380.html");  
	articleList.add(article1);

	newsMessage.setArticleCount(articleList.size());  
	newsMessage.setArticles(articleList);  
	respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage); 

	return respMessage;            
}

// 办税指南
function doTaxGuide(respMessage,newsMessage)
{
	var articleList = new java.util.ArrayList();  
	
	var article1 = new resp.Article();  
	article1.setTitle("办税指南");  
	article1.setDescription("");  
	// 将图片置为空  
	article1.setPicUrl("http://img1.cache.netease.com/catchpic/8/81/81C43116A06DEC6ADF38DB0C9A022548.jpg");  
	article1.setUrl("http://hz.gxgs.gov.cn/art/2013/12/24/art_102131_242057.html");  
	articleList.add(article1);
	
	article1 = new resp.Article();  
	article1.setTitle("税务登记");  
	article1.setDescription("");  
	// 将图片置为空  
	article1.setPicUrl("http://www.html5cn.org/data/attachment/portal/201404/03/132634u44dyw6yw44hduch.png");  
	article1.setUrl("http://hz.gxgs.gov.cn/art/2013/12/24/art_102131_242055.html");  
	articleList.add(article1);
	
	article1 = new resp.Article();  
	article1.setTitle("申报征收");  
	article1.setDescription("");  
	// 将图片置为空  
	article1.setPicUrl("http://www.html5cn.org/data/attachment/portal/201404/03/132634u44dyw6yw44hduch.png");  
	article1.setUrl("http://hz.gxgs.gov.cn/art/2012/9/17/art_102131_176380.html");  
	articleList.add(article1);

	article1 = new resp.Article();  
	article1.setTitle("核准认定");  
	article1.setDescription("");  
	// 将图片置为空  
	article1.setPicUrl("http://www.html5cn.org/data/attachment/portal/201404/03/132634u44dyw6yw44hduch.png");  
	article1.setUrl("http://hz.gxgs.gov.cn/art/2012/9/17/art_102131_176380.html");  
	articleList.add(article1);

	article1 = new resp.Article();  
	article1.setTitle("税收优惠");  
	article1.setDescription("");  
	// 将图片置为空  
	article1.setPicUrl("http://www.html5cn.org/data/attachment/portal/201404/03/132634u44dyw6yw44hduch.png");  
	article1.setUrl("http://hz.gxgs.gov.cn/art/2012/9/17/art_102131_176380.html");  
	articleList.add(article1);

	newsMessage.setArticleCount(articleList.size());  
	newsMessage.setArticles(articleList);  
	respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage); 

	return respMessage;            

}
}
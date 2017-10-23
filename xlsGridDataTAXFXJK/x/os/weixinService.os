function x_weixinService(){var pub = new JavaPackage("com.xlsgrid.net.pub");
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
	// 贺州国税
//	var weixinOS = new x_weixinHZGS();
//	return weixinOS.coreService(request,response);

	//广西中烟工业-真龙号
//	var weixinOS = new x_weixinGxZhenLong();
//	return weixinOS.coreService(request,response);

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
		
		db = new pub.EADatabase();
		
		var ds = db.QuerySQL("select * from weixin_userbind where fromusername='"+fromUserName+"'");
		//检查是否已绑定系统
		if (ds.getRowCount() <= 0 && content.indexOf("/") == -1) {
			textMessage.setContent("您还没有绑定到使用的系统，请回复用户名/密码进行绑定！例如：guest/test");
			respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
			return respMessage;
		}
		
		var borgid = "";
		var bsytid = "XLSGRID";
		var busrid = "";
		var bpwd = "";
		
		//已经绑定自动登录
		if (ds.getRowCount() > 0) {
			borgid = pub.EAFunc.NVL(ds.getStringAt(0, "ORG"),"XLSGRID");			
			busrid = ds.getStringAt(0, "USRID");
			bpwd = ds.getStringAt(0, "PASSWD");
			//pub.EAFunc.autoLogin(request, response);
		}
		
		if (msgType.equals(weixin.MessageUtil.REQ_MESSAGE_TYPE_EVENT)) {
			// 事件类型
			var eventType = requestMap.get("Event");
			// 订阅
			if (eventType.equals(weixin.MessageUtil.EVENT_TYPE_SUBSCRIBE)) {
				textMessage.setContent("感谢您的关注，请回复用户名/密码进行绑定！例如：guest/test");
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
		  		//pub.EAFunc.Log("eventKey="+eventKey);
		                if (eventKey.equals("11")) {  
					textMessage.setContent("请回复用户名/密码进行绑定！例如：guest/test <a href=\"http://www.xlsgrid.net/xlsgrid/org/XLSGRID/app/login.html\">点击登录</a>");
				} else if (eventKey.equals("12")) {  
					//textMessage.setContent("我的待办事务 >>");  
					//respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
					//return respMessage;
					try {
						return myTrkList(respMessage,newsMessage);
					}
					catch (e) {
						textMessage.setContent("系统出错:"+e.toString());  
						respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
						return respMessage;					
					}
				} else if (eventKey.equals("13")) {  
					//textMessage.setContent("我发起的事务 >>"); 
					return mySendTrkList(respMessage,newsMessage); 
				} else if (eventKey.equals("14")) {  
					//textMessage.setContent("所有事务 >>");  
					return allTrkList(respMessage,newsMessage);
				} else if (eventKey.equals("21")) {  
					//textMessage.setContent("通讯录 >>");  
					return memberActive(respMessage,newsMessage); // 连锁会员促销
					try {
						return contacts(respMessage,newsMessage);
					}
					catch (e) {
						textMessage.setContent("系统出错:"+e.toString());  
						respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
						return respMessage;					
					}

				} else if (eventKey.equals("22")) {  //行程计划-签到
					//textMessage.setContent("订单查询菜单项被点击！");  
					var msg = "";
					//判断当天是否已签到
					var myds = db.QuerySQL("select to_char(crtdat,'hh24:mi:ss') crtdat from SIGNIN where org='XLSGRID' and usrid in (
							select usrid from weixin_userbind where fromusername='"+fromUserName+"' and org='XLSGRID')
							and to_char(crtdat,'yyyymmdd')=to_char(sysdate,'yyyymmdd')");
					if (myds.getRowCount() > 0) {
						msg = "你已签到，签到时间："+myds.getStringAt(0,"CRTDAT");  
					}
					else {
						db.ExcecutSQL("insert into signin(org,usrid,crtdat,prj)values('XLSGRID','"+busrid+"',sysdate,'XLSGRID')");
						msg = "感谢你的签到，谢谢支持！";
					}
					
					//查询已签到列表
					myds = db.QuerySQL("select a.usrid,b.name,to_char(a.crtdat,'hh24:mi:ss') crtdat 
								from signin a,usr b where a.usrid=b.id and a.org=b.org and a.org='XLSGRID' 
								and to_char(a.crtdat,'yyyymmdd')=to_char(sysdate,'yyyymmdd') 
								order by a.crtdat");
					msg += "\n 已签到人员：\n";
					for (var i=0;i<myds.getRowCount();i++) {
						msg += (i+1)+" "+myds.getStringAt(i,"NAME")+" "+myds.getStringAt(i,"CRTDAT")+"\n";
					}
					textMessage.setContent(msg);
					
				} else if (eventKey.equals("23")) {  
					//textMessage.setContent("请假功能尚未上线，敬请期待！");  
					//捷强连锁 - 刮刮乐
					//textMessage.setContent("刮刮乐，开心赢大奖！<a href='http://fl.act.qq.com/27330/addev/h5/172836?v=demo'>点击进入</a>\n\n
					textMessage.setContent("<a href='https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx28aa2668339fb4b2&redirect_uri=http%3a%2f%2fwww.xmidware.com%2fxlsgrid%2fwxShare.jsp&response_type=code&scope=snsapi_base&state=0&wechat_redirect&usrid=xlsgrid&userpwd=0'>OAuth2.0网页制授权[snsapi_base/wxShare.jsp]</a>"); 
					
				} else if (eventKey.equals("31")) {  
					textMessage.setContent("在线客服菜单项被点击！");  
				} else if (eventKey.equals("32")) {  
					textMessage.setContent("留言菜单项被点击！");  
				} 
				
				else if (eventKey.equals("35")) {  
					textMessage.setContent("请在回复信息中点+号，然后选择位置再发送你的位置信息。");  
				}
				
  				respMessage = weixin.MessageUtil.textMessageToXml(textMessage);
				return respMessage;
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
                    	article.setTitle("查找我附近的门店");  
                    	article.setDescription(lb);  
                    	article.setPicUrl("http://i3.s2.dpfile.com/2010-03-01/3803174_b.jpg(700x700)/thumb.jpg");  
                    	article.setUrl("http://www.xlsgrid.net/xlsgrid/ROOT_0/mapSearch.sp?usrid=xlsgrid&userpwd=0&lx="+lx+"&ly="+ly+"&lb="+java.net.URLEncoder.encode(lb,"gbk"));  
                    	articleList.add(article);  
                    	// 设置图文消息个数  
                    	newsMessage.setArticleCount(articleList.size());  
                    	// 设置图文消息包含的图文集合  
                    	newsMessage.setArticles(articleList);  
                   	// 将图文消息对象转换成xml字符串  
                   	respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage); 
			return respMessage;

		}
		else {
			//绑定用户
			if (content.indexOf("/") > -1) {
				var id = content.split("/")[0];
				var pwd = content.split("/")[1];
				var usrds = db.QuerySQL("select * from usr where id='"+id+"' and passwd='"+pwd+"'");
				if (usrds.getRowCount() <= 0) {
					textMessage.setContent("用户名或密码不正确，请检查！");
				}
				else {
					db.ExcecutSQL("insert into weixin_userbind(org,syt,FromUserName,usrid,passwd,TOUSERNAME)values('XLSGRID','XLSGRID','"+fromUserName+"','"+id+"','"+pwd+"','"+toUserName+"')");
					textMessage.setContent(usrds.getStringAt(0, "NAME")+" 感谢您的使用，硕格软件竭诚为您服务！");
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
	textMessage.setContent("您好，我正在成长过程中，您的问题可能已经超出了我的知识范围，请多多关照，Thank you！");
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

//我的待办事务
function myTrkList(respMessage,newsMessage)
{  
	var articleList = new java.util.ArrayList();  
	
	var article1 = new resp.Article();  
	article1.setTitle("我的待办事务 >>");  
	article1.setDescription("");  
	// 将图片置为空  
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

//我发起的事务
function mySendTrkList(respMessage,newsMessage)
{  
	var articleList = new java.util.ArrayList();  
	
	var article1 = new resp.Article();  
	article1.setTitle("我发起的事务 >>");  
	article1.setDescription("");  
	// 将图片置为空  
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

//所有事务
function allTrkList(respMessage,newsMessage)
{  
	var articleList = new java.util.ArrayList();  
	
	var article1 = new resp.Article();  
	article1.setTitle("所有的事务 >>");  
	article1.setDescription("");  
	// 将图片置为空  
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

//通讯录
function contacts(respMessage,newsMessage)
{  
	var articleList = new java.util.ArrayList();  
	
	var article1 = new resp.Article();  
	article1.setTitle("通讯录 >>");  
	article1.setDescription("");  
	// 将图片置为空  
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

// 捷强连锁 - 会员促销
function memberActive(respMessage,newsMessage)
{  
	var articleList = new java.util.ArrayList();  
	
	var article1 = new resp.Article();  
	article1.setTitle("酒享聚惠");  
	article1.setDescription("");  
	// 将图片置为空  
	article1.setPicUrl("http://jqls.xlsgrid.net/jqfinx/ROOT_JQLS/EAFormBlob.sp?guid=F3B0557D65B5CE14E040007F010025BD");  
	article1.setUrl("活动日期：2014-03-26 至 2014-03-31");  
	articleList.add(article1);
	
	article1 = new resp.Article();  
	article1.setTitle("新品上市");  
	article1.setDescription("");  
	// 将图片置为空  
	article1.setPicUrl("http://jqls.xlsgrid.net/jqfinx/ROOT_JQLS/EAFormBlob.sp?guid=ED8E69B0D1B42080E040007F010011BB");  
	article1.setUrl("");  
	articleList.add(article1);
	
	article1 = new resp.Article();  
	article1.setTitle("55度五粮液18大纪念版");  
	article1.setDescription("");  
	// 将图片置为空  
	article1.setPicUrl("http://jqls.xlsgrid.net/jqfinx/ROOT_JQLS/EAFormBlob.sp?guid=ED7671A36901D60EE040007F010059C1");  
	article1.setUrl("");  
	articleList.add(article1);

	newsMessage.setArticleCount(articleList.size());  
	newsMessage.setArticles(articleList);  
	respMessage = weixin.MessageUtil.newsMessageToXml(newsMessage); 

	return respMessage;            
}
}
function x_showflg_zfb(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var conf = new JavaPackage ( "com.xlsgrid.net.alipay.config.*" );
var aliutl = new JavaPackage ( "com.xlsgrid.net.alipay.util" );
var javapack = new JavaPackage ( "java.util" );
var alipay= new JavaPackage ( "com.xlsgrid.net.alipay.config");
var md= new JavaPackage ( "com.xlsgrid.net.alipay.sign");
var util = new JavaPackage ( "java.util.*" );


function alipaydirect(){
		
		var db=null;
		var bilid=pubpack.EAFunc.NVL( request.getParameter("BILID"),"");//获取bilid

		var sql="select * from ("+TSQL+") where bilid='"+bilid+"'";
		var payment_type = "1"; 	//支付类型
		var notify_url =NTFYURL; 	//服务器异步通知页面路径   "http://商户网关地址/create_direct_pay_by_user-JAVA-GBK/notify_url.jsp";
		var return_url =RETURL;  	//页面跳转同步通知页面路径  "http://商户网关地址/create_direct_pay_by_user-JAVA-GBK/return_url.jsp";

		var out_trade_no ="";		//商户订单号
		var subject ="";		//订单名称
		var total_fee ="";		//付款金额
		var body ="";			//订单描述
		var show_url ="";		//商品展示地址
		var anti_phishing_key = ""; 	//防钓鱼时间戳  若要使用请调用类文件submit中的query_timestamp函数
		var exter_invoke_ip = ""; 	//客户端的IP地址 非局域网的外网IP地址，如：221.0.0.1
		
		try{
			db=new pubpack.EADatabase();
			var ds=db.QuerySQL(sql);
			if(ds.getRowCount()>0){
				out_trade_no =ds.getStringAt(0,"bilid");	//商户订单号 商户网站订单系统中唯一订单号
				subject =ds.getStringAt(0,"bilnam");		//订单名称 
				total_fee =ds.getStringAt(0,"money");	//付款金额 		
				body =ds.getStringAt(0,"note");		//订单描述
				show_url =ds.getStringAt(0,"url");	//商品展示地址 需以http://开头的完整路径，例如：http://www.商户网址.com/myorder.html 
			}
			else{
				if(bilid!="")
					return "未找到订单号为"+bilid+"数据！";
				else
					return "地址栏BILID为空或未定义！";
			}
//			out_trade_no ="abc481";
			//把请求参数打包成数组
			var sParaTemp = new javapack.HashMap();
			sParaTemp.put("service", "create_direct_pay_by_user");
		        sParaTemp.put("partner",PARTNER);// 合作身份者ID，以2088开头由16位纯数字组成的字符串
		        sParaTemp.put("seller_email",SELLER_EMAIL);// 收款支付宝账号
		        sParaTemp.put("_input_charset",alipay.AlipayConfig.input_charset); // 字符编码格式 目前支持 gbk 或 utf-8
//		        sParaTemp.put("key",KEY); // 商户的私钥
		        sParaTemp.put("sign_type","MD5"); // 
		        
			sParaTemp.put("payment_type",payment_type);
			sParaTemp.put("notify_url", notify_url);
			sParaTemp.put("return_url", return_url);
			sParaTemp.put("out_trade_no", out_trade_no);
			sParaTemp.put("subject", subject);
			sParaTemp.put("total_fee", total_fee);
			sParaTemp.put("body", body);
			sParaTemp.put("show_url", show_url);
			sParaTemp.put("anti_phishing_key", anti_phishing_key);
			sParaTemp.put("exter_invoke_ip", exter_invoke_ip);
			alipay.AlipayConfig.key=KEY;
			alipay.AlipayConfig.partner=PARTNER;
			alipay.AlipayConfig.seller_email=SELLER_EMAIL;
			
//			var preSignStr = aliutl.AlipayCore.createLinkString(aliutl.AlipayCore.paraFilter(sParaTemp));
//			var sign=md.MD5.sign(preSignStr,alipay.AlipayConfig.key,alipay.AlipayConfig.input_charset);
//			var boll=md.MD5.verify(preSignStr, sign,alipay.AlipayConfig.key,alipay.AlipayConfig.input_charset);

			//建立请求
			var sHtmlText =aliutl.AlipaySubmit.buildRequest(sParaTemp,"get","确认");
		
			return sHtmlText ;
		}
		catch(e){
			throw new Exception(e.toString());
		}
		return "";
}




//异步通知
function notifyurl(){
	//获取支付宝POST过来反馈信息
	var params = new javapack.HashMap();
	var requestParams = request.getParameterMap();
	for (var iter = requestParams.keySet().iterator(); iter.hasNext();) {
		var name = iter.next();

		var values = requestParams.get(name);
		
		var valueStr = "";

		for (var i = 0; i < values.length(); i++) {
			valueStr = (i == values.length() - 1) ? valueStr + values[i]:
			valueStr + values[i] + ",";
		}
		//乱码解决，这段代码在出现乱码时使用。如果mysign和sign不相等也可以使用这段代码转化

		valueStr = pubpack.EAFunc.encodeString(valueStr,"gbk","gbk"); 
		
		params.put(name, valueStr);
	}
	
	//获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以下仅供参考)//
	//商户订单号 	
	var out_trade_no =pubpack.EAFunc.NVL( request.getParameter("out_trade_no"),"");

	//支付宝交易号 
	var trade_no = pubpack.EAFunc.NVL(request.getParameter("trade_no"),"");

	//交易状态
	var trade_status =pubpack.EAFunc.NVL(request.getParameter("trade_status"),"");

	//获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以上仅供参考)//

	if(aliutl.AlipayNotify.verify(params)){//验证成功
		//////////////////////////////////////////////////////////////////////////////////////////
		//请在这里加上商户的业务逻辑程序代码
		
		//--请根据您的业务逻辑来编写程序（以下代码仅作参考）--
		
		if(trade_status.equals("TRADE_FINISHED")){
			//判断该笔订单是否在商户网站中已经做过处理
				//如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
				//如果有做过处理，不执行商户的业务程序
			var eas = new pubpack.EAScript(null);
			eas.DefineScopeVar("request", request);
			var ret =  eas.CallClassFunc("YXIMAGES_RETZFB","savezfdtl",null).castToString();
			//注意：
			//退款日期超过可退款期限后（如三个月可退款），支付宝系统发送该交易状态通知
		} else if (trade_status.equals("TRADE_SUCCESS")){
			//判断该笔订单是否在商户网站中已经做过处理
				//如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
				//如果有做过处理，不执行商户的业务程序
			var eas = new pubpack.EAScript(null);
			eas.DefineScopeVar("request", request);
			var ret =  eas.CallClassFunc("YXIMAGES_RETZFB","savezfdtl",null).castToString();
			//注意：
			//付款完成后，支付宝系统发送该交易状态通知
		}

		//--请根据您的业务逻辑来编写程序（以上代码仅作参考）--
			
//		out.println("success");	//请不要修改或删除
		return "success";

	}else{
		//验证失败
//		out.println("fail");
		return "fail";
	}
}
//同步通知
function returnurl(){
	//获取支付宝GET过来反馈信息

	var params = new javapack.HashMap();
	var requestParams = request.getParameterMap();
	for (var iter = requestParams.keySet().iterator(); iter.hasNext();) {
		var name = iter.next();

		var values = requestParams.get(name);
		
		var valueStr = "";

		for (var i = 0; i < values.length(); i++) {
			valueStr = (i == values.length() - 1) ? valueStr + values[i]:
			valueStr + values[i] + ",";
		}
		//乱码解决，这段代码在出现乱码时使用。如果mysign和sign不相等也可以使用这段代码转化

		valueStr = pubpack.EAFunc.encodeString(valueStr,"gbk","gbk"); 
		
		params.put(name, valueStr);
	}
	
	//获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以下仅供参考)//
	//商户订单号 	
	var out_trade_no =pubpack.EAFunc.NVL( request.getParameter("out_trade_no"),"");

	//支付宝交易号 
	var trade_no = pubpack.EAFunc.NVL(request.getParameter("trade_no"),"");

	//交易状态
	var trade_status =pubpack.EAFunc.NVL(request.getParameter("trade_status"),"");
	
	var pricess=pubpack.EAFunc.NVL(request.getParameter("PRICESS"),"");
	
	//获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以上仅供参考)//
	
//	var sign=params.get("sign");
//	var preSignStr = aliutl.AlipayCore.createLinkString(aliutl.AlipayCore.paraFilter(params));
//	return params.get("notify_id");
//	var boll=md.MD5.verify(preSignStr, sign,alipay.AlipayConfig.key,alipay.AlipayConfig.input_charset);

	if(aliutl.AlipayNotify.verify(params)){//验证成功
		//////////////////////////////////////////////////////////////////////////////////////////
		//请在这里加上商户的业务逻辑程序代码

		//--请根据您的业务逻辑来编写程序（以下代码仅作参考）--
		if(trade_status.equals("TRADE_FINISHED") || trade_status.equals("TRADE_SUCCESS")){
			//判断该笔订单是否在商户网站中已经做过处理
			//如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
			//如果有做过处理，不执行商户的业务程序
			
			var eas = new pubpack.EAScript(null);
			eas.DefineScopeVar("request", request);
			var ret =  eas.CallClassFunc("YXIMAGES_RETZFB","savezfdtl",null).castToString();
			return ret;
		}
		
		//该页面可做页面美工编辑
//		out.println("验证成功<br />");
		return "验证成功<br/>";
		//--请根据您的业务逻辑来编写程序（以上代码仅作参考）--

		//////////////////////////////////////////////////////////////////////////////////////////
	}else{
		//该页面可做页面美工编辑
//		out.println("验证失败");
		return "验证失败";
	}
}




}
function x_showflg_zfb(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var conf = new JavaPackage ( "com.xlsgrid.net.alipay.config.*" );
var aliutl = new JavaPackage ( "com.xlsgrid.net.alipay.util" );
var javapack = new JavaPackage ( "java.util" );
var alipay= new JavaPackage ( "com.xlsgrid.net.alipay.config");
var md= new JavaPackage ( "com.xlsgrid.net.alipay.sign");
var util = new JavaPackage ( "java.util.*" );


function alipaydirect(){
		
		var db=null;
		var bilid=pubpack.EAFunc.NVL( request.getParameter("BILID"),"");//��ȡbilid

		var sql="select * from ("+TSQL+") where bilid='"+bilid+"'";
		var payment_type = "1"; 	//֧������
		var notify_url =NTFYURL; 	//�������첽֪ͨҳ��·��   "http://�̻����ص�ַ/create_direct_pay_by_user-JAVA-GBK/notify_url.jsp";
		var return_url =RETURL;  	//ҳ����תͬ��֪ͨҳ��·��  "http://�̻����ص�ַ/create_direct_pay_by_user-JAVA-GBK/return_url.jsp";

		var out_trade_no ="";		//�̻�������
		var subject ="";		//��������
		var total_fee ="";		//������
		var body ="";			//��������
		var show_url ="";		//��Ʒչʾ��ַ
		var anti_phishing_key = ""; 	//������ʱ���  ��Ҫʹ����������ļ�submit�е�query_timestamp����
		var exter_invoke_ip = ""; 	//�ͻ��˵�IP��ַ �Ǿ�����������IP��ַ���磺221.0.0.1
		
		try{
			db=new pubpack.EADatabase();
			var ds=db.QuerySQL(sql);
			if(ds.getRowCount()>0){
				out_trade_no =ds.getStringAt(0,"bilid");	//�̻������� �̻���վ����ϵͳ��Ψһ������
				subject =ds.getStringAt(0,"bilnam");		//�������� 
				total_fee =ds.getStringAt(0,"money");	//������ 		
				body =ds.getStringAt(0,"note");		//��������
				show_url =ds.getStringAt(0,"url");	//��Ʒչʾ��ַ ����http://��ͷ������·�������磺http://www.�̻���ַ.com/myorder.html 
			}
			else{
				if(bilid!="")
					return "δ�ҵ�������Ϊ"+bilid+"���ݣ�";
				else
					return "��ַ��BILIDΪ�ջ�δ���壡";
			}
//			out_trade_no ="abc481";
			//������������������
			var sParaTemp = new javapack.HashMap();
			sParaTemp.put("service", "create_direct_pay_by_user");
		        sParaTemp.put("partner",PARTNER);// ���������ID����2088��ͷ��16λ��������ɵ��ַ���
		        sParaTemp.put("seller_email",SELLER_EMAIL);// �տ�֧�����˺�
		        sParaTemp.put("_input_charset",alipay.AlipayConfig.input_charset); // �ַ������ʽ Ŀǰ֧�� gbk �� utf-8
//		        sParaTemp.put("key",KEY); // �̻���˽Կ
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

			//��������
			var sHtmlText =aliutl.AlipaySubmit.buildRequest(sParaTemp,"get","ȷ��");
		
			return sHtmlText ;
		}
		catch(e){
			throw new Exception(e.toString());
		}
		return "";
}




//�첽֪ͨ
function notifyurl(){
	//��ȡ֧����POST����������Ϣ
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
		//����������δ����ڳ�������ʱʹ�á����mysign��sign�����Ҳ����ʹ����δ���ת��

		valueStr = pubpack.EAFunc.encodeString(valueStr,"gbk","gbk"); 
		
		params.put(name, valueStr);
	}
	
	//��ȡ֧������֪ͨ���ز������ɲο������ĵ���ҳ����תͬ��֪ͨ�����б�(���½����ο�)//
	//�̻������� 	
	var out_trade_no =pubpack.EAFunc.NVL( request.getParameter("out_trade_no"),"");

	//֧�������׺� 
	var trade_no = pubpack.EAFunc.NVL(request.getParameter("trade_no"),"");

	//����״̬
	var trade_status =pubpack.EAFunc.NVL(request.getParameter("trade_status"),"");

	//��ȡ֧������֪ͨ���ز������ɲο������ĵ���ҳ����תͬ��֪ͨ�����б�(���Ͻ����ο�)//

	if(aliutl.AlipayNotify.verify(params)){//��֤�ɹ�
		//////////////////////////////////////////////////////////////////////////////////////////
		//������������̻���ҵ���߼��������
		
		//--���������ҵ���߼�����д�������´�������ο���--
		
		if(trade_status.equals("TRADE_FINISHED")){
			//�жϸñʶ����Ƿ����̻���վ���Ѿ���������
				//���û�������������ݶ����ţ�out_trade_no�����̻���վ�Ķ���ϵͳ�в鵽�ñʶ�������ϸ����ִ���̻���ҵ�����
				//���������������ִ���̻���ҵ�����
			var eas = new pubpack.EAScript(null);
			eas.DefineScopeVar("request", request);
			var ret =  eas.CallClassFunc("YXIMAGES_RETZFB","savezfdtl",null).castToString();
			//ע�⣺
			//�˿����ڳ������˿����޺��������¿��˿��֧����ϵͳ���͸ý���״̬֪ͨ
		} else if (trade_status.equals("TRADE_SUCCESS")){
			//�жϸñʶ����Ƿ����̻���վ���Ѿ���������
				//���û�������������ݶ����ţ�out_trade_no�����̻���վ�Ķ���ϵͳ�в鵽�ñʶ�������ϸ����ִ���̻���ҵ�����
				//���������������ִ���̻���ҵ�����
			var eas = new pubpack.EAScript(null);
			eas.DefineScopeVar("request", request);
			var ret =  eas.CallClassFunc("YXIMAGES_RETZFB","savezfdtl",null).castToString();
			//ע�⣺
			//������ɺ�֧����ϵͳ���͸ý���״̬֪ͨ
		}

		//--���������ҵ���߼�����д�������ϴ�������ο���--
			
//		out.println("success");	//�벻Ҫ�޸Ļ�ɾ��
		return "success";

	}else{
		//��֤ʧ��
//		out.println("fail");
		return "fail";
	}
}
//ͬ��֪ͨ
function returnurl(){
	//��ȡ֧����GET����������Ϣ

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
		//����������δ����ڳ�������ʱʹ�á����mysign��sign�����Ҳ����ʹ����δ���ת��

		valueStr = pubpack.EAFunc.encodeString(valueStr,"gbk","gbk"); 
		
		params.put(name, valueStr);
	}
	
	//��ȡ֧������֪ͨ���ز������ɲο������ĵ���ҳ����תͬ��֪ͨ�����б�(���½����ο�)//
	//�̻������� 	
	var out_trade_no =pubpack.EAFunc.NVL( request.getParameter("out_trade_no"),"");

	//֧�������׺� 
	var trade_no = pubpack.EAFunc.NVL(request.getParameter("trade_no"),"");

	//����״̬
	var trade_status =pubpack.EAFunc.NVL(request.getParameter("trade_status"),"");
	
	var pricess=pubpack.EAFunc.NVL(request.getParameter("PRICESS"),"");
	
	//��ȡ֧������֪ͨ���ز������ɲο������ĵ���ҳ����תͬ��֪ͨ�����б�(���Ͻ����ο�)//
	
//	var sign=params.get("sign");
//	var preSignStr = aliutl.AlipayCore.createLinkString(aliutl.AlipayCore.paraFilter(params));
//	return params.get("notify_id");
//	var boll=md.MD5.verify(preSignStr, sign,alipay.AlipayConfig.key,alipay.AlipayConfig.input_charset);

	if(aliutl.AlipayNotify.verify(params)){//��֤�ɹ�
		//////////////////////////////////////////////////////////////////////////////////////////
		//������������̻���ҵ���߼��������

		//--���������ҵ���߼�����д�������´�������ο���--
		if(trade_status.equals("TRADE_FINISHED") || trade_status.equals("TRADE_SUCCESS")){
			//�жϸñʶ����Ƿ����̻���վ���Ѿ���������
			//���û�������������ݶ����ţ�out_trade_no�����̻���վ�Ķ���ϵͳ�в鵽�ñʶ�������ϸ����ִ���̻���ҵ�����
			//���������������ִ���̻���ҵ�����
			
			var eas = new pubpack.EAScript(null);
			eas.DefineScopeVar("request", request);
			var ret =  eas.CallClassFunc("YXIMAGES_RETZFB","savezfdtl",null).castToString();
			return ret;
		}
		
		//��ҳ�����ҳ�������༭
//		out.println("��֤�ɹ�<br />");
		return "��֤�ɹ�<br/>";
		//--���������ҵ���߼�����д�������ϴ�������ο���--

		//////////////////////////////////////////////////////////////////////////////////////////
	}else{
		//��ҳ�����ҳ�������༭
//		out.println("��֤ʧ��");
		return "��֤ʧ��";
	}
}




}
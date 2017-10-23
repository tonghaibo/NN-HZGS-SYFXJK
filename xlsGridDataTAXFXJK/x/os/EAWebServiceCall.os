function x_EAWebServiceCall(){
var pub = new JavaPackage("com.xlsgrid.net.pub");
var ws = new JavaPackage("com.xlsgrid.net.ws");
var soap = new JavaPackage("javax.xml.soap"); 
var soapconn = new JavaPackage("weblogic.wsee.saaj"); //.HttpSOAPConnectionFactory
var io = new JavaPackage("java.io");
var lang =  new JavaPackage("java.lang");
var msgf=  new JavaPackage("com.sun.xml.messaging.saaj.soap.ver1_1");
var net = new JavaPackage("java.net");
var transform = new JavaPackage("javax.xml.transform");
var stream = new JavaPackage("javax.xml.transform.stream");
function test(){
//	var sms = new ws.EAWebServiceCall2();
//		sms.addHeader("SOAPAction", "http://tempuri.org/GetGlucoseData");
		var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"><soapenv:Body><GetGlucoseData xmlns=\"http://tempuri.org/\"><DeviceID>E60715K01002723</DeviceID></GetGlucoseData></soapenv:Body></soapenv:Envelope>";
		var a = Send("http://124.248.34.89:8008/glucosewebservice.asmx", xml, "UTF-8");
//		throw new Exception(a);
	return a;
}

function SendWeblogic(endpoint,xml,encode,headid,headval){
		var ret = "";
		 try {   
			  	// ��������  
	            // ==================================================  
//	            var soapConnFactory = soapconn.SOAPConnectionFactoryImpl.newInstance();//weblogic12c����
		var soapConnFactory = soap.SOAPConnectionFactory.newInstance();//oracleas����
	            var connection = soapConnFactory.createConnection();   
	            
	            //  ������Ϣ����  
	            // ===========================================  
//	            var messageFactory = msgf.SOAPMessageFactory1_1Impl.newInstance(); //weblogic12c����
		     var messageFactory = soap.MessageFactory.newInstance();//oracleas����
	            var message = messageFactory.createMessage(); 
	            for(var i=0;i<headid.length();i++){
	            	//message.getMimeHeaders().addHeader("SOAPAction","http://tempuri.org/GetGlucoseData");
	            message.getMimeHeaders().addHeader(headid[i],headval[i]);

	            }
//	            message.getMimeHeaders().addHeader("SOAPAction","http://tempuri.org/GetGlucoseData");

	            var reqMsg =  messageFactory.createMessage(message.getMimeHeaders(),new io.ByteArrayInputStream(pub.EAFunc.getStringBytes(xml,encode)));   
	            reqMsg.saveChanges(); 
	            message = reqMsg; 
	            message.saveChanges(); 
 
	            /* 
	             * ʵ�ʵ���Ϣ��ʹ�� call()�������͵ģ��÷���������Ϣ�����Ŀ�ĵ���Ϊ�����������صڶ��� SOAPMessage ��Ϊ��Ӧ�� 
	             * call������message����Ϊ���͵�soap���ģ�urlΪmule���õ�inbound�˿ڵ�ַ�� 
	             */  
	            var url = new net.URL(endpoint);   
	            // ��Ӧ��Ϣ  
	            // ===========================================================================  
	            var reply = connection.call(message, url); 
	            //reply.setProperty(SOAPMessage.CHARACTER_SET_ENCODING, "gb2312");  
	            // ��ӡ����˷��ص�soap���Ĺ�����   
	            // ==================����soap��Ϣת������  
	            var transformerFactory = transform.TransformerFactory  
	                    .newInstance();   
	            var transformer = transformerFactory.newTransformer(); 
	            // Extract the content of the reply======================��ȡ��Ϣ����  
	            var sourceContent = reply.getSOAPPart().getContent();   
	            // Set the output for the transformation  
	            var baos = new io.ByteArrayOutputStream();
	            var result = new stream.StreamResult(baos); 
	            transformer.transform(sourceContent, result); 
	            ret = baos.toString("UTF-8");
	            // Close the connection �ر����� ==============   
	            //throw new Exception(ret);
	            connection.close();   
	        } catch (e) {  
	            throw new Exception(e);
	        }  
		 return ret;
	}

}
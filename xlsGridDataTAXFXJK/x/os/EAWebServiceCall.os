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
			  	// 创建连接  
	            // ==================================================  
//	            var soapConnFactory = soapconn.SOAPConnectionFactoryImpl.newInstance();//weblogic12c可用
		var soapConnFactory = soap.SOAPConnectionFactory.newInstance();//oracleas可用
	            var connection = soapConnFactory.createConnection();   
	            
	            //  创建消息对象  
	            // ===========================================  
//	            var messageFactory = msgf.SOAPMessageFactory1_1Impl.newInstance(); //weblogic12c可用
		     var messageFactory = soap.MessageFactory.newInstance();//oracleas可用
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
	             * 实际的消息是使用 call()方法发送的，该方法接收消息本身和目的地作为参数，并返回第二个 SOAPMessage 作为响应。 
	             * call方法的message对象为发送的soap报文，url为mule配置的inbound端口地址。 
	             */  
	            var url = new net.URL(endpoint);   
	            // 响应消息  
	            // ===========================================================================  
	            var reply = connection.call(message, url); 
	            //reply.setProperty(SOAPMessage.CHARACTER_SET_ENCODING, "gb2312");  
	            // 打印服务端返回的soap报文供测试   
	            // ==================创建soap消息转换对象  
	            var transformerFactory = transform.TransformerFactory  
	                    .newInstance();   
	            var transformer = transformerFactory.newTransformer(); 
	            // Extract the content of the reply======================提取消息内容  
	            var sourceContent = reply.getSOAPPart().getContent();   
	            // Set the output for the transformation  
	            var baos = new io.ByteArrayOutputStream();
	            var result = new stream.StreamResult(baos); 
	            transformer.transform(sourceContent, result); 
	            ret = baos.toString("UTF-8");
	            // Close the connection 关闭连接 ==============   
	            //throw new Exception(ret);
	            connection.close();   
	        } catch (e) {  
	            throw new Exception(e);
	        }  
		 return ret;
	}

}
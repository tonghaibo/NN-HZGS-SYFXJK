function x_testPrint(){
 
var ws = new JavaPackage("com.xlsgrid.net.ws");
 
function test2(){
	try{
	var sms = new ws.EAWebServiceCall2();
		sms.addHeader("SOAPAction", "http://tempuri.org/GetGlucoseData");
		var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"><soapenv:Body><GetGlucoseData xmlns=\"http://tempuri.org/\"><DeviceID>asdf</DeviceID></GetGlucoseData></soapenv:Body></soapenv:Envelope>";
		var a = sms.Send("http://124.248.34.89:8008/glucosewebservice.asmx", xml, "UTF-8");
	}catch(e){
		throw new Exception(e);
	}	 
	
}






//ҳ��BODY������Ϻ��¼�
//sb������bodyԪ�ؼ�ǰ���head����
//bodysb������body��innerHTML
function test()
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo(); 
{
	var str = "<table width='100%' height='100%'>
	  <table id='Table3' height='120' cellspacing='0' cellpadding='0'
  width='640px;' border='0'>
    <tr>
      <td align='center' width='70%'><font face='����' size=
      '4'>�������ż���ʢ�����������޹�˾</font></td>

      <td width='15%'><font face='����_GB2312' size=
      '2'>�������ͣ�</font></td>

      <td style='BORDER-RIGHT:' border-top:='' font-size:=''
      border-left:='' border-bottom:='' solid='' valign='middle'
      bordercolor='#FFFFFF' align='center' width='15%'><font face=
      '����_GB2312' size='2'><u>����</u></font></td>
    </tr>

    <tr>
      <td style='HEIGHT:' align='center'><font face='����' size=
      '4'>������</font></td>

      <td style='HEIGHT:'><font face='����_GB2312' size=
      '2'>�������ţ�</font></td>

      <td style='BORDER-RIGHT:' border-top:='' font-size:=''
      border-left:='' border-bottom:='' height:='' valign='middle'
      bordercolor='#FFFFFF' align='center' width='15%'><font face=
      '����_GB2312' size='2'>10637808</font></td>
    </tr>

    <tr>
      <td style='HEIGHT:' colspan='3' height='5'></td>
    </tr>

    <tr>
      <td colspan='3'><font face='����_GB2312'><font size=
      '2'><b>�ջ���λ:<u>0001բ����</u>
      &#160;&#160;�ŵ�绰:<u>56888666*1017</u></b><br />
      <b>�ŵ��ַ:<u>�Ϻ���բ��������·471��</u></b><br />
      �����̱���:
      <u>0047918</u>&#160;&#160;����������:<u>�Ϻ���ǿ�̲��ǾƼ�����������(10)</u><br />

      ��ϵ��:<u>�����</u>
      &#160;&#160;�绰:<u>58301900</u>&#160;&#160;����:<u>58203461</u><br />

      ��������:<u><b>2010.09.06</b></u>&#160;&#160;������Ч��:<u><b>2010.09.11</b></u><br />

      <br /></font></font></td>
    </tr>
  </table>
  </table>
	";  
	return str;
}


//ҳ��BODY������Ϻ��¼�
//sb������bodyԪ�ؼ�ǰ���head����
//bodysb������body��innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
  //var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{

  sb.append(test());
}

}
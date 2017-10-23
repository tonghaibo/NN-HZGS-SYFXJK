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






//页面BODY处理完毕后事件
//sb里面是body元素及前面的head内容
//bodysb里面是body的innerHTML
function test()
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo(); 
{
	var str = "<table width='100%' height='100%'>
	  <table id='Table3' height='120' cellspacing='0' cellpadding='0'
  width='640px;' border='0'>
    <tr>
      <td align='center' width='70%'><font face='黑体' size=
      '4'>华联集团吉买盛购物中心有限公司</font></td>

      <td width='15%'><font face='仿宋_GB2312' size=
      '2'>订单类型：</font></td>

      <td style='BORDER-RIGHT:' border-top:='' font-size:=''
      border-left:='' border-bottom:='' solid='' valign='middle'
      bordercolor='#FFFFFF' align='center' width='15%'><font face=
      '仿宋_GB2312' size='2'><u>经销</u></font></td>
    </tr>

    <tr>
      <td style='HEIGHT:' align='center'><font face='黑体' size=
      '4'>订货单</font></td>

      <td style='HEIGHT:'><font face='仿宋_GB2312' size=
      '2'>订货单号：</font></td>

      <td style='BORDER-RIGHT:' border-top:='' font-size:=''
      border-left:='' border-bottom:='' height:='' valign='middle'
      bordercolor='#FFFFFF' align='center' width='15%'><font face=
      '仿宋_GB2312' size='2'>10637808</font></td>
    </tr>

    <tr>
      <td style='HEIGHT:' colspan='3' height='5'></td>
    </tr>

    <tr>
      <td colspan='3'><font face='仿宋_GB2312'><font size=
      '2'><b>收货单位:<u>0001闸北店</u>
      &#160;&#160;门店电话:<u>56888666*1017</u></b><br />
      <b>门店地址:<u>上海市闸北区汾西路471号</u></b><br />
      供货商编码:
      <u>0047918</u>&#160;&#160;供货商名称:<u>上海捷强烟草糖酒集团配销中心(10)</u><br />

      联系人:<u>沈峥嵘</u>
      &#160;&#160;电话:<u>58301900</u>&#160;&#160;传真:<u>58203461</u><br />

      订货日期:<u><b>2010.09.06</b></u>&#160;&#160;到货有效日:<u><b>2010.09.11</b></u><br />

      <br /></font></font></td>
    </tr>
  </table>
  </table>
	";  
	return str;
}


//页面BODY处理完毕后事件
//sb里面是body元素及前面的head内容
//bodysb里面是body的innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
  //var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{

  sb.append(test());
}

}
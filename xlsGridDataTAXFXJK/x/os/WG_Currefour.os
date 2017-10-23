function x_WG_Currefour(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var getWeb = new JavaPackage("com.xlsgrid.net.webget");

function start()
{
	return getOrderStr("GMHD","2012-09-24","0005","ZXID","Eb63r223PGA","dept","UTF-8");
}

function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code)
{
	var carrefour = new getWeb.CarrefourWeb();
	try{
		carrefour.Start(dat,dat,userid,passwd);	
//		throw new Exception(carrefour.GetDtlDS().GetXml());
	}catch(e)	
	{
		throw new Exception(e);
	}
	return writeStr(userid,deptid,kaid,carrefour.GetHdrDS(),carrefour.GetDtlDS());
}

//==============================================================//
// 	 XMLDS样式：
//	 HDRDS：
/*
		<BILID>1d2b01b-128716d151e-f528764d624db129b32c21fbca0cb8d6</BILID>
		<CORPNAM>家乐福苏州体育中心店     </CORPNAM>
		<CORPID>SuZhou STADIUM Store     </CORPID>
		<DEPT>14 干性副食                 </DEPT>
		<订单号>14X852644</订单号>
		<DAT>07/05/2010</DAT>
		<期望到货日>09/05/2010</期望到货日>
		<电话号码>021-58301900        </电话号码>
		<传真号码>021-33050438        </传真号码>
*/
//        DTLDS：
/*
		<订单号>14X852789</订单号>
		<BILID>1d2b01b-1287212f287-f528764d624db129b32c21fbca0cb8d6</BILID>
		<SEQID>1</SEQID>
		<ITMID>206008</ITMID>
		<条码>6903474221565</条码>
		<SPEC>160 g          </SPEC>
		<ITMNAM>正一品鸭脖子                                           </ITMNAM>
		<UNTNUM>24</UNTNUM>
		<QTYFLG>P<QTYFLG>
		<QTY>3</QTY>
		<赠品数量>0</赠品数量>
		<不含税价>18.3760</不含税价>
*/
// 函数：writeStr
// 说明：把抓取的数据拼接
function writeStr(userid,deptid,kaid,hdrds,dtlds)
{
	var ordid = "";
	var context = "";
	var sb = new StringBuffer();
	
	for (var i = 0 ; i < hdrds.getRowCount(); i ++) {
		var hval = "NR~~~"+userid+"~~~"+deptid+"~~~"+kaid+"~~~";
		
		for (var c = 0; c < hdrds.getColumnCount(); c ++) {
			hval += hdrds.getStringAt(i,c)+"~~~";
		}
		ordid = hdrds.getStringAt(i,"订单号")+hdrds.getStringAt(i,"BILID");
		for(var j = 0; j < dtlds.getRowCount(); j ++) {
			var tmpord = dtlds.getStringAt(j,"订单号")+dtlds.getStringAt(j,"BILID");
			var dval = "";
			if(tmpord.equals(ordid)) {
				for (var m = 2; m < dtlds.getColumnCount(); m ++) {
					//modified by XHJ 2012-08-22
					if(m == 9)
						dval += dtlds.getStringAt(j,m+1)+"~~~";
					else if(m == 10)
						dval += dtlds.getStringAt(j,m-1)+"~~~";
					else
						dval += dtlds.getStringAt(j,m)+"~~~";
				}
				context = hval+dval;
				context += "None~~~None~~~None╃";
				sb.append(context);
				sb.append("\n");
			}
		}
	}
//	throw new Exception(sb.toString());
	return sb.toString();
}

}
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
// 	 XMLDS��ʽ��
//	 HDRDS��
/*
		<BILID>1d2b01b-128716d151e-f528764d624db129b32c21fbca0cb8d6</BILID>
		<CORPNAM>���ָ������������ĵ�     </CORPNAM>
		<CORPID>SuZhou STADIUM Store     </CORPID>
		<DEPT>14 ���Ը�ʳ                 </DEPT>
		<������>14X852644</������>
		<DAT>07/05/2010</DAT>
		<����������>09/05/2010</����������>
		<�绰����>021-58301900        </�绰����>
		<�������>021-33050438        </�������>
*/
//        DTLDS��
/*
		<������>14X852789</������>
		<BILID>1d2b01b-1287212f287-f528764d624db129b32c21fbca0cb8d6</BILID>
		<SEQID>1</SEQID>
		<ITMID>206008</ITMID>
		<����>6903474221565</����>
		<SPEC>160 g          </SPEC>
		<ITMNAM>��һƷѼ����                                           </ITMNAM>
		<UNTNUM>24</UNTNUM>
		<QTYFLG>P<QTYFLG>
		<QTY>3</QTY>
		<��Ʒ����>0</��Ʒ����>
		<����˰��>18.3760</����˰��>
*/
// ������writeStr
// ˵������ץȡ������ƴ��
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
		ordid = hdrds.getStringAt(i,"������")+hdrds.getStringAt(i,"BILID");
		for(var j = 0; j < dtlds.getRowCount(); j ++) {
			var tmpord = dtlds.getStringAt(j,"������")+dtlds.getStringAt(j,"BILID");
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
				context += "None~~~None~~~None��";
				sb.append(context);
				sb.append("\n");
			}
		}
	}
//	throw new Exception(sb.toString());
	return sb.toString();
}

}
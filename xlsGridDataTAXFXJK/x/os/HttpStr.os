function x_HttpStr(){var getWeb = new JavaPackage("com.xlsgrid.net.webget");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var iopack = new JavaPackage("java.io");
//��Ϊ.sp����ʱ�����
//Ԥ���������request,response
var ACC = "";
function Response()
{
	var db = null;
	var sql = "";
	var ds = null;
	var str = "";
	try{
		db = new pubpack.EADatabase();
		//var acc = request.getParameter("ACC"); 
		//var dat = request.getParameter("DAT");		
		//var dat = "2010-07-23";
		var acc = "JQPX";
		var carrefour = new getWeb.CarrefourWeb();
		if(acc != null && acc != "")
		{
			//�����ñ���ȡ����Ӧ�ͻ����û�������
			//throw new Exception(acc);
			sql = " select USERID,PASSWD,DEPTID,KAID,VALIDAT from EBCONFIG where ACC='"+acc+"'";			
			ds = db.QuerySQL(sql);
			if(ds.getRowCount()>0){
				for (var r = 0;r<ds.getRowCount();r++)
				{
					var userid = ds.getStringAt(r,"USERID");
					var passwd  = ds.getStringAt(r,"PASSWD");
					var deptid = ds.getStringDef(r,"DEPTID","None");	
					var kaid = ds.getStringDef(r,"KAID","None");	
					var valid = ds.getStringAt(r,"VALIDAT");								
					carrefour.Start(dat,dat,userid,passwd);
					str += writeStr(userid,deptid,kaid,carrefour.GetHdrDS(),carrefour.GetDtlDS());
				}
			}	
		}
		return str;
	}catch(Exception e)
	{
		throw new Exception(e);
	}finally
	{
		if(db != null)
			db.Close();
	}
}

//================================================================// 
// ������writeStr
// ˵������ץȡ�����������ļ��ļ�
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
		<QTY>3</QTY>
		<��Ʒ����>0</��Ʒ����>
		<����˰��>18.3760</����˰��>
*/			
// ������hdrds,dtlds
// ���أ�filename (�ļ���)
// ������
// ���ߣ�Hx_light
// �������ڣ�05/10/10 10:31:36
// �޸���־��
//================================================================// 
function writeStr(userid,deptid,kaid,hdrds,dtlds)
{
	var ordid = "";
	var context = "";
	var sb = new StringBuffer();
	for (var i = 0 ;i<hdrds.getRowCount();i++)
	{		
		var hval = userid+"~~~"+deptid+"~~~"+kaid+"~~~";
		
		for (var c = 0;c< hdrds.getColumnCount();c++)
		{
			hval += hdrds.getStringAt(i,c)+"~~~";
		}
		ordid = hdrds.getStringAt(i,"������");
		for(var j = 0;j<dtlds.getRowCount();j++)
		{
			var tmpord = dtlds.getStringAt(j,"������");
			var dval = "";
			if(tmpord.equals(ordid))
			{
				for (var m = 2;m<dtlds.getColumnCount();m++){
					dval += dtlds.getStringAt(j,m)+"~~~";
				}
				context = hval+dval;
				sb.append(context);
				sb.append("\n");
			}			
		}		
	}	
	return sb.toString();				
}

//�ֻ��˵��õķ���
function JM_httpstr(){
	try {HDRORDTL  = hdrordtl ;} catch ( e ) {HDRORDTL="1";}
}

}
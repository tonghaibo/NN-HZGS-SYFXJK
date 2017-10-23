function x_HttpStr(){var getWeb = new JavaPackage("com.xlsgrid.net.webget");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var iopack = new JavaPackage("java.io");
//作为.sp服务时的入口
//预定义变量：request,response
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
			//从配置表中取出对应客户的用户名密码
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
// 函数：writeStr
// 说明：把抓取的数据生成文件文件
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
		<QTY>3</QTY>
		<赠品数量>0</赠品数量>
		<不含税价>18.3760</不含税价>
*/			
// 参数：hdrds,dtlds
// 返回：filename (文件名)
// 样例：
// 作者：Hx_light
// 创建日期：05/10/10 10:31:36
// 修改日志：
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
		ordid = hdrds.getStringAt(i,"订单号");
		for(var j = 0;j<dtlds.getRowCount();j++)
		{
			var tmpord = dtlds.getStringAt(j,"订单号");
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

//手机端调用的方法
function JM_httpstr(){
	try {HDRORDTL  = hdrordtl ;} catch ( e ) {HDRORDTL="1";}
}

}
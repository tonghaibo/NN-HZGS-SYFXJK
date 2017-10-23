function XLSGRID_j2me_newtrk(){var pubpack=new JavaPackage("com.xlsgrid.net.pub");
var baskpack=new JavaPackage("com.xlsgrid.net");
//var servletpack=new JavaPackage("com.xlsgrid.net.servlet");
var web=new JavaPackage("com.xlsgrid.net.web");
var abc="asdf";
		var dtlusr = ""; //分配人
		var project = ""; //project;
		var note  =""; //  note+"\n\r";
		var title = "" ; //标题
		var crtusr = ""; //修改过的，原来是name
		var prio= "0";				//优先级
		//已经不需要了var crtusrorg = "";		//用户所属组织
		var filepath = "";	//附件地址
		var filenote = "";			//附件
		var show = "2";				//事务类型style 2为一般事务
		var mobile_sign = "0";		//短信通知
		var msg_sign = "0";			//消息通知
		var proorg = "";			//提出组织
		var prousr = "";			//提出人
		var prodat = "";			//提出日期
		var imagepath = "";//贴图地址
		var imagenote = "";		//贴图
		var aimorg =""; //_this.GetCellText(sheet,1,6);//这个事务所属的组织
		var selforg =""; // G_ORGID;			//全局变量
		var syt = ""; //G_SYTID;			//全局变量
		var acc  =""; //G_ACCID;			//全局变量
		var hdrguid  =""; //HDRGUID;			//事务打开事务的guid
		var tostat ="1"; //_this.GetCellText(0,5,8);	//1:处理中2:处理完
		var edit="";

function Response()
{
	var func=pubpack.EAFunc.NVL(request.getParameter("func"),"");//获取执行的函数名称如:save
	var data=pubpack.EAFunc.NVL(request.getParameter("_this"),"");//获取提交的数据.是一个xml
	var corpid=pubpack.EAFunc.NVL(request.getParameter("CORPID"),"");
	var locid=pubpack.EAFunc.NVL(request.getParameter("LOCID"),"");
	var corpsoid = pubpack.EAFunc.NVL(request.getParameter("CORPSOID"),"");
	//throw new Exception ("func="+func);
	var usr=web.EASession.GetLoginInfo(request);//获取当前用户信息
	var usrid = usr.getUsrid();
	var accid = usr.getAccid();
	var sytid = usr.getSytid();
	var orgid = usr.getOrgid();
	var db = null;//数据库
	selforg = orgid; 
	aimorg = orgid; 
	acc = accid;
	syt = sytid;
	crtusr = usrid;
	//读取参数
	//show.sp?grdid=HDRTRK&hdrordtl=2&hdrguid=984E55D55B624F4ABB70F88CDD3CC36D&style=31&prjid=TRA&edit=&dd=
	var xml="";
	xml=pubpack.EAJ2meUtil.getMainCellRangeXml(data);
	var row=xml.getRowCount();
	var col=xml.getColumnCount();
	var HDRORDTL = "";
	try {
		HDRORDTL  = xml.get(0,1) ;
		if(HDRORDTL=="")HDRORDTL="1";
	} catch ( e ) {HDRORDTL="1";}
	
	
	
	try{ project = xml.get(1,3); }catch(ee){project="error";}//当全部为空值时,会xml.get(0,3)抛出错误
	if(project != "error"){
		hdrguid = xml.get(0,3) ;//获取处理事务的hdrguid
		show = xml.get(0,2) ;//获取事务类型
		if(show == "")show = "2";
		edit="save";//save 保存 modify 修改 
		dtlusr = xml.get(2,3);
		title = xml.get(3,3);
		note = xml.get(4,3);
		if((project==""||dtlusr==""||title=="")&&(HDRORDTL=="1"||HDRORDTL=="2")){
			if(project=="")out.println("项目不能为空值");
			if(dtlusr=="")out.println("发送人不能为空值");
			if(title=="")out.println("标题不能为空值");
		}else if(HDRORDTL=="3"||title==""){
			if(title=="")out.println("标题不能为空值");
		}else if(project==""||dtlusr==""||title==""){
			if(project=="")out.println("项目不能为空值");
			if(dtlusr=="")out.println("发送人不能为空值");
			if(title=="")out.println("标题不能为空值");
		}else{
			var out=response.getOutputStream();
			response.setContentType("content-type:text/html; charset=UTF-8");
			out.println("show="+show+"hdrguid="+hdrguid+"prject="+project+"sendto="+dtlusr+"title="+title+"note="+note+"HDRORDTL="+HDRORDTL);//out.println();
			//throw new Exception("prject="+prject+"sendto="+sendto+"smssign="+smssign+"mailsign="+mailsign+"title="+title+"note="+note);
			//在服务端OS中引用其他中间件的服务端脚本
			//说明：x_SQLINPUT是指x系统SQLINPUT中间件
			var parent = new XLSGRID_HDRTRK();
			//parent.save1();
			if(HDRORDTL=="1"){
				parent.save1();
			}else if (HDRORDTL=="2"){
				parent.save2();
			}else if (HDRORDTL=="3"){
				parent.save3();
			}
		}
		
		
	}else{
		if(project=="error")out.println("你没有填任何信息");
	}

	
	
	

}
}
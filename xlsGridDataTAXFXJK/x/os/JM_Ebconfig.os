function x_JM_Ebconfig(){var pubpack=new JavaPackage("com.xlsgrid.net.pub");
var baskpack=new JavaPackage("com.xlsgrid.net");
//var servletpack=new JavaPackage("com.xlsgrid.net.servlet");
var web=new JavaPackage("com.xlsgrid.net.web");

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
	var selforg = orgid; 
	var aimorg = orgid; 
	var acc = accid;
	var syt = sytid;
	var crtusr = usrid;
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
	
	
	//
	var kaid = "";
	try{ kaid = xml.get(1,3); }catch(ee){kaid="error";}//当全部为空值时,会xml.get(0,3)抛出错误
	
	if(kaid != "error"){
		
		hdrguid = xml.get(0,3) ;//获取处理事务的hdrguid
		//show = xml.get(0,2) ;//获取事务类型
		//if(show == "")show = "2";
		//edit="save";//save 保存 modify 修改 
		var usrid = xml.get(2,3);
		var passwd = xml.get(3,3);
		var note = xml.get(4,3);
		throw new Exception(hdrguid+"|"+ kaid+"|"+usrid+"|"+passwd+"|"+note);
		var empty = false;
		if(kaid==""){
			out.println("您没有选择渠道");
			empty = true;
		}
		if(usrid ==""){
			out.println("您没有输入登录帐号");
			empty = true;
		}
		if(kapasswd==""){
			out.println("您没有输入登录密码");
			empty = true;
		}
		if(empty != true){
			try
		        {
		            db = new pubpack.EADatabase();
		            if(hdrguid==""){
		            	  var sql = "insert into ebconfig(userid,passwd,kaid,note,acc) values (?,?,?,?,?) ";
		                  var ps2 = db.prepareStatement(sql);
		                  ps2.setString(1,usrid);
		                  ps2.setString(2,passwd);
				  ps2.setString(3,kaid);
				  ps2.setString(4,note);
				  ps2.setString(5,"jqpx");
		
		                  ps2.executeUpdate();
		                  ps2.close();
		                  //throw new Exception(sql);
		            }else{
		            	var sql = "update ebconfig set userid=?,passwd=?,kaid=?,note=?,acc=? where guid='"+hdrguid+"'";
		            	 var ps2 = db.prepareStatement(sql);
		                  ps2.setString(1,usrid);
		                  ps2.setString(2,passwd);
				  ps2.setString(3,kaid);
				  ps2.setString(4,note);
				  ps2.setString(5,"jqpx");
		
		                  ps2.executeUpdate();
		                  ps2.close();
		                  throw new Exception(sql+"|"+hdrguid);
		            }
		                  
		                  //throw new Exception(sql);
				//return ret ;
		      }
		      catch(e)
		      {
		      	if( db!= null ) db.Rollback();
		
		            throw e;
		      }
		      finally
		      {
		            db.Close(); 
		      }       
	
			out.println("保存成功");
		}
	      
		
//		if((project==""||dtlusr==""||title=="")&&(HDRORDTL=="1"||HDRORDTL=="2")){
//			if(project=="")out.println("项目不能为空值");
//			if(dtlusr=="")out.println("发送人不能为空值");
//			if(title=="")out.println("标题不能为空值");
//		}else if(HDRORDTL=="3"||title==""){
//			if(title=="")out.println("标题不能为空值");
//		}else if(project==""||dtlusr==""||title==""){
//			if(project=="")out.println("项目不能为空值");
//			if(dtlusr=="")out.println("发送人不能为空值");
//			if(title=="")out.println("标题不能为空值");
//		}else{
//			var out=response.getOutputStream();
//			response.setContentType("content-type:text/html; charset=UTF-8");
//			out.println("show="+show+"hdrguid="+hdrguid+"prject="+project+"sendto="+dtlusr+"title="+title+"note="+note+"HDRORDTL="+HDRORDTL);//out.println();
//			//throw new Exception("prject="+prject+"sendto="+sendto+"smssign="+smssign+"mailsign="+mailsign+"title="+title+"note="+note);
//			//在服务端OS中引用其他中间件的服务端脚本
//			//说明：x_SQLINPUT是指x系统SQLINPUT中间件
//			var parent = new XLSGRID_HDRTRK();
//			//parent.save1();
//			if(HDRORDTL=="1"){
//				parent.save1();
//			}else if (HDRORDTL=="2"){
//				parent.save2();
//			}else if (HDRORDTL=="3"){
//				parent.save3();
//			}
//		}
		
		
	}else{
		if(kaid=="error")out.println("你没有填任何信息");
	}

	
	
	

}
}
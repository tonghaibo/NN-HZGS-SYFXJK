function x_JM_Ebconfig(){var pubpack=new JavaPackage("com.xlsgrid.net.pub");
var baskpack=new JavaPackage("com.xlsgrid.net");
//var servletpack=new JavaPackage("com.xlsgrid.net.servlet");
var web=new JavaPackage("com.xlsgrid.net.web");

function Response()
{
	var func=pubpack.EAFunc.NVL(request.getParameter("func"),"");//��ȡִ�еĺ���������:save
	var data=pubpack.EAFunc.NVL(request.getParameter("_this"),"");//��ȡ�ύ������.��һ��xml
	var corpid=pubpack.EAFunc.NVL(request.getParameter("CORPID"),"");
	var locid=pubpack.EAFunc.NVL(request.getParameter("LOCID"),"");
	var corpsoid = pubpack.EAFunc.NVL(request.getParameter("CORPSOID"),"");
	//throw new Exception ("func="+func);
	var usr=web.EASession.GetLoginInfo(request);//��ȡ��ǰ�û���Ϣ
	var usrid = usr.getUsrid();
	var accid = usr.getAccid();
	var sytid = usr.getSytid();
	var orgid = usr.getOrgid();
	var db = null;//���ݿ�
	var selforg = orgid; 
	var aimorg = orgid; 
	var acc = accid;
	var syt = sytid;
	var crtusr = usrid;
	//��ȡ����
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
	try{ kaid = xml.get(1,3); }catch(ee){kaid="error";}//��ȫ��Ϊ��ֵʱ,��xml.get(0,3)�׳�����
	
	if(kaid != "error"){
		
		hdrguid = xml.get(0,3) ;//��ȡ���������hdrguid
		//show = xml.get(0,2) ;//��ȡ��������
		//if(show == "")show = "2";
		//edit="save";//save ���� modify �޸� 
		var usrid = xml.get(2,3);
		var passwd = xml.get(3,3);
		var note = xml.get(4,3);
		throw new Exception(hdrguid+"|"+ kaid+"|"+usrid+"|"+passwd+"|"+note);
		var empty = false;
		if(kaid==""){
			out.println("��û��ѡ������");
			empty = true;
		}
		if(usrid ==""){
			out.println("��û�������¼�ʺ�");
			empty = true;
		}
		if(kapasswd==""){
			out.println("��û�������¼����");
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
	
			out.println("����ɹ�");
		}
	      
		
//		if((project==""||dtlusr==""||title=="")&&(HDRORDTL=="1"||HDRORDTL=="2")){
//			if(project=="")out.println("��Ŀ����Ϊ��ֵ");
//			if(dtlusr=="")out.println("�����˲���Ϊ��ֵ");
//			if(title=="")out.println("���ⲻ��Ϊ��ֵ");
//		}else if(HDRORDTL=="3"||title==""){
//			if(title=="")out.println("���ⲻ��Ϊ��ֵ");
//		}else if(project==""||dtlusr==""||title==""){
//			if(project=="")out.println("��Ŀ����Ϊ��ֵ");
//			if(dtlusr=="")out.println("�����˲���Ϊ��ֵ");
//			if(title=="")out.println("���ⲻ��Ϊ��ֵ");
//		}else{
//			var out=response.getOutputStream();
//			response.setContentType("content-type:text/html; charset=UTF-8");
//			out.println("show="+show+"hdrguid="+hdrguid+"prject="+project+"sendto="+dtlusr+"title="+title+"note="+note+"HDRORDTL="+HDRORDTL);//out.println();
//			//throw new Exception("prject="+prject+"sendto="+sendto+"smssign="+smssign+"mailsign="+mailsign+"title="+title+"note="+note);
//			//�ڷ����OS�����������м���ķ���˽ű�
//			//˵����x_SQLINPUT��ָxϵͳSQLINPUT�м��
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
		if(kaid=="error")out.println("��û�����κ���Ϣ");
	}

	
	
	

}
}
function XLSGRID_j2me_newtrk(){var pubpack=new JavaPackage("com.xlsgrid.net.pub");
var baskpack=new JavaPackage("com.xlsgrid.net");
//var servletpack=new JavaPackage("com.xlsgrid.net.servlet");
var web=new JavaPackage("com.xlsgrid.net.web");
var abc="asdf";
		var dtlusr = ""; //������
		var project = ""; //project;
		var note  =""; //  note+"\n\r";
		var title = "" ; //����
		var crtusr = ""; //�޸Ĺ��ģ�ԭ����name
		var prio= "0";				//���ȼ�
		//�Ѿ�����Ҫ��var crtusrorg = "";		//�û�������֯
		var filepath = "";	//������ַ
		var filenote = "";			//����
		var show = "2";				//��������style 2Ϊһ������
		var mobile_sign = "0";		//����֪ͨ
		var msg_sign = "0";			//��Ϣ֪ͨ
		var proorg = "";			//�����֯
		var prousr = "";			//�����
		var prodat = "";			//�������
		var imagepath = "";//��ͼ��ַ
		var imagenote = "";		//��ͼ
		var aimorg =""; //_this.GetCellText(sheet,1,6);//���������������֯
		var selforg =""; // G_ORGID;			//ȫ�ֱ���
		var syt = ""; //G_SYTID;			//ȫ�ֱ���
		var acc  =""; //G_ACCID;			//ȫ�ֱ���
		var hdrguid  =""; //HDRGUID;			//����������guid
		var tostat ="1"; //_this.GetCellText(0,5,8);	//1:������2:������
		var edit="";

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
	selforg = orgid; 
	aimorg = orgid; 
	acc = accid;
	syt = sytid;
	crtusr = usrid;
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
	
	
	
	try{ project = xml.get(1,3); }catch(ee){project="error";}//��ȫ��Ϊ��ֵʱ,��xml.get(0,3)�׳�����
	if(project != "error"){
		hdrguid = xml.get(0,3) ;//��ȡ���������hdrguid
		show = xml.get(0,2) ;//��ȡ��������
		if(show == "")show = "2";
		edit="save";//save ���� modify �޸� 
		dtlusr = xml.get(2,3);
		title = xml.get(3,3);
		note = xml.get(4,3);
		if((project==""||dtlusr==""||title=="")&&(HDRORDTL=="1"||HDRORDTL=="2")){
			if(project=="")out.println("��Ŀ����Ϊ��ֵ");
			if(dtlusr=="")out.println("�����˲���Ϊ��ֵ");
			if(title=="")out.println("���ⲻ��Ϊ��ֵ");
		}else if(HDRORDTL=="3"||title==""){
			if(title=="")out.println("���ⲻ��Ϊ��ֵ");
		}else if(project==""||dtlusr==""||title==""){
			if(project=="")out.println("��Ŀ����Ϊ��ֵ");
			if(dtlusr=="")out.println("�����˲���Ϊ��ֵ");
			if(title=="")out.println("���ⲻ��Ϊ��ֵ");
		}else{
			var out=response.getOutputStream();
			response.setContentType("content-type:text/html; charset=UTF-8");
			out.println("show="+show+"hdrguid="+hdrguid+"prject="+project+"sendto="+dtlusr+"title="+title+"note="+note+"HDRORDTL="+HDRORDTL);//out.println();
			//throw new Exception("prject="+prject+"sendto="+sendto+"smssign="+smssign+"mailsign="+mailsign+"title="+title+"note="+note);
			//�ڷ����OS�����������м���ķ���˽ű�
			//˵����x_SQLINPUT��ָxϵͳSQLINPUT�м��
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
		if(project=="error")out.println("��û�����κ���Ϣ");
	}

	
	
	

}
}
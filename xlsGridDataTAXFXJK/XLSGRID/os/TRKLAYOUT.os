function XLSGRID_TRKLAYOUT(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );


// ������־
// logtyp: ��־���࣬����TRKHDR
// logtypnam: ��־����,���Ѷ�
// guid: �ο����
// name: �����˵���������½�������ı���
// note: �������ϸ���ݣ�ɾ��һ�������ʱ�����ﱣ���������ϸ
// prj ��Ŀ
function OALOG( db,loginorgid ,loginusrid,logtyp,logtypnam,guid,name,note ,prj ) 
{
	var sql = "insert into OALOG(org,usrid,usrnam,mwtyp,action,bilid,name,note,prj)"+
	       "select a.org,a.id,a.name,'"+logtyp+"','"+logtypnam+"' ,'"+guid+"', '"+name+"','"+note+"','"+prj+"' from usr a where a.id='"+loginusrid +"' and a.org='"+loginorgid +"' ";
	//throw new Exception("log����:"+sql );
	db.ExcecutSQL(sql);
}

function test()
{
	return txt ;

}




// �õ�ĳ��trk��������
// �ͻ���: trkguid ��Ӧtrkhdr��guid
function trkquery()
{
	var db = null;
	var msg= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "select a.noteblob,a.guid,a.id,a.title,a.note,a.prio,to_char(a.crtdat,'YYYY-MM-DD HH24:MI:SS') crttim,b.name crtusr,b.id crtusrid,a.stat,a.dtlusr,a.project,a.filepath,a.filenote,a.imagepath,a.imagenote,a.show,a.selforg from trkhdr a,usr b where a.crtusr=b.id and a.SELFORG=b.org and  a.guid='"+trkguid +"'";
		var ds = db.QuerySQL(sql);
		
		if ( ds.getRowCount() > 0 ) {
			var id = ds.getStringAt(0,"id");
			msg += "<p align=center ><font size=3>"+ds.getStringAt(0,"title")+"</font></p>";
			msg += "<p align=center><font color=#808080>"+ds.getStringAt(0,"crtusr")+" "+ds.getStringAt(0,"crttim")+"</font></p>";
			
			var note = ds.getStringAt(0,"note"); 
			if(note=="") note += db.getBlob2String(sql,"noteblob");
			note = pubpack.EAFunc.Replace(note,"\n","<br>");//�滻���м�
			note = pubpack.EAFunc.Replace(note,"\r","<br>");//�滻���м�
			note = pubpack.EAFunc.Replace(note,"\u0009","&nbsp;&nbsp;&nbsp;&nbsp;");//�滻tab��
			msg += "<font size=2 >"+note+"</font>";
			var filenote = ds.getStringAt(0,"filenote");
//			var filenotes = filenote.split("\");
//			if (filenotes.length>0 )
//				 filenote = filenotes[filenotes.length-1];
			var imagenote = ds.getStringAt(0,"imagenote");
//			var imagenotes = imagenote.split("\\");
//			if ( imagenotes.length>0 ) 
//				imagenote = imagenotes[imagenotes.length-1];
			
			
			var filepath = ds.getStringAt(0,"filepath");
			if ( filepath !="" ) {
				var idx = filenote.indexOf("\\");
				while(idx>=0 ) {
					var idx1 = filenote.indexOf("\\",idx+1);
					if ( idx1>= 0 ) idx = idx1;
					else break;
				}
				if ( idx>=0 ) 
					filenote = filenote.substring(idx+1);
				msg += "<p><font color=#FF0000 >���ظ�����<a href=\"downloadFile.sp?unzip=1&filename="+filepath+"\">"+filenote+"</a>&nbsp;<a href=\"downloadFile.sp?format=zip&filename="+filepath+"\">ѹ������</a></font></p>";
			}
			if ( ds.getStringAt(0,"imagepath")!="" ) 
				msg += "<p><font color=#FF0000 >��Ļ��ͼ��<a href=\"downloadFile.sp?format=zip&filename="+ds.getStringAt(0,"imagepath")+"\">ѹ������</a>&nbsp;<a href=\"downloadFile.sp?unzip=1&format=rtf&filename="+ds.getStringAt(0,"imagepath")+"\">ԭʼ����</a></font></p>";
				
//			if ( loginusrid ==ds.getStringAt(0,"crtusrid")&& ds.getStringAt(0,"selforg")== loginorgid  )
//				msg+="&nbsp;&nbsp;<a href=\"show.sp?grdid=TRK_TRKDTL&datacc=XLSGRID&guid="+ds.getStringAt(row,"guid")+"\"  target=_blank >�༭</a>";
		
			if ( loginusrid ==ds.getStringAt(0,"crtusrid")&& ds.getStringAt(0,"selforg")== loginorgid  )
				msg+="<p align='right'><a href=\"show.sp?grdid=HDRTRK&datacc=XLSGRID&&edit=modify&id="+ds.getStringAt(0,"id")+"&style=2&dd=0\"  target=_blank >�༭</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href=\"#\" onclick=\"javascript:if(confirm('�����������Ƿ������')==1)window.location='XLSGRID.TRKLAYOUT.DelTrk.osp?trkguid="+trkguid+"';\" >ɾ��<a/>&nbsp;&nbsp;"+"</p>";
			else {
				var cnt = 1* db.GetSQL( "select count(*) from OALOG where mwtyp='READ' and bilid='"+trkguid+"' and usrid='"+loginusrid +"' and org='"+loginorgid +"' ");
				if( cnt == 0 ){
					//throw new Excetpion(ds.getStringAt(0,"title"));
					OALOG( db,loginorgid ,loginusrid,"READ","�Ѷ�",trkguid,ds.getStringAt(0,"title"),"",ds.getStringAt(0,"project") ) ;
					db.Commit();
				}	                
			
			}
		}
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}

// �������
function trkquerydtl()
{
	var db = null;
	var msg= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "select a.title,a.pro_note,b.name tousr,to_char(a.crtdat,'YYYY-MM-DD HH24:MI:SS') crttim,c.name crtusr,c.id crtusrid,dtltyp,a.guid ,a.selforg,a.filepath, a.filenote,a.imagepath, a.imagenote "+
		"from trkdtl a , usr b, usr c where a.trkguid='"+trkguid +"' and a.tousr=b.id(+) and a.AIMORG=b.org(+) and a.crtusr=c.id and a.selforg=c.org and NVL(a.dtltyp,' ')<>'2' order by a.crtdat asc";
		var ds = db.QuerySQL(sql);
		if ( ds.getRowCount() == 0 ) msg+="û�д����¼" ;
		for ( var row=0;row<ds.getRowCount();row ++ ) {
			msg +="<p>"+(row+1)+"."+ds.getStringAt(row,"crtusr")+"��"+ds.getStringAt(row,"crttim");
			var dtltyp  = ds.getStringAt(row,"dtltyp");
			var guid = ds.getStringAt(row,"guid");

			if (dtltyp   == "2" ) 
				msg += "��������";
			else 
				msg += "���������ת����"+ds.getStringAt(row,"tousr");
			msg +="<br>&nbsp;&nbsp;&nbsp;&nbsp;���⣺"+ds.getStringAt(row,"title")+"<BR>";

			var note = ds.getStringAt(row,"pro_note");
			if ( note.length() > 0 ) {
				note = pubpack.EAFunc.Replace(note,"\n","<BR>&nbsp;&nbsp;&nbsp;&nbsp;");
				msg +="&nbsp;&nbsp;&nbsp;&nbsp;<font color='#333333'>"+note+"</font>";
			}
			var filepath = ds.getStringAt(row,"filepath");
			var filenote = ds.getStringAt(row,"filenote");
			var imagepath = ds.getStringAt(row,"imagepath");
			var imagenote= ds.getStringAt(row,"imagenote");
			
			if ( filepath!="" ) 
				msg += "<p><font color=#FF0000 size=2>���ظ�����<a href=\"downloadFile.sp?unzip=1&filename="+filepath+"\">"+filenote+"</a>&nbsp;<a href=\"downloadFile.sp?format=zip&filename="+filepath+"\">ѹ������</a></font>";
			if ( imagepath !="" ) 
				msg += "<BR><font color=#FF0000 size=2>��Ļ��ͼ��<a href=\"downloadFile.sp?format=zip&filename="+imagepath+"\">ѹ������</a>&nbsp;<a href=\"downloadFile.sp?unzip=1&format=rtf&filename="+imagepath+"\">ԭʼ����</a></font>";			
			
			//show.sp?grdid=TRK_TRKDTL&datacc=XLSGRID&guid=28518ADFEFA0FC9DE040007F01006EA8&
			if ( loginusrid ==ds.getStringAt(row,"crtusrid")&& ds.getStringAt(row,"selforg")== loginorgid  )
				msg+="<p align='right'><a href=\"show.sp?grdid=TRK_TRKDTL&datacc=XLSGRID&guid="+guid+"\"  target=_blank >�༭</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href=\"#\" onclick=\"javascript:if(confirm('�����������Ƿ������')==1)window.location='XLSGRID.TRKLAYOUT.DelTrkDtl.osp?guid="+guid+"&trkguid="+trkguid+"';\" >ɾ��<a/>&nbsp;&nbsp;";
			msg+="</p>";
		}
			
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}
// ��������ۣ��ʹ����������
function trkquerydtlpl()
{
	var db = null;
	var msg= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "select a.title,a.pro_note,b.name tousr,to_char(a.crtdat,'YYYY-MM-DD HH24:MI:SS') crttim,c.name crtusr,c.id crtusrid,dtltyp,a.guid ,a.filepath, a.filenote,a.imagepath, a.imagenote ,a.crtusr, a.selforg "+
		"from trkdtl a , usr b, usr c where a.trkguid='"+trkguid +"' and a.tousr=b.id(+) and a.AIMORG=b.org(+) and a.crtusr=c.id and a.selforg=c.org and a.dtltyp='2' order by a.crtdat asc";
		var ds = db.QuerySQL(sql);
		if ( ds.getRowCount() == 0 ) msg+="û�д����¼" ;
		for ( var row=0;row<ds.getRowCount();row ++ ) {
			msg +="<p align='center'><font size='3'>"+ds.getStringAt(row,"title")+"</font></p>";
			msg +="<p align='center'>"+ds.getStringAt(row,"crtusr")+"��"+ds.getStringAt(row,"crttim")+"</p>";
			var note = ds.getStringAt(row,"pro_note");
			var guid = ds.getStringAt(row,"guid");

			if ( note.length() > 0 ) {
				note = pubpack.EAFunc.Replace(note,"\n","<BR>");
				msg +="<font color='#333333'>"+note+"</font>";
			}
			var filepath = ds.getStringAt(row,"filepath");
			var filenote = ds.getStringAt(row,"filenote");
			var imagepath = ds.getStringAt(row,"imagepath");
			var imagenote= ds.getStringAt(row,"imagenote");
			
			if ( filepath!="" ) 
				msg += "<p><font color=#FF0000 size=2>���ظ�����<a href=\"downloadFile.sp?unzip=1&filename="+filepath+"\">"+filenote+"</a>&nbsp;<a href=\"downloadFile.sp?format=zip&filename="+filepath+"\">ѹ������</a></font>";
			if ( imagepath !="" ) 
				msg += "<BR><font color=#FF0000 size=2>��Ļ��ͼ��<a href=\"downloadFile.sp?format=zip&filename="+imagepath+"\">ѹ������</a>&nbsp;<a href=\"downloadFile.sp?unzip=1&format=rtf&filename="+imagepath+"\">ԭʼ����</a></font>";			

			//show.sp?grdid=TRK_TRKDTL&datacc=XLSGRID&guid=28518ADFEFA0FC9DE040007F01006EA8&
			if ( loginusrid ==ds.getStringAt(row,"crtusrid")&& ds.getStringAt(row,"selforg")== loginorgid  )
				msg+="<p align='right'><a href=\"show.sp?grdid=TRK_TRKDTL&datacc=XLSGRID&guid="+ds.getStringAt(row,"guid")+"\"  target=_blank >�༭</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href=\"#\" onclick=\"javascript:if(confirm('�����������Ƿ������')==1)window.location='XLSGRID.TRKLAYOUT.DelTrkDtl.osp?guid="+guid+"&trkguid="+trkguid+"';\" >ɾ��<a/>&nbsp;&nbsp;</p>";
			msg+="<HR>";
		}
			
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}

// �õ�ĳ��trk��ͷ��Ϣ����Ҫ����trk���������ߣ������в�����ť
// �ͻ���: trkguid ��Ӧtrkhdr��guid
function trkhdr()
{
	var db = null;
	var msg= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();
	
	var browser =pubpack.EAFunc.getBroswerType(request);
	

	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "select a.id,a.title,b.id prjid,b.name prjnam,a.prio,e.name trktyp,to_char(a.crtdat,'YYYY-MM-DD HH24:MI:SS') crttim,a.crtusr,d.name statname,a.stat,a.dtlusr,c.name dtlusrnam,a.aimorg,a.project,a.filepath,a.filenote,a.imagepath,a.imagenote,a.show,a.selforg from trkhdr a, prj b,usr c,v_trkstat d,v_trktyp e where a.show=e.id and a.stat=d.id and a.dtlusr=c.id(+) and a.aimorg=c.org(+) and a.project=b.id and a.guid='"+trkguid +"'";
		var ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			var id = ds.getStringAt(0,"id");
			var usrid = ds.getStringAt(0,"DTLUSR");
			var usrorgid = ds.getStringAt(0,"AIMORG");
			var crtid = ds.getStringAt(0,"CRTUSR");
			var crtorgid = ds.getStringAt(0,"SELFORG");
			var show = ds.getStringAt(0,"SHOW");
			var prjid = ds.getStringAt(0,"PRJID");
			var stat = ds.getStringAt(0,"STAT");
			var trktyp = ds.getStringAt(0,"TRKTYP");


			
			msg += "<p align=left><font size=2 color=#808080>��Ŀ:"+ds.getStringAt(0,"prjnam")+"<BR>���ͣ�"+trktyp+"<BR>���:"+ds.getStringAt(0,"id")+"<BR>���ȼ�:"+ds.getStringAt(0,"prio")+"<BR>״̬:"+ds.getStringAt(0,"statname")+"<BR>��ת��:"+ds.getStringAt(0,"dtlusrnam")+"</font></p>" ;
			if (stat != "3" ) {
				if ( loginusrid ==usrid && usrorgid == loginorgid  ){
					if(browser=="4"){
						//msg += "<p align=center>���ô��������<BR>��<a href='show.sp?grdid=HDRTRK&hdrordtl=2&hdrguid="+trkguid+"&style="+show +"&prjid="+prjid +"&edit=&dd=' target=_blank>��������</a>��" ;
						msg += "<p align=center>���ô��������<BR>��<a href='show.sp?grdid=j2me_newtrk&hdrordtl=2&hdrguid="+trkguid+"&style="+show +"&prjid="+prjid +"&edit=&dd=&browser=4' target=_blank>��������</a>��" ;
						msg += "<BR>��<a href='show.sp?grdid=j2me_newtrk&hdrordtl=2&hdrguid="+trkguid+"&tousrid="+ds.getStringAt(0,"crtusr")+"&action=reply&style="+show +"&prjid="+prjid +"&edit=&dd=' target=_blank>�ظ�����</a>��" ;
					}else{
						//msg += "<p align=center>���ô��������<BR>��<a href='show.sp?grdid=j2me_newtrk&hdrordtl=2&hdrguid="+trkguid+"&style="+show +"&prjid="+prjid +"&edit=&dd=&browser=4' target=_blank>�ֻ���������</a>��" ;

						msg += "<p align=center>���ô��������<BR>��<a href='show.sp?grdid=HDRTRK&hdrordtl=2&hdrguid="+trkguid+"&style="+show +"&prjid="+prjid +"&edit=&dd=' target=_blank>��������</a>��" ;
						msg += "<BR>��<a href='show.sp?grdid=HDRTRK&hdrordtl=2&hdrguid="+trkguid+"&tousrid="+ds.getStringAt(0,"crtusr")+"&action=reply&style="+show +"&prjid="+prjid +"&edit=&dd=' target=_blank>�ظ�����</a>��" ;
					}
					
					msg += "<BR>��<a href='show.sp?grdid=HDRTRK&hdrordtl=2&hdrguid="+trkguid+"&tousrid="+ds.getStringAt(0,"dtlusr")+"&action=waiting&style="+show +"&prjid="+prjid +"&edit=&dd=' target=_blank>��Ϊ������</a>��" ;//todoing=y
					msg+"</p>";

				}
				
				if ( loginusrid ==crtid && usrorgid == crtorgid  ){
					if(browser=="4"){
						msg += "<p align=center>�����Խ���������<BR>��<a href=\"XLSGRID.TRKLAYOUT.EndTrk.osp?trkguid="+trkguid+"\"  >��������</a>��" ;
					}else{
						msg += "<p align=center>�����Խ���������<BR>��<a href=\"#\" onclick=\"javascript:if(confirm('�����������Ƿ������')==1)window.location='XLSGRID.TRKLAYOUT.EndTrk.osp?trkguid="+trkguid+"';\" >��������</a>��" ;
					}//msg += "<BR>��<a href='show.sp?grdid=HDRTRK&hdrordtl=2&style="+show +"&edit=&dd=' target=_blank>����</a>��</p>" ;
				}
			}
			if(browser=="4"){
				msg += "<p align=center>�����Է�������<BR>��<a href=\"show.sp?grdid=j2me_newtrk&hdrordtl=3&hdrguid="+trkguid+"&style="+show +"&prjid="+prjid +"&edit=&dd=\" >��������</a>��</p>" ;
				
			}else{
				msg += "<p align=center>�����Է�������<BR>��<a href=\"#\" onclick=\"javascript:window.open('show.sp?grdid=HDRTRK&hdrordtl=3&hdrguid="+trkguid+"&style="+show +"&prjid="+prjid +"&edit=&dd=');\">��������</a>��</p>" ;
			}
		}
		sql = "select title,pro_note,tousr,to_char(a.crtdat,'YYYY-MM-DD HH24:MI:SS') crttim,crtusr from trkdtl a where trkguid='"+trkguid +"' order by crtdat asc";
		
			
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}

//��ʾ��ǰλ��
function trklocal()//�������ѯ��"�ҵ�λ��"��ʾ
{
	var db = null;
	var msg= "";
	var DATE="";
	try {DATE  = date ;} catch ( e ) {DATE="";}
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "";
		
		// ����
		if ( DATE!="" ) {
			msg +="��������:"+ DATE+"<BR>";
		}
		// ������Ŀ
		sql = "select '��Ŀ:'||b.name name from prj b where b.id = '"+trkprj+"'" ;
		var ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			msg += ds.getStringAt(0,"name")+"<BR>";
		}
		// ���Ҵ�����
		sql = "select '������:'||b.name name  from usr b where b.id = '"+trkusr+"'" ;
		ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			msg += ds.getStringAt(0,"name")+"<BR>";
		}
		
		// ������������
		sql = "select '����:'||b.name||'<BR>˵��:'||b.note||'<BR>' name from trktyp b where b.id = '"+trktyp+"'" ;
		ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			msg += ds.getStringAt(0,"name");
			msg+="<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='show.sp?grdid=HDRTRK&style="+trktyp+"&edit=save&dd=0&prj="+trkprj+"' target=\"_blank\">��������>></a>";
		}
		
		
			
		
//		var sql = "  SELECT MAX(a.ID) ID,MAX(A.GUID) GUID,"+
//        	"a.name||''||(case MAX(C.COU) when 1 then '-->'||max(c.name)||'' else '' end)||'<BR>'||note||'<BR>&nbsp;&nbsp;&nbsp;&nbsp;<a href=''show.sp?grdid=HDRTRK&style="+trktyp+"&edit=save&dd=0&prj="+trkprj+"''>��������>></a>' NAME "+
//        	"FROM (select '����:'||b.name name,b.guid,b.id,'˵��:'||b.note note from trktyp b where b.id = '"+trktyp+"') A,"+
//       		"(select max(d.name) name,count(*) COU from prj d where d.id = '"+trkprj+"' ) C "+
//  		"group by a.name,a.note";
//		var ds = db.QuerySQL(sql);
//		if ( ds.getRowCount() > 0 ) {
//			msg = ds.getStringAt(0,"name");
//		}
//		
	}
	
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}
// ��ҳ�ĵ�¼��Ϣ
function LoginInfo()
{
	var ret= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var usrid = usrinfo.getUsrid();
	var usrorgid = usrinfo.getusrOrg();
	var db = null;
	ret = "��ӭ����"+usrinfo.getUsrnam()+"<BR>";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "select * from( select to_char(crtdat,'MM/DD HH24:MI') tim from usrlog where usrid='"+usrid +"' and org='"+usrorgid +"' and action='��¼ϵͳ' order by crtdat desc) where rownum<=2 ";
		var ds =db.QuerySQL(sql);
		if ( ds.getRowCount() > 1 ) {
			ret+="�����һ�ε�¼ʱ����"+ds.getStringAt(1,"TIM") +"<BR>";
		}
		sql = " select count(*) CNT from OALOG where usrid='"+usrid +"' and org='"+usrorgid +"' and ( mwtyp='TRKDTL1' or mwtyp='TRKHDR') and to_char(crtdat,'YYMM')=to_char(sysdate,'YYMM')  ";
		ds =db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			ret+="������������"+ds.getStringAt(0,"CNT") +"�� ";
		}
		sql = " select count(*) CNT from OALOG where usrid='"+usrid +"' and org='"+usrorgid +"' and to_char(crtdat,'YYMM')=to_char(sysdate,'YYMM') ";
		ds =db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			ret+="��Ծ��"+ds.getStringAt(0,"CNT") +"<BR>";
		}
		sql = " select to_char(crtdat,'HH24:MI') TIM from SIGNIN where usrid='"+usrid +"' and org='"+usrorgid +"' and to_char(crtdat,'YYMMDD')=to_char(sysdate,'YYMMDD') order by crtdat asc";
		ds =db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			ret+="����"+ds.getStringAt(0,"TIM")+"��ǩ��<BR>";
		}
		else 
			ret+="<a href=\"show.sp?grdid=TRK_SIGNIN\"  target=_blank><font color='#FF0000'>������ûǩ�������ǩ��</font></a>";
		//ret+="&nbsp;";
		//ret+="<form name='fsearch' action='Layout.sp'>&nbsp;<input id=\"query\" style='COLOR: #aaaaaa;border: 1px solid #0A246A; font-family:����; font-size:9pt' onfocus=\"if(document.all('query').value=='������...')document.all('query').value='';\" size=\"18\" value=\"������...\" onclick=\" if(this.value=='������...')this.value=''\" name=\"query\">&nbsp;<a href=\"#\" onclick=\"fsearch.submit();\">��ʼ����</a>";
		//ret+="<a href=\"#\" onclick=\"fsearch.submit();\">��ʼ����</a><input type='hidden' name ='id' value='SearchTrk'>";
		//ret+="<input type='hidden' name ='encoding' value='UTF-8'></form>";
		//		ret+="<form name='fsearch' action='Layout.sp'>&nbsp;<input id=\"query\" style='COLOR: #aaaaaa;border: 1px solid #0A246A; font-family:����; font-size:9pt' onfocus=\"if(document.all('query').value=='������...')document.all('query').value='';\" size=\"18\" value=\"������...\" onclick=\" if(this.value=='������...')this.value=''\" name=\"query\">&nbsp;<a href=\"#\" onclick=\"fsearch.submit();\">��ʼ����</a><input type='hidden' name ='id' value='SearchTrk'><input type='hidden' name ='ignoreencoding' value='1'><input type='hidden' name ='encoding' value='UTF-8'></form>";

	
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}


	return ret;
}

//����Ŀ�����б� ��ȫ����ť
function trkprjlist(){
	var DATE="";
	try {DATE  = date ;} catch ( e ) {DATE="";}
	var WORKTYPE="1";
	//��worktype=1:ֻ��ʾtitle 2:title,note����ʾ
	try {WORKTYPE  = worktype ;} catch ( e ) {WORKTYPE="1";}

	var db = null;
	var msg= "";//����ʾ��html���
	var url="Layout.sp?id="+id+"&trkusr="+trkusr+"&trktyp="+trktyp+"&worktyp="+worktyp+"&worktype="+WORKTYPE+"&date="+DATE;
	//worktyp   1 �������� 2 ���������� 3 ��־
	var where="";
	if (worktyp=="1"){
		where =" and b.stat<>'3' and e.id not in ('5','6','7','8','9','10','16','17') ";
	}
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "SELECT A.ID,A.NAME||'('||COUNT(*)||')' NAME,A.GUID ,'"+
		url+"&trkprj='|| A.id  url "+
		"FROM PRJ A,TRKHDR B ,trktyp e,v_trkstat d "+
		"WHERE B.PROJECT=A.ID AND B.SHOW LIKE '"+trktyp+"%' "+
		"and b.crtusr like '"+trkusr+"%'"+
		"and b.dtlusr like '"+trkusr+"%'"+
		"and b.show=e.id "+
		"and  b.stat=d.id  "+
		where +
		"and to_char(b.crtdat,'YYYY-MM-DD HH24:MI:SS') like '%"+DATE+"%'"+
		"GROUP BY A.ID,A.NAME,A.GUID "+
		"ORDER BY A.ID";
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trkprj="+"';\">"+"ȫ��"+"</a></td></tr>";//���ȫ����ť
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//ֱ�ӷ���html���

}
//�����ͷ����б� ��ȫ����ť
function trktyplist(){
	var DATE="";
	try {DATE  = date ;} catch ( e ) {DATE="";}
	var WORKTYPE="1";
	//��worktype=1:ֻ��ʾtitle 2:title,note����ʾ
	try {WORKTYPE  = worktype ;} catch ( e ) {WORKTYPE="1";}

	var db = null;
	var msg= "";//����ʾ��html���
	
	var url="Layout.sp?id="+id+"&trkusr="+trkusr+"&trkprj="+trkprj+"&worktyp="+worktyp+"&worktype="+WORKTYPE+"&date="+DATE;
	//worktyp   1 �������� 2 ���������� 3 ��־
	var where="";
	if (worktyp=="1"){
		where =" and b.stat<>'3' and e.id not in ('5','6','7','8','9','10','16','17') ";
	}
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "SELECT a.id,' '||A.NAME||'('||COUNT(*)||')' NAME,A.GUID ,'"+
		url+"&trktyp='|| A.id  url "+
		"FROM trktyp A,TRKHDR B,trktyp e,v_trkstat d  "+
		"WHERE B.SHOW=A.ID and b.project like '"+trkprj+"%' "+
		"and b.crtusr like '"+trkusr+"%' "+
		"and b.show=e.id "+
		"and  b.stat=d.id  "+
		where+
		"and to_char(b.crtdat,'YYYY-MM-DD HH24:MI:SS') like '%"+DATE+"%'"+
		"GROUP BY A.ID,A.NAME,A.GUID "+
		"ORDER BY A.ID";
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//��д��ʽ,���뷽ʽΪ�����,�ö�
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trktyp=';\">"+"ȫ��"+"</a></td></tr>";//���ȫ����ť
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//ֱ�ӷ���html���

}
//�������˷����б� ��ȫ����ť
function trkusrlist(){
	var DATE="";
	try {DATE  = date ;} catch ( e ) {DATE="";}
	var WORKTYPE="1";
	//��worktype=1:ֻ��ʾtitle 2:title,note����ʾ
	try {WORKTYPE  = worktype ;} catch ( e ) {WORKTYPE="1";}
	
	
	var db = null;
	var msg= "";//����ʾ��html���
	var url="Layout.sp?id="+id+"&trktyp="+trktyp+"&trkprj="+trkprj+"&worktyp="+worktyp+"&worktype="+WORKTYPE+"&date="+DATE;
	var where="";
	//worktyp   1 �������� 2 ���������� 3 ��־
	if (worktyp=="1"){
		where =" and b.stat<>'3' and e.id not in ('5','6','7','8','9','10','16','17') ";
	}
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "SELECT distinct max(a.id) id,' '||A.NAME||'('||COUNT(*)||')' NAME,max(A.GUID) guid ,'"+
		url+"&trkusr='|| max(A.id)  url "+
		"FROM v_usr9 A,TRKHDR B ,trktyp e,v_usr9 cc ,v_trkstat d "+
		"WHERE B.crtusr=A.ID and b.project like '"+trkprj+"%' "+
		"and b.show like '"+trktyp+"%'"+
		"and b.show=e.id "+
		"and b.crtusr=cc.id  "+
		"and  b.stat=d.id  "+
		where+
		"and to_char(b.crtdat,'YYYY-MM-DD HH24:MI:SS') like '%"+DATE+"%'"+
		"GROUP BY A.NAME ";
//		"ORDER BY A.ID";
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//��д��ʽ,���뷽ʽΪ�����,�ö�
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trkusr=';\">"+"ȫ��"+"</a></td></tr>";//���ȫ����ť
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//ֱ�ӷ���html���

}
//�����ڲ�ѯ
function trkdate(){
	//��ȡ��ǰ����
	var DATE="";
	try {DATE  = date ;
		if (DATE==""){//��DATEΪ��ʱ,ͬʱҲҪ�趨ΪĬ��ֵ
			throw new Exception();//�׳�����ִ��catch
		}
	} catch ( e ) {
		var db=null;
		var sqldate="select sysdate from dual";
		db = new pubpack.EADatabase();
		var ds = db.QuerySQL(sqldate);
		var dat="";
		if ( ds.getRowCount() > 0 ) 
		dat =  ds.getStringAt(0,"sysdate");
		DATE=dat;
	}
	var url="Layout.sp?id="+id+"&trkusr="+trkusr+"&trktyp="+trktyp+"&trkprj="+trkprj+"&worktyp="+worktyp;
	//throw new Exception(DATE);
	var msg="����"; 
	msg+="<script language=\"javascript\">
	function dateSubmit(form){
	var DATE=document.getElementsByName(\"date\")[0].value;
	var url=\""+url+"&worktype=2&date=\"+DATE+\"\";
	window.location = url;
	}</script>";
	msg+="<input name=\"date\" type=\"\" value=\""+DATE+"\"> <a href=\"#\" onclick=\"dateSubmit()\">����</a> ";
	
	
	
	
	//��ʾ���7��ļ�¼
	var DATE="";
	try {DATE  = date ;} catch ( e ) {DATE="";}
	var WORKTYPE="1";
	//��worktype=1:ֻ��ʾtitle 2:title,note����ʾ
	try {WORKTYPE  = worktype ;} catch ( e ) {WORKTYPE="1";}

	var db = null;
	//var msg= "";//����ʾ��html���
	//worktyp=��������ֻ��ʾ��ǰ�û�������
	//worktype �Ƿ���ʾ���������
	var url="Layout.sp?id="+id+"&trkusr="+trkusr+"&trkprj="+trkprj+"&worktyp="+worktyp+"&worktype=2&trktyp="+trktyp;
	var where="";
	if (worktyp=="1"){
		where =" and b.stat<>'3' and e.id not in ('5','6','7','8','9','10','16','17') ";
	}
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "SELECT '' id,' '||to_char(b.crtdat, 'YYYY-MM-DD')||'('||COUNT(*)||')' NAME,'' guid ,'"+
		url+"&date='|| to_char(b.crtdat, 'YYYY-MM-DD')  url "+
		"FROM trktyp A,TRKHDR B,trktyp e,v_trkstat d  "+
		"WHERE B.SHOW=A.ID and b.project like '"+trkprj+"%' "+
		"and b.crtusr like '"+trkusr+"%' "+
		"and b.show like '"+trktyp+"%'"+
		"and b.show=e.id "+
		"and  b.stat=d.id  "+
		where+
		"and to_char(b.crtdat, 'YYYY-MM-DD HH24:MI:SS') > to_char(sysdate-7,'YYYY-MM-DD')"+
		"GROUP BY to_char(b.crtdat, 'YYYY-MM-DD')"+
		"ORDER BY to_char(b.crtdat, 'YYYY-MM-DD') desc";
		//throw new Exception(sql);
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}

		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}


	
	
	return msg;
}
//��ʾ������б�,��������ʾtitle,not,����ֻ��ʾtitle���б�, ��worktype=1:ֻ��ʾtitle 2:title,note,������̵ȶ���ʾ
function trkall(){ 

	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();
	var DATE="";
	try {DATE  = date ;} catch ( e ) {DATE="";}
	var WORKTYPE="1";
	//��worktype=1:ֻ��ʾtitle 2:title,note����ʾ
	try {WORKTYPE  = worktype ;} catch ( e ) {WORKTYPE="1";}
	var db = null;
	var msg= "";//����ʾ��html���
	//	listtyp:  1 Ϊ�ҵĴ������� 2 Ϊ�Ҵ��������� 3Ϊ ��־
	var sql = "";
	
	sql+="select distinct '��' || a.title || ' ' || to_char(a.crtdat, 'YY/MM/DD') ||
	'    ' || b.name name,
	a.id,
	a.guid,
	'Layout.sp?id=trkquery&trkguid=' || a.guid url,
	a.crtdat,a.note,a.title,b.name crtusr,to_char(a.crtdat,'YYYY-MM-DD HH24:MI:SS') crttim,a.filenote,a.imagenote,a.filepath,
	a.imagepath,a.crtusr crtusrid
	from trkhdr a, usr b";
	
	var where= " where b.id(+) = a.crtusr
	and a.show like '"+trktyp+"%'
	and NVL(a.PROJECT, ' ') like '"+trkprj+"%'
	and NVL(a.crtusr, ' ') like '"+trkusr+"%'
	and to_char(a.crtdat,'YYYY-MM-DD HH24:MI:SS') like '%"+DATE+"%'
	order by a.crtdat desc ";
	sql += where;
	//throw new Exception(sql);
	
//	msg= this.list(sql);
	var url="Layout.sp?id=trkquery";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var ds = db.QuerySQL(sql);
		
		if(WORKTYPE=="1"){
			msg=msg+"<td valign=\"top\">"+
			"<font color=\"#014E82\">"+
			"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
			"<tbody>";//��д��ʽ,���뷽ʽΪ�����,�ö�
			
			//
			for( var i=0 ;i<ds.getRowCount()&&i<=500; i++ ) {
				msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
			}
	//		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&guid=';\">"+"ȫ��"+"</a></td></tr>";//���ȫ����ť
			msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		}else if(WORKTYPE=="2"){//��ʾ���ݺʹ������
			
			for( var i=0 ;i<ds.getRowCount()&&i<=500; i++ ) {
				if ( ds.getRowCount() > 0 ) {
					var id = ds.getStringAt(i,"id");
					msg += "<p align=center><font size=3 >"+ds.getStringAt(i,"title")+"<font></p>";//����
					msg += "<p align=center><font size=2 color=#808080>"+ds.getStringAt(i,"crtusr")+" "+ds.getStringAt(i,"crttim")+"</font></p>";
					
					var note = ds.getStringAt(i,"note");//����
					note = pubpack.EAFunc.Replace(note,"\n","<BR>");
					msg += "<font size=2 >"+note+"</font>";
					var filenote = ds.getStringAt(i,"filenote");
					var imagenote = ds.getStringAt(i,"imagenote");
		
					//��ȡ����
					var filepath = ds.getStringAt(i,"filepath");
					if ( filepath !="" ) {
						var idx = filenote.indexOf("\\");
						while(idx>=0 ) {
							var idx1 = filenote.indexOf("\\",idx+1);
							if ( idx1>= 0 ) idx = idx1;
							else break;
						}
						if ( idx>=0 ) 
							filenote = filenote.substring(idx+1);
						msg += "<p><font color=#FF0000 size=2>���ظ�����<a href=\"downloadFile.sp?unzip=1&filename="+filepath+"\">"+filenote+"</a>&nbsp;<a href=\"downloadFile.sp?format=zip&filename="+filepath+"\">ѹ������</a></font></p>";
					}
				}
				//�����ѭ����ʾ����Ĺ���
				var db2 = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
				var sql2 = "select a.title,a.pro_note,b.name tousr,to_char(a.crtdat,'YYYY-MM-DD HH24:MI:SS') crttim,c.name crtusr,c.id crtusrid,dtltyp,a.guid ,a.selforg,a.filepath, a.filenote,a.imagepath, a.imagenote "+
				"from trkdtl a , usr b, usr c where a.trkguid='"+ds.getStringAt(i,"guid") +"' and a.tousr=b.id(+) and a.AIMORG=b.org(+) and a.crtusr=c.id and a.selforg=c.org and NVL(a.dtltyp,' ')<>'2' order by a.crtdat asc";
				
				var ds2 = db2.QuerySQL(sql2);
				//msg +=sql2;
				//if ( ds2.getRowCount() == 0 ) msg+="û�д����¼" ;
				for ( var row=0;row<ds2.getRowCount();row ++ ) {
					
					msg +="<p>"+(row+1)+"."+ds2.getStringAt(row,"crtusr")+"��"+ds2.getStringAt(row,"crttim");
					var dtltyp  = ds2.getStringAt(row,"dtltyp");
					var guid = ds2.getStringAt(row,"guid");
		
					if (dtltyp   == "2" ) 
						msg += "��������";
					else 
						msg += "���������ת����"+ds2.getStringAt(row,"tousr");
					msg +="<br>&nbsp;&nbsp;&nbsp;&nbsp;���⣺"+ds2.getStringAt(row,"title")+"<BR>";
		
					var note = ds2.getStringAt(row,"pro_note");
					if ( note.length() > 0 ) {
						note = pubpack.EAFunc.Replace(note,"\n","<BR>&nbsp;&nbsp;&nbsp;&nbsp;");
						msg +="&nbsp;&nbsp;&nbsp;&nbsp;<font color='#333333'>"+note+"</font>";
					}
					
					var filepath = ds2.getStringAt(row,"filepath");
					var filenote = ds2.getStringAt(row,"filenote");
					var imagepath = ds2.getStringAt(row,"imagepath");
					var imagenote= ds2.getStringAt(row,"imagenote");
					
					if ( filepath!="" ) 
						msg += "<p><font color=#FF0000 size=2>���ظ�����<a href=\"downloadFile.sp?unzip=1&filename="+filepath+"\">"+filenote+"</a>&nbsp;<a href=\"downloadFile.sp?format=zip&filename="+filepath+"\">ѹ������</a></font>";
					if ( imagepath !="" ) 
						msg += "<BR><font color=#FF0000 size=2>��Ļ��ͼ��<a href=\"downloadFile.sp?format=zip&filename="+imagepath+"\">ѹ������</a>&nbsp;<a href=\"downloadFile.sp?unzip=1&format=rtf&filename="+imagepath+"\">ԭʼ����</a></font>";			
					//return sql2;
					//show.sp?grdid=TRK_TRKDTL&datacc=XLSGRID&guid=28518ADFEFA0FC9DE040007F01006EA8&
//					if ( loginusrid ==ds2.getStringAt(row,"crtusrid")&& ds2.getStringAt(row,"selforg")== loginorgid  )
//						msg+="<p align='right'><a href=\"show.sp?grdid=TRK_TRKDTL&datacc=XLSGRID&guid="+guid+"\"  target=_blank >�༭</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href=\"#\" onclick=\"javascript:if(confirm('�����������Ƿ������')==1)window.location='XLSGRID.TRKLAYOUT.DelTrkDtl.osp?guid="+guid+"&trkguid="+trkguid+"';\" >ɾ��<a/>&nbsp;&nbsp;";
//					msg+="</p>";
					
				}
			}
			

		}
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//ֱ�ӷ���html���

}



//Զ�̵��ý���һ������
//���������trkguid
function EndTrk()
{

	var db = null;
	var msg= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var ret =db.ExcecutSQL("update trkhdr set stat='3' where guid='"+trkguid+"'");
		db.ExcecutSQL("update trkhdr set stat='3' where guid='"+trkguid+"'");
		var ds = db.QuerySQL( "select title,project from trkhdr where guid='"+trkguid+"'");
		OALOG( db,loginorgid ,loginusrid,"ENDTRK","��������",trkguid,ds.getStringAt(0,"title"),"" ,ds.getStringAt(0,"project") ) ;
                  
		msg += "�����ɹ���������"+ret+"�ʼ�¼<BR><a href=\"javascript:window.location='Layout.sp?id=trkquery&trkguid="+trkguid+"';\">�������</a>" ; 
		db.Commit();			
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}

//Զ�̵���ɾ��һ������
//���������trkguid
function DelTrk()
{

	var db = null;
	var msg= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var ds = db.QuerySQL( "select title,note,project from trkhdr where guid='"+trkguid+"'" );
		if ( ds.getRowCount() > 0 ) {
			OALOG( db,loginorgid ,loginusrid,"DELTRKHDR","ɾ������",trkguid,ds.getStringAt(0,"title"),ds.getStringAt(0,"note") ,ds.getStringAt(0,"project")  ) ;
		}
                
                var ret =db.ExcecutSQL("delete from trkhdr  where guid='"+trkguid+"'");
		
		msg += "�����ɹ���������"+ret+"�ʼ�¼<BR><a href=\"javascript:window.location='Layout.sp?id=trkquery&trkguid="+trkguid+"';\">�������</a>" ; 
		db.Commit();			
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}
//Զ�̵���ɾ��һ������
//���������trkguid
function DelTrkDtl()
{

	var db = null;
	var msg= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var ds = db.QuerySQL( "select title,pro_note note,dtltyp,project from trkdtl where guid='"+guid+"'" );
		if ( ds.getRowCount() > 0 ) {
			if ( ds.getStringAt(0,"dtltyp")=="2" ) 
				OALOG( db,loginorgid ,loginusrid,"DELTRKDTL1","ɾ������",guid,ds.getStringAt(0,"title"),ds.getStringAt(0,"note"),ds.getStringAt(0,"project")  ) ;
			else OALOG( db,loginorgid ,loginusrid,"DELTRKDTL1","ɾ�������¼",guid,ds.getStringAt(0,"title"),ds.getStringAt(0,"note"),ds.getStringAt(0,"project")  ) ;
		}

		
		var ret =db.ExcecutSQL("delete from trkdtl  where guid='"+guid+"'");
		
		msg += "�����ɹ���������"+ret+"�ʼ�¼<BR><a href=\"javascript:window.location='Layout.sp?id=trkquery&trkguid="+trkguid+"';\">�������</a>" ; 
		db.Commit();			
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}

//�ҵĴ�������,�Ҵ���������,��־����ʾ�б�
function trkmylist(){
	
	var db = null;
	var msg= "";//����ʾ��html���
	//	listtyp:  1 Ϊ�ҵĴ������� 2 Ϊ�Ҵ��������� 3Ϊ ��־
	var sql = "";
	if(trkusr=="curusr"){//ֻ��ʾ��ǰ�û�
		var usr=web.EASession.GetLoginInfo(request);//��ȡ��ǰ�û���Ϣ
		trkusr=usr.getUsrid();
	}
	
	
	if(worktyp=="1"){
		sql="select a.title|| ' '||cc.name ||to_char(a.crtdat,'mm/dd hh24:mi') name,substr(a.note,1,25) note ,"+
		"a.guid ,a.id,'Layout.sp?id=trkquery&trkguid='||a.guid url"+
		" from  "+
		"trkhdr a,v_usr c ,trktyp e,v_usr cc "+
		"where "+
		"a.dtlusr=c.id  and a.AIMORG=c.orgid and a.crtusr=cc.id  and a.AIMORG=cc.orgid "+
//		"and c.id=lower('"+usrid+"')   "+
//		"and c.orgid='"+orgid+"'"+
		"and a.show =e.id   "+
		"and a.stat<>'3' "+//-- 0���½���1�������У�2���Ѵ���3�������꣬4��δ����"+
		"and e.id not in ('5','6','7','8','9','10','16','17') "+
		"and a.project like '"+trkprj+"%' "+
		"and a.show like '"+trktyp+"%' "+
		"and a.dtlusr like '"+trkusr+"%'"+
		"order by to_char(a.crtdat,'yyyy-mm-dd hh24:mi:ss') desc ";

	}else if(worktyp=="2"){
		sql="select a.title|| ' '||to_char(a.crtdat,'mm/dd')||' -��'||c.name||' ״̬'||d.name name,substr(a.note,1,25) note ,"+
		"a.guid ,a.id,'Layout.sp?id=trkquery&trkguid='||a.guid url"+
		" from  "+
		"trkhdr a,v_usr c ,trktyp e,v_usr cc, v_trkstat d "+
		"where "+
		"a.dtlusr=c.id  and a.AIMORG=c.orgid and a.crtusr=cc.id  and a.SELFORG=cc.orgid "+
		"and a.stat=d.id "+
//		"and cc.id=lower('[%SYS_USRID]')   "+
//		"and cc.orgid='[%SYS_ORGID]'"+
		"and a.show like'"+trktyp+"%'"+
		"and a.project like'"+trkprj+"%'"+
		"and a.crtusr like '"+trkusr+"%'"+
		"and a.show =e.id   "+
		""+
		"order by to_char(a.crtdat,'yyyy-mm-dd hh24:mi:ss') desc ";
	}else if(worktyp=="3"){
		sql="select  distinct ''||a.usrnam ||'  '||to_char(a.crtdat,'mm/dd hh24:mi')||'  '||a.action||substr(a.name,1,16)   name, "+
		"a.guid,a.usrid id,a.crtdat "+
		",'Layout.sp?id=trkquery&guid='||a.bilid||'&trkguid='||a.bilid url "+
		"from OALOG a ,trkhdr b where mwtyp in( 'TRKHDR','TRKDTL1','TRKDTL2','ENDTRK' ) "+
		" and "+
		" b.guid=a.bilid "+
		"and b.show like'"+trktyp+"%'"+
		"and b.project like'"+trkprj+"%'"+
		"and b.crtusr like '"+trkusr+"%'"+
		
		"order by crtdat desc"; 
	}
	
	//throw new Exception(sql);
	

	var url="Layout.sp?id=trkquery";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//��д��ʽ,���뷽ʽΪ�����,�ö�
		var ds = db.QuerySQL(sql);
		//
		for( var i=0 ;i<ds.getRowCount()&&i<=500; i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
//		msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&guid=';\">"+"ȫ��"+"</a></td></tr>";//���ȫ����ť
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//ֱ�ӷ���html���

}


//�������������б�
function searchtrk(){ 
	
	var db = null;
	var msg= "";//����ʾ��html���
	//	listtyp:  1 Ϊ�ҵĴ������� 2 Ϊ�Ҵ��������� 3Ϊ ��־
	var sql = "";
	var	querywhere = " and (";
			var str=query.split(" ");
			  //throw new Exception(str);
			for(var i=0;i<str.length();i++)    
			{	
				if(i==0){
					querywhere+="  lower( concat(UTL_RAW.CAST_TO_VARCHAR2(a.noteblob),concat(a.title,concat(a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}else{
					querywhere+=" and lower( concat(UTL_RAW.CAST_TO_VARCHAR2(a.noteblob),concat(a.title,concat( a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}
			} 
		querywhere+=") ";
	
	
	sql="SELECT A.id ,";//��ѯ�����sql���
		sql+="a.title|| ' '||cc.name||'('||d.name ||')'||to_char(a.crtdat,'yyyy/mm/dd hh24:mi') name,";
		sql+="A.GUID,";
		sql+="'Layout.sp?id=trkquery&trkguid='||a.guid url ";

		sql+="FROM  TRKHDR A,v_usr c ,trktyp e,v_usr cc,trktyp d ";
		sql+="where ";
		sql+="a.dtlusr=c.id(+)  and a.AIMORG=c.orgid(+) and a.crtusr=cc.id  and a.AIMORG=cc.orgid ";
		sql+="and a.show =e.id ";
		sql+="and d.id=a.show ";
		sql+="and a.PROJECT like '"+trkprj+"%'";
		sql+="and a.show like '"+trktyp+"%'";
		sql+="and a.crtusr like '"+crtusr+"%'";
		sql+=querywhere;
		sql+=" order by a.crtdat desc ";
	
	var querywhere = "  (";//��ѯ�������sql���������
			var str=query.split(" ");
			  //throw new Exception(str);
			for(var i=0;i<str.length();i++)    
			{	
				if(i==0){
					querywhere+="  lower( concat(a.name,concat(a.note,to_char(a.crtdat,'yyyy-mm-dd')))) like lower('%"+str[i]+"%')"; 
				}else{
					querywhere+=" and lower( concat(a.name,concat( a.note,to_char(a.crtdat,'yyyy-mm-dd')))) like lower('%"+str[i]+"%')"; 
				}
			} 
		querywhere+=") ";
	
	
	var sqlapi="select '' id,'' guid,a.name name,'Layout.sp?id=apiquery&apiguid='||a.guid url from FUNCLIST a where "+querywhere;
	
	//throw new Exception(sqlapi+"|"+sql);
	
//	msg= this.list(sql);
	var url="Layout.sp?id=trkquery";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//��д��ʽ,���뷽ʽΪ�����,�ö�
//		var ds = db.QuerySQL(sqlapi);
//		//
//		for( var i=0 ;i<ds.getRowCount()&&i<=100; i++ ) {
//			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
//		}
//		msg += "<tr><td width=100%  >------------------------------</td></tr>";
		
		
		var ds = db.QuerySQL(sql);
		//
		for( var i=0 ;i<ds.getRowCount()&&i<=500; i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
//		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&guid=';\">"+"ȫ��"+"</a></td></tr>";//���ȫ����ť
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//ֱ�ӷ���html���

}
//��ʾ�������������
function searchquery(){
	var db = null;
	db = new pubpack.EADatabase();
	var msg= "ȫ����� <br> �ؼ��� \""+query+"\" </br>";//����ʾ��html���
	var sql=""; 
	// ������Ŀ
		sql = "select '��Ŀ:'||b.name name from prj b where b.id = '"+trkprj+"'" ;
		var ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			msg += ds.getStringAt(0,"name")+"<BR>";
		}
	// ���Ҵ�����
		sql = "select '������:'||b.name name  from usr b where b.id = '"+crtusr+"'" ;
		ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			msg += ds.getStringAt(0,"name")+"<BR>";
		}
		
	// ������������
		sql = "select '����:'||b.name||'<BR>˵��:'||b.note||'<BR>' name from trktyp b where b.id = '"+trktyp+"'" ;
		ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			msg += ds.getStringAt(0,"name");
			msg+="<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='show.sp?grdid=HDRTRK&style="+trktyp+"&edit=save&dd=0&prj="+trkprj+"' target=\"_blank\">��������>></a>";
		}

	return msg;
}
//��������İ���Ŀ�����б� ��ȫ����ť
function searchprjlist(){
	var db = null;
	var msg= "";//����ʾ��html���
	var url="Layout.sp?id=SearchTrk&query="+query+""+"&crtusr="+crtusr+"&trktyp="+trktyp;//����������
	var sql="";
	var querywhere="";
	var category="";//����Ĳ�ѯ����
	// //��Ӳ�ѯ����
	querywhere = " and (";
			var str=query.split(" ");
			  //throw new Exception(str);
			for(var i=0;i<str.length();i++)    
			{	
				if(i==0){
					querywhere+="  lower( concat(B.title,concat(B.note,to_char(b.crtdat,'yyyy-mm-dd')))) like lower('%"+str[i]+"%')"; 
				}else{
					querywhere+=" and lower( concat(B.title,concat( B.note,to_char(b.crtdat,'yyyy-mm-dd')))) like lower('%"+str[i]+"%')"; 
				}
			} 
		querywhere+=") ";
	category = "and b.crtusr like '"+crtusr+"%'"+
			"and b.show like '"+trktyp+"%'";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "select * from (";
				sql+="SELECT A.ID,A.NAME||'('||COUNT(*)||')' NAME,A.GUID ,'"+
					url+"&trkprj='|| A.id  url "+
					"FROM PRJ A,TRKHDR B ,v_usr c ,v_usr cc "+
					"WHERE B.PROJECT=A.ID "+
					" and c.id= b.crtusr  "+
					" and cc.id(+)= b.dtlusr "+
					" and b.AIMORG=c.orgid "+
					" and b.AIMORG=cc.orgid(+) "+
					category;
					
				sql+=querywhere;
				
				sql+="GROUP BY A.ID,A.NAME,A.GUID "+
				"ORDER BY A.ID";
		sql+=") a";
		
		sql+=" union ";
		sql+="select '' id ,"+
                " 'ȫ�� ' || '(' || COUNT(*) || ')' NAME , "+
                " '' guid, "+
                " '"+url+"&trkprj=' url "+
		"from TRKHDR B, v_usr c, v_usr cc WHERE   "+
		"c.id = b.crtusr "+
		"and cc.id(+) = b.dtlusr "+
		"and b.AIMORG = c.orgid  "+
		"and b.AIMORG = cc.orgid(+) "+
		category;
           	sql+=querywhere;
		
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//
		
		//throw new Exception(sql);
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trkprj="+"';\">"+"ȫ��"+"</a></td></tr>";//���ȫ����ť
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//ֱ�ӷ���html���

}

//��������İ��������ͷ����б� ��ȫ����ť
function searchtyplist(){
	var db = null;
	var msg= "";//����ʾ��html���
	var url="Layout.sp?id=SearchTrk&query="+query+""+"&crtusr="+crtusr+"&trkprj="+trkprj;//����������
	var sql="";
	var querywhere = "";
	var category = "";//�����ѯ����
	// //��Ӳ�ѯ����
	querywhere = " and (";
			var str=query.split(" ");
			  //throw new Exception(str);
			for(var i=0;i<str.length();i++)    
			{	
				if(i==0){
					querywhere+="  lower( concat(B.title,concat(B.note,to_char(b.crtdat,'yyyy-mm-dd')))) like lower('%"+str[i]+"%')"; 
				}else{
					querywhere+=" and lower( concat(B.title,concat(B.note,to_char(b.crtdat,'yyyy-mm-dd')))) like lower('%"+str[i]+"%')"; 
				}
			} 
		querywhere+=") ";
	category = "and b.crtusr like '"+crtusr+"%'"+
			"and b.project like '"+trkprj+"%'";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "select * from (";
				sql+="SELECT A.ID,A.NAME||'('||COUNT(*)||')' NAME,A.GUID ,'"+
					url+"&trktyp='|| A.id  url "+
					"FROM trktyp A,TRKHDR B ,v_usr c ,v_usr cc "+
					"WHERE B.show=A.ID "+
					" and c.id= b.crtusr  "+
					" and cc.id(+)= b.dtlusr "+
					" and b.AIMORG=c.orgid "+
					" and b.AIMORG=cc.orgid(+) "+
					category;
				
				sql+=querywhere;
				
				sql+="GROUP BY A.ID,A.NAME,A.GUID "+
				"ORDER BY A.ID";
		sql+=") a";
		
		sql+=" union ";
		sql+="select '' id ,"+
                " 'ȫ�� ' || '(' || COUNT(*) || ')' NAME , "+
                " '' guid, "+
                " '"+url+"&trktyp=' url "+
		"from TRKHDR B, v_usr c, v_usr cc WHERE   "+
		"c.id = b.crtusr "+
		"and cc.id(+) = b.dtlusr "+
		"and b.AIMORG = c.orgid  "+
		"and b.AIMORG = cc.orgid(+) "+
		category;
           	sql+=querywhere;
		
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//
		
		//throw new Exception(sql);
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trkprj="+"';\">"+"ȫ��"+"</a></td></tr>";//���ȫ����ť
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//ֱ�ӷ���html���

}
//��������Ĵ����˷����б� ��ȫ����ť
function searchcrtusrlist(){ 
	var db = null;
	var msg= "";//����ʾ��html���
	var url="Layout.sp?id=SearchTrk&query="+query+""+"&trktyp="+trktyp+"&trkprj="+trkprj;//����������
	var sql="";
	var querywhere = "";
	var category = "";//�����ѯ����
	// //��Ӳ�ѯ����
	querywhere = " and (";
			var str=query.split(" ");
			  //throw new Exception(str);
			for(var i=0;i<str.length();i++)    
			{	
				if(i==0){
					querywhere+="  lower( concat(B.title,concat(B.note,to_char(b.crtdat,'yyyy-mm-dd')))) like lower('%"+str[i]+"%')"; 
				}else{
					querywhere+=" and lower( concat(B.title,concat(B.note,to_char(b.crtdat,'yyyy-mm-dd')))) like lower('%"+str[i]+"%')"; 
				}
			} 
		querywhere+=") ";
	category = "and b.show like '"+trktyp+"%'"+
			"and b.project like '"+trkprj+"%'";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "select * from (";
				sql+="SELECT A.ID,A.NAME||'('||COUNT(*)||')' NAME,A.GUID ,'"+
					url+"&crtusr='|| A.id  url "+
					"FROM v_usr9 A,TRKHDR B ,v_usr c ,v_usr cc "+
					"WHERE B.crtusr=A.ID "+
					" and c.id= b.crtusr  "+
					" and cc.id(+)= b.dtlusr "+
					" and b.AIMORG=c.orgid "+
					" and b.AIMORG=cc.orgid(+) "+
					category;
				
				sql+=querywhere;
				
				sql+="GROUP BY A.ID,A.NAME,A.GUID "+
				"ORDER BY A.ID";
		sql+=") a";
		
		sql+=" union ";
		sql+="select '' id ,"+
                " 'ȫ�� ' || '(' || COUNT(*) || ')' NAME , "+
                " '' guid, "+
                " '"+url+"&crtusr=' url "+
		"from TRKHDR B, v_usr c, v_usr cc WHERE   "+
		"c.id = b.crtusr "+
		"and cc.id(+) = b.dtlusr "+
		"and b.AIMORG = c.orgid  "+
		"and b.AIMORG = cc.orgid(+) "+
		category;
           	sql+=querywhere;
		
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//
		
		//throw new Exception(sql);
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trkprj="+"';\">"+"ȫ��"+"</a></td></tr>";//���ȫ����ť
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//ֱ�ӷ���html���

}

// �õ�ĳ��api��������
// �ͻ���: apiguid ��ӦFUNCLIST��guid
function apiquery()
{
	var db = null;
	var msg= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();	
	try {
	
		//msg += "<p align=center><B><font size=3 >"+ds.getStringAt(0,"title")+"<font></B></p>";
		//msg += "<p align=center><font size=2 color=#808080>"+ds.getStringAt(0,"crtusr")+" "+ds.getStringAt(0,"crttim")+"</font></p>";
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "select a.SAMPLE,a.PARAMETER,a.PARAMNOTE,a.FUNCTION,a.return,a.note,a.name,a.FUNCNOTE,a.CRTDAT,a.id from FUNCLIST a where a.guid='"+apiguid+"'";
		//throw new Exception(sql);
		var ds = db.QuerySQL(sql);
		
		if ( ds.getRowCount() > 0 ) {
			var id = ds.getStringAt(0,"id");
			//if(ds.getStringAt(0,"name")!="")
				msg += "<p align=center><B><font size=3 >"+ds.getStringAt(0,"name")+"<font></B></p>";
			//msg += "<p align=center><font size=2 color=#808080>"+"�������� "+ds.getStringAt(0,"CRTDAT")+"</font></p>";
			msg += "<font size=2 ><br>"+"����:<font size=2 color='#333333'> "+ds.getStringAt(0,"FUNCTION")+"</font>";
			msg += "<font size=2 ><br>"+"</font>��������:<font size=2 color='#333333'>"+ds.getStringAt(0,"FUNCNOTE")+"</font>";
			msg += "<br>"+"����ֵ:<font size=2 color='#333333'>"+ds.getStringAt(0,"return")+"</font>";
			msg += "<br>"+"����˵��:</font>";
			var note = ds.getStringAt(0,"note");
			note = pubpack.EAFunc.Replace(note,"\n","<br>");//�滻���м�
			note = pubpack.EAFunc.Replace(note,"\r","<br>");//�滻���м�
			note = pubpack.EAFunc.Replace(note,"\u0009","&nbsp;&nbsp;&nbsp;&nbsp;");//�滻tab��
			msg += "<br><font size=2 color='#333333'>"+note+"</font>";
			
			
			//var id = ds.getStringAt(0,"id");
			var note = ds.getStringAt(0,"PARAMETER");
			note = pubpack.EAFunc.Replace(note,"\n","<br>");//�滻���м�
			note = pubpack.EAFunc.Replace(note,"\r","<br>");//�滻���м�
			note = pubpack.EAFunc.Replace(note,"\u0009","&nbsp;&nbsp;&nbsp;&nbsp;");//�滻tab��
			msg += "<br><p align=left><font size=2  >����:<font size=2 color='#333333'>"+note+"</font></p>";
			//msg += "<p align=center><font size=1 color=#808080>"+" "+ds.getStringAt(0,"PARAMNOTE")+"</font></p>";
			
			var PARAMNOTE = ds.getStringAt(0,"PARAMNOTE");
			PARAMNOTE = pubpack.EAFunc.Replace(PARAMNOTE,"\n","<br>");//�滻���м�
			PARAMNOTE = pubpack.EAFunc.Replace(PARAMNOTE,"\r","<br>");//�滻���м�
			PARAMNOTE = pubpack.EAFunc.Replace(PARAMNOTE,"\u0009","&nbsp;&nbsp;&nbsp;&nbsp;");//�滻tab��
			//throw new Exception(note+"");
			msg += "<br><font size=2>����˵��:</font><br><font size=2 color='#333333'>"+PARAMNOTE+"</font>";
			
			var note = ds.getStringAt(0,"SAMPLE");
			note = pubpack.EAFunc.Replace(note,"\n","<br>");//�滻���м�
			note = pubpack.EAFunc.Replace(note,"\r","<br>");//�滻���м�
			note = pubpack.EAFunc.Replace(note,"\u0009","&nbsp;&nbsp;&nbsp;&nbsp;");//�滻tab��
			//throw new Exception(note+"");
			msg += "<br><font size=2 >����:</font><br><font size=2 color='#333333'"+note+"</font>";

		}
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}
// �õ�ĳ��api�����,����
function apiqueryclass()
{
	var db = null;
	var msg= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();	
	try {

		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "select a.guid,a.function, a.class, D.NAME flag, a.RLSNO, C.NAME lang, b.name SUBTYP, a.id
			  from FUNCLIST a ,V_FUNCSUBTYP B,V_FUNCLANG c,V_FUNCFLAG d 
			 where c.id(+)=a.lang and d.id(+)=a.flag AND B.ID(+)=A.SUBTYP and a.guid='"+apiguid+"'";
		//throw new Exception(sql);
		var ds = db.QuerySQL(sql);
		
		if ( ds.getRowCount() > 0 ) {
			var id = ds.getStringAt(0,"id");
			msg +="<font color=#014E82 size=2>";
			msg +="����:"+ ds.getStringAt(0,"LANG")+"<br>";
			//msg +="����:"+ ds.getStringAt(0,"function")+"<br>";
			msg +="����:"+ ds.getStringAt(0,"class")+"<br>";
			msg +="��־:"+ ds.getStringAt(0,"flag")+"<br>";
			msg +="����:"+ ds.getStringAt(0,"SUBTYP")+"<br>";
			msg +="֧�ְ汾:"+ ds.getStringAt(0,"RLSNO")+"<br>";
			msg +="</font></p>";

			var guid = ds.getStringAt(0,"guid");
			msg+="<p align=center><a href='show.sp?grdid=ACTIVEX&guid="+guid+"'>�༭</a></p>";

		}
		
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}


//����������api���б�
function searchapi(){ 
	
	var db = null;
	var msg= "";//����ʾ��html���
	//	listtyp:  1 Ϊ�ҵĴ������� 2 Ϊ�Ҵ��������� 3Ϊ ��־
	var sql = "";
	var querywhere = "  (";//��ѯ�������sql���������
			var str=query.split(" ");
			  //throw new Exception(str);
			for(var i=0;i<str.length();i++)    
			{	
				if(i==0){
					querywhere+="  lower( concat(a.function, concat(a.name,concat(a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}else{
					querywhere+=" and lower( concat(a.function, concat(a.name,concat( a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}
			} 
		querywhere+=") ";
	var category = " and decode(a.lang,null,' ',a.lang) like '"+apilang+"%'"+
			"and decode(a.flag,null,' ', a.flag) like '"+apiflag+"%'"+
			"and decode(a.subtyp,null,' ', a.subtyp) like'"+apisubtyp+"%'";
	
	var sqlapi="select '' id,'' guid,'��'||a.function||'  (����:'||a.CLASS||')'||'('||c.name||')'||'<br> &nbsp; '||a.name  name,'Layout.sp?id=apiquery&apiguid='||a.guid url from FUNCLIST a , V_FUNCSUBTYP B, V_FUNCLANG c, V_FUNCFLAG d
			 where c.id(+) = a.lang
			   and d.id(+) = a.flag
			   AND B.ID(+) = A.SUBTYP and "+querywhere+category;
	
	//throw new Exception(sqlapi);
	
	var url="Layout.sp?id=trkquery";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//��д��ʽ,���뷽ʽΪ�����,�ö�
		var ds = db.QuerySQL(sqlapi);
		//
		for( var i=0 ;i<ds.getRowCount()&&i<=500; i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		//msg += "<tr><td width=100%  >------------------------------</td></tr>";
		//		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&guid=';\">"+"ȫ��"+"</a></td></tr>";//���ȫ����ť
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//ֱ�ӷ���html���

}
//����api�����Է����б� ��ȫ����ť
function searchapilanglist(){
	var db = null;
	var msg= "";//����ʾ��html���
	var url="Layout.sp?id=SearchAPI&query="+query+""+"&apiflag="+apiflag+"&apisubtyp="+apisubtyp;//����������
	var sql="";
	var querywhere = "";
	var category = "";//�����ѯ����
	// //��Ӳ�ѯ����
	var querywhere = "  (";//��ѯ�������sql���������
			var str=query.split(" ");
			  //throw new Exception(str);
			for(var i=0;i<str.length();i++)    
			{	
				if(i==0){
					querywhere+="  lower( concat(a.function, concat(a.name,concat(a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}else{
					querywhere+=" and lower( concat(a.function, concat(a.name,concat( a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}
			} 
		querywhere+=") ";
	category = //"and decode(a.lang,null,' ',a.lang) like '"+apilang+"%'"+
			"and decode(a.flag,null,' ', a.flag) like '"+apiflag+"%'"+
			"and decode(a.subtyp,null,' ', a.subtyp) like'"+apisubtyp+"%'";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "select * from (";
				sql+="SELECT c.ID,c.NAME||'('||COUNT(*)||')' NAME,c.GUID ,'"+
					url+"&apilang='|| c.id  url "+
					"from FUNCLIST a , V_FUNCSUBTYP B, V_FUNCLANG c, V_FUNCFLAG d
					 where c.id(+) = a.lang
					   and d.id(+) = a.flag
					   AND B.ID(+) = A.SUBTYP "+
					category;
				
				sql+=" and "+querywhere;
				
				sql+="GROUP BY c.ID,c.NAME,c.GUID "+
				"ORDER BY c.ID";
		sql+=") a";
		
		sql+=" union ";
		sql+="select '' id ,"+
                " 'ȫ�� ' || '(' || COUNT(*) || ')' NAME , "+
                " '' guid, "+
                " '"+url+"&apilang=' url "+
		"from FUNCLIST a , V_FUNCSUBTYP B, V_FUNCLANG c, V_FUNCFLAG d
					 where c.id(+) = a.lang
					   and d.id(+) = a.flag
					   AND B.ID(+) = A.SUBTYP "+
		category;
           	sql+=" and "+querywhere;

		
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//
		
		//throw new Exception(sql);
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trkprj="+"';\">"+"ȫ��"+"</a></td></tr>";//���ȫ����ť
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//ֱ�ӷ���html���

}
//����api�ı�־�����б� ��ȫ����ť
function searchapiflaglist(){
	var db = null;
	var msg= "";//����ʾ��html���
	var url="Layout.sp?id=SearchAPI&query="+query+""+"&apilang="+apilang+"&apisubtyp="+apisubtyp;//����������

	var sql="";
	var querywhere = "";
	var category = "";//�����ѯ����
	// //��Ӳ�ѯ����
	var querywhere = "  (";//��ѯ�������sql���������
			var str=query.split(" ");
			  //throw new Exception(str);
			for(var i=0;i<str.length();i++)    
			{	
				if(i==0){
					querywhere+="  lower( concat(a.function, concat(a.name,concat(a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}else{
					querywhere+=" and lower( concat(a.function, concat(a.name,concat( a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}
			} 
		querywhere+=") ";
	category = "and decode(a.lang,null,' ',a.lang) like '"+apilang+"%'"+
			//"and decode(a.flag,null,' ', a.flag) like '"+apiflag+"%'"+
			"and decode(a.subtyp,null,' ', a.subtyp) like'"+apisubtyp+"%'";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "select * from (";
				sql+="SELECT d.ID,d.NAME||'('||COUNT(*)||')' NAME,d.GUID ,'"+
					url+"&apiflag='|| d.id  url "+
					"from FUNCLIST a , V_FUNCSUBTYP B, V_FUNCLANG c, V_FUNCFLAG d
					 where c.id(+) = a.lang
					   and d.id(+) = a.flag
					   AND B.ID(+) = A.SUBTYP "+
					category;
				
				sql+=" and "+querywhere;

				
				sql+="GROUP BY d.ID,d.NAME,d.GUID "+
				"ORDER BY d.ID";
		sql+=") a";
		
		sql+=" union ";
		sql+="select '' id ,"+
                " 'ȫ�� ' || '(' || COUNT(*) || ')' NAME , "+
                " '' guid, "+
                " '"+url+"&apiflag=' url "+
		"from FUNCLIST a , V_FUNCSUBTYP B, V_FUNCLANG c, V_FUNCFLAG d
					 where c.id(+) = a.lang
					   and d.id(+) = a.flag
					   AND B.ID(+) = A.SUBTYP "+
		category;
           	sql+=" and "+querywhere;

		
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//
		
		//throw new Exception(sql);
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trkprj="+"';\">"+"ȫ��"+"</a></td></tr>";//���ȫ����ť
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//ֱ�ӷ���html���

}
//����api�������б� ��ȫ����ť
function searchAPIsubtyplist(){
	var db = null;
	var msg= "";//����ʾ��html���
	var url="Layout.sp?id=SearchAPI&query="+query+""+"&apiflag="+apiflag+"&apilang="+apilang;//����������
	var sql="";
	var querywhere = "";
	var category = "";//�����ѯ����
	// //��Ӳ�ѯ����
	var querywhere = "  (";//��ѯ�������sql���������
			var str=query.split(" ");
			  //throw new Exception(str);
			for(var i=0;i<str.length();i++)    
			{	
				if(i==0){
					querywhere+="  lower( concat(a.function, concat(a.name,concat(a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}else{
					querywhere+=" and lower( concat(a.function, concat(a.name,concat( a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}
			} 
		querywhere+=") ";
	category = "and decode(a.lang,null,' ',a.lang) like '"+apilang+"%'"+
			"and decode(a.flag,null,' ', a.flag) like '"+apiflag+"%'";
			//"and decode(a.subtyp,null,' ', a.subtyp) like'"+apisubtyp+"%'";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "select * from (";
				sql+="SELECT b.ID,b.NAME||'('||COUNT(*)||')' NAME,b.GUID ,'"+
					url+"&apisubtyp='|| b.id  url "+
					"from FUNCLIST a , V_FUNCSUBTYP B, V_FUNCLANG c, V_FUNCFLAG d
					 where c.id(+) = a.lang
					   and d.id(+) = a.flag
					   AND B.ID(+) = A.SUBTYP "+
					category;
				
				sql+=" and "+querywhere;

				
				sql+="GROUP BY b.ID,b.NAME,b.GUID "+
				"ORDER BY b.ID";
		sql+=") a";
		sql+=" union ";
		sql+="select '' id ,"+
                " 'ȫ�� ' || '(' || COUNT(*) || ')' NAME , "+
                " '' guid, "+
                " '"+url+"&apisubtyp=' url "+
		"from FUNCLIST a , V_FUNCSUBTYP B, V_FUNCLANG c, V_FUNCFLAG d
					 where c.id(+) = a.lang
					   and d.id(+) = a.flag
					   AND B.ID(+) = A.SUBTYP "+
		category;
           	sql+=" and "+querywhere;

		
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//
		
		//throw new Exception(sql);
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trkprj="+"';\">"+"ȫ��"+"</a></td></tr>";//���ȫ����ť
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//ֱ�ӷ���html���

}
//��ʾ����api������
function searchapiquery(){
	var db = null;
	db = new pubpack.EADatabase();
	var msg= "ȫ����� <br> �ؼ��� \""+query+"\" </br>";//����ʾ��html���
	var sql=""; 
	// ������Ŀ
		sql = "select '����:'||b.name name from V_FUNCLANG b where b.id = '"+apilang+"'" ;
		var ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			msg += ds.getStringAt(0,"name")+"<BR>";
		}
	// ���Ҵ�����
		sql = "select '��־:'||b.name name  from V_FUNCFLAG b where b.id = '"+apiflag+"'" ;
		ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			msg += ds.getStringAt(0,"name")+"<BR>";
		}
		
	// ������������
		sql = "select '����:'||b.name||'<BR>˵��:'||b.note||'<BR>' name from V_FUNCSUBTYP b where b.id = '"+apisubtyp+"'" ;
		ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			msg += ds.getStringAt(0,"name");
			//msg+="<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='show.sp?grdid=HDRTRK&style="+trktyp+"&edit=save&dd=0&prj="+trkprj+"' target=\"_blank\">��������>></a>";
		}

	return msg;
}

//�ֻ��˿������������б�
function wapNewTrklist(){
	//return "";
	var db = null;
	var msg= "";//����ʾ��html���
	
	//var url="Layout.sp?id=SearchAPI&query="+query+""+"&apilang="+apilang+"&apisubtyp="+apisubtyp;//����������

	var sql="select name,url,id,guid from SYSURL where refid='3A�����������' order by seqid";
	
	try{ 
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";
		
		db = new pubpack.EADatabase();
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			if(i!=0&&(i%2=="0")){
				msg = msg+"<br>";
			}
			msg = msg + "<a href='"+ds.getStringAt(i,"url")+"'>"+ds.getStringAt(i,"name")+"</a>";
			msg += "&nbsp;&nbsp;&nbsp;&nbsp;";
		}
		
		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trkprj="+"';\">"+"ȫ��"+"</a></td></tr>";//���ȫ����ť
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//ֱ�ӷ���html���

}




}
function TAXMON_DesktopLayout(){var pub = new JavaPackage ( "com.xlsgrid.net.pub" );
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );

var Topstyle = "<style type=\"text/css\">.Cons{padding:1px 1px; }
			.Cons table{width:300px; border-bottom:1px #efefef solid; border-left:1px #efefef solid;margin:0 auto;}
			.Cons th{text-align:center; line-height:18px; padding-top:1px; color:#494949; background:#fff; font-weight:normal;border:1px solid #efefef;border-width:1px 1px 0;}
			.Cons td{text-align:center; line-height:18px; padding:2px 0 0; border-right:1px #efefef solid; border-top:1px #efefef solid; color:#333;}
			.Cons td.ConsTi{text-align:left; padding:2px 0 2px;font-size:12px;line-height:18px; }
			.Cons td.ConsTi2{text-align:right; padding:2px 0 2px;font-size:12px;line-height:18px; }
			.Cons td.ConsTi3{text-align:center; padding:2px 0 2px;font-size:12px;line-height:18px; }
		</style>";
//�õ����а�
function eleTop()
{
	var db = null;	
	var html = "<div class=\"Cons\"><table cellspacing=\"0\" style=\"width: 100%\">";
	try {
		db = new pub.EADatabase();
		var sql = "select rownum,name,elemny,taxmny from (
      select name,elemny,taxmny from (
        select nvl(b.id,a.usrid) id,nvl(b.name,a.usrnam) name,round(nvl(sum(elemny)/10000,0),2) elemny,
        round(nvl(sum(taxmny),0)/10000,2) taxmny from tax_eledata a,tax_company b,tax_taxdata C
        where a.usrid=b.ammno(+)
          AND b.id=c.id(+)   
          and substr(a.yymm,0,4)=to_char(sysdate,'yyyy')
        group by nvl(b.id,a.usrid),nvl(b.name,a.usrnam)
            ) order by elemny desc
      ) where rownum<=7";
		var ds = db.QuerySQL(sql);
		//html += "<tr><th width=\"50\">����</th><th width=\"200\">��ҵ����</th><th width=\"50\">�õ���</th></tr>";
		html += "<tr><td width=\"30\">����</td><td class='ConsTi3'>��ҵ����</td><td class='ConsTi3' width=\"60\">�õ���</td></tr>";//<td width=\"60\">��˰��</td>
		for (var i=0;i<ds.getRowCount();i++) {
			var num = ds.getStringAt(i,"ROWNUM");
			var title = ds.getStringAt(i,"NAME");
			var elemny = ds.getStringAt(i,"ELEMNY");
			var taxmny =ds.getStringAt(i,"TAXMNY");
			html += "<tr><td>"+num+"</td><td class='ConsTi'>"+title+"</td><td class='ConsTi2'>"+elemny+"</td></tr>";//<td  class='ConsTi2'>"+taxmny+"</td>
		}
		html += "</table></div>";
		
		html = Topstyle + html;
	}
	catch(e) {
		return e.toString();
	}
	finally {
		if(db != null) db.Close();
	}
	return html;
}

//��˰���а�
function taxTop()
{
	var db = null;	
	var html = "<div class=\"Cons\"><table cellspacing=\"0\" style=\"width: 100%\">";
	try {
		db = new pub.EADatabase();
		var sql = "select rownum,name name,taxmny from (
				select name,taxmny from (
					select a.id,a.name,round(nvl(sum(taxmny),0)/10000,2) taxmny
					from tax_taxdata a
					where substr(a.yymm,0,4)=to_char(sysdate,'yyyy')
					group by a.id,a.name
				      ) order by taxmny desc
				) where rownum<=7";
//		var sql = "select rownum,b.name,taxmny from( select rownum,nsrsbh,sehj taxmny from (
//				select nsrsbh,round(nvl(sum(sehj),0)/10000,2) sehj 
//				from v_tax_kpdata where to_char(jkfsrq,'YYYY')=to_char(sysdate,'yyyy')
//				group by nsrsbh 
//				order by sehj desc
//				) where rownum<=5) a,v_tax_company b where a.nsrsbh = b.id(+)";
		var ds = db.QuerySQL(sql);
		//html += "<tr><th width=\"50\">����</th><th width=\"200\">��ҵ����</th><th width=\"50\">˰��</th></tr>";
		html += "<tr><td width=\"30\">����</td><td class='ConsTi3'>��ҵ����</td><td class='ConsTi3'>��˰��</td></tr>";
		for (var i=0;i<ds.getRowCount();i++) {
			var num = ds.getStringAt(i,"ROWNUM");
			var title = ds.getStringAt(i,"NAME");
			var taxmny = ds.getStringAt(i,"TAXMNY");
			html += "<tr><td>"+num+"</td><td class='ConsTi'>"+title+"</td><td class='ConsTi2'>"+taxmny+"</td></tr>";
		}
		html += "</table></div>";
		
		html = Topstyle + html;
	}
	catch(e) {
		return e.toString();
	}
	finally {
		if(db != null) db.Close();
	}
	return html;

}

//Ȩ�޼��
function checkGenTask()
{
	//����˰�պ���ɽ�ɫ
	var sql = "select * from usrrol where usr=(select guid from usr where id='"+usrid+"' and org='"+thisorgid+"')
		and rol in (select guid from rol where id='02' and org='"+thisorgid+"')";
	return pub.EADbTool.GetSQLRowCount(sql);
}

//���ɻ�������
function insertTasks()
{
	var db = null;
	var ds = null;
	var sql = "";
	var ret = 0;

	try{
		db = new pubpack.EADatabase();
		var ds = new pubpack.EAXmlDS(xmlstr);
		var enddate = "";
		try { enddate = enddat; } catch(e) {}
		
		for (var i=0;i<ds.getRowCount();i++) {
			var flg = ds.getStringAt(i,"FLAG");
			if (flg == "1") {
				var bilid =db.GetBillid(accids,"TK","TK");  //���ɵ��ݺ�
				var id = ds.getStringAt(i,"ID");	
				var name = ds.getStringAt(i,"NAME");
				var taxman = "";
				var note = "";
				try { taxman = ds.getStringAt(i,"TAXMAN"); } catch (e) { }
				var town = "";
				
				try { 
					town = ds.getStringAt(i,"TOWN"); 
				} catch (e) { }				
						
				sql = "select * from tax_trkhdr where cmid='"+id+"' and nvl(yymm1,' ')=nvl('"+yymm1+"',' ') and nvl(yymm2,' ')=nvl('"+yymm2+"',' ')";
				var count = db.GetSQLRowCount(sql);	
				if(count == 0) {
					
					if (typ == "1") { //�е����޽�˰
						note = "�������£�"+yymm1+"~"+yymm2+"���õ�����"+ds.getStringAt(i,"ELEQTY");
					}
					else if (typ == "2") { //�н�˰�޵���
						note = "�������£�"+yymm1+"~"+yymm2+"���������룺"+ds.getStringAt(i,"somny")+"����ֵ˰��"+ds.getStringAt(i,"taxmny");
					}
					else if (typ == "3") { //����˰���쳣
						note = "�������£�"+yymm1+"~"+yymm2+"����ҵ�õ���(��)��"+ds.getStringAt(i,"eleqty")+"����ҵ����ָ�꣺"+ds.getStringAt(i,"envload")
							+ "��������������(Ԫ)��"+ds.getStringAt(i,"ens") + "���걨��������(Ԫ)��"+ds.getStringAt(i,"somny")
							+ "������(Ԫ)��"+ds.getStringAt(i,"cz");
					}
					else if (typ == "4") { //��ҵ˰���쳣
						note = "�������£�"+yymm1+"~"+yymm2+"����������(Ԫ)��"+ds.getStringAt(i,"somny")+"����ֵ˰��(Ԫ)��"+ds.getStringAt(i,"taxmny")
							+"��˰����%��"+ds.getStringAt(i,"taxbers") +"����ҵ˰����%��"+ds.getStringAt(i,"bears")
							+"������%��" +ds.getStringAt(i,"cy");
					}
					else if (typ == "5") { //�޵�����˰
					
					}
					else if (typ == "6") { //����ҵ����
					
					}
					else if (typ == "7") { //����˰���쳣
						note = "�������£�"+yymm1+"~"+yymm2+"����ҵ�õ���(��)��"+ds.getStringAt(i,"eleqty")+"������˰��ϵ����"+ds.getStringAt(i,"rate")
							+"��������ֵ˰��(Ԫ)��"+ds.getStringAt(i,"ens") +"��ʵ���걨��ֵ˰��(Ԫ)��"+ds.getStringAt(i,"taxmny")
							+"����ֵ˰�����(Ԫ)��" +ds.getStringAt(i,"cx");
					}else if(typ == "8"){ //��ѱȶ��쳣
						note = "�������£�"+yymm1+"~"+yymm2+"����ҵ�õ���(��)��"+ds.getStringAt(i,"eleqty")+"���õ��"+ds.getStringAt(i,"elemny")
							+"��ʵ���걨��ֵ˰��(Ԫ)��"+ds.getStringAt(i,"somny")
							+"����ֵ˰�����(Ԫ)��" +ds.getStringAt(i,"cz");
					}
					
					var newtyp = "";
					if (typ == "1" || typ == "2" || typ == "5" || typ == "6") {
						newtyp = "1"; //����©��
					}
					else {
						newtyp = "2"; //�쳣�걨
					}
					
					if(taxman == ""){
						sql="insert into tax_trkhdr(ACC,ORG,SYT,BILID,CRTUSR,CRTDAT,Cmid,Cmnam,Tousr,SUBTYP,yymm1,yymm2,dat,stat,enddat,town,note,newtyp) 
						select '"+accids+"','"+orgs+"','"+syts+"','"+bilid+"','"+usrids+"',sysdate,'"+id+"' ,'"+name+"','"+taxman+"','"+typ+"','"+yymm1+"','"+yymm2+"',trunc(sysdate),'1',to_date('"+enddate+"','yyyy-mm-dd'),'"+town+"','"+note+"','"+newtyp+"'  from dual";
						 
						ret += db.ExcecutSQL(sql);
					}
					else{
						sql="insert into tax_trkhdr(CHKUSR,CHKUSRNAM,CHKDAT,ACC,ORG,SYT,BILID,CRTUSR,STAT,CRTDAT,Cmid,Cmnam,Tousr,SUBTYP,yymm1,yymm2,dat,enddat,town,note,newtyp) 
						select '"+usrids+"','"+usrnams+"',sysdate,'"+accids+"','"+orgs+"','"+syts+"','"+bilid+"','"+usrids+"','2',sysdate,'"+id+"' ,'"+name+"','"+taxman+"','"+typ+"','"+yymm1+"','"+yymm2+"',trunc(sysdate),to_date('"+enddate+"','yyyy-mm-dd'),'"+town+"','"+note+"','"+newtyp+"'  from dual";
						 
						ret += db.ExcecutSQL(sql);
					}	
				}
			}
		}
		db.Commit();
		
		return "�ɹ�����"+ret+"������";
	}
	catch(e){
		if(db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if(db != null)	db.Close();
	}
}

function showClass()
{
	var db = null;
	var sql = "";
	var html = "<ul>";
	try {
		sql = "select guid,
				id,
				name,
				'' note,
				'' url
			from v_tax_hyclass
			order by id";
		db = new pubpack.EADatabase();
		var ds = db.QuerySQL(sql);	
		for (var i=0;i<ds.getRowCount();i++) {
			var guid = ds.getStringAt(i,"GUID");
			var name = ds.getStringAt(i,"NAME");
			html += "<li style='margin-bottom:8px'><a href='#' onclick=\"linkClass('"+guid+"','"+name+"')\">" + name + "</a></li>";
		}
		html += "</ul>";
		html += "<script type=text/javascript>
				function linkClass(guid,name) {
					//alert('Layout.sp?id=mdItemList&clsid='+clsid);
					window.frames['CELL_0_1'].location.href=\"Layout.sp?id=hydesc&cid=\"+guid+\"&clsname=\"+name;
				}
			</script>";
		
		return html;
	}
	catch(e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

//������ҵGUID
function hyInfos()
{
	var html = "��ҵ����>>"+clsname+"<hr>";
	html = pub.EAFunc.Replace(html,"[%clsname]","");
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "select contents from urlbody where fromguid='"+cid+"'";
		var note = db.getBlob2String(sql,"contents");
		note = pubpack.EAFunc.Replace(note,"\r\n","<br>");//�滻���м�
		note = pubpack.EAFunc.Replace(note,"\n","<br>");//�滻���м�
		note = pubpack.EAFunc.Replace(note,"\r","<br>");//�滻���м�
		note = pubpack.EAFunc.Replace(note,"\u0009","&nbsp;&nbsp;&nbsp;&nbsp;");//�滻tab��
		html += note;

		return html;

	}
	catch(e) {
		if (db != null) db.Rollback();
		return e.toString();
	}	
	finally {
		if (db != null) db.Close();
	}
}

function operShow()
{
	var html = "<br><ul>";
	var ds = pub.EADbTool.QuerySQL("select id,name from (select * from v_yyyy order by id desc) where rownum<=12");
	for (var i=0;i<ds.getRowCount();i++) {
		var id = ds.getStringAt(i,"ID");
		html += "<p align='left'><a href=\"Layout.sp?id=hyrep&yyyy="+id+"\"><li>"+id+"</li></a></p>";
	}
	html += "</ul>";
	return html;
}

function showReportFile()
{
	var html = "";
	var db = null;
	var usrinfo = web.EASession.GetLoginInfo(request);
	var usrid = usrinfo.getUsrid();
	var orgid = usrinfo.getusrOrg();	
	var yyyy = pub.EAFunc.NVL(request.getParameter("yyyy"),"");
	try {
		db = new pub.EADatabase();
		var sql = "select guid,org,yymm,title,note,filepath,filenote,crtusr,to_char(crtdat,'yyyy-mm-dd hh24:mi:ss') crttim from tax_filedata where org='"+orgid+"' ";
		if (yyyy != "" && yyyy != null) sql += "and substr(yymm,0,4)='"+yyyy+"'";
		sql += " order by yymm desc,crtdat desc";
		var ds = db.QuerySQL(sql);
		
		html = "<div class=\"Cons\"><table cellspacing=\"0\" style=\"width: 100%\">";
		html += "<tr><td class='ConsTi3' width=\"40%\">����</td><td class='ConsTi3' width=\"30%\">�����ļ�</td><td class='ConsTi3' width=\"20%\">����</td></tr>";
			
		for ( var i=0;i<ds.getRowCount();i++ ) {
			var guid = ds.getStringAt(i,"guid");
			var crtusr = ds.getStringAt(i,"crtusr");
			var crttim = ds.getStringAt(i,"crttim");
			var note = ds.getStringAt(i,"note"); 
			var yymm = ds.getStringAt(i,"yymm"); 
			var title = ds.getStringAt(i,"title");
			var filenote = ds.getStringAt(i,"filenote");
			filenote = filenote.substring(filenote.lastIndexOf("\\")+1);
			var filepath = ds.getStringAt(i,"filepath");
			note = pubpack.EAFunc.Replace(note,"\r\n","<br>");//�滻���м�
			note = pubpack.EAFunc.Replace(note,"\n","<br>");//�滻���м�
			note = pubpack.EAFunc.Replace(note,"\r","<br>");//�滻���м�
			note = pubpack.EAFunc.Replace(note,"\u0009","&nbsp;&nbsp;&nbsp;&nbsp;");//�滻tab��
			
			/*
			if (i > 0) html += "<br><hr>";
			html += "<p align=left><font size=2>��"+yymm+"��&nbsp;&nbsp;"+title+"</font>&nbsp;&nbsp;";
			html += "<font color=#808080>["+crtusr+" "+crttim+"]</font></p>";
			
			//if(note=="") note += db.getBlob2String(sql,"noteblob");
			html += "<p><font size=2 >"+note+"</font></p>";
			
			if ( filepath !="" ) {
				var idx = filenote.indexOf("\\");
				while(idx>=0 ) {
					var idx1 = filenote.indexOf("\\",idx+1);
					if ( idx1>= 0 ) idx = idx1;
					else break;
				}
				if ( idx>=0 ) filenote = filenote.substring(idx+1);
				html += "<div style=\"float:left;\"><font color=#FF0000 >�����ļ���<a href=\"downloadFile.sp?unzip=1&filename="+filepath+"\">"+filenote+"</a>&nbsp;&nbsp;<a href=\"downloadFile.sp?format=zip&filename="+filepath+"\">ѹ������</a></font></div>";
			}
			
			if ( usrid == crtusr) {
				html += "<div style=\"float:right;\"><a href=\"show.sp?grdid=ReportFile&edit=modify&guid="+guid+"\">�༭</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href=\"#\" onclick=\"javascript:if(confirm('ɾ���ü�¼���Ƿ������')==1)window.location='TAXMON.DesktopLayout.DeleteReportFile.osp?guid="+guid+"';\" >ɾ��<a/>&nbsp;&nbsp;</div>";
			
			}
			*/
			
			html += "<tr><td class='ConsTi'>"+title+"</td><td class='ConsTi'><a href=\"downloadFile.sp?unzip=1&filename="+filepath+"\">"+filenote+"</a></td><td class='ConsTi3'>";
			if ( usrid == crtusr) {
				html += "<div style=\"float:center;\"><a href=\"show.sp?grdid=ReportFile&edit=modify&guid="+guid+"\">�༭</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href=\"#\" onclick=\"javascript:if(confirm('ɾ���ü�¼���Ƿ������')==1)window.location='TAXMON.DesktopLayout.DeleteReportFile.osp?guid="+guid+"';\" >ɾ��<a/>&nbsp;&nbsp;</div>";
			}
			else {
				html += "<div style=\"float:center;\">--</div>";
			}
			html += "</td></tr>";
		}
		
		html += "</table></div>";
		html = Topstyle + html;
			

	}
	catch(e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
	
	return html;
}


function DeleteReportFile()
{
	var usr = web.EASession.GetLoginInfo(request);
  	var homeurl = usr.getHomeURL();
	var sql = "delete from tax_filedata where guid='"+guid+"'";
	pub.EADbTool.ExcecutSQL(sql);
	response.sendRedirect(homeurl+"Layout.sp?id=hyrep");
}
}
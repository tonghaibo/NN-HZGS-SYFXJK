function x_showflg_trk(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" );
var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var langpack = new JavaPackage ( "java.lang" );
var servletpack = new JavaPackage ( "com.xlsgrid.net.servlet");
//================================================================// 
// ������AllTrkDetail
// ˵������ʾ���е�������һ��������
// ������trktyp���������ͣ� crtdat(��������)
// ���أ�
// ������f
// ���ߣ�
// �������ڣ�01/28/15 17:58:16
// �޸���־��
//================================================================// 
function AllTrkDetail(){
	var html = "";
	var sql = "";
	var msg = "";
	var sb = new StringBuffer();
	var trkusr = pubpack.EAFunc.NVL(request.getParameter("trkusr" ),"") ;
	var trktyp= pubpack.EAFunc.NVL(request.getParameter("trktyp" ),"") ;
	var prj= pubpack.EAFunc.NVL(request.getParameter("prj" ),"") ;

	var crtdat= pubpack.EAFunc.NVL(request.getParameter("dat" ),"") ;
	//��ʾ�����sql 
	sql = "select a.guid,'<li>' || a.name || ' ' || to_char(a.crtdat, 'YY/MM/DD') ||
		'    ' || b.name name,
		a.id,
		'Layout.sp?id=trkquery&trkguid=' || a.guid url,
		to_char(a.crtdat,'yyyy-mm-dd hh24:mi:ss') crtdat,nvl(a.noteblob,empty_blob()) noteblob ,a.note,a.name title,b.name crtusr,to_char(a.crtdat,'YYYY-MM-DD HH24:MI:SS') crttim,a.filenote,a.filepath,
		a.crtusr crtusrid,u.name tousr ,tp.name trktyp,pj.name project
		from v_trk a, usr b ,v_usr_xlsgrid u ,v_trktyp tp,v_prj pj";
	var where = " where b.id(+) = a.crtusr
			and u.id(+) = a.tousr
			and tp.id(+) = a.trktyp
			and pj.id(+) = a.project
			 ";
	
	
	var sql2 = sql;//���ڶ�ȡblob��Ҫ��guid 
	sql += where;

	var ds = db.QuerySQL(sql+" and B.org='"+deforg+"'
			and NVL(a.crtusr, ' ') like '"+trkusr +"%'
			and NVL(a.trktyp,' ') like '"+trktyp+"%' 
			and decode(a.trktyp,'7',substr(a.name,0,10),to_char(a.crtdat,'YYYY-MM-DD')) like '"+crtdat+"%'
			and NVL(pj.id,' ') like '"+prj+"%' 
		
			order by a.crtdat   desc ");
//
//	throw new Exception( sql+" and B.org='"+deforg+"'
//			and NVL(a.crtusr, ' ') like '"+trkusr +"%'
//			and NVL(a.trktyp,' ') like '"+trktyp+"%' 
//			and to_char(a.crtdat,'YYYY-MM-DD') like '"+crtdat+"%'
//			order by a.crtusr   desc " );		
			
	for( var i=0 ;i<ds.getRowCount(); i++ ) {
			if(i>100) break;
			var crtusr = ds.getStringAt(i,"crtusr");
			
			//msg += "<p align=center><font size=3 color='#404040'>"+""+crtusr+"</font></p>";//�������˷�����ʾ
			//msg += "_____________________________________________________________________________________________________<br>";
			
			var guid = ds.getStringAt(i,"guid");
			sql = "select noteblob from v_trk where guid='"+guid+"' ";
			var id = ds.getStringAt(i,"id");
			
			msg += "<p align=center><font size=3 >["+ds.getStringAt(i,"project")+"]"+ds.getStringAt(i,"title")+"   </font></p>";//����
			msg += "<p align=center><font size=2 color='gray' >"+crtusr+" "+ds.getStringAt(i,"crtdat")+"</font></p>";//����
			//"ת������"+ds.getStringAt(i,"tousr")+"
			msg += "<HR width=90%>";

			//msg += "<p align=center><font size=2 color=#808080>"+ds.getStringAt(i,"crtusr")+" "+ds.getStringAt(i,"crttim")+"</font></p>";
			var url = ds.getStringAt(i,"url");
			var note = ds.getStringAt(i,"note");//����
			
			if(note=="") note += db.getBlob2String(sql,"noteblob");
//					throw new Exception(note+"|"+sql);
//					if(i==1)throw new Exception(sql);

			msg += "<table border=\"0\" width=\"100%\" cellspacing=\"5\" cellpadding=\"10\" style=\"border-collapse: collapse\"><tr><td align=left>"+note+"</td></tr></table>";
			var filenote = ds.getStringAt(i,"filenote");

			
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
				msg += "<p align=center><font color=#FF0000 size=2>���ظ�����<a href=\"downloadFile.sp?unzip=1&filename="+filepath+"\">"+filenote+"</a>&nbsp;<a href=\"downloadFile.sp?format=zip&filename="+filepath+"\">ѹ������</a></font></p>";
			}
			msg += "<BR><BR>";

	}

	
	return msg ;
}


}
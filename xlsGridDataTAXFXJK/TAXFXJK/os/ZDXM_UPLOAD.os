function TAXFXJK_ZDXM_UPLOAD(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//�鿴��ĿͼƬ��Ӧ����
function showIMG()
{
	var xmuuid = request.getParameter("xmuuid");
	var html = "<table align=center><tr>";
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "select * from tax_zdxm_xmtp where fgwxmuuid='"+xmuuid+"' order by crtdat asc";
		var ds = db.QuerySQL(sql);
		for (var i=0;i<ds.getRowCount();i++) {
			var imgguid = ds.getStringAt(i,"FORMGUID");
			var crtdat = ds.getStringAt(i,"CRTDAT");
			var note = ds.getStringAt(i,"NOTE");
			var divstr = "<div style='float:center;width:auto;height:auto'>
					<img src='EAFormBlob.sp?guid="+imgguid+"'>
				</div><br><span>�ϴ�ʱ�䣺"+crtdat+"</span><br><span>ͼƬ˵����"+note+"</span><hr>\n";
			html += divstr;
		}
		
		html += "</tr></table>";
		
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
	
	return html;
}

}
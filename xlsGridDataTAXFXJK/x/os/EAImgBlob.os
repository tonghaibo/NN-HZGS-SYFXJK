function x_EAImgBlob(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
//��Ϊ.sp����ʱ�����
//Ԥ���������request,response
//EAImgBlob.sp?guid= 
function Response() {
		var  db = null;
		var  ret = "";
		var guid = pubpack.EAFunc.NVL(request.getParameter("guid"),"");//layimghdr ��guid
		try {
			db = new pubpack.EADatabase();
				var  skinguid = guid;
				//2014 modify by scott add skinguid support
				// find if skin session exist
				var  userskin = "";
				// �����ڷ����os��request.getSession().setAttribute("USERSKIN", "blue")
				if(request.getSession().getAttribute("USERSKIN")!=null)
					userskin =""+request.getSession().getAttribute("USERSKIN");

					try {
						var  imgurl = "";
						var hdrds = db.QuerySQL("select defimg from layimghdr where guid='"+skinguid+"'");
						if(hdrds.getRowCount()>0){
							//find if dtl has data
							var dtlds = db.QuerySQL("select imgurl from layimgdtl where formguid='"+skinguid+"' and skinguid='"+userskin+"'");
							if(dtlds.getRowCount()>0){
								imgurl = dtlds.getStringAt(0,"imgurl");
							}
							else {
								imgurl = hdrds.getStringAt(0,"defimg");
							}
						}
						if(imgurl.length()>0&&imgurl.startsWith("EAFormBlob.sp?guid=")){
							guid = imgurl.substring("EAFormBlob.sp?guid=".length(), "EAFormBlob.sp?guid=".length()+32);
						}
					} catch (Exception e2) {
						e2.printStackTrace();
					}
				var blobds = db.QuerySQL("select fileurl,filename,sytid,grdid from FORMBLOB where guid='" + guid + "'");

				if (blobds.getRowCount() == 0) {
					return "guid=" + guid + "����û���ҵ�";
				}
				
				var fileurl = blobds.getStringAt(0, "FILEURL");
				var fileurl1 = pubpack.EAFunc.Replace(fileurl, "\\", "@@@");
				var filenames = pubpack.EAFunc.SplitString(fileurl1, "@@@");

				if (filenames.length == 0) {
					filenames = fileurl.split("/");
				}
				var filename = filenames[filenames.length() - 1];
				 //new String(filename.getBytes("GBK"),"ISO8859-1");
				// new String(filename.getBytes("GBK"),"ISO8859-1")
				response.setHeader("Content-Disposition","attachment;filename=" +filename );
				
				response.setHeader("File", filename );

				var b = db.getBlob2Byte("select bdata from formblob where guid='" + guid + "' for update", "bdata");
				response.getOutputStream().write(b);
				// ��Ҫ��ѹ��?
				// EAZip.deCompressFileToStream(filename,response.getOutputStream());

		} catch (Exception e) {
			ret += e.toString();
			if (db != null) db.Rollback();
			System.out.println(">>>>>>>>>>> EAFormBlob.sp Exception:" + ret);

		} finally {
			if (db != null) db.Close();
		}
		return ret;
}
}